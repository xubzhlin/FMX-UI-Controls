unit uCalendarFrameUnit;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uCustomBaseFrame, FMX.Objects, FMX.Controls.Presentation, FMX.Layouts,
  FMX.CalendarControl;

type
  TfrmCalendarFrame = class(TfrmBaseFrame)
    procedure btnBackClick(Sender: TObject);
  private
    { Private declarations }
    FCalendar:TCalendarControl;
    procedure DoAfterBack(Sender:TObject); override;
    procedure DoAfterShow(Sender:TObject); override;
    procedure DoSelectedItem(Sender:TObject);  //选中日期
  public
    { Public declarations }
  end;

var
  frmCalendarFrame: TfrmCalendarFrame;

implementation

uses
  FMX.CalendarItemAppearance;

{$R *.fmx}

{ TfrmBaseFrame1 }

procedure TfrmCalendarFrame.btnBackClick(Sender: TObject);
begin
  Back;
  frmCalendarFrame:=nil;

end;

procedure TfrmCalendarFrame.DoAfterBack(Sender: TObject);
begin
  FCalendar.Free;
  inherited;

end;

procedure TfrmCalendarFrame.DoAfterShow(Sender: TObject);
begin
  inherited;
  FCalendar:=TCalendarControl.Create(Self);
  FCalendar.Parent:=Self;
  FCalendar.Align:=TAlignLayout.Client;
  FCalendar.OnSelectedItem:=DoSelectedItem;
end;

procedure TfrmCalendarFrame.DoSelectedItem(Sender: TObject);
begin
  if not (Sender is TClendarDayItem) then Exit;
  txtTitle.Text:=FormatDatetime('YYYY-MM-DD', TClendarDayItem(Sender).Day);
end;

end.

