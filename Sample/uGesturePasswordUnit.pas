unit uGesturePasswordUnit;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uCustomBaseFrame, FMX.Objects, FMX.Controls.Presentation, FMX.Layouts, uGesturePassword;

type
  TfrmGesturePassword = class(TfrmBaseFrame)
    Circle: TImage;
    Point: TImage;
    procedure btnBackClick(Sender: TObject);
  private
    { Private declarations }
    FLytPwd:TPasswordLayout;
    procedure DoAfterBack(Sender:TObject); override;
    procedure DoAfterShow(Sender:TObject); override;

    procedure EnterComplete(Sender: TObject; const APassword: string);
    // 说明: 手势录入之后获取密码
    procedure BeginGesturePassWord(Sender:TObject; Button: TMouseButton; Shift: TShiftState;
      X, Y: Single);
    // 说明: 开始录入手势密码
  public
    { Public declarations }
  end;

var
  frmGesturePassword: TfrmGesturePassword;

implementation

{$R *.fmx}

{ TfrmGesturePassword }

procedure TfrmGesturePassword.BeginGesturePassWord(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  txtTitle.Text:='';
end;

procedure TfrmGesturePassword.btnBackClick(Sender: TObject);
begin
  Back;
  frmGesturePassword:=nil;
end;

procedure TfrmGesturePassword.DoAfterBack(Sender: TObject);
begin
  FLytPwd.Free;
  inherited;
end;

procedure TfrmGesturePassword.DoAfterShow(Sender: TObject);
var
  MaxSize: Single;
begin
  inherited;

  FLytPwd := TPasswordLayout.Create(Self);
  FLytPwd.Point:=Self.Point;
  FLytPwd.Circle:=Self.Circle;
  FLytPwd.OnEnterCompleteEvent := EnterComplete;
  FLytPwd.OnMouseDown:= BeginGesturePassWord;
  FLytPwd.Parent := Self;
  FLytPwd.Align := TAlignLayout.Client;

  FLytPwd.LineWidth := Trunc(Width / 21);
  FLytPwd.LineColor := TAlphaColors.White;//MakeColor(0, $47, $9D);

end;

procedure TfrmGesturePassword.EnterComplete(Sender: TObject;
  const APassword: string);
begin
  txtTitle.Text:=APassword;
end;

end.

