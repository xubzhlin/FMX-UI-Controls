unit uHttpDownLoadFileServiceUnit;
//HTTP 下载文件服务
//THttpDownLoadFileService 下载文件服务
//TDownLoadTheard 定时器触发 下载文件
//THttpInstance HttpClient +  Stream
//THttpPool  管理 THttpInstance 池，减少频繁创建、释放 开销


interface

uses
  System.Classes, System.SysUtils, System.Generics.Collections, FMX.Types,
  System.Net.HttpClient, FMX.Ani;

type
  THttpInstance = record
    HttpClient:THTTPClient;
    Stream:TMemoryStream;
  end;

  THttpDownLoadFileService = class(TObject)
  private type
    TServiceDestroyer = class
    private
      procedure DoServiceFinished(Sender: TObject);
    end;
  public const
    DefaultDownLoadRate = 60;
  public class var
    DownLoadRate: Integer;
  private class var
    FDownLoadTheard:TTimer;
  private class var
    FDestroyer:TServiceDestroyer;
  private
    FTagert:TObject;
    FSourceFile:String;
    FDestFile:String;
    FRunning:Boolean;
    FHttpClient:THTTPClient;
    FStream:TMemoryStream;
    FOnFinished:TNotifyEvent;
    FOnError:TNotifyEvent;
    class procedure CreateDestroyer;
    class procedure Uninitialize;
  private
    procedure ProcessTick;
    procedure InitInstance;
    procedure UnInitInstance;
    property Running:Boolean read FRunning write FRunning;
    property HttpClient:THTTPClient read FHttpClient write FHttpClient;
  public
    class procedure StartDownLoadFile(ASourceFile, ADestFile: String); overload;
    class procedure StartDownLoadFile(ASourceFile, ADestFile: String; AOnFinished:TNotifyEvent; AOnError: TNotifyEvent); overload;
    class procedure StartDownLoadFile(ASourceFile, ADestFile: String; Tagert:TObject; AOnFinished:TNotifyEvent; AOnError: TNotifyEvent); overload;
    procedure Start;
    procedure Stop;
    constructor Create;
    destructor Destroy; override;
  published
    property Tagert:TObject read FTagert write FTagert;
    property SourceFile:string read FSourceFile write FSourceFile;
    property DestFile:string read FDestFile write FDestFile;
    property OnFinished:TNotifyEvent read FOnFinished write FOnFinished;
    property OnError:TNotifyEvent read FOnError write FOnError;

  end;

implementation

uses
  System.Threading;

type
  TDownLoadTheard = class(TTimer)
  private
    FServiceList: TList<THttpDownLoadFileService>;
    FTime, FDeltaTime: Double;
    procedure DoSyncTimer(Sender: TObject);
  public
    constructor Create; reintroduce;
    destructor Destroy; override;
    procedure AddService(const Service: THttpDownLoadFileService);
    procedure RemovService(const Service: THttpDownLoadFileService);
  end;

  THttpPool = class
  private
    FUsed: TList<THttpInstance>;
    FReadyToUse: TList<THttpInstance>;
    procedure CreateOneMoreInstance;
    procedure FreezeInstance(AInstance: THttpInstance);
  public
    function GetInstance: THttpInstance;
    procedure ReturnInstance(const AInstance: THttpInstance);
    destructor Destroy; override;
    constructor Create;
  end;

var
  HttpPool:THttpPool;

{ THttpDownLoadFileService }

class procedure THttpDownLoadFileService.StartDownLoadFile(ASourceFile, ADestFile: String);
var
  AService:THttpDownLoadFileService;
begin
  CreateDestroyer;
  AService:=THttpDownLoadFileService.Create;
  AService.OnFinished:=FDestroyer.DoServiceFinished;
  AService.FSourceFile:=ASourceFile;
  AService.FDestFile:=ADestFile;
  AService.Start;
end;

procedure THttpDownLoadFileService.ProcessTick;
begin
  TDownLoadTheard(FDownLoadTheard).RemovService(Self);
  TThread.CreateAnonymousThread(procedure
  begin
    try
      if FHttpClient.Get(FSourceFile, FStream).StatusCode = 200 then
      begin
        FStream.SaveToFile(FDestFile);
        FStream.Clear;
        FRunning:=False;
        if Assigned(FOnFinished) then
          FOnFinished(FTagert);
      end
      else
      begin
        if Assigned(FOnError) then
          FOnError(FTagert);
      end;
    except
      //异常
      if Assigned(FOnError) then
        FOnError(FTagert);
    end;

    Self.DisposeOf;
  end).Start;

end;

procedure THttpDownLoadFileService.Start;
begin
  if FRunning then exit;
  if FDownLoadTheard = nil then
    FDownLoadTheard := TDownLoadTheard.Create;
  FRunning:=True;
  TDownLoadTheard(FDownLoadTheard).AddService(Self);
end;

class procedure THttpDownLoadFileService.StartDownLoadFile(ASourceFile,
  ADestFile: String; Tagert: TObject; AOnFinished, AOnError: TNotifyEvent);
var
  AService:THttpDownLoadFileService;
begin
  AService:=THttpDownLoadFileService.Create;
  AService.Tagert:=Tagert;
  AService.OnFinished:=AOnFinished;
  AService.OnError:=AOnError;
  AService.FSourceFile:=ASourceFile;
  AService.FDestFile:=ADestFile;
  AService.Start;

end;

class procedure THttpDownLoadFileService.StartDownLoadFile(ASourceFile,
  ADestFile: String; AOnFinished: TNotifyEvent; AOnError: TNotifyEvent);
var
  AService:THttpDownLoadFileService;
begin
  AService:=THttpDownLoadFileService.Create;
  AService.OnFinished:=AOnFinished;
  AService.OnError:=AOnError;
  AService.FSourceFile:=ASourceFile;
  AService.FDestFile:=ADestFile;
  AService.Start;
end;

procedure THttpDownLoadFileService.Stop;
begin
  if not FRunning then exit;
  if FDownLoadTheard <> nil then
    TDownLoadTheard(FDownLoadTheard).FServiceList.Remove(Self);
end;

class procedure THttpDownLoadFileService.Uninitialize;
begin
  FreeAndNil(FDownLoadTheard);
  FreeAndNil(FDestroyer);
end;

procedure THttpDownLoadFileService.UnInitInstance;
var
  LInstance:THttpInstance;
begin
  FStream.Clear;
  LInstance.HttpClient := FHttpClient;
  LInstance.Stream := FStream;
  HttpPool.ReturnInstance(LInstance);
  FHttpClient:=nil;
  FStream:=nil;
end;

constructor THttpDownLoadFileService.Create;
begin
  inherited Create;
  FRunning:=False;
  InitInstance;
end;

class procedure THttpDownLoadFileService.CreateDestroyer;
begin
  if FDestroyer = nil then
    FDestroyer:=TServiceDestroyer.Create;
end;

destructor THttpDownLoadFileService.Destroy;
begin
  UnInitInstance;
  if FDownLoadTheard <> nil then
    TDownLoadTheard(FDownLoadTheard).FServiceList.Remove(Self);
  inherited;
end;


procedure THttpDownLoadFileService.InitInstance;
var
  LInstance:THttpInstance;
begin
  LInstance:=HttpPool.GetInstance;
  FHttpClient:=LInstance.HttpClient;
  FStream:=LInstance.Stream;
end;

{ TDownLoadTheard }

procedure TDownLoadTheard.AddService(const Service: THttpDownLoadFileService);
begin
  if FServiceList.IndexOf(Service) < 0 then
    FServiceList.Add(Service);
  Enabled := FServiceList.Count > 0;
end;

constructor TDownLoadTheard.Create;
begin
  inherited Create(nil);
  if THttpDownLoadFileService.DownLoadRate < 5 then
    THttpDownLoadFileService.DownLoadRate := 5;
  if THttpDownLoadFileService.DownLoadRate > 100 then
    THttpDownLoadFileService.DownLoadRate := 100;
  Interval := Trunc(1000 / THttpDownLoadFileService.DownLoadRate / 10) * 10;
  if (Interval <= 0) then Interval := 1;

  OnTimer := DoSyncTimer;
  FServiceList := TList<THttpDownLoadFileService>.Create;

  Enabled := False;
end;

destructor TDownLoadTheard.Destroy;
begin
  FreeAndNil(FServiceList);
  inherited;
end;

procedure TDownLoadTheard.DoSyncTimer(Sender: TObject);
var
  I:integer;
begin
  Enabled := False;
  if FServiceList.Count>0 then
  begin
    I := FServiceList.Count - 1;
    while I >= 0 do
    begin
      if FServiceList[I].FRunning then
      begin
        FServiceList[I].ProcessTick;
      end;
      dec(I);
      if I >= FServiceList.Count then
        I := FServiceList.Count - 1;
    end;
  end;

end;

procedure TDownLoadTheard.RemovService(const Service: THttpDownLoadFileService);
begin
  FServiceList.Remove(Service);
  Enabled := FServiceList.Count > 0;
end;


{ THttpPool }

constructor THttpPool.Create;
begin
  FUsed := TList<THttpInstance>.Create;
  FReadyToUse := TList<THttpInstance>.Create;
end;

procedure THttpPool.CreateOneMoreInstance;
var
  LItem: THttpInstance;
begin
  LItem.HttpClient:=THTTPClient.Create;
  LItem.Stream:=TMemoryStream.Create;
  FReadyToUse.Add(LItem);
end;

destructor THttpPool.Destroy;
var
  i:Integer;
  LItem:THttpInstance;
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

procedure THttpPool.FreezeInstance(AInstance: THttpInstance);
begin
  FreeAndNil(AInstance.HttpClient);
  FreeAndNil(AInstance.Stream);
end;

function THttpPool.GetInstance: THttpInstance;
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

procedure THttpPool.ReturnInstance(const AInstance: THttpInstance);
begin
  TMonitor.Enter(Self);
  try
    FUsed.Remove(AInstance);
    FReadyToUse.Add(AInstance);
  finally
    TMonitor.Exit(Self);
  end;
end;

{ THttpDownLoadFileService.TServiceDestroyer }

procedure THttpDownLoadFileService.TServiceDestroyer.DoServiceFinished(
  Sender: TObject);
begin

end;

initialization
  THttpDownLoadFileService.DownLoadRate := THttpDownLoadFileService.DefaultDownLoadRate;
  HttpPool := THttpPool.Create;
finalization
  THttpDownLoadFileService.Uninitialize;
  FreeAndNil(HttpPool);
end.
