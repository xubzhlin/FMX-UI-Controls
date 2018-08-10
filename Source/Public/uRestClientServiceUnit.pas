unit uRestClientServiceUnit;
//REST Client Service
//TRESTInstance 包含  TRestClient  TRESTResponse  TOnRESTRequest
//通过 TRESTPool 池来管理  TRESTInstance 提高使用效率，避免重复创建、释放

interface


uses
  System.Classes, System.SysUtils, IPPeerClient, REST.Client;

type
  TOnRESTRequest = procedure(StatusCode:Integer; StatusText:String; Content:String) of object;

  //REST 服务 用于数据请求
  TRESTClientService = class(TObject)
  private
    FClient:TRestClient;
    FRequest:TRESTRequest;
    FResponse:TRESTResponse;

    procedure InitInstance;
    procedure UnInitInstance;
    procedure DoRESTRequest(const RESTRequest:TOnRESTRequest);
  public
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;
    procedure Execute(const RESTRequest:TOnRESTRequest); overload;
    class procedure Execute(const URL:String; const RESTRequest:TOnRESTRequest); overload;
  published
    property Client:TRestClient read FClient write FClient;
    property Request:TRESTRequest read FRequest write FRequest;
    property Response:TRESTResponse read FResponse write FResponse;
  end;


implementation

uses
  System.Generics.Collections;

type
  TRESTInstance = record
    Client:TRestClient;
    Request:TRESTRequest;
    Response:TRESTResponse;
  end;

  TRESTPool = class(TObject)
  private
    FUsed: TList<TRESTInstance>;
    FReadyToUse: TList<TRESTInstance>;
    procedure CreateOneMoreInstance;
    procedure FreezeInstance(AInstance: TRESTInstance);
  public
    function GetInstance: TRESTInstance;
    procedure ReturnInstance(const AInstance: TRESTInstance);
    destructor Destroy; override;
    constructor Create;
  end;

var
  RESTPool:TRESTPool;

{ TRestClient }

constructor TRESTClientService.Create(AOwner: TComponent);
begin
  inherited Create;
  InitInstance;
end;

destructor TRESTClientService.Destroy;
begin
  UnInitInstance;
  inherited;
end;


procedure TRESTClientService.DoRESTRequest(const RESTRequest:TOnRESTRequest);
begin
  if Assigned(RESTRequest) then
    RESTRequest(FResponse.StatusCode, FResponse.StatusText, FResponse.Content);
end;

procedure TRESTClientService.Execute(const RESTRequest:TOnRESTRequest);
begin
  try
    FRequest.Execute;
    DoRESTRequest(RESTRequest);
  except
    DoRESTRequest(RESTRequest);
  end;
end;

class procedure TRESTClientService.Execute(const URL:String; const RESTRequest:TOnRESTRequest);
var
  RESTService:TRESTClientService;
begin
  RESTService:=TRESTClientService.Create(nil);
  RESTService.Client.BaseURL:=URL;
  try
    RESTService.Execute(RESTRequest);
  finally
    RESTService.Free;
  end;
end;



procedure TRESTClientService.InitInstance;
var
  LInstance:TRESTInstance;
begin
  LInstance:=RESTPool.GetInstance;
  FClient:=LInstance.Client;
  FRequest:=LInstance.Request;
  FResponse:=LInstance.Response;

  FRequest.ResetToDefaults;
  FClient.ResetToDefaults;
  FResponse.ResetToDefaults;
  FRequest.Timeout:=5000;
end;

procedure TRESTClientService.UnInitInstance;
var
  LInstance: TRESTInstance;
begin
  LInstance.Client := FClient;
  LInstance.Request := FRequest;
  LInstance.Response := FResponse;
  RESTPool.ReturnInstance(LInstance);
  FClient:=nil;
  FRequest:=nil;
  FResponse:=nil;
end;

{ TRESTPool }

constructor TRESTPool.Create;
begin
  FUsed := TList<TRESTInstance>.Create;
  FReadyToUse := TList<TRESTInstance>.Create;
end;

procedure TRESTPool.CreateOneMoreInstance;
var
  LItem: TRESTInstance;
begin
  LItem.Client:=TRestClient.Create(nil);
  LItem.Request:=TRESTRequest.Create(LItem.Client);
  LItem.Response:=TRESTResponse.Create(LItem.Client);
  LItem.Request.Response:=LItem.Response;
  FReadyToUse.Add(LItem);
end;

destructor TRESTPool.Destroy;
var
  i:Integer;
  LItem:TRESTInstance;
begin
  for i := 0 to FUsed.Count - 1 do
  begin
    LItem:=FUsed[i];
    FreezeInstance(LItem);
  end;
  FUsed.Free;
  for i := 0 to FReadyToUse.Count - 1 do
  begin
    LItem:=FReadyToUse[i];
    FreezeInstance(LItem);
  end;
  FReadyToUse.Free;
  inherited;
end;

procedure TRESTPool.FreezeInstance(AInstance: TRESTInstance);
begin
  //FRequest and FResponse owner is  FClient
  //so need free and nil FRequest and FResponse
  //or not free FRequest and FResponse
  FreeAndNil(AInstance.Request);
  FreeAndNil(AInstance.Response);
  FreeAndNil(AInstance.Client);
end;

function TRESTPool.GetInstance: TRESTInstance;
begin
  TMonitor.Enter(Self);
  try
    if FReadyToUse.Count = 0 then
      CreateOneMoreInstance;
    Result := FReadyToUse.First;
    FReadyToUse.Remove(Result);
    FUsed.Add(Result);
  finally
    TMonitor.Exit(Self);
  end;
end;

procedure TRESTPool.ReturnInstance(const AInstance: TRESTInstance);
begin
  TMonitor.Enter(Self);
  try
    FUsed.Remove(AInstance);
    FReadyToUse.Add(AInstance);
  finally
    TMonitor.Exit(Self);
  end;
end;


initialization
  RESTPool := TRESTPool.Create;

finalization
  RESTPool.Free;

end.
