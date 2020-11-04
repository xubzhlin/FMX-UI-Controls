unit FMX.Camera.Player;

interface

uses
  System.Classes, System.Types, FMX.Controls, FMX.Types3D, FMX.Objects,
  System.Math.Vectors, FMX.Types;

type
  TCameraPlayer = class;

  ICameraPlayer = interface(IInterface)
    ['{1BB19DCA-0418-43C1-8155-3C2509E63368}']
    procedure start(CameraId: Integer);
    function started: Boolean;
    procedure stop;
    procedure focus;
    procedure focusAreas(const Point: TPointF);
    function getCameraWidth: Integer;
    function getCameraHeight: Integer;
    function isCapturing: Boolean;
    procedure setCameraPlayer(Control: TCameraPlayer);
    function getCameraPlayer: TCameraPlayer;
    procedure setOnFrameAvailable(OnFrameAvailable: TNotifyEvent);
    procedure setOnCameraSizeChanged(OnCameraSizeChanged: TNotifyEvent);
    function getCameraRotation: Integer;
    function getTexture: TTexture;
    procedure willBecomeForeground;
    procedure enteredBackground;
  end;

  TCameraPlayer = class(TRectangle)
  private
    FPlayer: ICameraPlayer;
    FCameraRect: TRectF;
    FCameraMatrix: TMatrix;
  private
    procedure DoFrameAvailable(Sender: TObject);
    procedure DoCameraSizeChanged(Sender: TObject);
  protected
    procedure DoResized; override;
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property Player: ICameraPlayer read FPlayer;
  end;

implementation

uses
  System.UITypes, FMX.Canvas.GPU, System.UIConsts, System.SysUtils, FMX.Graphics,
  SYstem.Math
{$IFDEF Android}
  ,FMX.Camera.Player.Android;
{$ENDIF}
{$IFDEF iOS}
  ,FMX.Camera.Player.iOS;
{$ENDIF}
{$IFDEF MSWINDOWS}
  //FMX.Media.Player.Win
  ;
{$ENDIF}

function  PrepareColor(const SrcColor: TAlphaColor; const Opacity: Single): TAlphaColor;
begin
  if Opacity < 1 then
  begin
    TAlphaColorRec(Result).R := Round(TAlphaColorRec(SrcColor).R * Opacity);
    TAlphaColorRec(Result).G := Round(TAlphaColorRec(SrcColor).G * Opacity);
    TAlphaColorRec(Result).B := Round(TAlphaColorRec(SrcColor).B * Opacity);
    TAlphaColorRec(Result).A := Round(TAlphaColorRec(SrcColor).A * Opacity);
  end
  else if (TAlphaColorRec(SrcColor).A < $FF) then
    Result := PremultiplyAlpha(SrcColor)
  else
    Result := SrcColor;
end;

function FillRect(const R: TRectF;const ADesignatedArea: TRectF): TRectF;
var
  Ratio: Single;
begin
  if (ADesignatedArea.Width <= 0) or (ADesignatedArea.Height <= 0) then
  begin
    Exit(R);
  end;

  if (R.Width / ADesignatedArea.Width) < (R.Height / ADesignatedArea.Height) then
    Ratio := R.Width / ADesignatedArea.Width
  else
    Ratio := R.Height / ADesignatedArea.Height;

  if Ratio = 0 then
    Exit(R)
  else
  begin
    Result := TRectF.Create(0, 0, R.Width / Ratio, R.Height / Ratio);
    RectCenter(Result, ADesignatedArea);
  end;

end;

{ TCameraPlayer }


constructor TCameraPlayer.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Fill.Color := $FF000000;
{$IFDEF Android}
  FPlayer := TCameraPlayerAndroid.Create;
{$ENDIF}
{$IFDEF iOS}
  FPlayer := TCameraPlayeriOS.Create;
{$ENDIF}
{$IFDEF MSWINDOWS}
  //FPlayer := TMediaPlayerWin.Create;
{$ENDIF}

  FPlayer.setCameraPlayer(Self);
  FPlayer.setOnFrameAvailable(DoFrameAvailable);
  FPlayer.setOnCameraSizeChanged(DoCameraSizeChanged);
end;

destructor TCameraPlayer.Destroy;
begin
  FPlayer := nil;
  inherited;
end;

procedure TCameraPlayer.DoCameraSizeChanged(Sender: TObject);
var
  Texture:  TTexture;
  M1, M2, ScaleMatrix, RotMatrix, TranslateMatrix: TMatrix;
  CameraRotation: Integer;
  CameraSize: TPointF;
  OffsetPoint: TPointF;
  IsRotation: Boolean;
begin
  if not FPlayer.isCapturing then exit;

  // »æÖÆ
  Texture := FPlayer.getTexture;

  if (Texture = nil) or (Texture.IsEmpty) then exit;

  CameraRotation := FPlayer.getCameraRotation;
  IsRotation := (CameraRotation div 90) mod 2 = 1;
  if IsRotation then
  begin
    FCameraRect := TrectF.Create(0, 0, LocalRect.Height, LocalRect.Width);
    FCameraRect := FillRect(TRectF.Create(0, 0, Texture.Width, Texture.Height), (FCameraRect));
    OffsetPoint := TPointF.Create ((FCameraRect.Height - LocalRect.Width) / 2, (FCameraRect.Width - LocalRect.Height) / 2);
  end else
  begin
    FCameraRect := LocalRect;
    FCameraRect := FillRect(TRectF.Create(0, 0, Texture.Width, Texture.Height), (FCameraRect));
    OffsetPoint := TPointF.Create ((FCameraRect.Width - LocalRect.Width) / 2, (FCameraRect.Height - LocalRect.Height) / 2);
  end;
  FCameraRect := Canvas.AlignToPixel(FCameraRect);
  FCameraRect := FCameraRect.CenterAt(LocalRect);
  FCameraRect.Offset(OffsetPoint);

  if IsRotation then
    CameraSize := TPointF.Create(FCameraRect.Height, FCameraRect.Width)
  else
    CameraSize := TPointF.Create(FCameraRect.Width, FCameraRect.Height);

  if not SameValue(CameraRotation, 0.0, TEpsilon.Scale) then
  begin

    // scale
    ScaleMatrix := TMatrix.Identity;
    ScaleMatrix.m11 := Scale.X;
    ScaleMatrix.m22 := Scale.Y;
    FCameraMatrix := ScaleMatrix;
    // rotation
    if CameraRotation <> 0 then
    begin
      M1 := TMatrix.Identity;
      M1.m31 := -0.5 * CameraSize.X * Scale.X;
      M1.m32 := -0.5 * CameraSize.Y * Scale.Y;
      M2 := TMatrix.Identity;
      M2.m31 := 0.5 * CameraSize.X * Scale.X;
      M2.m32 := 0.5 * CameraSize.Y * Scale.Y;
      RotMatrix := M1 * (TMatrix.CreateRotation(DegToRad(CameraRotation)) * M2);
      FCameraMatrix := FCameraMatrix * RotMatrix;
      Canvas.SetMatrix(FCameraMatrix);
    end;
    // translate
    TranslateMatrix := TMatrix.Identity;
    TranslateMatrix.m31 := Position.X;
    TranslateMatrix.m32 := Position.Y;
    FCameraMatrix := FCameraMatrix * TranslateMatrix;

    if CameraRotation <> 0 then
      FCameraMatrix := FCameraMatrix * ParentControl.AbsoluteMatrix;
  end;
end;

procedure TCameraPlayer.DoFrameAvailable(Sender: TObject);
begin
  RePaint;
end;

procedure TCameraPlayer.DoResized;
begin
  inherited;
  DoCameraSizeChanged(Self);
  Repaint;
end;

procedure TCameraPlayer.Paint;
var
  DestRect: TrectF;
  Texture:  TTexture;
  State: TCanvasSaveState;
  M1, M2, ScaleMatrix, RotMatrix, TranslateMatrix, CameraMatrix: TMatrix;
  CameraRotation: Integer;
  OffsetPoint: TPointF;
begin
  inherited Paint;

  Log.d('FMX TCameraPlayer: %d, %d', [FPlayer.getTexture.Width, FPlayer.getTexture.Height]);

  if not FPlayer.isCapturing then exit;
  
  // »æÖÆ
  Texture := FPlayer.getTexture;

  if (Texture = nil) or (Texture.IsEmpty) then exit;

  CameraRotation := FPlayer.getCameraRotation;
  Log.d('FMX TCameraPlayer: %d, %d', [FPlayer.getTexture.Width, FPlayer.getTexture.Height]);
  if not SameValue(CameraRotation, 0.0, TEpsilon.Scale) then
  begin
    State := Canvas.SaveState;
    try
      Canvas.SetMatrix(FCameraMatrix);

      TCustomCanvasGpu(Canvas).DrawTexture(FCameraRect, TRectF.Create(0, 0, FPlayer.getTexture.Width, FPlayer.getTexture.Height),
        PrepareColor(TCustomCanvasGpu.ModulateColor, AbsoluteOpacity), FPlayer.getTexture);
    finally
      Canvas.RestoreState(State);
    end;
  end
  else
  begin
    TCustomCanvasGpu(Canvas).DrawTexture(FCameraRect, TRectF.Create(0, 0, FPlayer.getTexture.Width, FPlayer.getTexture.Height),
      PrepareColor(TCustomCanvasGpu.ModulateColor, AbsoluteOpacity), FPlayer.getTexture);
  end;


end;

end.
