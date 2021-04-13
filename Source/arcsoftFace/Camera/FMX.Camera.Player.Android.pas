unit FMX.Camera.Player.Android;

interface

uses
  System.Classes, FMX.Camera.Player, Androidapi.JNI.Os, Androidapi.JNI.Hardware,
  Androidapi.JNI.GraphicsContentViewText, FMX.SurfaceTexture.Android, Androidapi.JNI.JavaTypes, Androidapi.JNIBridge,
  FMX.Types3D, FMX.Material.External, System.Types, System.SyncObjs, System.Sensors.Components, FMX.Types;

const DELEY_DURATION = 300;

type
  JCamera_Area = interface;

  JCamera_AreaClass = interface(JObjectClass)
    ['{F04D9628-3235-42EE-9ADA-3227DB027EC0}']
    function init(rect: JRect; weight: Integer): JCamera_Area; cdecl;

  end;

  [JavaSignature('android/hardware/Camera$Area')]
  JCamera_Area = interface(JObject)
    ['{84DCBF92-B744-4A39-9632-F52C9B994C63}']
    function equals(obj: JObject): Boolean; cdecl;
    function _Getrect: JRect;
    procedure _Setrect(rect: JRect);
    function _Getweight: Integer;
    procedure _Setweight(weight: Integer);

    property rect: JRect read _Getrect write _Setrect;
    property weight: Integer read _GETweight write _SETweight;
  end;
  TJCamera_Area = class(TJavaGenericImport<JCamera_AreaClass, JCamera_Area>) end;

  TCameraPlayerAndroid = class;

  TOnPreviewFrame = procedure(data: TJavaArray<Byte>) of object;

  TMediaPlayer_BaseListener = class(TJavaLocal)
  private
    [weak]FPlayer: TCameraPlayerAndroid;
  public
    constructor Create(Player: TCameraPlayerAndroid);
  end;

  TJCamera_PreviewCallback = class(TMediaPlayer_BaseListener, JCamera_PreviewCallback)
    procedure onPreviewFrame(data: TJavaArray<Byte>; camera: JCamera); cdecl;
  end;

  TSENSOR_STATUES = (STATUS_NONE, STATUS_MOVE, STATUS_STATIC);

  TFouceThread = class(TThread)
  private
    [weak] FPlayer: TCameraPlayerAndroid;
    FMotionSensor: TMotionSensor;
    FX, FY, FZ: Single;
    FStatues: TSENSOR_STATUES;
    FLastStaticStamp: Integer;
    FCanFocus: Boolean;

    procedure DoFouce;
  protected
    procedure Execute; override;
  public
    constructor Create(Player: TCameraPlayerAndroid);
    destructor Destroy; override;

    procedure Start;
    procedure Stop;
  end;

  TCameraPlayerAndroid = class(TInterfacedObject, ICameraPlayer)
  private
    class var FCurrentCamera: JCamera;
    class var FCurrentCameraID: Integer;
    class var FSurfaceTexture: TAndroidSurfaceTexture;
    class var FSharedBufferBytes: Integer;
    class var FSharedBufferFormat: Integer;
    class var FSharedBuffer: TJavaArray<Byte>;
    FFouceing: Boolean;
    FStarted: Boolean;
    FCapturing: Boolean;
    FCameraId: Integer;
    FControl: TCameraPlayer;
    FFouceThread: TFouceThread;
    FEvent: TEvent;

    FOnFrameAvailable: TNotifyEvent;

    FOnPreviewCallback: TJCamera_PreviewCallback;
    FOnPreviewFrame: TOnPreviewFrame;

    FOnCameraSizeChanged: TNotifyEvent;
  private
    procedure DoFrameAvailable(Sender: TObject);
    procedure DoPreviewSizeChanged(Sender: TObject);
    procedure DoPreviewFrame(data: TJavaArray<Byte>);
    function GetCamera: JCamera;
    function GetSurfaceTexture: TAndroidSurfaceTexture;
    function GetManualBitmapRotation: Integer;
    function CalculateTapArea(const Point: TPointF; Coefficient: Single): JRect;
    function GetOnPreviewFrame: TOnPreviewFrame;
    procedure SetOnPreviewFrame(const Value: TOnPreviewFrame);
    function DoStart(CameraId: Integer): Boolean;
    procedure DoStop;
    function DoPrepare(CameraId: Integer): Boolean;
  public
    constructor Create;
    destructor Destroy; override;
    procedure start(CameraId: Integer);
    function started: Boolean;
    procedure stop;
    procedure focus;
    procedure focusAreas(const Point: TPointF);
    function getCameraWidth: Integer;
    function getCameraHeight: Integer;
    function isCapturing: Boolean;
    procedure setCameraPlayer(Control: TCameraPlayer);
    function getCameraPlayer: TCameraPlayer;
    procedure setOnFrameAvailable(OnFrameAvailable: TNotifyEvent);
    procedure setOnCameraSizeChanged(OnCameraSizeChanged: TNotifyEvent);
    function getCameraRotation: Integer;
    function getTexture: TTexture;
    procedure willBecomeForeground;
    procedure enteredBackground;
  public
    property OnPreviewFrame: TOnPreviewFrame read GetOnPreviewFrame write SetOnPreviewFrame;
  end;

implementation

uses
  System.Permissions, Androidapi.Helpers, FMX.Consts, FMX.Platform, FMX.Forms,
  System.SysUtils, AppTest;

{ TMediaPlayerAndroid }
function clamp(const x, min, max: Integer): Integer;
begin
  if(x > max) then
    Result := max
  else
  if(x < min) then
    Result := min
  else
    Result := x;
end;

procedure TCameraPlayerAndroid.focus;
var
  Params: JCamera_Parameters;
begin
  if FCurrentCamera <> nil then
  begin
    if FFouceing then exit;
    FFouceing := true;

    Params := FCurrentCamera.getParameters;
    if Params = nil then
      Exit;
    Params.setFocusMode(TJCamera_Parameters.JavaClass.FOCUS_MODE_AUTO);

    FCurrentCamera.cancelAutoFocus;
    FCurrentCamera.autoFocus(nil);
    FFouceing := False;
  end;
end;

procedure TCameraPlayerAndroid.focusAreas(const Point: TPointF);
var
  Params: JCamera_Parameters;
  areas, areasMetrix: JArrayList;
  focusRect, metrixRect: JRect;
begin
  if FCurrentCamera <> nil then
  begin
    if FFouceing then exit;
    FFouceing := true;

    Params := FCurrentCamera.getParameters;
    if Params = nil then
      Exit;
    FCurrentCamera.cancelAutoFocus;

    areas := TJArrayList.JavaClass.init;
    areasMetrix := TJArrayList.JavaClass.init;

    focusRect := calculateTapArea(Point, 1.0);
    metrixRect := calculateTapArea(Point, 1.5);

    areas.add(TJCamera_Area.JavaClass.init(focusRect, 1000));
    areasMetrix.add(TJCamera_Area.JavaClass.init(metrixRect, 1000));

    Params.setFocusAreas(JList(areas));
    Params.setMeteringAreas(JList(areasMetrix));
    Params.setFocusMode(TJCamera_Parameters.JavaClass.FOCUS_MODE_AUTO);

    FCurrentCamera.autoFocus(nil);
    FFouceing := False;
  end;
end;

function TCameraPlayerAndroid.GetCamera: JCamera;
begin
  if not PermissionsService.IsPermissionGranted(
           JStringToString(TJManifest_permission.JavaClass.CAMERA)) then
    raise EPermissionException.CreateFmt(SRequiredPermissionsAreAbsent, ['CAMERA']);
  // 每一次重新打开摄像头
  // 可能会损失一些性能，不过没有找到更好得办法
  // 再回到后台后，不重新打开 可能会出现 setpreview texture faild.
  FCurrentCamera := TJCamera.JavaClass.open(FCameraId);
  FCurrentCameraID := FCameraId;
  Result := FCurrentCamera;
end;

function TCameraPlayerAndroid.CalculateTapArea(const Point: TPointF;
  Coefficient: Single): JRect;
var
  focusAreaSize: Single;
  areaSize: Integer;
  centerY, centerX, left, top: Integer;
  rectF: JRectF;
begin
  focusAreaSize := 300;
  areaSize :=  Trunc(focusAreaSize * Coefficient);
  centerY := Trunc(Point.X / Screen.Size.Width  * 2000 - 1000);
  centerX := Trunc(Point.Y / Screen.Size.Height  * 2000 - 1000);
  left := clamp(Trunc(centerX - areaSize / 2), -1000, 1000);
  top := clamp(Trunc(centerY - areaSize / 2), -1000, 1000);
  rectF := TJRectF.JavaClass.init(left, top, left + areaSize, top + areaSize);
  Result := TJRect.JavaClass.init(Round(rectF.left), Round(rectF.top), Round(rectF.right), Round(rectF.bottom));
end;

constructor TCameraPlayerAndroid.Create;
begin
  inherited Create;

  FEvent := TEvent.Create;

  FOnPreviewCallback := TJCamera_PreviewCallback.Create(Self);


end;

destructor TCameraPlayerAndroid.Destroy;
begin
  stop;
  if FFouceThread <> nil then
  begin
    FFouceThread.Terminate;
    FEvent.SetEvent;
  end;

  FEvent.Free;
  inherited;
end;

procedure TCameraPlayerAndroid.DoFrameAvailable(Sender: TObject);
begin
  Log.d('TCameraPlayerAndroid DoFrameAvailable');
  if Assigned(FOnFrameAvailable) then
    FOnFrameAvailable(Self);
end;

function TCameraPlayerAndroid.DoPrepare(CameraId: Integer): Boolean;
var
  Params: JCamera_Parameters;
  PreviewSize: JCamera_Size;
begin
  Result := False;
  FCameraId := CameraId;

  GetCamera;
  if FCurrentCamera = nil then
    Exit;

  GetSurfaceTexture;
  if FSurfaceTexture = nil then
    Exit;
  if FSurfaceTexture.SurfaceTexture = nil then
    Exit;

  Params := FCurrentCamera.getParameters;
  if Params = nil then
    Exit;

  Params.setFocusMode(TJCamera_Parameters.JavaClass.FOCUS_MODE_AUTO);

  // Workaround for Google Glass
  if TPlatformServices.Current.GlobalFlags.ContainsKey(EnableGlassFPSWorkaround) and
    TPlatformServices.Current.GlobalFlags[EnableGlassFPSWorkaround] then
  begin
    Params.setPreviewFpsRange(30000, 30000);
    FCurrentCamera.setParameters(Params);
  end;

  PreviewSize := Params.getPreviewSize;

  FSurfaceTexture.PreviewSize := TPoint.Create(PreviewSize.width, PreviewSize.height);
  FSharedBufferFormat := Params.getPreviewFormat;
  FSharedBufferBytes := PreviewSize.width * PreviewSize.height *
    (TJImageFormat.JavaClass.getBitsPerPixel(FSharedBufferFormat));
  FreeAndNil(FSharedBuffer);
  FSharedBuffer := TJavaArray<Byte>.Create(FSharedBufferBytes);
  Result := True;

end;

procedure TCameraPlayerAndroid.DoPreviewFrame(data: TJavaArray<Byte>);
begin
  if Assigned(FOnPreviewFrame) then
    FOnPreviewFrame(data);
  FCurrentCamera.addCallbackBuffer(FSharedBuffer);
end;

procedure TCameraPlayerAndroid.DoPreviewSizeChanged(Sender: TObject);
begin
  if Assigned(FOnCameraSizeChanged) then
    FOnCameraSizeChanged(Self);
end;

function TCameraPlayerAndroid.DoStart(CameraId: Integer): Boolean;
begin
  Result := DoPrepare(CameraId);
  if (FCurrentCamera<> nil) and Result and (not FCapturing) then
  begin
    GetSurfaceTexture;

    FCurrentCamera.setPreviewTexture(FSurfaceTexture.SurfaceTexture);

    FCurrentCamera.setPreviewCallbackWithBuffer(FOnPreviewCallback);
    FCurrentCamera.startPreview;
    FCurrentCamera.addCallbackBuffer(FSharedBuffer);

    if FFouceThread = nil then
      FFouceThread := TFouceThread.Create(Self);
    FFouceThread.Start;
    FCapturing := True;
    Result := True;
  end;
end;

procedure TCameraPlayerAndroid.DoStop;
begin

  if (FCurrentCamera<> nil) and FCapturing then
  begin
    FCapturing := False;
    if FFouceThread <> nil then
      FFouceThread.Stop;
    FCurrentCamera.setPreviewCallback(nil);
    FCurrentCamera.stopPreview;
    FCurrentCamera := nil;
    FreeAndNil(FSharedBuffer);
    FControl.Repaint;
  end;
end;

procedure TCameraPlayerAndroid.enteredBackground;
begin
  if FStarted then
    DoStop;
end;

function TCameraPlayerAndroid.getCameraHeight: Integer;
begin
  if FSurfaceTexture = nil then
    Exit(0);
  Result := FSurfaceTexture.PreviewSize.Y;
end;

function TCameraPlayerAndroid.getCameraWidth: Integer;
begin
  if FSurfaceTexture = nil then
    Exit(0);
  Result := FSurfaceTexture.PreviewSize.X;
end;

function TCameraPlayerAndroid.getCameraRotation: Integer;
begin
  Result := GetManualBitmapRotation;
end;

function TCameraPlayerAndroid.GetManualBitmapRotation: Integer;
var
  CameraInfo: JCamera_CameraInfo;
  Display: JDisplay;
  DisplayOrientation: Integer;
begin
  CameraInfo := TJCamera_CameraInfo.JavaClass.init;
  TJCamera.JavaClass.getCameraInfo(FCameraId, CameraInfo);

  Display := TAndroidHelper.Display;
  if Display = nil then
    Exit(0);

  case Display.getRotation of
    0: // TJSurface.JavaClass.ROTATION_0
      DisplayOrientation := 0;
    1: // TJSurface.JavaClass.ROTATION_90
      DisplayOrientation := 90;
    2: // TJSurface.JavaClass.ROTATION_180
      DisplayOrientation := 180;
    3: // TJSurface.JavaClass.ROTATION_270
      DisplayOrientation := 270;
  else
    Exit(0);
  end;

  if CameraInfo.facing = TJCamera_CameraInfo.JavaClass.CAMERA_FACING_FRONT then
    Result := (DisplayOrientation + CameraInfo.orientation) mod 360
  else
    Result := (360 + CameraInfo.orientation - DisplayOrientation) mod 360;
end;

function TCameraPlayerAndroid.GetOnPreviewFrame: TOnPreviewFrame;
begin
  Result := FOnPreviewFrame;
end;


function TCameraPlayerAndroid.GetSurfaceTexture: TAndroidSurfaceTexture;
begin
  if FSurfaceTexture = nil then
    FSurfaceTexture := TAndroidSurfaceTexture.Create;
  FSurfaceTexture.OnFrameAvailable := DoFrameAvailable;
  FSurfaceTexture.OnPreviewSizeChanged := DoPreviewSizeChanged;
  Result := FSurfaceTexture;
end;

function TCameraPlayerAndroid.getCameraPlayer: TCameraPlayer;
begin
  Result := FControl;
end;

function TCameraPlayerAndroid.getTexture: TTexture;
begin
  if FSurfaceTexture = nil then
    Exit(nil);
  Result := FSurfaceTexture.Texture;
end;

function TCameraPlayerAndroid.isCapturing: Boolean;
begin
  Result := FCapturing;
end;

function TCameraPlayerAndroid.started: Boolean;
begin
  Result := FStarted;
end;

procedure TCameraPlayerAndroid.setCameraPlayer(Control: TCameraPlayer);
begin
  FControl := Control;
end;

procedure TCameraPlayerAndroid.setOnCameraSizeChanged(
  OnCameraSizeChanged: TNotifyEvent);
begin
  FOnCameraSizeChanged := OnCameraSizeChanged;
end;

procedure TCameraPlayerAndroid.setOnFrameAvailable(
  OnFrameAvailable: TNotifyEvent);
begin
  FOnFrameAvailable := OnFrameAvailable;
end;

procedure TCameraPlayerAndroid.SetOnPreviewFrame(const Value: TOnPreviewFrame);
begin
  FOnPreviewFrame := Value;
end;

procedure TCameraPlayerAndroid.start(CameraId: Integer);
begin
  if not FStarted then
    FStarted := DoStart(CameraId);

end;

procedure TCameraPlayerAndroid.stop;
begin
  if FStarted then
  begin
    DoStop;
    FStarted := False;
  end;
end;

procedure TCameraPlayerAndroid.willBecomeForeground;
begin
  if FStarted then
    DoStart(FCameraId);
end;

{ TFouceThread }

constructor TFouceThread.Create(Player: TCameraPlayerAndroid);
begin
  inherited Create(False);
  FPlayer := Player;
  FreeOnTerminate := True;
  FMotionSensor := TMotionSensor.Create(nil);

end;

destructor TFouceThread.Destroy;
begin

  FMotionSensor.Free;
  inherited;
end;

procedure TFouceThread.DoFouce;
var
  Stamp: Cardinal;
  X, Y, Z, Value: Single;
begin

  X := FMotionSensor.Sensor.AccelerationX;
  Y := FMotionSensor.Sensor.AccelerationY;
  Z := FMotionSensor.Sensor.AccelerationZ;

  if(FStatues <> TSENSOR_STATUES.STATUS_NONE) then
  begin
    Value := Sqrt(Sqr((FX - X)) + Sqr((FY - Y)) + Sqr((FZ - Z)));
    Stamp := TThread.GetTickCount;

    if Value > 0.1 then
    begin
      FStatues := TSENSOR_STATUES.STATUS_MOVE;
    end
    else
    begin
      if (FStatues = TSENSOR_STATUES.STATUS_MOVE) then
      begin
        FLastStaticStamp := Stamp;
        FCanFocus := True;
      end;
      if(FCanFocus) then
      begin

        if(Stamp - FLastStaticStamp > DELEY_DURATION) then
        begin
          TThread.Synchronize(nil, procedure
          begin
            FPlayer.focus;
          end);
          FCanFocus := False;
        end;
      end;
      FStatues := TSENSOR_STATUES.STATUS_STATIC;
    end;
  end else
  begin
    FLastStaticStamp := Stamp;
    FStatues := TSENSOR_STATUES.STATUS_STATIC;
  end;

  FX := X;
  FY := Y;
  FZ := Z;
end;

procedure TFouceThread.Execute;
var
  WaitResult: TWaitResult;
begin
  while not Terminated do
  begin
    if FPlayer = nil then exit;

    if FPlayer.FCapturing then
    begin
      WaitResult := FPlayer.FEvent.WaitFor(200);
      if FPlayer.FCapturing then
        DoFouce;
      FPlayer.FEvent.ResetEvent;
    end else
    begin
      WaitResult := FPlayer.FEvent.WaitFor(INFINITE);
      FPlayer.FEvent.ResetEvent;
    end;
  end;

end;

procedure TFouceThread.Start;
begin
  FStatues := TSENSOR_STATUES.STATUS_NONE;
  FCanFocus:= False;
  FMotionSensor.Active := True;
  FMotionSensor.Sensor.UpdateInterval := 200;
  FPlayer.FEvent.SetEvent;
end;

procedure TFouceThread.Stop;
begin
  FMotionSensor.Active := False;
  FPlayer.FEvent.SetEvent;
end;

{ TMediaPlayer_BaseListener }

constructor TMediaPlayer_BaseListener.Create(Player: TCameraPlayerAndroid);
begin
  inherited Create;
  FPlayer := Player;
end;

{ TJCamera_PreviewCallback }

procedure TJCamera_PreviewCallback.onPreviewFrame(data: TJavaArray<Byte>;
  camera: JCamera);
begin
  if FPlayer <> nil then
  begin
    FPlayer.DoPreviewFrame(data);
  end;
end;


end.
