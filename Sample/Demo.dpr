program Demo;

uses
  System.StartUpCopy,
  FMX.Forms,
  uMainFrom in 'uMainFrom.pas' {Form23},
  uCustomBaseAniFrame in 'uCustomBaseAniFrame.pas' {FrmBaseAniFrame: TFrame},
  uCustomBaseFrame in 'uCustomBaseFrame.pas' {frmBaseFrame: TFrame},
  uGesturePasswordUnit in 'uGesturePasswordUnit.pas' {frmGesturePassword: TFrame},
  uGesturePassword in 'uGesturePassword.pas',
  uMainFrameUnit in 'uMainFrameUnit.pas' {frmMainFrame: TFrame},
  uMessageListViewUnit in 'uMessageListViewUnit.pas' {frmMessageListView: TFrame},
  FMX.MessageAppearance in 'FMX.MessageAppearance.pas',
  FMX.Graphics.Helper in 'FMX.Graphics.Helper.pas',
  uCalendarFrameUnit in 'uCalendarFrameUnit.pas' {frmCalendarFrame: TFrame},
  FMX.CalendarControl in 'FMX.CalendarControl.pas',
  FMX.CalendarItemAppearance in 'FMX.CalendarItemAppearance.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm23, Form23);
  Application.Run;
end.
