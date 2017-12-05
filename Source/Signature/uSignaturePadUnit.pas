unit uSignaturePadUnit;

//author:Xubzhlin
//Email:371889755@qq.com
//手写 带笔锋 单元

interface

uses
  System.Classes, System.SysUtils, System.Types, System.UITypes, System.UIConsts, System.Generics.Collections, System.Math,
  System.Math.Vectors, FMX.Controls, FMX.Canvas.GPU, FMX.Objects,
  FMX.Types, FMX.Types3D, FMX.Platform, FMX.Filter, FMX.Forms, FMX.Graphics;

const
  STROKE_WIDTH_MIN = 2;//0.004; // Stroke width determined by touch velocity
  STROKE_WIDTH_MAX = 10;//0.030;
  STROKE_WIDTH_SMOOTHING = 0.5;   // Low pass filter alpha

  VELOCITY_CLAMP_MIN = 20;
  VELOCITY_CLAMP_MAX = 5000;

  QUADRATIC_DISTANCE_TOLERANCE = 3.0;   // Minimum distance to make a curve

  MAXIMUM_VERTECES = 100000;
type

  TTrackingInfo = packed record
    Position: TPointF;
    Time: TDateTime;
  end;

  TStepInfo = record
    Point:TPointF;
    Thickness:Single;
  end;

  TStepsList = TList<TStepInfo>;

  TSignaturePadPath = class(TPaintBox)
  private
    FIsMouseDown:Boolean;
    FPreStep, FCurrStep:TStepInfo;

    FCacha:TBitMap;

    FPenThickness:Single;
    FPreviousThickness:Single;

    FTracking:TTrackingInfo;

    FPrePoint:TPointF;
    FMidPoint:TPointF;
    FAtPoint:TPointF;

    FMinThickness:Single;
    FMaxThickness:Single;
    FSceneScale:Single;

    function QuadraticPointInCurve(sPoint, ePoint, cPoint:TPointF; Percent:Single):TPointF;
    function GenerateRandom(from, &to:Single):Single;
    function Clamp(sMin, sMax, sValue:Single):Single;

    function GetDistance(NewTracking:TTrackingInfo):Single;
    function GetThickness(NewTracking:TTrackingInfo):Single;
    procedure AddTriangleStripPointsForPrevious(pPoint, nPoint:TPointF);
    function perpendicular(pPoint, nPoint:TPointF):TPointF;
    procedure MoveToPoint(X, Y:Single);
    procedure DrawLineToBitMap;
    procedure DrawDotToBitMap;
  protected
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Single); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Single); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Single); override;
    procedure Tap(const Point:TPointF); override;
    procedure DoMouseEnter; override;
    procedure DoMouseLeave; override;

    procedure Paint; override;
    procedure ReSize ; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Clear;
    property MinThickness:Single read FMinThickness;
    property MaxThickness:Single read FMaxThickness;
    property Scale;
  end;



implementation

{ TSignaturePadPath }

procedure TSignaturePadPath.AddTriangleStripPointsForPrevious(pPoint, nPoint:TPointF);
var
  i: Integer;
  toTravel:Single;
  p, p1, ref:TPointF;
  distance, difX, difY, ratio:Single;
  stripPoint:TPointF;
  StepInfo:TStepInfo;
begin
  toTravel := FPenThickness / 2.0;
  for i := 0 to 1 do
  begin
    p := perpendicular(pPoint, nPoint);
    p1:= nPoint;
    ref:=pPoint + nPoint;

    distance:=(P - P1).Length;

    difX:=P1.X - Ref.X;
    difY:=P1.Y - Ref.Y;
    ratio:=-1.0*(toTravel / distance);

    difX:=difX*ratio;
    difY:=difY*ratio;

    stripPoint.X:= p1.X + difX;
    stripPoint.Y:= p1.Y + difY;

    StepInfo.Point:=stripPoint;
    StepInfo.Thickness:=FPenThickness;

    FPreStep:=FCurrStep;
    FCurrStep:=StepInfo;

    DrawLineToBitMap;

    toTravel := toTravel * -1;
  end;
end;

function TSignaturePadPath.Clamp(sMin, sMax, sValue: Single): Single;
begin
  Result := Max(smin, Min(smax, svalue));
end;

procedure TSignaturePadPath.Clear;
begin

  if FCacha<>nil  then
    FCacha.Clear($FFFFFFFF);
  FMinThickness:=STROKE_WIDTH_MAX;
  FMaxThickness:=STROKE_WIDTH_MIN;
  Repaint;
end;

constructor TSignaturePadPath.Create(AOwner: TComponent);
begin
  inherited;
  Randomize;
  FIsMouseDown:=False;
  FAtPoint:=TPointF.Create(0, 0);
  FPrePoint:=FAtPoint;
  FTracking.Position:=FPrePoint;
  FTracking.Time:=0;

  FPenThickness:=STROKE_WIDTH_MIN;

  FMinThickness:=STROKE_WIDTH_MAX;
  FMaxThickness:=STROKE_WIDTH_MIN;

end;

destructor TSignaturePadPath.Destroy;
begin

  FCacha.Free;
  inherited;
end;


procedure TSignaturePadPath.DoMouseEnter;
begin
  inherited;

end;

procedure TSignaturePadPath.DoMouseLeave;
begin

  inherited;
  FIsMouseDown := False;
end;

procedure TSignaturePadPath.DrawDotToBitMap;
var
  penThickness, angle:Single;
  segments:Integer;
  i: Integer;
  radius:TPointF;
  P1, P2:TPointF;
begin
  P1:=FAtPoint;
  P2:=P1;
  angle:=0;
  segments := 20;
  radius.X:=clamp(0.00001, 0.02,  FPenThickness * generateRandom(0.5, 1.5));
  radius.Y:=clamp(0.00001, 0.02,  FPenThickness * generateRandom(0.5, 1.5));

  FCacha.Canvas.BeginScene;
  FCacha.Canvas.Stroke.Kind:=TBrushKind.Solid;
  FCacha.Canvas.Stroke.Cap:=TStrokeCap.Round;
  FCacha.Canvas.Stroke.Color:=$FF000000;
  penThickness:= (STROKE_WIDTH_MAX + STROKE_WIDTH_MIN);
  FCacha.Canvas.Stroke.Thickness:= (STROKE_WIDTH_MAX + STROKE_WIDTH_MIN);
  for i := 0 to segments do
  begin
    P2.X := P2.X + radius.X * cos(angle);
    P2.Y := P2.Y + radius.Y * sin(angle);
    angle := PI * 2.0 / segments;
    FCacha.Canvas.DrawLine(P1.Scale(FSceneScale) , P2.Scale(FSceneScale), 1);
    P1:=P2;
  end;
  FCacha.Canvas.EndScene;

end;

procedure TSignaturePadPath.DrawLineToBitMap;

begin

  if not FIsMouseDown then Exit;


  FCacha.Canvas.Stroke.Kind:=TBrushKind.Solid;
  FCacha.Canvas.Stroke.Cap:=TStrokeCap.Round;
  FCacha.Canvas.Stroke.Color:=$FF000000;

  FCacha.Canvas.Stroke.Thickness:=FCurrStep.Thickness;
  FCacha.Canvas.DrawLine(FPreStep.Point.Scale(FSceneScale) , FCurrStep.Point.Scale(FSceneScale), 1);

end;

function TSignaturePadPath.GenerateRandom(from, &to: Single): Single;
begin
  Result := Random(10000) / 10000.0 * (&to - from) + from;
end;

function TSignaturePadPath.GetDistance(NewTracking:TTrackingInfo): Single;
begin
  Result:=Sqrt(Sqr(NewTracking.Position.X - FTracking.Position.X)+Sqr(NewTracking.Position.Y - FTracking.Position.Y));
end;


function TSignaturePadPath.GetThickness(NewTracking:TTrackingInfo): Single;
var
  Interval:TTimeStamp;
  velocityMagnitude, clampedVelocityMagnitude, normalizedVelocity, lowPassFilterAlpha, newThickness:Single;
begin
  if SameValue(FTracking.Position.X, NewTracking.Position.X, 0.01) and SameValue(FTracking.Position.Y, NewTracking.Position.Y, 0.01) then
    velocityMagnitude:=VELOCITY_CLAMP_MIN
  else
  begin
    Interval := DateTimeToTimeStamp(NewTracking.Time - FTracking.Time);
    if Interval.Time = 0 then
      Interval.Time:=1;
    velocityMagnitude:= NewTracking.Position.Distance(FTracking.Position) / Interval.Time * MSecsPerSec;
  end;
  clampedVelocityMagnitude:=Clamp(VELOCITY_CLAMP_MIN, VELOCITY_CLAMP_MAX, velocityMagnitude);
  normalizedVelocity:= (clampedVelocityMagnitude - VELOCITY_CLAMP_MIN) / (VELOCITY_CLAMP_MAX - VELOCITY_CLAMP_MIN);
  lowPassFilterAlpha:=STROKE_WIDTH_SMOOTHING;
  newThickness:=(STROKE_WIDTH_MAX - STROKE_WIDTH_MIN) * (1 - normalizedVelocity) + STROKE_WIDTH_MIN;
  Result := FPenThickness * lowPassFilterAlpha + newThickness * (1 - lowPassFilterAlpha);

end;

procedure TSignaturePadPath.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Single);
var
  L:TPointF;
  StepInfo:TStepInfo;
begin
  FIsMouseDown:=True;

  L:=TPointF.Create(X, Y);

  FPrePoint:=L;

  FTracking.Position:=L;
  FTracking.Time:=Now;
  FPenThickness:=GetThickness(FTracking);

  FPreviousThickness:=FPenThickness;



  FMidPoint:=L;

  StepInfo.Point:=L;
  StepInfo.Thickness:=FPenThickness;

  FPreStep:=StepInfo;
  FCurrStep:=StepInfo;
  FAtPoint:=L;

end;

procedure TSignaturePadPath.MouseMove(Shift: TShiftState; X, Y: Single);
var
  L:TPointF;
begin
  if not FIsMouseDown then exit;
  try
    FCacha.Canvas.BeginScene;
    MoveToPoint(X, Y);
  finally
    FCacha.Canvas.EndScene;
  end;
  Repaint;
end;

procedure TSignaturePadPath.MouseUp(Button: TMouseButton; Shift: TShiftState; X,
  Y: Single);
var
  L:TPointF;
  StepInfo:TStepInfo;

begin

  FIsMouseDown:=False;
  L:= TPointF.Create(X, Y);

  FPrePoint:=L;


end;

procedure TSignaturePadPath.MoveToPoint(X, Y: Single);
var
  L:TPointF;
  Mid:TPointF;
  Distance:Single;
  i, segments:Integer;
  quadPoint:TPointF;

  startPenThickness, endPenThickness:Single;

  StepInfo:TStepInfo;

  NewTrackInfo:TTrackingInfo;
begin
  L:=TPointF.Create(X, Y);


  NewTrackInfo.Position:=L;
  NewTrackInfo.Time:=Now;

  FPenThickness:=GetThickness(NewTrackInfo);
  Distance:=GetDistance(NewTrackInfo);

  Mid:=TPointF.Create((FTracking.Position.X + L.X) /2.0, (FTracking.Position.Y + L.Y) /2.0);
  if (distance > QUADRATIC_DISTANCE_TOLERANCE) then
  begin
    // Plot quadratic bezier instead of line
    segments:=Trunc(distance / 1.5);

    startPenThickness:= FPreviousThickness;
    endPenThickness:=FPenThickness;
    FPreviousThickness:=FPenThickness;
    for i := 0 to segments -1 do
    begin
      FPenThickness:= startPenThickness + ((endPenThickness - startPenThickness) / segments) * i;

      quadPoint := QuadraticPointInCurve(FMidPoint, Mid, FTracking.Position, i/segments);

      AddTriangleStripPointsForPrevious(FTracking.Position, quadPoint);

      FPrePoint:=quadPoint;
    end;
  end
  else
  if distance > 1.0 then
  begin
    AddTriangleStripPointsForPrevious(FTracking.Position, L);
    FPrePoint:=quadPoint;
    FPreviousThickness:=FPenThickness;
  end;

  FTracking:=NewTrackInfo;
  FMidPoint := mid;
end;

procedure TSignaturePadPath.Paint;
var
  i:Single;
begin
  if FCacha = nil then
  begin
    FSceneScale:=Canvas.Scale;
    FCacha:=TBitMap.Create(Trunc(Width*FSceneScale), Trunc(Height*FSceneScale));
    FCacha.Clear($FFFFFFFF);
  end;
  Canvas.BeginScene;
  Canvas.DrawBitmap(FCacha, TRectF.Create(0, 0, FCacha.Width, FCacha.Height),
    ClipRect, 1, True);
  Canvas.EndScene;
end;

function TSignaturePadPath.perpendicular(pPoint, nPoint: TPointF):TPointF;
begin
  Result.X:=nPoint.Y - pPoint.Y;
  Result.Y:=-1 * (nPoint.X - pPoint.x);
end;

function TSignaturePadPath.QuadraticPointInCurve(sPoint, ePoint,
  cPoint: TPointF; Percent: Single): TPointF;
var
  a, b, c:Single;
begin
  a := Power((1.0 - Percent), 2.0);
  b := 2.0 * Percent * (1.0 - Percent);
  c := Power(Percent, 2.0);
  Result.X := a*sPoint.X + b*cPoint.X + c*ePoint.X;
  Result.Y := a*sPoint.Y + b*cPoint.Y + c*ePoint.Y;

end;

procedure TSignaturePadPath.ReSize;
begin
  if FCacha <> nil then
  begin
    FSceneScale:=Canvas.Scale;

    FCacha.SetSize(Trunc(Width*FSceneScale), Trunc(Height*FSceneScale));
    FCacha.Clear($FFFFFFFF);
  end;
  inherited;
end;

procedure TSignaturePadPath.Tap(const Point: TPointF);
begin
  FAtPoint:=Point;
  DrawDotToBitMap;
  Repaint;
end;

end.
