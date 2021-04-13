//====================================================
//
//  转换来自JarOrClass2Pas(原JavaClassToDelphiUnit)
//  原始作者：ying32
//  QQ: 1444386932、396506155
//  Email：yuanfen3287@vip.qq.com
//
//  修改 By：Flying Wang & 爱吃猪头肉
//  请不要移除以上的任何信息。
//  请不要将本版本发到城通网盘，否则死全家。
//
//  Email：1765535979@qq.com
//  QQ Group：165232328
//
//  生成时间：2020/8/31 21:22:02
//  工具版本：1.0.2018.2.26
//
//====================================================
unit Androidapi.JNI.arcsoft_face;

interface

uses
  Androidapi.JNIBridge, 
  Androidapi.JNI.JavaTypes, 
  Androidapi.JNI.GraphicsContentViewText;


type

// ===== Forward declarations =====

  JActiveFileInfo = interface; //com.arcsoft.face.ActiveFileInfo
  JAgeInfo = interface; //com.arcsoft.face.AgeInfo
  JBuildConfig = interface; //com.arcsoft.face.BuildConfig
  JCompareModel = interface; //com.arcsoft.face.enums.CompareModel
  JDetectFaceOrientPriority = interface; //com.arcsoft.face.enums.DetectFaceOrientPriority
  JDetectMode = interface; //com.arcsoft.face.enums.DetectMode
  JDetectModel = interface; //com.arcsoft.face.enums.DetectModel
  JRuntimeABI = interface; //com.arcsoft.face.enums.RuntimeABI
  JErrorInfo = interface; //com.arcsoft.face.ErrorInfo
  JFace3DAngle = interface; //com.arcsoft.face.Face3DAngle
  JFaceEngine = interface; //com.arcsoft.face.FaceEngine
  JFaceFeature = interface; //com.arcsoft.face.FaceFeature
  JFaceInfo = interface; //com.arcsoft.face.FaceInfo
  JFaceSimilar = interface; //com.arcsoft.face.FaceSimilar
  JGenderInfo = interface; //com.arcsoft.face.GenderInfo
  JLivenessInfo = interface; //com.arcsoft.face.LivenessInfo
  JLivenessParam = interface; //com.arcsoft.face.LivenessParam
  JArcSoftImageInfo = interface; //com.arcsoft.face.model.ArcSoftImageInfo
  JImageUtils = interface; //com.arcsoft.face.util.ImageUtils
  JVersionInfo = interface; //com.arcsoft.face.VersionInfo

// ===== Forward SuperClasses declarations =====


// ===== Interface declarations =====

  JActiveFileInfoClass = interface(JObjectClass)
  ['{084D5487-DEB1-4D1E-8C6B-52B5CAF304E1}']
    { static Property Methods }

    { static Methods }
    {class} function init: JActiveFileInfo; cdecl; //()V

    { static Property }
  end;

  [JavaSignature('com/arcsoft/face/ActiveFileInfo')]
  JActiveFileInfo = interface(JObject)
  ['{DACE3650-DC36-478D-BBC4-C762D77153CC}']
    { Property Methods }

    { methods }
    function getAppId: JString; cdecl; //()Ljava/lang/String;
    function getSdkKey: JString; cdecl; //()Ljava/lang/String;
    function getPlatform: JString; cdecl; //()Ljava/lang/String;
    function getSdkType: JString; cdecl; //()Ljava/lang/String;
    function getSdkVersion: JString; cdecl; //()Ljava/lang/String;
    function getFileVersion: JString; cdecl; //()Ljava/lang/String;
    function getStartTime: JString; cdecl; //()Ljava/lang/String;
    function getEndTime: JString; cdecl; //()Ljava/lang/String;
    function toString: JString; cdecl; //()Ljava/lang/String;

    { Property }
  end;

  TJActiveFileInfo = class(TJavaGenericImport<JActiveFileInfoClass, JActiveFileInfo>) end;

  JAgeInfoClass = interface(JObjectClass)
  ['{FFDEEEFF-835C-4F13-AF7D-6B2DD676A0A3}']
    { static Property Methods }
    {class} function _GetUNKNOWN_AGE: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I

    { static Methods }
    {class} function init: JAgeInfo; cdecl; overload; //()V
    {class} function init(obj: JAgeInfo): JAgeInfo; cdecl; overload; //(Lcom/arcsoft/face/AgeInfo;)V

    { static Property }
    {class} property UNKNOWN_AGE: Integer read _GetUNKNOWN_AGE;
  end;

  [JavaSignature('com/arcsoft/face/AgeInfo')]
  JAgeInfo = interface(JObject)
  ['{B5818482-F1F2-46E1-824F-B5E709A14EA1}']
    { Property Methods }

    { methods }
    function getAge: Integer; cdecl; //()I
    function clone: JAgeInfo; cdecl; overload; //()Lcom/arcsoft/face/AgeInfo;
    //function clone: JObject; cdecl; overload; //()Ljava/lang/Object;

    { Property }
  end;

  TJAgeInfo = class(TJavaGenericImport<JAgeInfoClass, JAgeInfo>) end;

  JBuildConfigClass = interface(JObjectClass)
  ['{75419BB0-AE40-452E-9E48-929B40DE906F}']
    { static Property Methods }
    {class} function _GetDEBUG: Boolean;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //Z
    {class} function _GetAPPLICATION_ID: JString;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //Ljava/lang/String;
    {class} function _GetBUILD_TYPE: JString;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //Ljava/lang/String;
    {class} function _GetFLAVOR: JString;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //Ljava/lang/String;
    {class} function _GetVERSION_CODE: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I
    {class} function _GetVERSION_NAME: JString;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //Ljava/lang/String;

    { static Methods }
    {class} function init: JBuildConfig; cdecl; //()V

    { static Property }
    {class} property DEBUG: Boolean read _GetDEBUG;
    {class} property APPLICATION_ID: JString read _GetAPPLICATION_ID;
    {class} property BUILD_TYPE: JString read _GetBUILD_TYPE;
    {class} property FLAVOR: JString read _GetFLAVOR;
    {class} property VERSION_CODE: Integer read _GetVERSION_CODE;
    {class} property VERSION_NAME: JString read _GetVERSION_NAME;
  end;

  [JavaSignature('com/arcsoft/face/BuildConfig')]
  JBuildConfig = interface(JObject)
  ['{333B8BA4-1FA0-4EF4-A0FD-8A9E75FE2CBB}']
    { Property Methods }

    { methods }

    { Property }
  end;

  TJBuildConfig = class(TJavaGenericImport<JBuildConfigClass, JBuildConfig>) end;

  JCompareModelClass = interface(JEnumClass) // or JObjectClass // SuperSignature: java/lang/Enum
  ['{A15904CD-E92F-47F8-981B-1C3683F484C1}']
    { static Property Methods }
    {class} function _GetLIFE_PHOTO: JCompareModel;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //Lcom/arcsoft/face/enums/CompareModel;
    {class} function _GetID_CARD: JCompareModel;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //Lcom/arcsoft/face/enums/CompareModel;

    { static Methods }
    {class} function values: TJavaObjectArray<JCompareModel>; cdecl; //()[Lcom/arcsoft/face/enums/CompareModel;
    {class} function valueOf(name: JString): JCompareModel; cdecl; //(Ljava/lang/String;)Lcom/arcsoft/face/enums/CompareModel;

    { static Property }
    {class} property LIFE_PHOTO: JCompareModel read _GetLIFE_PHOTO;
    {class} property ID_CARD: JCompareModel read _GetID_CARD;
  end;

  [JavaSignature('com/arcsoft/face/enums/CompareModel')]
  JCompareModel = interface(JEnum) // or JObject // SuperSignature: java/lang/Enum
  ['{A9CA5FD6-C9DA-40B5-90C5-3AFEC5554CA6}']
    { Property Methods }

    { methods }
    function getModel: Integer; cdecl; //()I

    { Property }
  end;

  TJCompareModel = class(TJavaGenericImport<JCompareModelClass, JCompareModel>) end;

  JDetectFaceOrientPriorityClass = interface(JEnumClass) // or JObjectClass // SuperSignature: java/lang/Enum
  ['{1F732885-AF10-4A9D-AF5A-A94668F288FB}']
    { static Property Methods }
    {class} function _GetASF_OP_0_ONLY: JDetectFaceOrientPriority;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //Lcom/arcsoft/face/enums/DetectFaceOrientPriority;
    {class} function _GetASF_OP_90_ONLY: JDetectFaceOrientPriority;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //Lcom/arcsoft/face/enums/DetectFaceOrientPriority;
    {class} function _GetASF_OP_270_ONLY: JDetectFaceOrientPriority;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //Lcom/arcsoft/face/enums/DetectFaceOrientPriority;
    {class} function _GetASF_OP_180_ONLY: JDetectFaceOrientPriority;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //Lcom/arcsoft/face/enums/DetectFaceOrientPriority;
    {class} function _GetASF_OP_ALL_OUT: JDetectFaceOrientPriority;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //Lcom/arcsoft/face/enums/DetectFaceOrientPriority;

    { static Methods }
    {class} function values: TJavaObjectArray<JDetectFaceOrientPriority>; cdecl; //()[Lcom/arcsoft/face/enums/DetectFaceOrientPriority;
    {class} function valueOf(name: JString): JDetectFaceOrientPriority; cdecl; //(Ljava/lang/String;)Lcom/arcsoft/face/enums/DetectFaceOrientPriority;

    { static Property }
    {class} property ASF_OP_0_ONLY: JDetectFaceOrientPriority read _GetASF_OP_0_ONLY;
    {class} property ASF_OP_90_ONLY: JDetectFaceOrientPriority read _GetASF_OP_90_ONLY;
    {class} property ASF_OP_270_ONLY: JDetectFaceOrientPriority read _GetASF_OP_270_ONLY;
    {class} property ASF_OP_180_ONLY: JDetectFaceOrientPriority read _GetASF_OP_180_ONLY;
    {class} property ASF_OP_ALL_OUT: JDetectFaceOrientPriority read _GetASF_OP_ALL_OUT;
  end;

  [JavaSignature('com/arcsoft/face/enums/DetectFaceOrientPriority')]
  JDetectFaceOrientPriority = interface(JEnum) // or JObject // SuperSignature: java/lang/Enum
  ['{001012AC-7576-4473-8E1E-4FFE20EB3048}']
    { Property Methods }

    { methods }
    function getPriority: Integer; cdecl; //()I

    { Property }
  end;

  TJDetectFaceOrientPriority = class(TJavaGenericImport<JDetectFaceOrientPriorityClass, JDetectFaceOrientPriority>) end;

  JDetectModeClass = interface(JEnumClass) // or JObjectClass // SuperSignature: java/lang/Enum
  ['{ECC6873E-CF78-413E-9F46-FEAF4E18BB00}']
    { static Property Methods }
    {class} function _GetASF_DETECT_MODE_VIDEO: JDetectMode;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //Lcom/arcsoft/face/enums/DetectMode;
    {class} function _GetASF_DETECT_MODE_IMAGE: JDetectMode;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //Lcom/arcsoft/face/enums/DetectMode;

    { static Methods }
    {class} function values: TJavaObjectArray<JDetectMode>; cdecl; //()[Lcom/arcsoft/face/enums/DetectMode;
    {class} function valueOf(name: JString): JDetectMode; cdecl; //(Ljava/lang/String;)Lcom/arcsoft/face/enums/DetectMode;

    { static Property }
    {class} property ASF_DETECT_MODE_VIDEO: JDetectMode read _GetASF_DETECT_MODE_VIDEO;
    {class} property ASF_DETECT_MODE_IMAGE: JDetectMode read _GetASF_DETECT_MODE_IMAGE;
  end;

  [JavaSignature('com/arcsoft/face/enums/DetectMode')]
  JDetectMode = interface(JEnum) // or JObject // SuperSignature: java/lang/Enum
  ['{BE44B041-99C2-4D1A-9682-8537D0C803FF}']
    { Property Methods }

    { methods }
    function getMode: Int64; cdecl; //()J

    { Property }
  end;

  TJDetectMode = class(TJavaGenericImport<JDetectModeClass, JDetectMode>) end;

  JDetectModelClass = interface(JEnumClass) // or JObjectClass // SuperSignature: java/lang/Enum
  ['{305EFF68-F248-41E1-AB38-D6EBB66B3731}']
    { static Property Methods }
    {class} function _GetRGB: JDetectModel;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //Lcom/arcsoft/face/enums/DetectModel;

    { static Methods }
    {class} function values: TJavaObjectArray<JDetectModel>; cdecl; //()[Lcom/arcsoft/face/enums/DetectModel;
    {class} function valueOf(name: JString): JDetectModel; cdecl; //(Ljava/lang/String;)Lcom/arcsoft/face/enums/DetectModel;

    { static Property }
    {class} property RGB: JDetectModel read _GetRGB;
  end;

  [JavaSignature('com/arcsoft/face/enums/DetectModel')]
  JDetectModel = interface(JEnum) // or JObject // SuperSignature: java/lang/Enum
  ['{847DA0C1-E60C-40E4-B72C-4299CD46C9EA}']
    { Property Methods }

    { methods }
    function getModel: Integer; cdecl; //()I

    { Property }
  end;

  TJDetectModel = class(TJavaGenericImport<JDetectModelClass, JDetectModel>) end;

  JRuntimeABIClass = interface(JEnumClass) // or JObjectClass // SuperSignature: java/lang/Enum
  ['{B2B8BF0C-3A77-4B70-8522-3364F731D914}']
    { static Property Methods }
    {class} function _GetANDROID_ABI_UNSUPPORTED: JRuntimeABI;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //Lcom/arcsoft/face/enums/RuntimeABI;
    {class} function _GetANDROID_ABI_ARM64: JRuntimeABI;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //Lcom/arcsoft/face/enums/RuntimeABI;
    {class} function _GetANDROID_ABI_ARM32: JRuntimeABI;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //Lcom/arcsoft/face/enums/RuntimeABI;

    { static Methods }
    {class} function values: TJavaObjectArray<JRuntimeABI>; cdecl; //()[Lcom/arcsoft/face/enums/RuntimeABI;
    {class} function valueOf(name: JString): JRuntimeABI; cdecl; //(Ljava/lang/String;)Lcom/arcsoft/face/enums/RuntimeABI;

    { static Property }
    {class} property ANDROID_ABI_UNSUPPORTED: JRuntimeABI read _GetANDROID_ABI_UNSUPPORTED;
    {class} property ANDROID_ABI_ARM64: JRuntimeABI read _GetANDROID_ABI_ARM64;
    {class} property ANDROID_ABI_ARM32: JRuntimeABI read _GetANDROID_ABI_ARM32;
  end;

  [JavaSignature('com/arcsoft/face/enums/RuntimeABI')]
  JRuntimeABI = interface(JEnum) // or JObject // SuperSignature: java/lang/Enum
  ['{51BF12A9-5EF3-478A-8DA9-B5143F14DFBA}']
    { Property Methods }

    { methods }

    { Property }
  end;

  TJRuntimeABI = class(TJavaGenericImport<JRuntimeABIClass, JRuntimeABI>) end;

  JErrorInfoClass = interface(JObjectClass)
  ['{770400ED-9355-480E-9DC2-8E588FFB5F7A}']
    { static Property Methods }
    {class} function _GetMOK: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I
    {class} function _GetMERR_BASIC_BASE: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I
    {class} function _GetMERR_UNKNOWN: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I
    {class} function _GetMERR_INVALID_PARAM: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I
    {class} function _GetMERR_UNSUPPORTED: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I
    {class} function _GetMERR_NO_MEMORY: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I
    {class} function _GetMERR_BAD_STATE: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I
    {class} function _GetMERR_USER_CANCEL: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I
    {class} function _GetMERR_EXPIRED: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I
    {class} function _GetMERR_USER_PAUSE: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I
    {class} function _GetMERR_BUFFER_OVERFLOW: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I
    {class} function _GetMERR_BUFFER_UNDERFLOW: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I
    {class} function _GetMERR_NO_DISKSPACE: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I
    {class} function _GetMERR_COMPONENT_NOT_EXIST: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I
    {class} function _GetMERR_GLOBAL_DATA_NOT_EXIST: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I
    {class} function _GetMERR_FSDK_BASE: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I
    {class} function _GetMERR_FSDK_INVALID_APP_ID: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I
    {class} function _GetMERR_FSDK_INVALID_SDK_ID: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I
    {class} function _GetMERR_FSDK_INVALID_ID_PAIR: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I
    {class} function _GetMERR_FSDK_MISMATCH_ID_AND_SDK: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I
    {class} function _GetMERR_FSDK_SYSTEM_VERSION_UNSUPPORTED: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I
    {class} function _GetMERR_FSDK_FR_ERROR_BASE: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I
    {class} function _GetMERR_FSDK_FR_INVALID_MEMORY_INFO: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I
    {class} function _GetMERR_FSDK_FR_INVALID_IMAGE_INFO: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I
    {class} function _GetMERR_FSDK_FR_INVALID_FACE_INFO: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I
    {class} function _GetMERR_FSDK_FR_NO_GPU_AVAILABLE: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I
    {class} function _GetMERR_FSDK_FR_MISMATCHED_FEATURE_LEVEL: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I
    {class} function _GetMERR_FSDK_FACEFEATURE_ERROR_BASE: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I
    {class} function _GetMERR_FSDK_FACEFEATURE_UNKNOWN: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I
    {class} function _GetMERR_FSDK_FACEFEATURE_MEMORY: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I
    {class} function _GetMERR_FSDK_FACEFEATURE_INVALID_FORMAT: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I
    {class} function _GetMERR_FSDK_FACEFEATURE_INVALID_PARAM: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I
    {class} function _GetMERR_FSDK_FACEFEATURE_LOW_CONFIDENCE_LEVEL: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I
    {class} function _GetMERR_ASF_EX_BASE: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I
    {class} function _GetMERR_ASF_EX_FEATURE_UNSUPPORTED_ON_INIT: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I
    {class} function _GetMERR_ASF_EX_FEATURE_UNINITED: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I
    {class} function _GetMERR_ASF_EX_FEATURE_UNPROCESSED: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I
    {class} function _GetMERR_ASF_EX_FEATURE_UNSUPPORTED_ON_PROCESS: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I
    {class} function _GetMERR_ASF_EX_INVALID_IMAGE_INFO: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I
    {class} function _GetMERR_ASF_EX_INVALID_FACE_INFO: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I
    {class} function _GetMERR_ASF_BASE: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I
    {class} function _GetMERR_ASF_ACTIVATION_FAIL: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I
    {class} function _GetMERR_ASF_ALREADY_ACTIVATED: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I
    {class} function _GetMERR_ASF_NOT_ACTIVATED: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I
    {class} function _GetMERR_ASF_SCALE_NOT_SUPPORT: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I
    {class} function _GetMERR_ASF_ACTIVEFILE_SDKTYPE_MISMATCH: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I
    {class} function _GetMERR_ASF_DEVICE_MISMATCH: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I
    {class} function _GetMERR_ASF_UNIQUE_IDENTIFIER_ILLEGAL: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I
    {class} function _GetMERR_ASF_PARAM_NULL: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I
    {class} function _GetMERR_ASF_LIVENESS_EXPIRED: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I
    {class} function _GetMERR_ASF_VERSION_NOT_SUPPORT: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I
    {class} function _GetMERR_ASF_SIGN_ERROR: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I
    {class} function _GetMERR_ASF_DATABASE_ERROR: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I
    {class} function _GetMERR_ASF_UNIQUE_CHECKOUT_FAIL: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I
    {class} function _GetMERR_ASF_COLOR_SPACE_NOT_SUPPORT: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I
    {class} function _GetMERR_ASF_IMAGE_WIDTH_HEIGHT_NOT_SUPPORT: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I
    {class} function _GetMERR_ASF_BASE_EXTEND: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I
    {class} function _GetMERR_ASF_READ_PHONE_STATE_DENIED: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I
    {class} function _GetMERR_ASF_ACTIVATION_DATA_DESTROYED: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I
    {class} function _GetMERR_ASF_SERVER_UNKNOWN_ERROR: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I
    {class} function _GetMERR_ASF_INTERNET_DENIED: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I
    {class} function _GetMERR_ASF_ACTIVEFILE_SDK_MISMATCH: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I
    {class} function _GetMERR_ASF_DEVICEINFO_LESS: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I
    {class} function _GetMERR_ASF_LOCAL_TIME_NOT_CALIBRATED: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I
    {class} function _GetMERR_ASF_APPID_DATA_DECRYPT: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I
    {class} function _GetMERR_ASF_APPID_APPKEY_SDK_MISMATCH: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I
    {class} function _GetMERR_ASF_NO_REQUEST: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I
    {class} function _GetMERR_ASF_ACTIVE_FILE_NO_EXIST: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I
    {class} function _GetMERR_ASF_CURRENT_DEVICE_TIME_INCORRECT: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I
    {class} function _GetMERR_ASF_DETECT_MODEL_UNSUPPORTED: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I
    {class} function _GetMERR_ASF_ACTIVATION_QUANTITY_OUT_OF_LIMIT: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I
    {class} function _GetMERR_ASF_IP_BLACK_LIST: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I
    {class} function _GetMERR_ASF_NETWORK_BASE: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I
    {class} function _GetMERR_ASF_NETWORK_COULDNT_RESOLVE_HOST: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I
    {class} function _GetMERR_ASF_NETWORK_COULDNT_CONNECT_SERVER: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I
    {class} function _GetMERR_ASF_NETWORK_CONNECT_TIMEOUT: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I
    {class} function _GetMERR_ASF_NETWORK_UNKNOWN_ERROR: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I

    { static Methods }

    { static Property }
    {class} property MOK: Integer read _GetMOK;
    {class} property MERR_BASIC_BASE: Integer read _GetMERR_BASIC_BASE;
    {class} property MERR_UNKNOWN: Integer read _GetMERR_UNKNOWN;
    {class} property MERR_INVALID_PARAM: Integer read _GetMERR_INVALID_PARAM;
    {class} property MERR_UNSUPPORTED: Integer read _GetMERR_UNSUPPORTED;
    {class} property MERR_NO_MEMORY: Integer read _GetMERR_NO_MEMORY;
    {class} property MERR_BAD_STATE: Integer read _GetMERR_BAD_STATE;
    {class} property MERR_USER_CANCEL: Integer read _GetMERR_USER_CANCEL;
    {class} property MERR_EXPIRED: Integer read _GetMERR_EXPIRED;
    {class} property MERR_USER_PAUSE: Integer read _GetMERR_USER_PAUSE;
    {class} property MERR_BUFFER_OVERFLOW: Integer read _GetMERR_BUFFER_OVERFLOW;
    {class} property MERR_BUFFER_UNDERFLOW: Integer read _GetMERR_BUFFER_UNDERFLOW;
    {class} property MERR_NO_DISKSPACE: Integer read _GetMERR_NO_DISKSPACE;
    {class} property MERR_COMPONENT_NOT_EXIST: Integer read _GetMERR_COMPONENT_NOT_EXIST;
    {class} property MERR_GLOBAL_DATA_NOT_EXIST: Integer read _GetMERR_GLOBAL_DATA_NOT_EXIST;
    {class} property MERR_FSDK_BASE: Integer read _GetMERR_FSDK_BASE;
    {class} property MERR_FSDK_INVALID_APP_ID: Integer read _GetMERR_FSDK_INVALID_APP_ID;
    {class} property MERR_FSDK_INVALID_SDK_ID: Integer read _GetMERR_FSDK_INVALID_SDK_ID;
    {class} property MERR_FSDK_INVALID_ID_PAIR: Integer read _GetMERR_FSDK_INVALID_ID_PAIR;
    {class} property MERR_FSDK_MISMATCH_ID_AND_SDK: Integer read _GetMERR_FSDK_MISMATCH_ID_AND_SDK;
    {class} property MERR_FSDK_SYSTEM_VERSION_UNSUPPORTED: Integer read _GetMERR_FSDK_SYSTEM_VERSION_UNSUPPORTED;
    {class} property MERR_FSDK_FR_ERROR_BASE: Integer read _GetMERR_FSDK_FR_ERROR_BASE;
    {class} property MERR_FSDK_FR_INVALID_MEMORY_INFO: Integer read _GetMERR_FSDK_FR_INVALID_MEMORY_INFO;
    {class} property MERR_FSDK_FR_INVALID_IMAGE_INFO: Integer read _GetMERR_FSDK_FR_INVALID_IMAGE_INFO;
    {class} property MERR_FSDK_FR_INVALID_FACE_INFO: Integer read _GetMERR_FSDK_FR_INVALID_FACE_INFO;
    {class} property MERR_FSDK_FR_NO_GPU_AVAILABLE: Integer read _GetMERR_FSDK_FR_NO_GPU_AVAILABLE;
    {class} property MERR_FSDK_FR_MISMATCHED_FEATURE_LEVEL: Integer read _GetMERR_FSDK_FR_MISMATCHED_FEATURE_LEVEL;
    {class} property MERR_FSDK_FACEFEATURE_ERROR_BASE: Integer read _GetMERR_FSDK_FACEFEATURE_ERROR_BASE;
    {class} property MERR_FSDK_FACEFEATURE_UNKNOWN: Integer read _GetMERR_FSDK_FACEFEATURE_UNKNOWN;
    {class} property MERR_FSDK_FACEFEATURE_MEMORY: Integer read _GetMERR_FSDK_FACEFEATURE_MEMORY;
    {class} property MERR_FSDK_FACEFEATURE_INVALID_FORMAT: Integer read _GetMERR_FSDK_FACEFEATURE_INVALID_FORMAT;
    {class} property MERR_FSDK_FACEFEATURE_INVALID_PARAM: Integer read _GetMERR_FSDK_FACEFEATURE_INVALID_PARAM;
    {class} property MERR_FSDK_FACEFEATURE_LOW_CONFIDENCE_LEVEL: Integer read _GetMERR_FSDK_FACEFEATURE_LOW_CONFIDENCE_LEVEL;
    {class} property MERR_ASF_EX_BASE: Integer read _GetMERR_ASF_EX_BASE;
    {class} property MERR_ASF_EX_FEATURE_UNSUPPORTED_ON_INIT: Integer read _GetMERR_ASF_EX_FEATURE_UNSUPPORTED_ON_INIT;
    {class} property MERR_ASF_EX_FEATURE_UNINITED: Integer read _GetMERR_ASF_EX_FEATURE_UNINITED;
    {class} property MERR_ASF_EX_FEATURE_UNPROCESSED: Integer read _GetMERR_ASF_EX_FEATURE_UNPROCESSED;
    {class} property MERR_ASF_EX_FEATURE_UNSUPPORTED_ON_PROCESS: Integer read _GetMERR_ASF_EX_FEATURE_UNSUPPORTED_ON_PROCESS;
    {class} property MERR_ASF_EX_INVALID_IMAGE_INFO: Integer read _GetMERR_ASF_EX_INVALID_IMAGE_INFO;
    {class} property MERR_ASF_EX_INVALID_FACE_INFO: Integer read _GetMERR_ASF_EX_INVALID_FACE_INFO;
    {class} property MERR_ASF_BASE: Integer read _GetMERR_ASF_BASE;
    {class} property MERR_ASF_ACTIVATION_FAIL: Integer read _GetMERR_ASF_ACTIVATION_FAIL;
    {class} property MERR_ASF_ALREADY_ACTIVATED: Integer read _GetMERR_ASF_ALREADY_ACTIVATED;
    {class} property MERR_ASF_NOT_ACTIVATED: Integer read _GetMERR_ASF_NOT_ACTIVATED;
    {class} property MERR_ASF_SCALE_NOT_SUPPORT: Integer read _GetMERR_ASF_SCALE_NOT_SUPPORT;
    {class} property MERR_ASF_ACTIVEFILE_SDKTYPE_MISMATCH: Integer read _GetMERR_ASF_ACTIVEFILE_SDKTYPE_MISMATCH;
    {class} property MERR_ASF_DEVICE_MISMATCH: Integer read _GetMERR_ASF_DEVICE_MISMATCH;
    {class} property MERR_ASF_UNIQUE_IDENTIFIER_ILLEGAL: Integer read _GetMERR_ASF_UNIQUE_IDENTIFIER_ILLEGAL;
    {class} property MERR_ASF_PARAM_NULL: Integer read _GetMERR_ASF_PARAM_NULL;
    {class} property MERR_ASF_LIVENESS_EXPIRED: Integer read _GetMERR_ASF_LIVENESS_EXPIRED;
    {class} property MERR_ASF_VERSION_NOT_SUPPORT: Integer read _GetMERR_ASF_VERSION_NOT_SUPPORT;
    {class} property MERR_ASF_SIGN_ERROR: Integer read _GetMERR_ASF_SIGN_ERROR;
    {class} property MERR_ASF_DATABASE_ERROR: Integer read _GetMERR_ASF_DATABASE_ERROR;
    {class} property MERR_ASF_UNIQUE_CHECKOUT_FAIL: Integer read _GetMERR_ASF_UNIQUE_CHECKOUT_FAIL;
    {class} property MERR_ASF_COLOR_SPACE_NOT_SUPPORT: Integer read _GetMERR_ASF_COLOR_SPACE_NOT_SUPPORT;
    {class} property MERR_ASF_IMAGE_WIDTH_HEIGHT_NOT_SUPPORT: Integer read _GetMERR_ASF_IMAGE_WIDTH_HEIGHT_NOT_SUPPORT;
    {class} property MERR_ASF_BASE_EXTEND: Integer read _GetMERR_ASF_BASE_EXTEND;
    {class} property MERR_ASF_READ_PHONE_STATE_DENIED: Integer read _GetMERR_ASF_READ_PHONE_STATE_DENIED;
    {class} property MERR_ASF_ACTIVATION_DATA_DESTROYED: Integer read _GetMERR_ASF_ACTIVATION_DATA_DESTROYED;
    {class} property MERR_ASF_SERVER_UNKNOWN_ERROR: Integer read _GetMERR_ASF_SERVER_UNKNOWN_ERROR;
    {class} property MERR_ASF_INTERNET_DENIED: Integer read _GetMERR_ASF_INTERNET_DENIED;
    {class} property MERR_ASF_ACTIVEFILE_SDK_MISMATCH: Integer read _GetMERR_ASF_ACTIVEFILE_SDK_MISMATCH;
    {class} property MERR_ASF_DEVICEINFO_LESS: Integer read _GetMERR_ASF_DEVICEINFO_LESS;
    {class} property MERR_ASF_LOCAL_TIME_NOT_CALIBRATED: Integer read _GetMERR_ASF_LOCAL_TIME_NOT_CALIBRATED;
    {class} property MERR_ASF_APPID_DATA_DECRYPT: Integer read _GetMERR_ASF_APPID_DATA_DECRYPT;
    {class} property MERR_ASF_APPID_APPKEY_SDK_MISMATCH: Integer read _GetMERR_ASF_APPID_APPKEY_SDK_MISMATCH;
    {class} property MERR_ASF_NO_REQUEST: Integer read _GetMERR_ASF_NO_REQUEST;
    {class} property MERR_ASF_ACTIVE_FILE_NO_EXIST: Integer read _GetMERR_ASF_ACTIVE_FILE_NO_EXIST;
    {class} property MERR_ASF_CURRENT_DEVICE_TIME_INCORRECT: Integer read _GetMERR_ASF_CURRENT_DEVICE_TIME_INCORRECT;
    {class} property MERR_ASF_DETECT_MODEL_UNSUPPORTED: Integer read _GetMERR_ASF_DETECT_MODEL_UNSUPPORTED;
    {class} property MERR_ASF_ACTIVATION_QUANTITY_OUT_OF_LIMIT: Integer read _GetMERR_ASF_ACTIVATION_QUANTITY_OUT_OF_LIMIT;
    {class} property MERR_ASF_IP_BLACK_LIST: Integer read _GetMERR_ASF_IP_BLACK_LIST;
    {class} property MERR_ASF_NETWORK_BASE: Integer read _GetMERR_ASF_NETWORK_BASE;
    {class} property MERR_ASF_NETWORK_COULDNT_RESOLVE_HOST: Integer read _GetMERR_ASF_NETWORK_COULDNT_RESOLVE_HOST;
    {class} property MERR_ASF_NETWORK_COULDNT_CONNECT_SERVER: Integer read _GetMERR_ASF_NETWORK_COULDNT_CONNECT_SERVER;
    {class} property MERR_ASF_NETWORK_CONNECT_TIMEOUT: Integer read _GetMERR_ASF_NETWORK_CONNECT_TIMEOUT;
    {class} property MERR_ASF_NETWORK_UNKNOWN_ERROR: Integer read _GetMERR_ASF_NETWORK_UNKNOWN_ERROR;
  end;

  [JavaSignature('com/arcsoft/face/ErrorInfo')]
  JErrorInfo = interface(JObject)
  ['{70B376B9-9C43-4B10-B35B-1CBABBF078E8}']
    { Property Methods }

    { methods }

    { Property }
  end;

  TJErrorInfo = class(TJavaGenericImport<JErrorInfoClass, JErrorInfo>) end;

  JFace3DAngleClass = interface(JObjectClass)
  ['{54E4326F-D682-4263-AFDE-B29537268C52}']
    { static Property Methods }

    { static Methods }
    {class} function init: JFace3DAngle; cdecl; overload; //()V
    {class} function init(obj: JFace3DAngle): JFace3DAngle; cdecl; overload; //(Lcom/arcsoft/face/Face3DAngle;)V

    { static Property }
  end;

  [JavaSignature('com/arcsoft/face/Face3DAngle')]
  JFace3DAngle = interface(JObject)
  ['{5E1541EA-2EB1-4396-AF42-18F537A97F0C}']
    { Property Methods }

    { methods }
    function getYaw: Single; cdecl; //()F
    function getRoll: Single; cdecl; //()F
    function getPitch: Single; cdecl; //()F
    function getStatus: Integer; cdecl; //()I
    function clone: JFace3DAngle; cdecl; overload; //()Lcom/arcsoft/face/Face3DAngle;
    function toString: JString; cdecl; //()Ljava/lang/String;
    //function clone: JObject; cdecl; overload; //()Ljava/lang/Object;

    { Property }
  end;

  TJFace3DAngle = class(TJavaGenericImport<JFace3DAngleClass, JFace3DAngle>) end;

  JFaceEngineClass = interface(JObjectClass)
  ['{7CF7CAE9-FA6A-4822-B3B1-51E17ADB70D8}']
    { static Property Methods }
    {class} function _GetASF_NONE: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I
    {class} function _GetASF_FACE_DETECT: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I
    {class} function _GetASF_FACE_RECOGNITION: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I
    {class} function _GetASF_AGE: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I
    {class} function _GetASF_GENDER: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I
    {class} function _GetASF_FACE3DANGLE: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I
    {class} function _GetASF_LIVENESS: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I
    {class} function _GetASF_IR_LIVENESS: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I
    {class} function _GetCP_PAF_NV21: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I
    {class} function _GetCP_PAF_BGR24: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I
    {class} function _GetCP_PAF_GRAY: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I
    {class} function _GetCP_PAF_DEPTH_U16: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I
    {class} function _GetASF_OC_0: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I
    {class} function _GetASF_OC_90: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I
    {class} function _GetASF_OC_270: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I
    {class} function _GetASF_OC_180: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I
    {class} function _GetASF_OC_30: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I
    {class} function _GetASF_OC_60: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I
    {class} function _GetASF_OC_120: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I
    {class} function _GetASF_OC_150: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I
    {class} function _GetASF_OC_210: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I
    {class} function _GetASF_OC_240: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I
    {class} function _GetASF_OC_300: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I
    {class} function _GetASF_OC_330: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I

    { static Methods }
    {class} function getRuntimeABI: JRuntimeABI; cdecl; //()Lcom/arcsoft/face/enums/RuntimeABI;
    {class} function init: JFaceEngine; cdecl; overload; //()V
    {class} function active(context: JContext; appId: JString; sdkKey: JString): Integer; cdecl; //(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)I
    {class} function activeOnline(context: JContext; appId: JString; sdkKey: JString): Integer; cdecl; //(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)I
    {class} function getActiveFileInfo(context: JContext; activeFileInfo: JActiveFileInfo): Integer; cdecl; //(Landroid/content/Context;Lcom/arcsoft/face/ActiveFileInfo;)I
    {class} function getVersion(versionInfo: JVersionInfo): Integer; cdecl; //(Lcom/arcsoft/face/VersionInfo;)I

    { static Property }
    {class} property ASF_NONE: Integer read _GetASF_NONE;
    {class} property ASF_FACE_DETECT: Integer read _GetASF_FACE_DETECT;
    {class} property ASF_FACE_RECOGNITION: Integer read _GetASF_FACE_RECOGNITION;
    {class} property ASF_AGE: Integer read _GetASF_AGE;
    {class} property ASF_GENDER: Integer read _GetASF_GENDER;
    {class} property ASF_FACE3DANGLE: Integer read _GetASF_FACE3DANGLE;
    {class} property ASF_LIVENESS: Integer read _GetASF_LIVENESS;
    {class} property ASF_IR_LIVENESS: Integer read _GetASF_IR_LIVENESS;
    {class} property CP_PAF_NV21: Integer read _GetCP_PAF_NV21;
    {class} property CP_PAF_BGR24: Integer read _GetCP_PAF_BGR24;
    {class} property CP_PAF_GRAY: Integer read _GetCP_PAF_GRAY;
    {class} property CP_PAF_DEPTH_U16: Integer read _GetCP_PAF_DEPTH_U16;
    {class} property ASF_OC_0: Integer read _GetASF_OC_0;
    {class} property ASF_OC_90: Integer read _GetASF_OC_90;
    {class} property ASF_OC_270: Integer read _GetASF_OC_270;
    {class} property ASF_OC_180: Integer read _GetASF_OC_180;
    {class} property ASF_OC_30: Integer read _GetASF_OC_30;
    {class} property ASF_OC_60: Integer read _GetASF_OC_60;
    {class} property ASF_OC_120: Integer read _GetASF_OC_120;
    {class} property ASF_OC_150: Integer read _GetASF_OC_150;
    {class} property ASF_OC_210: Integer read _GetASF_OC_210;
    {class} property ASF_OC_240: Integer read _GetASF_OC_240;
    {class} property ASF_OC_300: Integer read _GetASF_OC_300;
    {class} property ASF_OC_330: Integer read _GetASF_OC_330;
  end;

  [JavaSignature('com/arcsoft/face/FaceEngine')]
  JFaceEngine = interface(JObject)
  ['{1E69709E-7992-4A85-91CC-81FE789446B6}']
    { Property Methods }

    { methods }
    function init(context: JContext; detectMode: JDetectMode; detectFaceOrientPriority: JDetectFaceOrientPriority; detectFaceScaleVal: Integer; detectFaceMaxNum: Integer; combinedMask: Integer): Integer; cdecl; overload; //(Landroid/content/Context;Lcom/arcsoft/face/enums/DetectMode;Lcom/arcsoft/face/enums/DetectFaceOrientPriority;III)I
    function unInit: Integer; cdecl; //()I
    function detectFaces(data: TJavaArray<Byte>; width: Integer; height: Integer; format: Integer; faceInfoList: JList): Integer; cdecl; overload; //([BIIILjava/util/List;)I
    function detectFaces(data: TJavaArray<Byte>; width: Integer; height: Integer; format: Integer; detectModel: JDetectModel; faceInfoList: JList): Integer; cdecl; overload; //([BIIILcom/arcsoft/face/enums/DetectModel;Ljava/util/List;)I
    function detectFaces(arcSoftImageInfo: JArcSoftImageInfo; faceInfoList: JList): Integer; cdecl; overload; //(Lcom/arcsoft/face/model/ArcSoftImageInfo;Ljava/util/List;)I
    function detectFaces(arcSoftImageInfo: JArcSoftImageInfo; detectModel: JDetectModel; faceInfoList: JList): Integer; cdecl; overload; //(Lcom/arcsoft/face/model/ArcSoftImageInfo;Lcom/arcsoft/face/enums/DetectModel;Ljava/util/List;)I
    function process(data: TJavaArray<Byte>; width: Integer; height: Integer; format: Integer; faceInfoList: JList; P6: Integer): Integer; cdecl; overload; //([BIIILjava/util/List;I)I
    function process(arcSoftImageInfo: JArcSoftImageInfo; faceInfoList: JList; P3: Integer): Integer; cdecl; overload; //(Lcom/arcsoft/face/model/ArcSoftImageInfo;Ljava/util/List;I)I
    function processIr(data: TJavaArray<Byte>; width: Integer; height: Integer; format: Integer; faceInfoList: JList; P6: Integer): Integer; cdecl; overload; //([BIIILjava/util/List;I)I
    function processIr(arcSoftImageInfo: JArcSoftImageInfo; faceInfoList: JList; P3: Integer): Integer; cdecl; overload; //(Lcom/arcsoft/face/model/ArcSoftImageInfo;Ljava/util/List;I)I
    function extractFaceFeature(data: TJavaArray<Byte>; width: Integer; height: Integer; format: Integer; faceInfo: JFaceInfo; feature: JFaceFeature): Integer; cdecl; overload; //([BIIILcom/arcsoft/face/FaceInfo;Lcom/arcsoft/face/FaceFeature;)I
    function extractFaceFeature(arcSoftImageInfo: JArcSoftImageInfo; faceInfo: JFaceInfo; feature: JFaceFeature): Integer; cdecl; overload; //(Lcom/arcsoft/face/model/ArcSoftImageInfo;Lcom/arcsoft/face/FaceInfo;Lcom/arcsoft/face/FaceFeature;)I
    function compareFaceFeature(feature1: JFaceFeature; feature2: JFaceFeature; faceSimilar: JFaceSimilar): Integer; cdecl; overload; //(Lcom/arcsoft/face/FaceFeature;Lcom/arcsoft/face/FaceFeature;Lcom/arcsoft/face/FaceSimilar;)I
    function compareFaceFeature(feature1: JFaceFeature; feature2: JFaceFeature; compareModel: JCompareModel; faceSimilar: JFaceSimilar): Integer; cdecl; overload; //(Lcom/arcsoft/face/FaceFeature;Lcom/arcsoft/face/FaceFeature;Lcom/arcsoft/face/enums/CompareModel;Lcom/arcsoft/face/FaceSimilar;)I
    function getAge(ageInfoList: JList): Integer; cdecl; //(Ljava/util/List;)I
    function getGender(genderInfoList: JList): Integer; cdecl; //(Ljava/util/List;)I
    function getFace3DAngle(face3DAngleList: JList): Integer; cdecl; //(Ljava/util/List;)I
    function setLivenessParam(livenessParam: JLivenessParam): Integer; cdecl; //(Lcom/arcsoft/face/LivenessParam;)I
    function getLiveness(livenessInfoList: JList): Integer; cdecl; //(Ljava/util/List;)I
    function getIrLiveness(irLivenessInfoList: JList): Integer; cdecl; //(Ljava/util/List;)I

    { Property }
  end;

  TJFaceEngine = class(TJavaGenericImport<JFaceEngineClass, JFaceEngine>) end;

  JFaceFeatureClass = interface(JObjectClass)
  ['{00454295-FC0F-49AC-AB37-B028C0316C5B}']
    { static Property Methods }
    {class} function _GetFEATURE_SIZE: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I

    { static Methods }
    {class} function init(obj: JFaceFeature): JFaceFeature; cdecl; overload; //(Lcom/arcsoft/face/FaceFeature;)V
    {class} function init: JFaceFeature; cdecl; overload; //()V
    {class} function init(data: TJavaArray<Byte>): JFaceFeature; cdecl; overload; //([B)V

    { static Property }
    {class} property FEATURE_SIZE: Integer read _GetFEATURE_SIZE;
  end;

  [JavaSignature('com/arcsoft/face/FaceFeature')]
  JFaceFeature = interface(JObject)
  ['{F7C8E809-75FF-4737-AD46-BE938C918EC7}']
    { Property Methods }

    { methods }
    function getFeatureData: TJavaArray<Byte>; cdecl; //()[B
    procedure setFeatureData(data: TJavaArray<Byte>); cdecl; //([B)V
    function clone: JFaceFeature; cdecl; overload; //()Lcom/arcsoft/face/FaceFeature;
    //function clone: JObject; cdecl; overload; //()Ljava/lang/Object;

    { Property }
  end;

  TJFaceFeature = class(TJavaGenericImport<JFaceFeatureClass, JFaceFeature>) end;

  JFaceInfoClass = interface(JObjectClass)
  ['{CBDB2DD5-6EF0-4A99-B64A-9B0DBDAD223F}']
    { static Property Methods }

    { static Methods }
    {class} function init(rect: JRect; orient: Integer): JFaceInfo; cdecl; overload; //(Landroid/graphics/Rect;I)V
    {class} function init(obj: JFaceInfo): JFaceInfo; cdecl; overload; //(Lcom/arcsoft/face/FaceInfo;)V
    {class} function init: JFaceInfo; cdecl; overload; //()V

    { static Property }
  end;

  [JavaSignature('com/arcsoft/face/FaceInfo')]
  JFaceInfo = interface(JObject)
  ['{445E7545-BD57-44F8-9173-B015ABB08C47}']
    { Property Methods }

    { methods }
    function getRect: JRect; cdecl; //()Landroid/graphics/Rect;
    function getOrient: Integer; cdecl; //()I
    procedure setRect(rect: JRect); cdecl; //(Landroid/graphics/Rect;)V
    procedure setOrient(orient: Integer); cdecl; //(I)V
    function getFaceId: Integer; cdecl; //()I
    procedure setFaceId(faceId: Integer); cdecl; //(I)V
    function toString: JString; cdecl; //()Ljava/lang/String;
    function clone: JFaceInfo; cdecl; overload; //()Lcom/arcsoft/face/FaceInfo;
    //function clone: JObject; cdecl; overload; //()Ljava/lang/Object;

    { Property }
  end;

  TJFaceInfo = class(TJavaGenericImport<JFaceInfoClass, JFaceInfo>) end;

  JFaceSimilarClass = interface(JObjectClass)
  ['{2EEE5A1F-3A87-438B-BA13-B3B9C2748943}']
    { static Property Methods }

    { static Methods }
    {class} function init: JFaceSimilar; cdecl; //()V

    { static Property }
  end;

  [JavaSignature('com/arcsoft/face/FaceSimilar')]
  JFaceSimilar = interface(JObject)
  ['{14929B20-0EFC-4355-87BE-B08A901CE2DB}']
    { Property Methods }

    { methods }
    function getScore: Single; cdecl; //()F

    { Property }
  end;

  TJFaceSimilar = class(TJavaGenericImport<JFaceSimilarClass, JFaceSimilar>) end;

  JGenderInfoClass = interface(JObjectClass)
  ['{42EE27E6-5E4B-47B7-AAEB-C1B51DB3E9E8}']
    { static Property Methods }
    {class} function _GetMALE: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I
    {class} function _GetFEMALE: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I
    {class} function _GetUNKNOWN: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I

    { static Methods }
    {class} function init: JGenderInfo; cdecl; overload; //()V
    {class} function init(obj: JGenderInfo): JGenderInfo; cdecl; overload; //(Lcom/arcsoft/face/GenderInfo;)V

    { static Property }
    {class} property MALE: Integer read _GetMALE;
    {class} property FEMALE: Integer read _GetFEMALE;
    {class} property UNKNOWN: Integer read _GetUNKNOWN;
  end;

  [JavaSignature('com/arcsoft/face/GenderInfo')]
  JGenderInfo = interface(JObject)
  ['{7C38796A-758E-4FF9-BC3D-A0C6C7FCE0C3}']
    { Property Methods }

    { methods }
    function getGender: Integer; cdecl; //()I
    function clone: JGenderInfo; cdecl; overload; //()Lcom/arcsoft/face/GenderInfo;
    //function clone: JObject; cdecl; overload; //()Ljava/lang/Object;

    { Property }
  end;

  TJGenderInfo = class(TJavaGenericImport<JGenderInfoClass, JGenderInfo>) end;

  JLivenessInfoClass = interface(JObjectClass)
  ['{331BF74E-96D6-474A-B5B8-278BB5597A85}']
    { static Property Methods }
    {class} function _GetUNKNOWN: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I
    {class} function _GetNOT_ALIVE: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I
    {class} function _GetALIVE: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I
    {class} function _GetFACE_NUM_MORE_THAN_ONE: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I
    {class} function _GetFACE_TOO_SMALL: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I
    {class} function _GetFACE_ANGLE_TOO_LARGE: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I
    {class} function _GetFACE_BEYOND_BOUNDARY: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I

    { static Methods }
    {class} function init: JLivenessInfo; cdecl; overload; //()V
    {class} function init(livenessInfo: JLivenessInfo): JLivenessInfo; cdecl; overload; //(Lcom/arcsoft/face/LivenessInfo;)V

    { static Property }
    {class} property UNKNOWN: Integer read _GetUNKNOWN;
    {class} property NOT_ALIVE: Integer read _GetNOT_ALIVE;
    {class} property ALIVE: Integer read _GetALIVE;
    {class} property FACE_NUM_MORE_THAN_ONE: Integer read _GetFACE_NUM_MORE_THAN_ONE;
    {class} property FACE_TOO_SMALL: Integer read _GetFACE_TOO_SMALL;
    {class} property FACE_ANGLE_TOO_LARGE: Integer read _GetFACE_ANGLE_TOO_LARGE;
    {class} property FACE_BEYOND_BOUNDARY: Integer read _GetFACE_BEYOND_BOUNDARY;
  end;

  [JavaSignature('com/arcsoft/face/LivenessInfo')]
  JLivenessInfo = interface(JObject)
  ['{F8AA270A-6FFE-4F72-9C58-8FAA8FD3FED2}']
    { Property Methods }

    { methods }
    function getLiveness: Integer; cdecl; //()I
    function clone: JLivenessInfo; cdecl; overload; //()Lcom/arcsoft/face/LivenessInfo;
    //function clone: JObject; cdecl; overload; //()Ljava/lang/Object;

    { Property }
  end;

  TJLivenessInfo = class(TJavaGenericImport<JLivenessInfoClass, JLivenessInfo>) end;

  JLivenessParamClass = interface(JObjectClass)
  ['{B935D697-59B8-47D5-AB91-A5308FF0477F}']
    { static Property Methods }

    { static Methods }
    {class} function init(rgbThreshold: Single; irThreshold: Single): JLivenessParam; cdecl; //(FF)V

    { static Property }
  end;

  [JavaSignature('com/arcsoft/face/LivenessParam')]
  JLivenessParam = interface(JObject)
  ['{47EED2C9-082B-4DAC-878A-444DFC7AF497}']
    { Property Methods }

    { methods }
    function getRgbThreshold: Single; cdecl; //()F
    procedure setRgbThreshold(rgbThreshold: Single); cdecl; //(F)V
    function getIrThreshold: Single; cdecl; //()F
    procedure setIrThreshold(irThreshold: Single); cdecl; //(F)V

    { Property }
  end;

  TJLivenessParam = class(TJavaGenericImport<JLivenessParamClass, JLivenessParam>) end;

  JArcSoftImageInfoClass = interface(JObjectClass)
  ['{3E66FB3C-4C4C-4DC2-9292-5FCEF84FAE56}']
    { static Property Methods }

    { static Methods }
    {class} function init(width: Integer; height: Integer; imageFormat: Integer): JArcSoftImageInfo; cdecl; overload; //(III)V
    {class} function init(width: Integer; height: Integer; imageFormat: Integer; planes: TJavaArray<Byte>; strides: TJavaArray<Integer>): JArcSoftImageInfo; cdecl; overload; //(III[[B[I)V

    { static Property }
  end;

  [JavaSignature('com/arcsoft/face/model/ArcSoftImageInfo')]
  JArcSoftImageInfo = interface(JObject)
  ['{D41AB2F3-79DA-4DB4-A796-E9B860E121AA}']
    { Property Methods }

    { methods }
    function getWidth: Integer; cdecl; //()I
    procedure setWidth(width: Integer); cdecl; //(I)V
    function getHeight: Integer; cdecl; //()I
    procedure setHeight(height: Integer); cdecl; //(I)V
    function getImageFormat: Integer; cdecl; //()I
    procedure setImageFormat(imageFormat: Integer); cdecl; //(I)V
    function getPlanes: TJavaArray<TJavaArray<Byte>>; cdecl; //()[[B
    procedure setPlanes(planes: TJavaArray<Byte>); cdecl; //([[B)V
    function getStrides: TJavaArray<Integer>; cdecl; //()[I
    procedure setStrides(strides: TJavaArray<Integer>); cdecl; //([I)V

    { Property }
  end;

  TJArcSoftImageInfo = class(TJavaGenericImport<JArcSoftImageInfoClass, JArcSoftImageInfo>) end;

  JImageUtilsClass = interface(JObjectClass)
  ['{050085A1-17EE-4036-8265-1BFDC25CEB09}']
    { static Property Methods }

    { static Methods }
    {class} function init: JImageUtils; cdecl; //()V
    {class} function bitmapToBgr24(image: JBitmap): TJavaArray<Byte>; cdecl; //(Landroid/graphics/Bitmap;)[B
    {class} function bgrToBitmap(bgr: TJavaArray<Byte>; width: Integer; height: Integer): JBitmap; cdecl; //([BII)Landroid/graphics/Bitmap;
    {class} function alignBitmapForBgr24(bitmap: JBitmap): JBitmap; cdecl; //(Landroid/graphics/Bitmap;)Landroid/graphics/Bitmap;
    {class} function cropImage(bitmap: JBitmap; rect: JRect): JBitmap; cdecl; //(Landroid/graphics/Bitmap;Landroid/graphics/Rect;)Landroid/graphics/Bitmap;
    {class} function rotateBitmap(bitmap: JBitmap; rotateDegree: Single): JBitmap; cdecl; //(Landroid/graphics/Bitmap;F)Landroid/graphics/Bitmap;
    {class} function cropNv21(nv21: TJavaArray<Byte>; width: Integer; height: Integer; rect: JRect): TJavaArray<Byte>; cdecl; //([BIILandroid/graphics/Rect;)[B
    {class} function cropBgr24(bgr24: TJavaArray<Byte>; width: Integer; height: Integer; rect: JRect): TJavaArray<Byte>; cdecl; //([BIILandroid/graphics/Rect;)[B

    { static Property }
  end;

  [JavaSignature('com/arcsoft/face/util/ImageUtils')]
  JImageUtils = interface(JObject)
  ['{D61861A4-DF28-4F6D-81C8-C86DC65C1F3A}']
    { Property Methods }

    { methods }

    { Property }
  end;

  TJImageUtils = class(TJavaGenericImport<JImageUtilsClass, JImageUtils>) end;

  JVersionInfoClass = interface(JObjectClass)
  ['{F71E35DA-1698-4D41-8926-38498BA3D5BF}']
    { static Property Methods }

    { static Methods }
    {class} function init: JVersionInfo; cdecl; //()V

    { static Property }
  end;

  [JavaSignature('com/arcsoft/face/VersionInfo')]
  JVersionInfo = interface(JObject)
  ['{B3BAF68D-D099-47A7-AB7A-05A0AB3608B2}']
    { Property Methods }

    { methods }
    function getVersion: JString; cdecl; //()Ljava/lang/String;
    function getBuildDate: JString; cdecl; //()Ljava/lang/String;
    function getCopyRight: JString; cdecl; //()Ljava/lang/String;
    function toString: JString; cdecl; //()Ljava/lang/String;

    { Property }
  end;

  TJVersionInfo = class(TJavaGenericImport<JVersionInfoClass, JVersionInfo>) end;

implementation

procedure RegisterTypes;
begin
  TRegTypes.RegisterType('Androidapi.JNI.arcsoft_face.JActiveFileInfo', 
    TypeInfo(Androidapi.JNI.arcsoft_face.JActiveFileInfo));
  TRegTypes.RegisterType('Androidapi.JNI.arcsoft_face.JAgeInfo', 
    TypeInfo(Androidapi.JNI.arcsoft_face.JAgeInfo));
  TRegTypes.RegisterType('Androidapi.JNI.arcsoft_face.JBuildConfig', 
    TypeInfo(Androidapi.JNI.arcsoft_face.JBuildConfig));
  TRegTypes.RegisterType('Androidapi.JNI.arcsoft_face.JCompareModel', 
    TypeInfo(Androidapi.JNI.arcsoft_face.JCompareModel));
  TRegTypes.RegisterType('Androidapi.JNI.arcsoft_face.JDetectFaceOrientPriority', 
    TypeInfo(Androidapi.JNI.arcsoft_face.JDetectFaceOrientPriority));
  TRegTypes.RegisterType('Androidapi.JNI.arcsoft_face.JDetectMode', 
    TypeInfo(Androidapi.JNI.arcsoft_face.JDetectMode));
  TRegTypes.RegisterType('Androidapi.JNI.arcsoft_face.JDetectModel', 
    TypeInfo(Androidapi.JNI.arcsoft_face.JDetectModel));
  TRegTypes.RegisterType('Androidapi.JNI.arcsoft_face.JRuntimeABI', 
    TypeInfo(Androidapi.JNI.arcsoft_face.JRuntimeABI));
  TRegTypes.RegisterType('Androidapi.JNI.arcsoft_face.JErrorInfo', 
    TypeInfo(Androidapi.JNI.arcsoft_face.JErrorInfo));
  TRegTypes.RegisterType('Androidapi.JNI.arcsoft_face.JFace3DAngle', 
    TypeInfo(Androidapi.JNI.arcsoft_face.JFace3DAngle));
  TRegTypes.RegisterType('Androidapi.JNI.arcsoft_face.JFaceEngine', 
    TypeInfo(Androidapi.JNI.arcsoft_face.JFaceEngine));
  TRegTypes.RegisterType('Androidapi.JNI.arcsoft_face.JFaceFeature', 
    TypeInfo(Androidapi.JNI.arcsoft_face.JFaceFeature));
  TRegTypes.RegisterType('Androidapi.JNI.arcsoft_face.JFaceInfo', 
    TypeInfo(Androidapi.JNI.arcsoft_face.JFaceInfo));
  TRegTypes.RegisterType('Androidapi.JNI.arcsoft_face.JFaceSimilar', 
    TypeInfo(Androidapi.JNI.arcsoft_face.JFaceSimilar));
  TRegTypes.RegisterType('Androidapi.JNI.arcsoft_face.JGenderInfo', 
    TypeInfo(Androidapi.JNI.arcsoft_face.JGenderInfo));
  TRegTypes.RegisterType('Androidapi.JNI.arcsoft_face.JLivenessInfo', 
    TypeInfo(Androidapi.JNI.arcsoft_face.JLivenessInfo));
  TRegTypes.RegisterType('Androidapi.JNI.arcsoft_face.JLivenessParam', 
    TypeInfo(Androidapi.JNI.arcsoft_face.JLivenessParam));
  TRegTypes.RegisterType('Androidapi.JNI.arcsoft_face.JArcSoftImageInfo', 
    TypeInfo(Androidapi.JNI.arcsoft_face.JArcSoftImageInfo));
  TRegTypes.RegisterType('Androidapi.JNI.arcsoft_face.JImageUtils', 
    TypeInfo(Androidapi.JNI.arcsoft_face.JImageUtils));
  TRegTypes.RegisterType('Androidapi.JNI.arcsoft_face.JVersionInfo', 
    TypeInfo(Androidapi.JNI.arcsoft_face.JVersionInfo));
end;


initialization
  RegisterTypes;

end.
