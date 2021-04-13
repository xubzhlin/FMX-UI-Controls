unit ArcSoft.FaceEngineManager.Android;

interface

uses
  Androidapi.JNI.JavaTypes, Androidapi.JNIBridge, Androidapi.JNI.GraphicsContentViewText,
  System.SysUtils, ArcSoft.FaceEngine.Android, Androidapi.JNI.arcsoft_face,
  Androidapi.JNI.arcsoft_image_util, System.Generics.Collections, FMX.Graphics;

type
  TFaceStatus = (fsNone, fsDetect, fsLiveness, fsIrLiveness, fsRecognition);

  TOnFaceEngineMessage = procedure(Sender: TObject; Msg: string) of object;

  TAndroidFaceEngineManager = class(TObject)
  private
    FFaceIdMap: TDictionary<Integer, TFaceStatus>;
    FFaceOrient: TDetectFaceOrient;
    // 人脸检测
    FTEngine: TAndroidFaceEngine;
    // 人脸特征
    FREngine: TAndroidFaceEngine;
    // RGB 活体检测
    FLEngine: TAndroidFaceEngine;
    // LR 活体检测
    FIEngine: TAndroidFaceEngine;
    // 人脸对比
    FCEngine: TAndroidFaceEngine;
    FOnFaceEngineMessage: TOnFaceEngineMessage;
  private
    procedure DoFaceEngineMessage(Msg: string);
    function CreateDetectEngine: TAndroidFaceEngine;
    function CreateLivenessEngine: TAndroidFaceEngine;
    function CreateIrLivenessEngine: TAndroidFaceEngine;
    function CreateRecognitionEngine: TAndroidFaceEngine;
    function CreateCompareEngine: TAndroidFaceEngine;

    function KeepMaxFace(FaceInfoList: JList): Boolean;

    function Liveness(data: TJavaArray<Byte>; Width, Height, Format: Integer; FaceInfoList: JList): Integer;
    function LivenessIr(data: TJavaArray<Byte>; Width, Height, Format: Integer; FaceInfoList: JList): Integer;
    // 获取合适得尺寸
    function getBestRect(Width, Height: Integer; srcRect: JRect): JRect;
    // 截取合适的头像并旋转
    function GetHeadImage(data: TJavaArray<Byte>; Width, Height, Orient: Integer; Format: JArcSoftImageFormat; CropRect: JRect ): TBitMap;
    function GetFaceFeature(Engine: TAndroidFaceEngine; data: TJavaArray<Byte>; Width, Height, Format: Integer; var HeadBitMap: TBitMap): TBytes; overload;

    function GetFaceStatus(FaceId: Integer): TFaceStatus;
    procedure SetFaceStatus(FaceId: Integer; const Value: TFaceStatus);
    procedure CheckFaceStatus(FaceInfoList: JList; const StatusValue: TFaceStatus); overload;
    procedure CheckFaceStatus(FaceInfo: JFaceInfo; const StatusValue: TFaceStatus); overload;
  private

    property FaceStatus[FaceId: Integer]: TFaceStatus read GetFaceStatus write SetFaceStatus;
  public
    constructor Create(FaceOrient: TDetectFaceOrient);
    destructor Destroy; override;
    // 返回人脸特征 目前 只返回最大人脸
    function GetFaceFeature(data: TJavaArray<Byte>; Width, Height, Format: Integer; var HeadBitMap: TBitMap): TBytes; overload;
    // 返回人脸特征 目前 只返回最大人脸
    function GetFaceFeature(BitMap: TBitMap; var HeadBitMap: TBitMap): TBytes; overload;
    // 对比两个人脸 数据 返回得分
    function CompareFaceFeature(Feature1, Feature2: TBytes): Single;
    property OnFaceEngineMessage: TOnFaceEngineMessage read FOnFaceEngineMessage write FOnFaceEngineMessage;
  end;

implementation

uses
  Androidapi.JNI.com.arcsoft.faceHelper.FaceEngineHelper, Androidapi.Helpers,
  FMX.Surfaces, FMX.Helpers.Android, System.Math, APPTest;

{ TAndroidFaceEngineManager }


procedure TAndroidFaceEngineManager.CheckFaceStatus(FaceInfo: JFaceInfo;
  const StatusValue: TFaceStatus);
begin
  if FaceStatus[FaceInfo.getFaceId] < StatusValue then
    FaceStatus[FaceInfo.getFaceId] :=  StatusValue;
end;

function TAndroidFaceEngineManager.CompareFaceFeature(Feature1,
  Feature2: TBytes): Single;
var
  ResultCode: Integer;
  LFeature1Data, LFeature2Data: TJavaArray<Byte>;
  LFeature1, LFeature2: JFaceFeature;
  LFaceSimilar: JFaceSimilar;
begin
  LFeature1Data := TBytesToTJavaArray(Feature1);
  LFeature2Data := TBytesToTJavaArray(Feature2);
  LFeature1 := TJFaceFeature.JavaClass.init(LFeature1Data);
  LFeature2 := TJFaceFeature.JavaClass.init(LFeature2Data);
  LFaceSimilar := TJFaceSimilar.JavaClass.init;
  ResultCode := FCEngine.compareFaceFeature(LFeature1, LFeature2, LFaceSimilar);
  if ResultCode <> 0 then Exit(0);
  Result := LFaceSimilar.getScore;

end;

constructor TAndroidFaceEngineManager.Create(FaceOrient: TDetectFaceOrient);
begin
  inherited Create;
  FFaceOrient := FaceOrient;
  FTEngine := CreateDetectEngine;
  FREngine := CreateRecognitionEngine;
  FLEngine := CreateLivenessEngine;
  FIEngine := CreateIrLivenessEngine;
  FCEngine := CreateCompareEngine;
end;

function TAndroidFaceEngineManager.CreateCompareEngine: TAndroidFaceEngine;
var
  ResultCode: Integer;
begin
  Result := TAndroidFaceEngine.Create;
  Result.DetectMode := TDetectMode.ASF_DETECT_MODE_IMAGE;
  Result.DetectFaceOrient := TDetectFaceOrient.ASF_OP_270_ONLY;
  Result.DetectFaceScaleVal := 32;
  Result.DetectFaceMaxNum := MAX_DETECT_NUM;
  Result.DetectMasks := [TDetectMask.ASF_FACE_DETECT, TDetectMask.ASF_FACE_RECOGNITION];

  ResultCode := Result.initEngine;
  if ResultCode <> TJErrorInfo.JavaClass.MOK then
    raise Exception.Create(Format('arcsoft detect initEngine errorcode: %d', [ResultCode]));

end;

function TAndroidFaceEngineManager.CreateDetectEngine: TAndroidFaceEngine;
var
  ResultCode: Integer;
begin
  Result := TAndroidFaceEngine.Create;
  Result.DetectMode := TDetectMode.ASF_DETECT_MODE_IMAGE;
  Result.DetectFaceOrient := FFaceOrient;
  Result.DetectFaceScaleVal := 32;
  Result.DetectFaceMaxNum := MAX_DETECT_NUM;
  Result.DetectMasks := [TDetectMask.ASF_FACE_DETECT];

  ResultCode := Result.initEngine;
  if ResultCode <> TJErrorInfo.JavaClass.MOK then
    raise Exception.Create(Format('arcsoft detect initEngine errorcode: %d', [ResultCode]));
end;

function TAndroidFaceEngineManager.CreateIrLivenessEngine: TAndroidFaceEngine;
var
  ResultCode: Integer;
begin
  Result := TAndroidFaceEngine.Create;
  Result.DetectMode := TDetectMode.ASF_DETECT_MODE_IMAGE;
  Result.DetectFaceOrient := FFaceOrient;
  Result.DetectFaceScaleVal := 32;
  Result.DetectFaceMaxNum := MAX_DETECT_NUM;
  Result.DetectMasks := [TDetectMask.ASF_IR_LIVENESS];
  ResultCode := Result.initEngine;
  if ResultCode <> TJErrorInfo.JavaClass.MOK then
    raise Exception.Create(Format('arcsoft liveness initEngine errorcode: %d', [ResultCode]));
end;

function TAndroidFaceEngineManager.CreateLivenessEngine: TAndroidFaceEngine;
var
  ResultCode: Integer;
begin
  Result := TAndroidFaceEngine.Create;
  Result.DetectMode := TDetectMode.ASF_DETECT_MODE_IMAGE;
  Result.DetectFaceOrient := FFaceOrient;
  Result.DetectFaceScaleVal := 32;
  Result.DetectFaceMaxNum := MAX_DETECT_NUM;
  Result.DetectMasks := [TDetectMask.ASF_LIVENESS];
  ResultCode := Result.initEngine;
  if ResultCode <> TJErrorInfo.JavaClass.MOK then
    raise Exception.Create(Format('arcsoft liveness initEngine errorcode: %d', [ResultCode]));
end;

function TAndroidFaceEngineManager.CreateRecognitionEngine: TAndroidFaceEngine;
var
  ResultCode: Integer;
begin
  Result := TAndroidFaceEngine.Create;
  Result.DetectMode := TDetectMode.ASF_DETECT_MODE_IMAGE;
  Result.DetectFaceOrient := FFaceOrient;
  Result.DetectFaceScaleVal := 32;
  Result.DetectFaceMaxNum := MAX_DETECT_NUM;
  Result.DetectMasks := [TDetectMask.ASF_FACE_RECOGNITION];

  ResultCode := Result.initEngine;
  if ResultCode <> TJErrorInfo.JavaClass.MOK then
    raise Exception.Create(Format('arcsoft recogntion initEngine errorcode: %d', [ResultCode]));
end;

destructor TAndroidFaceEngineManager.Destroy;
begin
  FTEngine.Free;
  FREngine.Free;
  FLEngine.Free;
  inherited;
end;


procedure TAndroidFaceEngineManager.DoFaceEngineMessage(Msg: string);
begin
  if Assigned(FOnFaceEngineMessage) then
    FOnFaceEngineMessage(Self, Msg);
end;

function TAndroidFaceEngineManager.getBestRect(Width, Height: Integer;
  srcRect: JRect): JRect;
var
  maxOverFlow, padding: Integer;
begin
  if srcRect = nil then Exit(nil);
  Result := TJRect.JavaClass.init(srcRect);

  maxOverFlow := Max(-Result.left, Max(-Result.top, Max(Result.right - Width, Result.bottom - Height)));
  if maxOverFlow >=0 then
  begin
    Result.inset(maxOverFlow, maxOverFlow);
  end else
  begin
    padding := Result.height div 2;
    if not ((Result.left - padding > 0) and (Result.right + padding < width) and
      (Result.top - padding > 0) and (Result.bottom + padding < height)) then
    begin
      padding := Min(Min(Min(Result.left, width - Result.right), height - Result.bottom), Result.top);
    end;
    Result.inset(-padding, -padding);
  end;
  Result.left := Result.left shr 2 shl 2;
  Result.top := Result.top shr 2 shl 2;
  Result.right := Result.right shr 2 shl 2;
  Result.bottom := Result.bottom shr 2 shl 2;
end;

function TAndroidFaceEngineManager.GetFaceFeature(
  BitMap: TBitMap; var HeadBitMap: TBitMap): TBytes;
var
  LSurface: TBitmapSurface;
  LBitMap: JBitMap;
  BRG24: TJavaArray<Byte>;

begin
  SetLength(Result, 0);
  LSurface := TBitmapSurface.Create;
  try
    LSurface.Assign(Bitmap);
    LBitMap := TJBitmap.JavaClass.createBitmap(LSurface.Width, LSurface.Height, TJBitmap_Config.JavaClass.ARGB_8888);
    if not SurfaceToJBitmap(LSurface, LBitMap) then
      Exit;
  finally
    LSurface.DisposeOf;
  end;

  // 图像对齐
  LBitMap := TJArcSoftImageUtil.JavaClass.getAlignedBitmap(LBitMap, True);
  // bitmap转bgr24
  BRG24 := TJArcSoftImageUtil.JavaClass.createImageData(LBitMap.getWidth, LBitMap.getHeight, TJArcSoftImageFormat.JavaClass.BGR24);
  TJArcSoftImageUtil.JavaClass.bitmapToImageData(LBitMap, BRG24, TJArcSoftImageFormat.JavaClass.BGR24);
  // 获取特征值
  Result := GetFaceFeature(FTEngine, BRG24, LBitMap.getWidth, LBitMap.getHeight, TJFaceEngine.JavaClass.CP_PAF_BGR24, HeadBitMap);
end;

function TAndroidFaceEngineManager.GetFaceStatus(FaceId: Integer): TFaceStatus;
var
  Status: TFaceStatus;
begin
  Result := TFaceStatus.fsNone;
  if FFaceIdMap.TryGetValue(FaceId, Status) then
    Result := Status;
end;

function TAndroidFaceEngineManager.GetFaceFeature(Engine: TAndroidFaceEngine;
  data: TJavaArray<Byte>; Width, Height, Format: Integer; var HeadBitMap: TBitMap): TBytes;
var
  List: JList;
  FaceInfo: JFaceInfo;
  Feature: JFaceFeature;
  FeatureData: TJavaArray<Byte>;
  ResultCode: Integer;
begin
  SetLength(Result, 0);

  List := TJList.Wrap(TJArrayList.JavaClass.init);

  // 人脸追踪
  ResultCode := Engine.detectFaces(data, Width, Height, Format, List);
  DoFaceEngineMessage(System.SysUtils.Format('detectFaces TAndroidFaceEngineManager result code:%d, list size:%d', [ResultCode, List.size]));
  if ResultCode <> 0 then Exit;
  if List.size = 0 then Exit;

  // 只保留最大人脸
  if not KeepMaxFace(List) then Exit;
  DoFaceEngineMessage(System.SysUtils.Format('KeepMaxFace TAndroidFaceEngineManager:%d', [ResultCode, List.size]));

  // RGB 活体检测
  List := TJFaceEngineHelper.JavaClass.arrayAsList(TJFaceInfo.Wrap(List.get(0)));
  ResultCode := Liveness(data, Width, Height, Format, List);
  DoFaceEngineMessage(System.SysUtils.Format('Liveness TAndroidFaceEngineManager result code:%d, list size:%d', [ResultCode, List.size]));
  if ResultCode <> 0 then Exit;
  if List.size = 0 then Exit;

  // Ir 活体检测
  // List := TJFaceEngineHelper.JavaClass.arrayAsList(TJFaceInfo.Wrap(List.get(0)));
//  ResultCode := LivenessIr(data, Width, Height, Format, List);
//  DoFaceEngineMessage(System.SysUtils.Format('LivenessIr TAndroidFaceEngineManager result code:%d, list size:%d', [ResultCode, List.size]));
//  if ResultCode <> 0 then Exit;
//  if List.size = 0 then Exit;

  // 返回 人脸特征
  FaceInfo := TJFaceInfo.Wrap(List.get(0));
  Feature := TJFaceFeature.JavaClass.init;
  ResultCode := FREngine.extractFaceFeature(data, Width, Height, Format, FaceInfo, Feature);
  DoFaceEngineMessage(System.SysUtils.Format('extractFaceFeature TAndroidFaceEngineManager result code:%d', [ResultCode]));
  if ResultCode <> 0 then Exit;

  if Format = TJFaceEngine.JavaClass.CP_PAF_NV21 then
    HeadBitMap := GetHeadImage(data, Width, Height, FaceInfo.getOrient, TJArcSoftImageFormat.JavaClass.NV21, FaceInfo.getRect)
  else
  if Format = TJFaceEngine.JavaClass.CP_PAF_BGR24 then
    HeadBitMap := GetHeadImage(data, Width, Height, FaceInfo.getOrient, TJArcSoftImageFormat.JavaClass.BGR24, FaceInfo.getRect);

  FeatureData := Feature.getFeatureData;
  Result := TJavaArrayToTBytes(FeatureData);
end;

function TAndroidFaceEngineManager.GetHeadImage(data: TJavaArray<Byte>; Width,
  Height, Orient: Integer; Format: JArcSoftImageFormat; CropRect: JRect): TBitMap;
var
  HeadImageData, RotateHeadImageData: TJavaArray<Byte>;
  CropImageWidth, CropImageHeight: Integer;
  RotateDegree: JArcSoftRotateDegree;
  HeadBmp: JBitMap;
  Surface: TBitmapSurface;
begin
  Result := nil;
  CropRect := getBestRect(Width, Height, CropRect);
  HeadImageData := TJArcSoftImageUtil.JavaClass.createImageData(CropRect.width, cropRect.height, Format);
  TJArcSoftImageUtil.JavaClass.cropImage(data, HeadImageData, Width, Height, CropRect, Format);
  // 90度或270度的情况，需要宽高互换
  if (Orient = TJFaceEngine.JavaClass.ASF_OC_90) or (Orient = TJFaceEngine.JavaClass.ASF_OC_270) then
  begin
    CropImageWidth :=  CropRect.height;
    CropImageHeight := CropRect.width;
  end else
  begin
    CropImageWidth := cropRect.width;
    CropImageHeight := cropRect.height;
  end;

  RotateDegree := nil;
  if Orient = TJFaceEngine.JavaClass.ASF_OC_90 then
    RotateDegree := TJArcSoftRotateDegree.JavaClass.DEGREE_270
  else
  if Orient = TJFaceEngine.JavaClass.ASF_OC_180 then
    RotateDegree := TJArcSoftRotateDegree.JavaClass.DEGREE_180
  else
  if Orient = TJFaceEngine.JavaClass.ASF_OC_270 then
    RotateDegree := TJArcSoftRotateDegree.JavaClass.DEGREE_90
  else
    RotateHeadImageData := HeadImageData;


  // 非0度的情况，旋转图像
  if RotateDegree<>nil then
  begin
    RotateHeadImageData := TJavaArray<Byte>.Create(headImageData.Length);
    TJArcSoftImageUtil.JavaClass.rotateImage(HeadImageData, RotateHeadImageData, CropRect.width, CropRect.height, rotateDegree, Format);
  end;

  // 将创建一个Bitmap，并将图像数据存放到Bitmap中
  HeadBmp := TJBitmap.JavaClass.createBitmap(CropImageWidth, CropImageHeight, TJBitMap_Config.JavaClass.RGB_565);

  if (TJArcSoftImageUtil.JavaClass.imageDataToBitmap(RotateHeadImageData, HeadBmp, Format) = TJArcSoftImageUtilError.JavaClass.CODE_SUCCESS) then
  begin  
    Surface := TBitmapSurface.Create;
    try
      if JBitmapToSurface(HeadBmp, Surface) then
      begin
        Result := TBitmap.Create;
        Result.Assign(Surface);
      end;
    finally
      Surface.Free;
    end;
  end;

end;

function TAndroidFaceEngineManager.GetFaceFeature(
  data: TJavaArray<Byte>; Width, Height, Format: Integer; var HeadBitMap: TBitMap): TBytes;
begin
  Result := GetFaceFeature(FTEngine, data, Width, Height, Format, HeadBitMap);
end;

function TAndroidFaceEngineManager.KeepMaxFace(FaceInfoList: JList): Boolean;
var
  i: Integer;
  FaceInfo, MaxFaceInfo: JFaceInfo;
begin
  Exit;
  if(FaceInfoList = nil) or (FaceInfoList.size < 1) then
    Exit(False);
  MaxFaceInfo := TJFaceInfo.Wrap(FaceInfoList.get(0));
  for i := 0 to FaceInfoList.size - 1 do
  begin
    FaceInfo := TJFaceInfo.Wrap(FaceInfoList.get(i));
    if(FaceInfo.getRect.width > MaxFaceInfo.getRect.width) then
      MaxFaceInfo := FaceInfo;
  end;
  FaceInfoList.clear;
  FaceInfoList.add(MaxFaceInfo);
  Result := True;
end;

function TAndroidFaceEngineManager.Liveness(data: TJavaArray<Byte>; Width, Height, Format: Integer; FaceInfoList: JList): Integer;
var
  LivenessInfo: JLivenessInfo;
  LivenessInfoList: JList;
  i: Integer;
begin
  // RGB检活
  Result := FLEngine.process(data, Width, Height, Format, FaceInfoList, [TDetectMask.ASF_LIVENESS]);
  LivenessInfoList := TJList.Wrap(TJArrayList.JavaClass.init);
  Result := FLEngine.getLiveness(LivenessInfoList);
//  for i := LivenessInfoList.size - 1 downto 0 do
//  begin
//    LivenessInfo := TJLivenessInfo.Wrap(TJList.Wrap(LivenessInfoList.get(0)));
//    if LivenessInfo.getLiveness <> TJLivenessInfo.JavaClass.ALIVE then
//    begin
//      // 移出 RGB活体检测失败的人脸
//      FaceInfoList.remove(i);
//    end;
//  end;

end;

function TAndroidFaceEngineManager.LivenessIr(data: TJavaArray<Byte>; Width,
  Height, Format: Integer; FaceInfoList: JList): Integer;
var
  LivenessInfo: JLivenessInfo;
  LivenessInfoList: JList;
  i: Integer;
begin
  // Ir检活
  Result := FIEngine.processIr(data, Width, Height, Format, FaceInfoList, [TDetectMask.ASF_IR_LIVENESS]);
  if Result <> 0 then exit;
  LivenessInfoList := TJList.Wrap(TJArrayList.JavaClass.init);
  Result := FIEngine.getIrLiveness(LivenessInfoList);
//  for i := LivenessInfoList.size - 1 downto 0 do
//  begin
//    LivenessInfo := TJLivenessInfo.Wrap(LivenessInfoList.get(0));
//    if LivenessInfo.getLiveness <> TJLivenessInfo.JavaClass.ALIVE then
//    begin
//      // 移出 IR活体检测失败的人脸
//      FaceInfoList.remove(i);
//    end;
//  end;

end;

procedure TAndroidFaceEngineManager.CheckFaceStatus(FaceInfoList: JList; const StatusValue: TFaceStatus);
var
  i: Integer;
  FaceInfo: JFaceInfo;
  OldStatus: TFaceStatus;
begin
  if FaceInfoList.size = 0 then Exit;
  for i := FaceInfoList.size - 1 downto 0  do
  begin
    FaceInfo := TJFaceInfo.Wrap(FaceInfoList.get(i));
    OldStatus := FFaceIdMap[FaceInfo.getFaceId];
    if OldStatus < StatusValue then
      FaceStatus[FaceInfo.getFaceId] := StatusValue;
  end;
end;

procedure TAndroidFaceEngineManager.SetFaceStatus(FaceId: Integer;
  const Value: TFaceStatus);
var
  Status: TFaceStatus;
begin
  if FFaceIdMap.TryGetValue(FaceId, Status) then
  begin
    if(Value > Status) then
      FFaceIdMap[FaceId] := Status;
  end else
    FFaceIdMap.Add(FaceId, Status);   
end;

end.

