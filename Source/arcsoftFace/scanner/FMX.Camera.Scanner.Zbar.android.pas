unit FMX.Camera.Scanner.Zbar.android;

interface

uses
  System.SysUtils, FMX.Layouts, System.Classes, FMX.Types, FMX.Camera.Player, FMX.Scanner.Zbar.Android,
  Androidapi.JNIBridge;

type
  TOnScannerResult = procedure(Results: TStrings) of object;
  TAndroidCameraScannerZbar = class(TLayout)
  private
    FCameraPlayer: TCameraPlayer;
    FImageScaner: TAndroidZbarImageScaner;
    FOnScannerResult: TOnScannerResult;
//    FData: TJavaArray<Byte>;
//    FBuffer: PByte;
  private
    procedure DoOnPreviewFrame(data: TJavaArray<Byte>);
    procedure DoResults(Results: TStrings);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure StartScanner;
    procedure StopScanner;
    procedure WillBecomeForeground;
    procedure EnteredBackground;
    property OnScannerResult: TOnScannerResult read FOnScannerResult write FOnScannerResult;
  end;

implementation

uses
  FMX.Camera.Player.android;

{ TAndroidCameraScannerZbar }

constructor TAndroidCameraScannerZbar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCameraPlayer := TCameraPlayer.Create(Self);
  FCameraPlayer.Parent := Self;
  FCameraPlayer.Align := TAlignLayout.Client;
  TCameraPlayerAndroid(FCameraPlayer.Player).OnPreviewFrame := DoOnPreviewFrame;

  FImageScaner := TAndroidZbarImageScaner.Create;
end;

destructor TAndroidCameraScannerZbar.Destroy;
begin
  FImageScaner.Free;
  FCameraPlayer.Free;
  inherited;
end;

procedure TAndroidCameraScannerZbar.DoOnPreviewFrame(data: TJavaArray<Byte>);
var
  Image: TAndroidZbarImage;
  Ret: Integer;
begin
  Image := TAndroidZbarImage.Create(FCameraPlayer.Player.getCameraWidth, FCameraPlayer.Player.getCameraHeight, 'Y800');
  Image.SetData(data.Data, data.Length);
  ret := FImageScaner.ScanImage(Image);
  if(ret <> 0) then
  begin

    StopScanner;
    DoResults(FImageScaner.GetResults);
  end;
end;

procedure TAndroidCameraScannerZbar.DoResults(Results: TStrings);
begin
  if Assigned(FOnScannerResult) then
    FOnScannerResult(Results)
end;

procedure TAndroidCameraScannerZbar.EnteredBackground;
begin
  FCameraPlayer.Player.enteredBackground;
end;

procedure TAndroidCameraScannerZbar.StartScanner;
begin
  FCameraPlayer.Player.start(0);
end;

procedure TAndroidCameraScannerZbar.StopScanner;
begin
  FCameraPlayer.Player.stop;
end;

procedure TAndroidCameraScannerZbar.WillBecomeForeground;
begin
  FCameraPlayer.Player.willBecomeForeground;
end;

end.
