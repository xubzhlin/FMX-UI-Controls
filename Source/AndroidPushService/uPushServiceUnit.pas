unit uPushServiceUnit;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Types,
  {$IFDEF ANDROID}
  System.Android.Service,
  {$ENDIF}
  uPushCommonUnit, System.Notification,
  {$IFDEF ANDROID}
  Androidapi.JNI.App,
  Androidapi.JNI.GraphicsContentViewText,
  Androidapi.JNI.Os, Androidapi.Helpers,
  Androidapi.JNI.JavaTypes, Androidapi.JNIBridge,
  {$ENDIF}
  uAWSIotServiceUnit, AWS.IoT.Comm;

const CONST_ENCODE_STR = 'chinaexpressair';

type
  TNotifyRec = packed record
    AlertTitle:string;
    AlertBody:string;
    Number:Integer;
    Sound:String;        
  end;


  TDMIotPushService = class(TAndroidService)
    NotificationCenter1: TNotificationCenter;
    procedure AndroidServiceDestroy(Sender: TObject);
    function AndroidServiceStartCommand(const Sender: TObject;
      const Intent: JIntent; Flags, StartId: Integer): Integer;
    procedure AndroidServiceCreate(Sender: TObject);
    procedure AndroidServiceTrimMemory(const Sender: TObject; Level: Integer);
    function AndroidServiceHandleMessage(const Sender: TObject;
      const AMessage: JMessage): Boolean;
  private const
    Process_Name = 'com.embarcadero.uPushClient:WatchService';
    // function isRunning
  private
    { Private declarations }
    FEmployeeNum:Integer;
    FIotSubTimerInterval:Integer;
    FIotStatus:TAWSIotMqttClientStatus;
    procedure DoAWSIotMqttClientStatus(Status:TAWSIotMqttClientStatus);
    procedure DoAWSIoTMQTTNewMessage(NewMessage:string);
    procedure SubIot(EmployeeNum:Integer; SystemIdenty:TSystemIdenty);
    procedure WaitTimerInterval;

    function isProessRunning(context: JContext; proessName: string)
      : Boolean; overload;
    function isProessRunning(context: JContext; proessName: JString)
      : Boolean; overload;
    procedure keepWatchService;


  public
    { Public declarations }

    procedure NotifyCenter(ANotifyRec: TNotifyRec);
  end;

var
  DMIotPushService: TDMIotPushService;

implementation


uses
  Androidapi.WakeLockManager, System.JSON, uLogsUnit;

{ %CLASSGROUP 'FMX.Controls.TControl' }

{$R *.dfm}

procedure TDMIotPushService.AndroidServiceCreate(Sender: TObject);
begin
  // 保持 WatchService 运行
  //keepWatchService;
{$IFDEF POSIX}
  FIotSubTimerInterval:=100;
  if GAWSIotPubSubService = nil then
  begin
    GAWSIotPubSubService:=TAWSIotPubSubService.Create;
    //Iot连接
    GAWSIotPubSubService.OnAWSIotMqttClientStatus:=DoAWSIotMqttClientStatus;
    GAWSIotPubSubService.OnAWSIoTMQTTNewMessage:=DoAWSIoTMQTTNewMessage;
    GAWSIotPubSubService.Connecte;
  end;
{$ENDIF}

end;

procedure TDMIotPushService.AndroidServiceDestroy(Sender: TObject);
begin
  //释放设备电源锁
  //TWakeLockManagerService.releaseWakeLock;
end;

function TDMIotPushService.AndroidServiceHandleMessage(const Sender: TObject;
  const AMessage: JMessage): Boolean;
const
  Set_EmployeeNum = 123;
var
  LStr: JString;
  LBundle: JBundle;
  EmployeeNum:Integer;
  SystemIdenty:TSystemIdenty;
begin
  case AMessage.what of
    Set_EmployeeNum:
    begin
      LBundle := TJBundle.Wrap(AMessage.obj);
      EmployeeNum := LBundle.getInt(TAndroidHelper.StringToJString('EmployeeNum'));
      SystemIdenty := TSystemIdenty(LBundle.getInt(TAndroidHelper.StringToJString('SystemIdenty')));
      if EmployeeNum <> FEmployeeNum then
      begin
        //主题更换 取消以前订阅的主题
        FEmployeeNum:=EmployeeNum;
        GAWSIotPubSubService.UnsubscribeTopic;
      end;
      SubIot(FEmployeeNum, SystemIdenty);
      Result := False;
    end;
  else
    Result := False;
  end;

end;

function TDMIotPushService.AndroidServiceStartCommand(const Sender: TObject;
  const Intent: JIntent; Flags, StartId: Integer): Integer;
begin
  //申请电源锁，禁止休眠
  //TWakeLockManagerService.acquireWakeLock;
  Result := TJService.JavaClass.START_STICKY;
end;

procedure TDMIotPushService.AndroidServiceTrimMemory(const Sender: TObject;
  Level: Integer);
begin
  // 保持 WatchService 运行
  //keepWatchService;
end;



procedure TDMIotPushService.DoAWSIotMqttClientStatus(
  Status: TAWSIotMqttClientStatus);
begin
  FIotStatus:=Status;
end;

procedure TDMIotPushService.DoAWSIoTMQTTNewMessage(NewMessage: string);
var
  AJson:TJSONValue;
  NotifyRec: TNotifyRec;
begin
  LogInfo('Push Service NewMessage:'+NewMessage);
  try

    AJson:=TJSONObject.ParseJSONValue(NewMessage);
    try
      //新的推送消息
      NotifyRec.AlertTitle:=AJson.GetValue<string>('title');
      NotifyRec.AlertBody:=AJson.GetValue<string>('body');
      NotifyRec.Number := 0;
      LogInfo('Push Service NotifyCenter');
      NotifyCenter(NotifyRec);
    finally
      AJson.Free;
    end;
  except
    LogInfo('Push Service ParseJSONValue Error');
  end;
end;

function TDMIotPushService.isProessRunning(context: JContext;
  proessName: string): Boolean;
begin
  Result := isProessRunning(context, StringToJString(proessName));
end;

function TDMIotPushService.isProessRunning(context: JContext;
  proessName: JString): Boolean;
var
  Manager: JActivityManager;
  i: Integer;
  lists: JList;
  ProcessInfo: JActivityManager_RunningAppProcessInfo;
begin
  Result := False;
  Manager := TJActivityManager.Wrap
    ((context.getSystemService(TJContext.JavaClass.ACTIVITY_SERVICE)
    as ILocalObject).GetObjectID);

  lists := Manager.getRunningAppProcesses;
  for i := 0 to lists.size - 1 do
  begin
    ProcessInfo := TJActivityManager_RunningAppProcessInfo.Wrap
      ((lists.get(i) as ILocalObject).GetObjectID);
    if ProcessInfo.processName.equals(proessName) then
    begin
      Result := True;
      Break;
    end;
  end;
end;

procedure TDMIotPushService.keepWatchService;
begin
  if not isProessRunning(JavaService.getBaseContext, Process_Name) then
  begin
    //NotifyCenter('PushService:keepWatchService');
    TLocalServiceConnection.StartService('WatchService');
  end;
end;

procedure TDMIotPushService.NotifyCenter(ANotifyRec: TNotifyRec);
var
  MyNotification: TNotification;
begin
  MyNotification := NotificationCenter1.CreateNotification;
  try
    MyNotification.Title := ANotifyRec.AlertTitle;
    MyNotification.AlertBody := ANotifyRec.AlertBody;
    MyNotification.Number:= ANotifyRec.Number;
    MyNotification.SoundName:= ANotifyRec.Sound;
    NotificationCenter1.PresentNotification(MyNotification);
  finally
    MyNotification.Free;
  end;

end;

procedure TDMIotPushService.SubIot(EmployeeNum:Integer; SystemIdenty:TSystemIdenty);
var
  Topic:string;
begin

  Topic := '/HX/NOTIFY/FOSS/' + TSystemIdentyStr[SystemIdenty] + '/EMP/'+InttoStr(EmployeeNum);
  while True do
  begin
    //等待连接
    case FIotStatus of
      AWSIotMqttUnknown, AWSIotMqttConnectionLost, AWSIotMqttConnectionError, AWSIotMqttProtocolError:
       begin
        GAWSIotPubSubService.Connecte;
        WaitTimerInterval;
       end;
      AWSIotMqttConnecting, AWSIotMqttReconnecting: WaitTimerInterval;
      AWSIotMqttConnected: Break;
    end;
  end;
  LogInfo('Push Service SubscribeToTopic:'+Topic);
  GAWSIotPubSubService.SubscribeToTopic(Topic);
end;

procedure TDMIotPushService.WaitTimerInterval;
begin
  Sleep(FIotSubTimerInterval);
  Inc(FIotSubTimerInterval, 10);
  if FIotSubTimerInterval < 500 then
    FIotSubTimerInterval:=100;
end;

end.
