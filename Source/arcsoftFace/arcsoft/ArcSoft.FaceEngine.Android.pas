unit ArcSoft.FaceEngine.Android;

interface

uses
  Androidapi.JNI.JavaTypes, Androidapi.JNIBridge,
  Androidapi.JNI.arcsoft_face;

const
  MAX_DETECT_NUM = 10;

type
  TDetectMode = (ASF_DETECT_MODE_VIDEO, ASF_DETECT_MODE_IMAGE);
  TDetectFaceOrient = (ASF_OP_0_ONLY, ASF_OP_90_ONLY, ASF_OP_180_ONLY, ASF_OP_270_ONLY, ASF_OP_ALL_OUT);
  TDetectMask = (ASF_NONE, ASF_FACE_DETECT, ASF_FACE_RECOGNITION, ASF_AGE, ASF_GENDER, ASF_FACE3DANGLE, ASF_LIVENESS, ASF_IR_LIVENESS);
  TDetectMasks = set of TDetectMask;



  TAndroidFaceEngine = class(TObject)
  public
    class var AppId: string;
    class var SDKKey: string;
  private
    FEngine: JFaceEngine;
    FDetectMode: TDetectMode;
    FDetectFaceOrient: TDetectFaceOrient;
    (*
    VIDEO模式取值范围[2,32]，推荐值为16
    IMAGE模式取值范围[2,32]，推荐值为32
    *)
    FDetectFaceScaleVal: Integer;
    // 最大需要检测的人脸个数，取值范围[1,50]
    FDetectFaceMaxNum: Integer;
    // 需要启用的功能组合，可多选
    FDetectMasks: TDetectMasks;
  public
    constructor Create;
    destructor Destroy; override;

    class function checkFile: Boolean;
    class function activeOnline: Integer;
    class function getDetectMode(ADetectMode: TDetectMode): JDetectMode;
    class function getDetectFaceOrientPriority(ADetectFaceOrient: TDetectFaceOrient): JDetectFaceOrientPriority;
    class function getCombinedMask(ADetectMasks: TDetectMasks): Integer;
    // 初始化引擎
    function initEngine: Integer;
    function unInitEngine: Integer;
    // 人脸检测
    function detectFaces(Data: TJavaArray<Byte>; Width: Integer; Height: Integer; Format: Integer; FaceInfoList: JList): Integer;
    // 人脸特征提取
    function extractFaceFeature(Data: TJavaArray<Byte>; Width: Integer; Height: Integer; Format: Integer; FaceInfo: JFaceInfo; Feature: JFaceFeature): Integer;
    // 人脸特征对比
    function compareFaceFeature(Feature1, Feature2: JFaceFeature; FaceSimilar: JFaceSimilar): Integer;
    // 设置RGB/IR活体阈值，若不设置内部默认RGB：0.5, IR：0.7
    function setLivenessParam(rgbThreshold, irThreshold: Single): Integer;
    // 人脸属性检测
    function process(Data: TJavaArray<Byte>; Width: Integer; Height: Integer; Format: Integer; FaceInfoList: JList; ProcessMask: TDetectMasks): Integer;
    // RGB活体检测
    function getLiveness(LivenessInfoList: JList): Integer;
    // 人脸属性检测
    function processIr(Data: TJavaArray<Byte>; Width: Integer; Height: Integer; Format: Integer; FaceInfoList: JList; ProcessMask: TDetectMasks): Integer;
    // IR活体检测
    function getIrLiveness(IRLivenessInfoList: JList): Integer;
  published
    property DetectMode: TDetectMode read FDetectMode write FDetectMode;
    property DetectFaceOrient: TDetectFaceOrient read FDetectFaceOrient write FDetectFaceOrient;
    property DetectFaceScaleVal: Integer read FDetectFaceScaleVal write FDetectFaceScaleVal;
    property DetectFaceMaxNum: Integer read FDetectFaceMaxNum write FDetectFaceMaxNum;
    property DetectMasks: TDetectMasks read FDetectMasks write FDetectMasks;
  end;




implementation

uses
  Androidapi.Helpers, Androidapi.JNI.com.arcsoft.faceHelper.FaceEngineHelper;

{ TAndroidFaceEngine }

class function TAndroidFaceEngine.activeOnline: Integer;
begin
  Result := TJFaceEngine.JavaClass.activeOnline(SharedActivityContext, StringToJString(AppId), StringToJString(SDKKey));
end;

class function TAndroidFaceEngine.checkFile: Boolean;
var
  Dir: JFile;
  Files: TJavaObjectArray<JFile>;
  i: Integer;
begin
  Dir := TJFile.JavaClass.init(SharedActivityContext.getApplicationInfo.nativeLibraryDir);
  Files := Dir.listFiles;
  if(Files = nil) or (Files.Length=0) then
    Exit(False);
  for i := 0 to Files.Length - 1 do
  begin

  end;

end;

function TAndroidFaceEngine.compareFaceFeature(Feature1, Feature2: JFaceFeature;
  FaceSimilar: JFaceSimilar): Integer;
begin
  FaceSimilar := TJFaceSimilar.JavaClass.init;
  Result := FEngine.compareFaceFeature(Feature1, Feature2, FaceSimilar);
end;

constructor TAndroidFaceEngine.Create;
begin
  inherited Create;
end;

destructor TAndroidFaceEngine.Destroy;
begin

  inherited;
end;

function TAndroidFaceEngine.detectFaces(Data: TJavaArray<Byte>; Width, Height,
  Format: Integer; FaceInfoList: JList): Integer;
begin
  Result := FEngine.detectFaces(Data, Width, Height, Format, FaceInfoList);
end;

function TAndroidFaceEngine.extractFaceFeature(Data: TJavaArray<Byte>; Width,
  Height, Format: Integer; FaceInfo: JFaceInfo;
  Feature: JFaceFeature): Integer;
begin
  Result := FEngine.extractFaceFeature(Data, Width, Height, Format, FaceInfo, Feature);

end;

class function TAndroidFaceEngine.getCombinedMask(
  ADetectMasks: TDetectMasks): Integer;
var
  LMask: TDetectMask;
begin
  Result := TJFaceEngine.JavaClass.ASF_NONE;
  if ASF_FACE_DETECT in ADetectMasks then
    Result := Result or TJFaceEngine.JavaClass.ASF_FACE_DETECT;

  if ASF_FACE_RECOGNITION in ADetectMasks then
    Result := Result or TJFaceEngine.JavaClass.ASF_FACE_RECOGNITION;

  if ASF_AGE in ADetectMasks then
    Result := Result or TJFaceEngine.JavaClass.ASF_AGE;

  if ASF_GENDER in ADetectMasks then
    Result := Result or TJFaceEngine.JavaClass.ASF_GENDER;

  if ASF_FACE3DANGLE in ADetectMasks then
    Result := Result or TJFaceEngine.JavaClass.ASF_FACE3DANGLE;

  if ASF_LIVENESS in ADetectMasks then
    Result := Result or TJFaceEngine.JavaClass.ASF_LIVENESS;

  if ASF_IR_LIVENESS in ADetectMasks then
    Result := Result or TJFaceEngine.JavaClass.ASF_IR_LIVENESS;

end;

class function TAndroidFaceEngine.getDetectFaceOrientPriority(
  ADetectFaceOrient: TDetectFaceOrient): JDetectFaceOrientPriority;
begin
  case ADetectFaceOrient of
    ASF_OP_0_ONLY: Result := TJDetectFaceOrientPriority.JavaClass.ASF_OP_0_ONLY;
    ASF_OP_90_ONLY: Result := TJDetectFaceOrientPriority.JavaClass.ASF_OP_90_ONLY;
    ASF_OP_180_ONLY: Result := TJDetectFaceOrientPriority.JavaClass.ASF_OP_180_ONLY;
    ASF_OP_270_ONLY: Result := TJDetectFaceOrientPriority.JavaClass.ASF_OP_270_ONLY;
    ASF_OP_ALL_OUT: Result := TJDetectFaceOrientPriority.JavaClass.ASF_OP_ALL_OUT;
  end;
end;

class function TAndroidFaceEngine.getDetectMode(
  ADetectMode: TDetectMode): JDetectMode;
begin
  case ADetectMode of
    ASF_DETECT_MODE_VIDEO: Result := TJDetectMode.JavaClass.ASF_DETECT_MODE_VIDEO;
    ASF_DETECT_MODE_IMAGE: Result := TJDetectMode.JavaClass.ASF_DETECT_MODE_IMAGE;
  end;
end;

function TAndroidFaceEngine.getIrLiveness(
  IRLivenessInfoList: JList): Integer;
begin
  Result := FEngine.getIrLiveness(IRLivenessInfoList);
end;

function TAndroidFaceEngine.getLiveness(
  LivenessInfoList: JList): Integer;
begin
  Result := FEngine.getLiveness(LivenessInfoList);
end;



function TAndroidFaceEngine.initEngine: Integer;
var
  Mask: TDetectMask;
  LDetectMode: JDetectMode;
  LDetectFaceOrient: JDetectFaceOrientPriority;
  LCombinedMask: Integer;
begin
  FEngine := TJFaceEngine.JavaClass.init;

  LDetectMode := getDetectMode(FDetectMode);
  LDetectFaceOrient := getDetectFaceOrientPriority(FDetectFaceOrient);
  LCombinedMask := getCombinedMask(FDetectMasks);
  Result := TJFaceEngineHelper.JavaClass.initEngine(FEngine, SharedActivityContext, LDetectMode, LDetectFaceOrient, FDetectFaceScaleVal, FDetectFaceMaxNum, LCombinedMask);
end;

function TAndroidFaceEngine.process(Data: TJavaArray<Byte>; Width, Height,
  Format: Integer; FaceInfoList: JList; ProcessMask: TDetectMasks): Integer;
var
  LProcessMask: Integer;
begin
  LProcessMask := getCombinedMask(FDetectMasks);
  Result := FEngine.process(Data, Width, Height, Format, FaceInfoList, LProcessMask);
end;

function TAndroidFaceEngine.processIr(Data: TJavaArray<Byte>; Width, Height,
  Format: Integer; FaceInfoList: JList; ProcessMask: TDetectMasks): Integer;
var
  LProcessMask: Integer;
begin
  LProcessMask := getCombinedMask(FDetectMasks);
  Result := FEngine.processIr(Data, Width, Height, Format, FaceInfoList, LProcessMask);
end;

function TAndroidFaceEngine.setLivenessParam(
  rgbThreshold, irThreshold: Single): Integer;
var
  LivenessParam: JLivenessParam;
begin
  LivenessParam := TJLivenessParam.JavaClass.init(rgbThreshold, irThreshold);
  Result := FEngine.setLivenessParam(LivenessParam);
end;

function TAndroidFaceEngine.unInitEngine: Integer;
begin
  Result := 0;
  if FEngine <> nil then
  begin
    Result := FEngine.unInit;
    FEngine := nil;
  end;
end;




end.
