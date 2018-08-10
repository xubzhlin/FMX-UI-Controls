unit uPushNotificationUnit;

interface

uses
  System.SysUtils
  ,System.JSON
  ,System.Classes
  {$IFDEF ANDROID}
  ,System.Android.Service
  ,Androidapi.JNI.Os
  ,Androidapi.Helpers
  {$ENDIF}
  {$IFDEF iOS}
  ,System.PushNotification
  ,FMX.PushNotification.iOS
  ,uRestClientServiceUnit
  {$ENDIF}
  ;
{$IFDEF ANDROID}
const
  cDefaultPushService = '';  //安卓推送服务名称
{$ENDIF}

type
  TPushNotification = class(TObject)
  private
    {$IFDEF iOS}
    APushService: TPushService;
    AServiceConnection: TPushServiceConnection;
    ARestService: TRESTClientService;
    {$ENDIF}
    {$IFDEF ANDROID}
    AServiceConnection:TRemoteServiceConnection;
    {$ENDIF}

    {$IFDEF iOS}
    procedure PushServiceChange(Sender: TObject; AChange: TPushService.TChanges);
    procedure RegisterDeviceToken(DeviceToken:string);
    // 推送服务发生改变 只用于iOS
    procedure ReceiveNotification(Sender: TObject; const ANotification: TPushServiceNotification);
    {$ENDIF}
    {$IFDEF ANDROID}
    procedure DoHandleMessage(const AMessage: JMessage);
    procedure DoServiceConnected(const ServiceMessenger: JMessenger);
    {$ENDIF}
  public
    constructor Create;
    destructor Destroy; override;
    procedure RegisterPushNotification;
  end;

var
  GPushNotification:TPushNotification;


implementation

uses
  uCommonTypesUnit, REST.Types;

{ TPushNotification }

constructor TPushNotification.Create;
begin
  inherited Create;
{$IFDEF iOS}
  APushService:=nil;
  AServiceConnection:=nil;
{$ENDIF}
{$IFDEF ANDROID}
  AServiceConnection:=nil;
{$ENDIF}
end;

destructor TPushNotification.Destroy;
begin
{$IFDEF iOS}
  if APushService <> nil then
    FreeAndNil(APushService);
  if AServiceConnection <> nil then
    FreeAndNil(AServiceConnection);
  if ARestService <> nil then
    FreeAndNil(ARestService);
{$ENDIF}
{$IFDEF ANDROID}
  if AServiceConnection <> nil then
    FreeAndNil(AServiceConnection);
{$ENDIF}
  inherited;
end;

procedure TPushNotification.RegisterPushNotification;
begin
  
{$IFDEF iOS}
  if APushService=nil then
    APushService := TPushServiceManager.Instance.GetServiceByName(TPushService.TServiceNames.APS);
  if AServiceConnection=nil then
    AServiceConnection := TPushServiceConnection.Create(APushService);
  if ARestService = nil then
    ARestService := TRESTClientService.Create(nil);

  AServiceConnection.OnChange:=PushServiceChange;

  //AServiceConnection.OnReceiveNotification:=ReceiveNotification;

  AServiceConnection.Active := True;

{$ENDIF}
{$IFDEF ANDROID}
  //启动服务
  TLocalServiceConnection.StartService(cDefaultPushService);

  if AServiceConnection=nil then
    AServiceConnection:=TRemoteServiceConnection.Create;

  AServiceConnection.OnConnected:=DoServiceConnected;
  AServiceConnection.OnHandleMessage := DoHandleMessage;

  //绑定服务通讯
  AServiceConnection.BindService(TAndroidHelper.JStringToString(TAndroidHelper.Context.getPackageName()), cDefaultPushService);
{$ENDIF}
end;

{$IFDEF iOS}
procedure TPushNotification.PushServiceChange(Sender: TObject;
  AChange: TPushService.TChanges);
var
  ADeviceToken:String;
begin
  
  if ((TPushService.TChange.DeviceToken in AChange)
     and (TPushService.TChange.Status in AChange)) then
  begin
    if APushService.Status = TPushService.TStatus.Started then
    begin
      ADeviceToken := APushService.DeviceTokenValue[TPushService.TDeviceTokenNames.DeviceToken];
      TThread.CreateAnonymousThread(procedure
      begin
        RegisterDeviceToken(ADeviceToken);
      end).Start;
    end
    else
    if APushService.Status = TPushService.TStatus.StartupError then
    begin
      ADeviceToken:= '';
      TThread.CreateAnonymousThread(procedure
      begin
        RegisterDeviceToken(ADeviceToken);
      end).Start;
    end;
  end;
end;

procedure TPushNotification.RegisterDeviceToken(DeviceToken:string);
var
  ThisJson:string;
  JSONObject:TJSONObject;
begin
 
  //注册令牌
  JSONObject:=TJSONObject.Create;
  try
    //{"employeeNum":1454,"systemIdenty":5,"userPlatform":3,"deviceToken":"2f23raf3"}
    JSONObject.AddPair('employeeNum', TJSONNumber.Create(GEmployeeNum));
    JSONObject.AddPair('deviceToken', TJSONString.Create(DeviceToken));
    JSONObject.AddPair('userPlatform', TJSONNumber.Create(Ord(GPlatformType)));
    JSONObject.AddPair('systemIdenty', TJSONNumber.Create(Ord(GSystemIdenty)));
    ThisJson:=JSONObject.ToJSON;
  finally
    JSONObject.Free;
  end;

  try
    ARestService.Request.ResetToDefaults;
    ARestService.Client.Params.Clear;
    ARestService.Client.BaseURL:=GBrokerURL + 'DeviceRegister';
    ARestService.Client.ContentType:='application/json';
    ARestService.Request.Accept:='*/*';

    ARestService.Request.ClearBody;
    ARestService.Request.AddBody(ThisJson, ctTEXT_PLAIN);
    ARestService.Request.Method:=TRESTRequestMethod.rmPOST;
    ARestService.Request.URLAlreadyEncoded:=True;
    ARestService.Request.Timeout:=5000;

    ARestService.Execute(nil);
  except
  end;
end;

procedure TPushNotification.ReceiveNotification(Sender: TObject; const ANotification: TPushServiceNotification);
begin
  // 前台收到推送信息
end;

{$ENDIF}

{$IFDEF ANDROID}
procedure TPushNotification.DoServiceConnected(const ServiceMessenger: JMessenger);
var
  LMessage: JMessage;
  LBundle: JBundle;
const
  Set_EmployeeNum = 123;
begin
  // 传入 Iot 主题
  LBundle := TJBundle.Create;
  LBundle.putInt(TAndroidHelper.StringToJString('EmployeeNum'), GEmployeeNum);
  LBundle.putInt(TAndroidHelper.StringToJString('SystemIdenty'), Ord(GSystemIdenty));
  LMessage := TJMessage.JavaClass.obtain(nil, Set_EmployeeNum);
  LMessage.replyTo := AServiceConnection.LocalMessenger;
  LMessage.obj := LBundle;
  AServiceConnection.ServiceMessenger.send(LMessage);

end;

procedure TPushNotification.DoHandleMessage(const AMessage: JMessage);
begin
  //接受Service信息
end;
{$ENDIF}

end.
