unit uMainFrameUnit;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uCustomBaseAniFrame, FMX.Objects, FMX.Layouts, FMX.Controls.Presentation{$IFDEF iOS}, FMX.iOSNativeSearchBox{$ENDIF};

type

  TFMXUIControlType = (ctGpwd, ctMsglst, ctCalendar, ctiOSSearchBox);

  TfrmMainFrame = class(TFrmBaseAniFrame)
    Text1: TText;
    VertScrollBox1: TVertScrollBox;
    GridLayout1: TGridLayout;
    Layout1: TLayout;
    CheckBox1: TCheckBox;
    procedure GridLayout1Resize(Sender: TObject);
  private
    { Private declarations }
  {$IFDEF iOS}
    FSearchBox:TFMXiOSNativeSearchBox;
  {$ENDIF}
    procedure CreateButton;

    procedure ButtonClick(Sender:TObject);
    procedure ButtonTap(Sender: TObject; const Point: TPointF);

    procedure DoAfterBack(Sender:TObject); override;
    procedure DoAfterShow(Sender:TObject); override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AParent: TFmxObject; ATarget:TFmxObject); override;
    destructor Destroy; override;
  end;

const
  TFMXUIControlTypeNames:array[TFMXUIControlType] of string = ('GesturePassword', 'MessageListView', 'Calendar', 'iOSSearchBox');

var
  frmMainFrame: TfrmMainFrame;

implementation

uses
  uGesturePasswordUnit, uMessageListViewUnit, uCalendarFrameUnit;

{$R *.fmx}

{ TfrmMainFrame }

procedure TfrmMainFrame.ButtonClick(Sender: TObject);
begin
  case TFMXUIControlType(TButton(Sender).Tag) of
    ctGpwd:
      begin
        //frmGesturePassword Auto Free After Back
        if frmGesturePassword = nil then
        begin
          frmGesturePassword:=TfrmGesturePassword.Create(Application, Application.MainForm, Self);
        end;
      end;

    ctMsglst:
      begin
        //frmGesturePassword not Auto Free After Back
        if frmMessageListView = nil then
        begin
          frmMessageListView:=TfrmMessageListView.Create(Application, Application.MainForm, Self);
          frmMessageListView.NeedFreeAfterBack:=False;
        end
        else
          frmMessageListView.Show;
      end;
    ctCalendar:
      begin
        if frmCalendarFrame = nil then
          frmCalendarFrame:=TfrmCalendarFrame.Create(Application, Application.MainForm, Self);
      end;
    ctiOSSearchBox:
      begin
      {$IFDEF iOS}
        if FSearchBox<>nil then
        begin
          FSearchBox:=TFMXiOSNativeSearchBox.Create(Self);
          FSearchBox.Parent:=Layout1;
          FSearchBox.Align:=TAlignLayout.Client;
          FSearchBox.TextPrompt:='iOSNativeSearchBox';

          //Set Seach Responder and Filter;
          FSearchBox.OnFilter:=nil;
          FSearchBox.Model.SearchResponder:=nil;
        end;
      {$ENDIF}
      end;
  end;
end;

procedure TfrmMainFrame.ButtonTap(Sender: TObject; const Point: TPointF);
begin
  ButtonClick(Sender);
end;

constructor TfrmMainFrame.Create(AOwner: TComponent; AParent,
  ATarget: TFmxObject);
begin
  inherited Create(AOwner, AParent, ATarget);
  CreateButton;
  NeedFreeAfterBack:=False;
  Show;
end;

procedure TfrmMainFrame.CreateButton;
var
  Count:Integer;
  i: TFMXUIControlType;
  Button:TButton;
begin
  for i := Low(TFMXUIControlType) to High(TFMXUIControlType) do
  begin
    Button:=TButton.Create(Self);
    Button.Parent:=GridLayout1;
    Button.Margins.Left:=4;
    Button.Margins.Top:=4;
    Button.Margins.Right:=4;
    Button.Margins.Bottom:=4;
    Button.Align:=TAlignLayout.Client;
    Button.Text:=TFMXUIControlTypeNames[i];
  {$IFDEF MSWINDOWS}
    Button.OnClick:=ButtonClick;
  {$ELSE}
    Button.OnTap:=ButtonTap;
  {$ENDIF}
    Button.Tag:=Ord(i);
  end;

  GridLayout1.Height:=Round(GridLayout1.ChildrenCount / 3) * 40;

end;

destructor TfrmMainFrame.Destroy;
var
  i:Integer;
begin
  for i := GridLayout1.ChildrenCount - 1 downto 0  do
    GridLayout1.Children[i].Free;
  inherited;
end;

procedure TfrmMainFrame.DoAfterBack(Sender: TObject);
begin
  inherited;
{$IFDEF iOS}
  if (FSearchBox<>nil) and Checkbox1.IsChecked then
  begin
    FSearchBox.SetNativeVisible(False);
  end;
{$ENDIF}

end;

procedure TfrmMainFrame.DoAfterShow(Sender: TObject);
begin
  inherited;
{$IFDEF iOS}
  if (FSearchBox<>nil) and Checkbox1.IsChecked then
  begin
    FSearchBox.SetNativeVisible(True);
  end;
{$ENDIF}
end;

procedure TfrmMainFrame.GridLayout1Resize(Sender: TObject);
begin
  GridLayout1.ItemWidth := GridLayout1.Width / 3;
  GridLayout1.ItemHeight := 40;
end;

end.
