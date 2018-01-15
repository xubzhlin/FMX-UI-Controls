unit uCustomBaseFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uCustomBaseAniFrame, FMX.Objects, FMX.Layouts, FMX.Controls.Presentation;

type
  TfrmBaseFrame = class(TFrmBaseAniFrame)
    lytTop: TLayout;
    btnBack: TSpeedButton;
    txtTitle: TText;
  private
    { Private declarations }
    function DoPointInObjectEvent(Sender: TObject; const X, Y: Single): Boolean; override;

  public
    { Public declarations }
    constructor Create(AOwner: TComponent; AParent: TFmxObject; ATarget:TFmxObject); override;
  end;

var
  frmBaseFrame: TfrmBaseFrame;

implementation

{$R *.fmx}

{ TfrmBaseFrame }

constructor TfrmBaseFrame.Create(AOwner: TComponent; AParent,
  ATarget: TFmxObject);
begin
  inherited Create(AOwner, AParent, ATarget);
  Show;
end;

function TfrmBaseFrame.DoPointInObjectEvent(Sender: TObject; const X,
  Y: Single): Boolean;
var
  AbsolutePoint: TPointF;
begin
  AbsolutePoint := DetailOverlay.LocalToAbsolute(TPointF.Create(X, Y));
  Result := not btnBack.PointInObject(AbsolutePoint.X, AbsolutePoint.Y);
end;

end.
