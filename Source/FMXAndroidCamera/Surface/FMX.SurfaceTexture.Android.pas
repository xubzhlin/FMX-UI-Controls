unit FMX.SurfaceTexture.Android;

interface

uses
  System.Classes, System.Types, Androidapi.JNI.GraphicsContentViewText, Androidapi.JNI.JavaTypes,
  Androidapi.JNI.Os, Androidapi.JNIBridge, FMX.Types3D, FMX.Material.External, FMX.Types;

type
  TAndroidSurfaceTexture = class;

  TJSurfaceTexture_OnFrameAvailableListener = class(TJavaLocal, JSurfaceTexture_OnFrameAvailableListener)
    private
    [weak]FSurfaceTexture: TAndroidSurfaceTexture;
  public
    constructor Create(SurfaceTexture: TAndroidSurfaceTexture);
    procedure onFrameAvailable(surfaceTexture: JSurfaceTexture); cdecl;
  end;

  TAndroidSurfaceTexture = class(TObject)
  private
    FSurfaceTexture: JSurfaceTexture;
    FOnFrameAvailableListener: TJSurfaceTexture_OnFrameAvailableListener;
    FOnFrameAvailable: TNotifyEvent;

    FTexture: TExternalTexture;
    FHandler: JHandler;

    FPreviewSize: TPoint;
    FOnPreviewSizeChanged: TNotifyEvent;

  private
    procedure DoFrameAvailable(SurfaceTexture: JSurfaceTexture);
    function GetTexture: TTexture;
  public
    constructor Create;
    destructor Destroy; override;
    property SurfaceTexture: JSurfaceTexture read FSurfaceTexture;
    property Texture: TTexture read GetTexture;
    property OnFrameAvailable: TNotifyEvent read FOnFrameAvailable write FOnFrameAvailable;
    property OnPreviewSizeChanged: TNotifyEvent read FOnPreviewSizeChanged write FOnPreviewSizeChanged;
    property PreviewSize: TPoint read FPreviewSize write FPreviewSize;
  end;

implementation

{ TJSurfaceTexture_OnFrameAvailableListener }

constructor TJSurfaceTexture_OnFrameAvailableListener.Create(
  SurfaceTexture: TAndroidSurfaceTexture);
begin
  inherited Create;
  FSurfaceTexture := SurfaceTexture;
end;

procedure TJSurfaceTexture_OnFrameAvailableListener.onFrameAvailable(
  surfaceTexture: JSurfaceTexture);
begin
  if FSurfaceTexture <> nil then
    FSurfaceTexture.DoFrameAvailable(surfaceTexture);
end;

{ TAndroidSurfaceTexture }

constructor TAndroidSurfaceTexture.Create;
begin
  inherited Create;

  FOnFrameAvailableListener :=  TJSurfaceTexture_OnFrameAvailableListener.Create(Self);

  FTexture := TExternalTexture.Create;
  TCanvasExternalOESTextureMaterial.InitializeTexture(FTexture);

  FSurfaceTexture := TJSurfaceTexture.JavaClass.init(FTexture.Handle);

  if TJBuild_VERSION.JavaClass.SDK_INT >= 21 then
  begin
    FHandler := TJHandler.JavaClass.init(TJLooper.javaclass.getMainLooper());
    FSurfaceTexture.setOnFrameAvailableListener(FOnFrameAvailableListener, FHandler);
  end else
    FSurfaceTexture.setOnFrameAvailableListener(FOnFrameAvailableListener);
end;

destructor TAndroidSurfaceTexture.Destroy;
begin
  FOnFrameAvailableListener.Free;
  FTexture.Free;
  FSurfaceTexture := nil;
  inherited;
end;


procedure TAndroidSurfaceTexture.DoFrameAvailable(
  SurfaceTexture: JSurfaceTexture);
begin
  Log.d('FMX TAndroidSurfaceTexture: %d, %d', [FPreviewSize.X, FPreviewSize.Y]);
  if (FTexture.Width <> FPreviewSize.X) or (FTexture.Height <> FPreviewSize.Y) then
  begin
    TTextureAccessPrivate(FTexture).FWidth := FPreviewSize.X;
    TTextureAccessPrivate(FTexture).FHeight := FPreviewSize.Y;
    if Assigned(FOnPreviewSizeChanged) then FOnPreviewSizeChanged(Self);
  end;
  if FSurfaceTexture <> nil then
    FSurfaceTexture.updateTexImage;

  if Assigned(FOnFrameAvailable) then FOnFrameAvailable(Self);
end;

function TAndroidSurfaceTexture.GetTexture: TTexture;
begin
  Result := FTexture;
end;

end.
