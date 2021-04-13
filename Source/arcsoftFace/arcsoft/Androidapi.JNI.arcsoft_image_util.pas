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
//  生成时间：2020/8/31 12:38:04
//  工具版本：1.0.2018.2.26
//
//====================================================
unit Androidapi.JNI.arcsoft_image_util;

interface

uses
  Androidapi.JNIBridge, 
  Androidapi.JNI.JavaTypes, 
  Androidapi.JNI.GraphicsContentViewText;


type

// ===== Forward declarations =====

  JArcSoftImageFormat = interface; //com.arcsoft.imageutil.ArcSoftImageFormat
  JArcSoftImageUtil = interface; //com.arcsoft.imageutil.ArcSoftImageUtil
  JArcSoftImageUtilError = interface; //com.arcsoft.imageutil.ArcSoftImageUtilError
  JArcSoftMirrorOrient = interface; //com.arcsoft.imageutil.ArcSoftMirrorOrient
  JArcSoftRotateDegree = interface; //com.arcsoft.imageutil.ArcSoftRotateDegree
  JBuildConfig = interface; //com.arcsoft.imageutil.BuildConfig

// ===== Forward SuperClasses declarations =====


// ===== Interface declarations =====

  JArcSoftImageFormatClass = interface(JEnumClass) // or JObjectClass // SuperSignature: java/lang/Enum
  ['{DBFA9F59-2019-4061-8D8D-76AE62772FBE}']
    { static Property Methods }
    {class} function _GetBGR24: JArcSoftImageFormat;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //Lcom/arcsoft/imageutil/ArcSoftImageFormat;
    {class} function _GetNV21: JArcSoftImageFormat;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //Lcom/arcsoft/imageutil/ArcSoftImageFormat;
    {class} function _GetNV12: JArcSoftImageFormat;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //Lcom/arcsoft/imageutil/ArcSoftImageFormat;
    {class} function _GetI420: JArcSoftImageFormat;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //Lcom/arcsoft/imageutil/ArcSoftImageFormat;
    {class} function _GetYV12: JArcSoftImageFormat;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //Lcom/arcsoft/imageutil/ArcSoftImageFormat;
    {class} function _GetYUYV: JArcSoftImageFormat;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //Lcom/arcsoft/imageutil/ArcSoftImageFormat;
    {class} function _GetGRAY: JArcSoftImageFormat;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //Lcom/arcsoft/imageutil/ArcSoftImageFormat;

    { static Methods }
    {class} function values: TJavaObjectArray<JArcSoftImageFormat>; cdecl; //()[Lcom/arcsoft/imageutil/ArcSoftImageFormat;
    {class} function valueOf(name: JString): JArcSoftImageFormat; cdecl; overload; //(Ljava/lang/String;)Lcom/arcsoft/imageutil/ArcSoftImageFormat;
    {class} function valueOf(formatValue: Integer): JArcSoftImageFormat; cdecl; overload; //(I)Lcom/arcsoft/imageutil/ArcSoftImageFormat;

    { static Property }
    {class} property BGR24: JArcSoftImageFormat read _GetBGR24;
    {class} property NV21: JArcSoftImageFormat read _GetNV21;
    {class} property NV12: JArcSoftImageFormat read _GetNV12;
    {class} property I420: JArcSoftImageFormat read _GetI420;
    {class} property YV12: JArcSoftImageFormat read _GetYV12;
    {class} property YUYV: JArcSoftImageFormat read _GetYUYV;
    {class} property GRAY: JArcSoftImageFormat read _GetGRAY;
  end;

  [JavaSignature('com/arcsoft/imageutil/ArcSoftImageFormat')]
  JArcSoftImageFormat = interface(JEnum) // or JObject // SuperSignature: java/lang/Enum
  ['{B4F78EC8-602B-4417-866C-014A0E98596F}']
    { Property Methods }

    { methods }

    { Property }
  end;

  TJArcSoftImageFormat = class(TJavaGenericImport<JArcSoftImageFormatClass, JArcSoftImageFormat>) end;


  JArcSoftImageUtilClass = interface(JObjectClass)
  ['{8251C46C-AAFF-41C8-9D05-95794FF2338B}']
    { static Property Methods }

    { static Methods }
    {class} function init: JArcSoftImageUtil; cdecl; //()V
    {class} function getAlignedBitmap(bitmap: JBitmap; crop: Boolean): JBitmap; cdecl; //(Landroid/graphics/Bitmap;Z)Landroid/graphics/Bitmap;
    {class} function createImageData(width: Integer; height: Integer; arcSoftImageFormat: JArcSoftImageFormat): TJavaArray<Byte>; cdecl; //(IILcom/arcsoft/imageutil/ArcSoftImageFormat;)[B
    {class} function bitmapToImageData(bitmap: JBitmap; data: TJavaArray<Byte>; arcSoftImageFormat: JArcSoftImageFormat): Integer; cdecl; //(Landroid/graphics/Bitmap;[BLcom/arcsoft/imageutil/ArcSoftImageFormat;)I
    {class} function imageDataToBitmap(data: TJavaArray<Byte>; bitmap: JBitmap; arcSoftImageFormat: JArcSoftImageFormat): Integer; cdecl; //([BLandroid/graphics/Bitmap;Lcom/arcsoft/imageutil/ArcSoftImageFormat;)I
    {class} function cropImage(originImageData: TJavaArray<Byte>; cropImageData: TJavaArray<Byte>; originWidth: Integer; originHeight: Integer; rect: JRect; arcSoftImageFormat: JArcSoftImageFormat): Integer; cdecl; overload; //([B[BIILandroid/graphics/Rect;Lcom/arcsoft/imageutil/ArcSoftImageFormat;)I
    {class} function cropImage(originImageData: TJavaArray<Byte>; cropImageData: TJavaArray<Byte>; originWidth: Integer; originHeight: Integer; left: Integer; top: Integer; right: Integer; bottom: Integer; arcSoftImageFormat: JArcSoftImageFormat): Integer; cdecl; overload; //([B[BIIIIIILcom/arcsoft/imageutil/ArcSoftImageFormat;)I
    {class} function cropImage(originImageData: TJavaArray<Byte>; cropImageData: TJavaArray<Byte>; originWidth: Integer; originHeight: Integer; leftTop: JPoint; rightBottom: JPoint; arcSoftImageFormat: JArcSoftImageFormat): Integer; cdecl; overload; //([B[BIILandroid/graphics/Point;Landroid/graphics/Point;Lcom/arcsoft/imageutil/ArcSoftImageFormat;)I
    {class} function rotateImage(originImageData: TJavaArray<Byte>; rotateImageData: TJavaArray<Byte>; originWidth: Integer; originHeight: Integer; degree: JArcSoftRotateDegree; arcSoftImageFormat: JArcSoftImageFormat): Integer; cdecl; //([B[BIILcom/arcsoft/imageutil/ArcSoftRotateDegree;Lcom/arcsoft/imageutil/ArcSoftImageFormat;)I
    {class} function mirrorImage(originImageData: TJavaArray<Byte>; mirrorImageData: TJavaArray<Byte>; width: Integer; height: Integer; arcSoftMirrorOrient: JArcSoftMirrorOrient; arcSoftImageFormat: JArcSoftImageFormat): Integer; cdecl; //([B[BIILcom/arcsoft/imageutil/ArcSoftMirrorOrient;Lcom/arcsoft/imageutil/ArcSoftImageFormat;)I
    {class} function transformImage(originImageData: TJavaArray<Byte>; targetImageData: TJavaArray<Byte>; width: Integer; height: Integer; originFormat: JArcSoftImageFormat; targetFormat: JArcSoftImageFormat): Integer; cdecl; //([B[BIILcom/arcsoft/imageutil/ArcSoftImageFormat;Lcom/arcsoft/imageutil/ArcSoftImageFormat;)I
    {class} function getVersion: JString; cdecl; //()Ljava/lang/String;

    { static Property }
  end;

  [JavaSignature('com/arcsoft/imageutil/ArcSoftImageUtil')]
  JArcSoftImageUtil = interface(JObject)
  ['{9DDCC26A-DC57-4C5C-8604-F2C852970EBC}']
    { Property Methods }

    { methods }

    { Property }
  end;

  TJArcSoftImageUtil = class(TJavaGenericImport<JArcSoftImageUtilClass, JArcSoftImageUtil>) end;

  JArcSoftImageUtilErrorClass = interface(JObjectClass)
  ['{71A22509-D427-4624-A51D-A222922D72E8}']
    { static Property Methods }
    {class} function _GetCODE_SUCCESS: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I
    {class} function _GetCODE_SIZE_MISMATCH: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I
    {class} function _GetCODE_UNSUPPORTED_BITMAP_FORMAT: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I
    {class} function _GetCODE_GET_BITMAP_INFO_FAILED: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I
    {class} function _GetCODE_NULL_PARAMS: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I
    {class} function _GetCODE_SAME_OBJECT: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I
    {class} function _GetCODE_INVALID_AREA: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I
    {class} function _GetCODE_WIDTH_HEIGHT_UNSUPPORTED: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I
    {class} function _GetCODE_ROTATE_DEGREE_UNSUPPORTED: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I
    {class} function _GetCODE_IMAGE_FORMAT_UNSUPPORTED: Integer;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //I

    { static Methods }
    {class} function init: JArcSoftImageUtilError; cdecl; //()V

    { static Property }
    {class} property CODE_SUCCESS: Integer read _GetCODE_SUCCESS;
    {class} property CODE_SIZE_MISMATCH: Integer read _GetCODE_SIZE_MISMATCH;
    {class} property CODE_UNSUPPORTED_BITMAP_FORMAT: Integer read _GetCODE_UNSUPPORTED_BITMAP_FORMAT;
    {class} property CODE_GET_BITMAP_INFO_FAILED: Integer read _GetCODE_GET_BITMAP_INFO_FAILED;
    {class} property CODE_NULL_PARAMS: Integer read _GetCODE_NULL_PARAMS;
    {class} property CODE_SAME_OBJECT: Integer read _GetCODE_SAME_OBJECT;
    {class} property CODE_INVALID_AREA: Integer read _GetCODE_INVALID_AREA;
    {class} property CODE_WIDTH_HEIGHT_UNSUPPORTED: Integer read _GetCODE_WIDTH_HEIGHT_UNSUPPORTED;
    {class} property CODE_ROTATE_DEGREE_UNSUPPORTED: Integer read _GetCODE_ROTATE_DEGREE_UNSUPPORTED;
    {class} property CODE_IMAGE_FORMAT_UNSUPPORTED: Integer read _GetCODE_IMAGE_FORMAT_UNSUPPORTED;
  end;

  [JavaSignature('com/arcsoft/imageutil/ArcSoftImageUtilError')]
  JArcSoftImageUtilError = interface(JObject)
  ['{621A01DF-FEA2-4293-879E-8C323BCBB0B2}']
    { Property Methods }

    { methods }

    { Property }
  end;

  TJArcSoftImageUtilError = class(TJavaGenericImport<JArcSoftImageUtilErrorClass, JArcSoftImageUtilError>) end;

  JArcSoftMirrorOrientClass = interface(JEnumClass) // or JObjectClass // SuperSignature: java/lang/Enum
  ['{26778002-D332-4100-BAAA-53C77FFF5FE4}']
    { static Property Methods }
    {class} function _GetHORIZONTAL: JArcSoftMirrorOrient;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //Lcom/arcsoft/imageutil/ArcSoftMirrorOrient;
    {class} function _GetVERTICAL: JArcSoftMirrorOrient;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //Lcom/arcsoft/imageutil/ArcSoftMirrorOrient;

    { static Methods }
    {class} function values: TJavaObjectArray<JArcSoftMirrorOrient>; cdecl; //()[Lcom/arcsoft/imageutil/ArcSoftMirrorOrient;
    {class} function valueOf(name: JString): JArcSoftMirrorOrient; cdecl; //(Ljava/lang/String;)Lcom/arcsoft/imageutil/ArcSoftMirrorOrient;

    { static Property }
    {class} property HORIZONTAL: JArcSoftMirrorOrient read _GetHORIZONTAL;
    {class} property VERTICAL: JArcSoftMirrorOrient read _GetVERTICAL;
  end;

  [JavaSignature('com/arcsoft/imageutil/ArcSoftMirrorOrient')]
  JArcSoftMirrorOrient = interface(JEnum) // or JObject // SuperSignature: java/lang/Enum
  ['{B16F10E0-5DD9-41C4-A922-818A6A35DA17}']
    { Property Methods }

    { methods }

    { Property }
  end;

  TJArcSoftMirrorOrient = class(TJavaGenericImport<JArcSoftMirrorOrientClass, JArcSoftMirrorOrient>) end;

  JArcSoftRotateDegreeClass = interface(JEnumClass) // or JObjectClass // SuperSignature: java/lang/Enum
  ['{53EFED65-0643-46E4-82AF-20598AC5F4A7}']
    { static Property Methods }
    {class} function _GetDEGREE_90: JArcSoftRotateDegree;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //Lcom/arcsoft/imageutil/ArcSoftRotateDegree;
    {class} function _GetDEGREE_180: JArcSoftRotateDegree;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //Lcom/arcsoft/imageutil/ArcSoftRotateDegree;
    {class} function _GetDEGREE_270: JArcSoftRotateDegree;{$IF CompilerVersion >= 29.0} cdecl; {>=XE8}{$ENDIF} //Lcom/arcsoft/imageutil/ArcSoftRotateDegree;

    { static Methods }
    {class} function values: TJavaObjectArray<JArcSoftRotateDegree>; cdecl; //()[Lcom/arcsoft/imageutil/ArcSoftRotateDegree;
    {class} function valueOf(name: JString): JArcSoftRotateDegree; cdecl; //(Ljava/lang/String;)Lcom/arcsoft/imageutil/ArcSoftRotateDegree;

    { static Property }
    {class} property DEGREE_90: JArcSoftRotateDegree read _GetDEGREE_90;
    {class} property DEGREE_180: JArcSoftRotateDegree read _GetDEGREE_180;
    {class} property DEGREE_270: JArcSoftRotateDegree read _GetDEGREE_270;
  end;

  [JavaSignature('com/arcsoft/imageutil/ArcSoftRotateDegree')]
  JArcSoftRotateDegree = interface(JEnum) // or JObject // SuperSignature: java/lang/Enum
  ['{98F6B946-7777-47AB-A173-F436A78250A4}']
    { Property Methods }

    { methods }

    { Property }
  end;

  TJArcSoftRotateDegree = class(TJavaGenericImport<JArcSoftRotateDegreeClass, JArcSoftRotateDegree>) end;

  JBuildConfigClass = interface(JObjectClass)
  ['{1EC308A0-AFC2-46A3-B975-E31098F499A2}']
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

  [JavaSignature('com/arcsoft/imageutil/BuildConfig')]
  JBuildConfig = interface(JObject)
  ['{41CED3F3-A557-41AE-BF26-86ED96F8C117}']
    { Property Methods }

    { methods }

    { Property }
  end;

  TJBuildConfig = class(TJavaGenericImport<JBuildConfigClass, JBuildConfig>) end;

implementation

procedure RegisterTypes;
begin
  TRegTypes.RegisterType('Androidapi.JNI.arcsoft_image_util.JArcSoftImageFormat', 
    TypeInfo(Androidapi.JNI.arcsoft_image_util.JArcSoftImageFormat));
  TRegTypes.RegisterType('Androidapi.JNI.arcsoft_image_util.JArcSoftImageUtil', 
    TypeInfo(Androidapi.JNI.arcsoft_image_util.JArcSoftImageUtil));
  TRegTypes.RegisterType('Androidapi.JNI.arcsoft_image_util.JArcSoftImageUtilError', 
    TypeInfo(Androidapi.JNI.arcsoft_image_util.JArcSoftImageUtilError));
  TRegTypes.RegisterType('Androidapi.JNI.arcsoft_image_util.JArcSoftMirrorOrient', 
    TypeInfo(Androidapi.JNI.arcsoft_image_util.JArcSoftMirrorOrient));
  TRegTypes.RegisterType('Androidapi.JNI.arcsoft_image_util.JArcSoftRotateDegree', 
    TypeInfo(Androidapi.JNI.arcsoft_image_util.JArcSoftRotateDegree));
  TRegTypes.RegisterType('Androidapi.JNI.arcsoft_image_util.JBuildConfig', 
    TypeInfo(Androidapi.JNI.arcsoft_image_util.JBuildConfig));
end;


initialization
  RegisterTypes;

end.
