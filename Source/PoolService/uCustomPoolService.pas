unit uCustomPoolServiceUnit;
//通用池服务
//通过 池来管理  提高使用效率，避免重复创建、释放
//author:Xubzhlin
//Email:371889755@qq.com

(*
  //Example 一个简单的 REST Client 通过 池来管理
  //REST 对象
  TRESTInstance = class(TCustomInstance)
  public
    Client:TRestClient;
    Request:TRESTRequest;
    Response:TRESTResponse;

    destructor Destroy; override;
    constructor Create; override;
  end;
  { TInstance }

  constructor TInstance.Create;
  begin
    Client:=TRestClient.Create(nil);
    Request:=TRESTRequest.Create(Client);
    Response:=TRESTResponse.Create(Client);
    Request.Response:=Response;
  end;

  destructor TInstance.Destroy;
  begin
    FreeAndNil(Request);
    FreeAndNil(Response);
    FreeAndNil(Client);
    inherited;
  end;

  //REST Client 服务
  TRESTService = TCustomInstanceService<TInstance>;

  // initialization 创建池
  initialization
    TService.CreatePool;
  // finalization 销毁池
  finalization
    TService.FreezePool;

  //调用示例
  var
    FRESTService:TRESTService;
  begin
    FRESTService:=TRESTService.Create;
    FService.Instance.Client.BaseURL:='www.baidu.com';
    FService.Instance.Request.Execute;
    FRESTService.Free;
  end;
*)

interface

uses
  System.Classes, System.SysUtils, System.Generics.Collections;

type
  //池需要管理的基础对象
  TCustomInstance = class(TObject)
  protected
    procedure FreezeInstance;
    class function CreateOneMoreInstance(const InstanceClass: TClass):TCustomInstance;
    constructor Create; virtual;
  end;

  //池的具体实现
  TCustomPool<T:TCustomInstance> = class(TObject)
  private
    FUsed: TList<T>;
    FReadyToUse: TList<T>;
    procedure CreateOneMoreInstance;
    procedure FreezeInstance(AInstance: T);
  public
    function GetInstance: T;
    procedure ReturnInstance(const AInstance: T);
    destructor Destroy; override;
    constructor Create;
  end;

  //池提供的基础服务
  TCustomInstanceService<T:TCustomInstance> = class(TObject)
  private
    class var FPool:TCustomPool<T>;
    FInstance:T;
    function GetInstance: T;
  protected
    procedure InitInstance; virtual;
    procedure UnInitInstance; virtual;
  public
    class procedure CreatePool;  //创建 池  需要在 initialization 中调用
    class procedure FreezePool;  //释放 池  需要在 finalization 中调用
    destructor Destroy; override;
    constructor Create;
    property Instance:T read GetInstance;
  end;

implementation

{ TCustomPool<T> }

constructor TCustomPool<T>.Create;
begin
  inherited Create;
  FUsed := TList<T>.Create;
  FReadyToUse := TList<T>.Create;
end;



procedure TCustomPool<T>.CreateOneMoreInstance;
var
  LItem:TCustomInstance;
begin
  LItem:=TCustomInstance.CreateOneMoreInstance(T);
  FReadyToUse.Add(LItem);
end;

destructor TCustomPool<T>.Destroy;
var
  i:Integer;
  LItem:T;
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

procedure TCustomPool<T>.FreezeInstance(AInstance: T);
begin
  TCustomInstance(AInstance).FreezeInstance;
end;

function TCustomPool<T>.GetInstance: T;
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

procedure TCustomPool<T>.ReturnInstance(const AInstance: T);
begin
  TMonitor.Enter(Self);
  try
    FUsed.Remove(AInstance);
    FReadyToUse.Add(AInstance);
  finally
    TMonitor.Exit(Self);
  end;
end;

{ TCustomInstanceService<T> }

constructor TCustomInstanceService<T>.Create;
begin
  InitInstance;
end;

class procedure TCustomInstanceService<T>.CreatePool;
begin
  FPool := TCustomPool<T>.Create;
end;

destructor TCustomInstanceService<T>.Destroy;
begin
  UnInitInstance;
  inherited;
end;

class procedure TCustomInstanceService<T>.FreezePool;
begin
  FPool.Free;
end;

function TCustomInstanceService<T>.GetInstance: T;
begin
  Result:=FInstance;
end;

procedure TCustomInstanceService<T>.InitInstance;
begin
  FInstance:=FPool.GetInstance;
end;

procedure TCustomInstanceService<T>.UnInitInstance;
begin
  FPool.ReturnInstance(FInstance);
end;

{ TCustomInstance }


{ TCustomInstance }

constructor TCustomInstance.Create;
begin

end;

class function TCustomInstance.CreateOneMoreInstance(
  const InstanceClass: TClass): TCustomInstance;
begin
  Result:=TCustomInstance(InstanceClass.NewInstance);
  Result.Create;
end;

procedure TCustomInstance.FreezeInstance;
begin
  Free;
end;

end.
