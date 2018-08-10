unit FMX.ListView.LineItemAppearances;

interface

uses
  System.Classes, System.Types, System.Math, FMX.ListView.Types, FMX.ListView.Appearances, FMX.Graphics, FMX.Objects;

type
  TLineItem = class(TListItemDrawable)
  private
    FNeedUpdate: Boolean;
    FBitMap:TBitMap;

    FStroke: TStrokeBrush;
    FLineType: TLineType;
    FShortenLine: Boolean;
    FLineLocation: TLineLocation;

    procedure SetLineType(const Value: TLineType);
    procedure SetStroke(const Value: TStrokeBrush);
    procedure SetLineLocation(const Value: TLineLocation);
    procedure SetShortenLine(const Value: Boolean);
  protected
    procedure DoResize; override;
    function GetShapeRect: TRectF;
    procedure DoPaintToBitmap;
    procedure StrokeChanged(Sender:TObject);
  public
    procedure Render(const Canvas: TCanvas; const DrawItemIndex: Integer;
      const DrawStates: TListItemDrawStates;
      const Resources: TListItemStyleResources;
      const Params: TListItemDrawable.TParams;
      const SubPassNo: Integer = 0); override;
    constructor Create(const AOwner: TListItem); override;
    destructor Destroy; override;
  published
    property LineType: TLineType read FLineType write SetLineType;
    property ShortenLine: Boolean read FShortenLine write SetShortenLine;
    property LineLocation: TLineLocation read FLineLocation write SetLineLocation;
    property Stroke: TStrokeBrush read FStroke write SetStroke;
  end;

  TLineObjectAppearance = class(TCommonObjectAppearance)
  private
    FStroke: TStrokeBrush;
    FLineType: TLineType;
    FShortenLine: Boolean;
    FLineLocation: TLineLocation;
    procedure SetLineLocation(const Value: TLineLocation);
    procedure SetLineType(const Value: TLineType);
    procedure SetShortenLine(const Value: Boolean);
    procedure SetStroke(const Value: TStrokeBrush);
    procedure StrokeChanged(Sender:TObject);
  protected
    procedure AssignTo(ADest: TPersistent); override;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure CreateObject(const AListViewItem: TListViewItem); override;
    procedure ResetObject(const AListViewItem: TListViewItem); override;
  published
    property LineType: TLineType read FLineType write SetLineType;
    property ShortenLine: Boolean read FShortenLine write SetShortenLine;
    property LineLocation: TLineLocation read FLineLocation write SetLineLocation;
    property Stroke: TStrokeBrush read FStroke write SetStroke;
  end;

implementation

{ TLineItem }

constructor TLineItem.Create(const AOwner: TListItem);
begin
  inherited;
  FNeedUpdate:=True;

  FStroke := TStrokeBrush.Create(TBrushKind.Solid, $FF000000);
  FStroke.OnChanged := StrokeChanged;
  FLineType:= TLineType.Diagonal;
  FShortenLine:=False;
  FLineLocation:=TLineLocation.Boundary;
end;

destructor TLineItem.Destroy;
begin
  FBitMap.Free;
  FStroke.Free;
  inherited;
end;

procedure TLineItem.DoPaintToBitmap;
const
  PixelSize = 1;
  HalfPixelSize = 0.5;
  LineMinLength = 0.01;
  RectOffsetCorrection = 0.01;

  function CorrectShapeClientRect(const ARect: TRectF; const ACanvas: TCanvas): TRectF;
  begin
    Result := ARect;
    Result.Inflate(-HalfPixelSize * ACanvas.Scale, -HalfPixelSize * ACanvas.Scale);
  end;

  function ValidateRect(const ALocalRect, ARect: TRectF): TRectF;
  begin
    Result := ARect;
    if LineType = TLineType.Diagonal then
      if Result.Right < Result.Left + RectOffsetCorrection then
      begin
        Result.Right := (ALocalRect.Left + ALocalRect.Right) * 0.5;
        Result.Left := Result.Right - RectOffsetCorrection;
        Result.Right := Result.Right + RectOffsetCorrection;
      end;
      if Result.Bottom < Result.Top + RectOffsetCorrection then
      begin
        Result.Bottom := (ALocalRect.Top + ALocalRect.Bottom) * 0.5;
        Result.Top := Result.Bottom - RectOffsetCorrection;
        Result.Bottom := Result.Bottom + RectOffsetCorrection;
      end;
  end;

  procedure GetStartingPointAndDirection(out AStartingPoint, ADirection: TPointF);
  var
    LLocalRect: TRectF;
    LShapeRect: TRectF;
    LDeinflateShapeRect: TRectF;
  begin

    LLocalRect := TRectF.Create(0, 0, FBitMap.Width, FBitMap.Height);
    LShapeRect := ValidateRect(LLocalRect, CorrectShapeClientRect(LLocalRect, FBitMap.Canvas));
    LDeinflateShapeRect := ValidateRect(LLocalRect, GetShapeRect);

    case FLineType of
      TLineType.Top:
        begin
          if FLineLocation <> TLineLocation.Boundary then
            AStartingPoint := TPointF.Create(LShapeRect.Left, LDeinflateShapeRect.Top)
          else
            AStartingPoint := TPointF.Create(LShapeRect.Left, LShapeRect.Top);
          ADirection.X := LShapeRect.Right - LShapeRect.Left;
          ADirection.Y := 0;
        end;
      TLineType.Bottom:
        begin
          if FLineLocation <> TLineLocation.Boundary then
            AStartingPoint := TPointF.Create(LShapeRect.Left, LDeinflateShapeRect.Bottom)
          else
            AStartingPoint := TPointF.Create(LShapeRect.Left, LShapeRect.Bottom);
          ADirection.X := LShapeRect.Right - LShapeRect.Left;
          ADirection.Y := 0;
        end;
      TLineType.Left:
        begin
          if FLineLocation <> TLineLocation.Boundary then
            AStartingPoint := TPointF.Create(LDeinflateShapeRect.Left, LShapeRect.Top)
          else
            AStartingPoint := TPointF.Create(LShapeRect.Left, LShapeRect.Top);
          ADirection.X := 0;
          ADirection.Y := LShapeRect.Bottom - LShapeRect.Top;
        end;
      TLineType.Right:
        begin
          if FLineLocation <> TLineLocation.Boundary then
            AStartingPoint := TPointF.Create(LDeinflateShapeRect.Right, LShapeRect.Top)
          else
            AStartingPoint := TPointF.Create(LShapeRect.Right, LShapeRect.Top);
          ADirection.X := 0;
          ADirection.Y := LShapeRect.Bottom - LShapeRect.Top;
        end;
    else
      AStartingPoint := TPointF.Create(LShapeRect.Left, LShapeRect.Top);
      ADirection := LShapeRect.BottomRight - LShapeRect.TopLeft;
    end;
  end;

var
  StrokeThicknessRestoreValue: Single;
  StartingPoint, Direction, UnitDirection: TPointF;
  VectorLength, SizeFactor, Offset: Single;
  LineBegin, LineEnd: TPointF;
begin
  StrokeThicknessRestoreValue := FStroke.Thickness;
  try
    if (FLineLocation = TLineLocation.InnerWithin) and (FStroke.Thickness > Min(Width, Height)) then
      FStroke.Thickness := Min(Width, Height);

    GetStartingPointAndDirection(StartingPoint, Direction);

    if FShortenLine then
      SizeFactor := 2
    else
      SizeFactor := 1;

    VectorLength := Direction.Length;
    UnitDirection := Direction.Normalize;

    if VectorLength < FStroke.Thickness * SizeFactor then
    begin
      FStroke.Thickness := VectorLength / SizeFactor;
      if FLineLocation <> TLineLocation.Boundary then
      begin
        GetStartingPointAndDirection(StartingPoint, Direction);
        UnitDirection := Direction.Normalize;
      end;
    end;

    Offset := FStroke.Thickness * 0.5 * SizeFactor;

    if Offset * 2 < VectorLength - LineMinLength then
    begin
      LineBegin := StartingPoint + (UnitDirection * Offset);
      LineEnd := StartingPoint + Direction - (UnitDirection * Offset);
    end
    else
    begin
      LineBegin := StartingPoint + (UnitDirection * Offset);
      LineEnd := LineBegin + UnitDirection * LineMinLength;
    end;

    FBitMap.Canvas.DrawLine(LineBegin, LineEnd, 1, FStroke);
  finally
    if StrokeThicknessRestoreValue <> FStroke.Thickness then
      FStroke.Thickness := StrokeThicknessRestoreValue;
  end;
end;

procedure TLineItem.DoResize;
begin
  FNeedUpdate:=True;
  inherited;
end;

function TLineItem.GetShapeRect: TRectF;
begin
  Result := LocalRect;
  if FStroke.Kind <> TBrushKind.None then
    InflateRect(Result, -(FStroke.Thickness / 2), -(FStroke.Thickness / 2));
end;

procedure TLineItem.Render(const Canvas: TCanvas;
  const DrawItemIndex: Integer; const DrawStates: TListItemDrawStates;
  const Resources: TListItemStyleResources;
  const Params: TListItemDrawable.TParams; const SubPassNo: Integer);
begin
  if (SubPassNo <> 0) or (Width = 0) then
    Exit;

  if FNeedUpdate then
  begin
    if FBitMap = nil then
      FBitMap:=TBitMap.Create;
    FBitMap.SetSize(Trunc(LocalRect.Width), Trunc(LocalRect.Height));
    FBitMap.Canvas.BeginScene;
    DoPaintToBitmap;
    FBitMap.Canvas.EndScene;
    FNeedUpdate:=False;
  end;

  Canvas.DrawBitmap(FBitMap, TRectF.Create(0, 0, FBitMap.Width, FBitMap.Height), LocalRect, 1, True);

end;

procedure TLineItem.SetLineLocation(const Value: TLineLocation);
begin
  if FLineLocation<>Value then
  begin
    FNeedUpdate:=True;
    FLineLocation := Value;
    Invalidate;
  end;
end;

procedure TLineItem.SetLineType(const Value: TLineType);
begin
  if FLineType<>Value then
  begin
    FNeedUpdate:=True;
    FLineType := Value;
    Invalidate;
  end;
end;

procedure TLineItem.SetShortenLine(const Value: Boolean);
begin
  if FShortenLine<>Value then
  begin
    FNeedUpdate:=True;
    FShortenLine := Value;
    Invalidate;
  end;
end;

procedure TLineItem.SetStroke(const Value: TStrokeBrush);
begin
  FStroke.Assign(Value);
end;

procedure TLineItem.StrokeChanged(Sender: TObject);
begin
  FNeedUpdate:=True;
  Invalidate;
end;

{ TLineObjectAppearance }

procedure TLineObjectAppearance.AssignTo(ADest: TPersistent);
var
  DstDrawable: TLineItem;
  DstAppearance: TLineObjectAppearance;
begin
  if ADest is TLineObjectAppearance then
  begin
    DstAppearance := TLineObjectAppearance(ADest);
    DstAppearance.BeginUpdate;
    try
      DstAppearance.FStroke.Assign(FStroke);
      DstAppearance.FLineType:=FLineType;
      DstAppearance.FShortenLine:=FShortenLine;
      DstAppearance.FLineLocation:=FLineLocation;
      inherited AssignTo(ADest);
    finally
      DstAppearance.EndUpdate;
    end;
  end
  else if ADest is TLineItem then
  begin
    DstDrawable := TLineItem(ADest);
    DstDrawable.BeginUpdate;
    try
      DstDrawable.FStroke.Assign(FStroke);
      DstDrawable.FLineType:=FLineType;
      DstDrawable.FShortenLine:=FShortenLine;
      DstDrawable.FLineLocation:=FLineLocation;
      inherited AssignTo(ADest);
    finally
      DstDrawable.EndUpdate;
    end;
  end
  else
    inherited;


end;

constructor TLineObjectAppearance.Create;
begin
  inherited;
  FStroke := TStrokeBrush.Create(TBrushKind.Solid, $00000000);
  FStroke.OnChanged := StrokeChanged;
  FLineType:= TLineType.Diagonal;
  FShortenLine:=False;
  FLineLocation:= TLineLocation.Boundary;

end;

procedure TLineObjectAppearance.CreateObject(
  const AListViewItem: TListViewItem);
var
  LItem: TLineItem;
begin
  LItem := TLineItem.Create(AListViewItem);
  LItem.BeginUpdate;
  try
    LItem.Assign(Self);
    LItem.Name := Name;
  finally
    LItem.EndUpdate;
  end;

end;

destructor TLineObjectAppearance.Destroy;
begin
  FStroke.Free;
  inherited;
end;

procedure TLineObjectAppearance.ResetObject(const AListViewItem: TListViewItem);
begin
  ResetObjectT<TLineItem>(AListViewItem);

end;

procedure TLineObjectAppearance.SetLineLocation(const Value: TLineLocation);
begin
  if FLineLocation<>Value then
  begin
    FLineLocation := Value;
    DoChange;
  end;
end;

procedure TLineObjectAppearance.SetLineType(const Value: TLineType);
begin
  if FLineType<>Value then
  begin
    FLineType := Value;
    DoChange;
  end;
end;

procedure TLineObjectAppearance.SetShortenLine(const Value: Boolean);
begin
  if FShortenLine<>Value then
  begin
    FShortenLine := Value;
    DoChange;
  end;
end;

procedure TLineObjectAppearance.SetStroke(const Value: TStrokeBrush);
begin
  FStroke := Value;
end;

procedure TLineObjectAppearance.StrokeChanged(Sender: TObject);
begin
  DoChange;
end;

end.
