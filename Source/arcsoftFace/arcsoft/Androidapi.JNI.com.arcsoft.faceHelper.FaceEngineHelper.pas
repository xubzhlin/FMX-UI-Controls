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
//  生成时间：2020/8/31 22:55:25
//  工具版本：1.0.2018.2.26
//
//====================================================
unit Androidapi.JNI.com.arcsoft.faceHelper.FaceEngineHelper;

interface

uses
  Androidapi.JNIBridge, 
  Androidapi.JNI.JavaTypes,
  Androidapi.JNI.GraphicsContentViewText,
  Androidapi.JNI.arcsoft_face;


type

// ===== Forward declarations =====

  JFaceEngineHelper = interface; //com.arcsoft.faceHelper.FaceEngineHelper

// ===== Forward SuperClasses declarations =====


// ===== Interface declarations =====

  JFaceEngineHelperClass = interface(JObjectClass)
  ['{A5C66433-6901-4507-9098-C383088D2EB5}']
    { static Property Methods }

    { static Methods }
    {class} function init: JFaceEngineHelper; cdecl; //()V
    {class} function initEngine(engine: JFaceEngine; context: JContext; detectMode: JDetectMode; detectFaceOrientPriority: JDetectFaceOrientPriority; detectFaceScaleVal: Integer; detectFaceMaxNum: Integer; combinedMask: Integer): Integer; cdecl; //(Lcom/arcsoft/face/FaceEngine;Landroid/content/Context;Lcom/arcsoft/face/enums/DetectMode;Lcom/arcsoft/face/enums/DetectFaceOrientPriority;III)I
    {class} function arrayAsList(faceInfo: JFaceInfo): JList; cdecl; //(Lcom/arcsoft/face/FaceInfo;)Ljava/util/List;

    { static Property }
  end;

  [JavaSignature('com/arcsoft/faceHelper/FaceEngineHelper')]
  JFaceEngineHelper = interface(JObject)
  ['{E2926A55-C450-44AE-A7D2-D5E5E5C85C82}']
    { Property Methods }

    { methods }

    { Property }
  end;

  TJFaceEngineHelper = class(TJavaGenericImport<JFaceEngineHelperClass, JFaceEngineHelper>) end;

implementation

procedure RegisterTypes;
begin
  TRegTypes.RegisterType('Androidapi.JNI.com.arcsoft.faceHelper.FaceEngineHelper.JFaceEngineHelper', 
    TypeInfo(Androidapi.JNI.com.arcsoft.faceHelper.FaceEngineHelper.JFaceEngineHelper));
end;


initialization
  RegisterTypes;

end.
