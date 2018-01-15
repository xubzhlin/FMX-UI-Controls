unit uMainFrom;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Layouts, FMX.Controls.Presentation, FMX.StdCtrls;

type
  TForm23 = class(TForm)
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;


var
  Form23: TForm23;

implementation

uses
  uMainFrameUnit;

{$R *.fmx}



procedure TForm23.FormCreate(Sender: TObject);
begin
  frmMainFrame:=TfrmMainFrame.Create(Application.MainForm, Self, nil);
end;

procedure TForm23.FormDestroy(Sender: TObject);
begin
  FreeAndNil(frmMainFrame);
end;

end.
