unit FMX.ListView.RectangleItemAppearances;

interface

uses
  System.Classes, System.Types, System.Math, System.Math.Vectors, FMX.Types,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.Graphics, FMX.Objects;

type
  TRectangleObjectAppearance = class;

  TRectangleItem = class(TListItemDrawable)
  private
    FFill: TBrush;
    FStroke: TStrokeBrush;
    FSides: TSides;
    FYRadius: Single;
    FXRadius: Single;
    FCorners: TCorners;
    FCornerType: TCornerType;
    FIsShow:Boolean;
    procedure SetFill(const Value: TBrush);
    procedure SetStroke(const Value: TStrokeBrush);
    procedure SetSides(const Value: TSides);
    procedure FillChanged(Sender: TObject);
    procedure StrokeChanged(Sender: TObject);
    procedure SetXRadius(const Value: Single);
    procedure SetYRadius(const Value: Single);
    procedure SetCorners(const Value: TCorners);
    procedure SetCornerType(const Value: TCornerType);

    function GetShapeRect: TRectF;
    procedure SetIsShow(const Value: Boolean);
  protected
    procedure DoResize; override;
  public
    procedure CalculateLocalRect(const DestRect: TRectF; const SceneScale: Single;
      const DrawStates: TListItemDrawStates; const Item: TListItem); override;
    procedure Render(const Canvas: TCanvas; const DrawItemIndex: Integer;
      const DrawStates: TListItemDrawStates;
      const Resources: TListItemStyleResources;
      const Params: TListItemDrawable.TParams;
      const SubPassNo: Integer = 0); override;
    constructor Create(const AOwner: TListItem); override;
    destructor Destroy; override;
  published
    property Fill: TBrush read FFill write SetFill;
    property Stroke: TStrokeBrush read FStroke write SetStroke;
    property Sides: TSides read FSides write SetSides;
    property XRadius: Single read FXRadius write SetXRadius;
    property YRadius: Single read FYRadius write SetYRadius;
    property Corners: TCorners read FCorners write SetCorners;
    property CornerType: TCornerType read FCornerType write SetCornerType;
    property IsShow:Boolean read FIsShow write SetIsShow;
  end;

  TRectangleObjectAppearance = class(TCommonObjectAppearance)
  private
    FFill: TBrush;
    FStroke: TStrokeBrush;
    FSides: TSides;
    FYRadius: Single;
    FXRadius: Single;
    FCorners: TCorners;
    FCornerType: TCornerType;
    FIsAssignBrush: Boolean;
    procedure SetFill(const Value: TBrush);
    procedure SetStroke(const Value: TStrokeBrush);
    procedure SetSides(const Value: TSides);
    procedure FillChanged(Sender: TObject);
    procedure StrokeChanged(Sender: TObject);
    procedure SetXRadius(const Value: Single);
    procedure SetYRadius(const Value: Single);
    procedure SetCorners(const Value: TCorners);
    procedure SetCornerType(const Value: TCornerType);
    procedure SetIsAssignBrush(const Value: Boolean);
  protected
    procedure AssignTo(ADest: TPersistent); override;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure CreateObject(const AListViewItem: TListViewItem); override;
    procedure ResetObject(const AListViewItem: TListViewItem); override;
  published
    property Sides: TSides read FSides write SetSides;
    property Fill: TBrush read FFill write SetFill;
    property Stroke: TStrokeBrush read FStroke write SetStroke;
    property XRadius: Single read FXRadius write SetXRadius;
    property YRadius: Single read FYRadius write SetYRadius;
    property Corners: TCorners read FCorners write SetCorners;
    property CornerType: TCornerType read FCornerType write SetCornerType;
    property IsAssignBrush: Boolean read FIsAssignBrush write SetIsAssignBrush;
  end;

implementation

function GetDrawingShapeRectAndSetThickness(const AItem: TRectangleItem; const Fit: Boolean; var FillShape, DrawShape: Boolean;
  var StrokeThicknessRestoreValue: Single): TRectF;
const
  MinRectAreaSize = 0.01;
begin
  FillShape := (AItem.FFill <> nil) and (AItem.FFill.Kind <> TBrushKind.None);
  DrawShape := (AItem.FStroke <> nil) and (AItem.FStroke.Kind <> TBrushKind.None);

  if Fit then
    Result := TRectF.Create(0, 0, 1, 1).FitInto(AItem.LocalRect)
  else
    Result := AItem.LocalRect;

  if DrawShape then
  begin
    if Result.Width < AItem.FStroke.Thickness then
    begin
      StrokeThicknessRestoreValue := AItem.FStroke.Thickness;
      FillShape := False;
      AItem.FStroke.Thickness := Min(Result.Width, Result.Height);
      Result.Left := (Result.Right + Result.Left) * 0.5;
      Result.Right := Result.Left + MinRectAreaSize;
    end
    else
      Result.Inflate(-AItem.FStroke.Thickness * 0.5, 0);

    if Result.Height < AItem.FStroke.Thickness then
    begin
      if StrokeThicknessRestoreValue < 0.0 then
        StrokeThicknessRestoreValue := AItem.FStroke.Thickness;
      FillShape := False;
      AItem.FStroke.Thickness := Min(Result.Width, Result.Height);
      Result.Top := (Result.Bottom + Result.Top) * 0.5;
      Result.Bottom := Result.Top + MinRectAreaSize;
    end
    else
      Result.Inflate(0, -AItem.FStroke.Thickness * 0.5);
  end;
end;

{ TRectangleItem }

procedure TRectangleItem.CalculateLocalRect(const DestRect: TRectF;
  const SceneScale: Single; const DrawStates: TListItemDrawStates;
  const Item: TListItem);
begin
  inherited;
end;

constructor TRectangleItem.Create(const AOwner: TListItem);
begin
  inherited;
  FFill := TBrush.Create(TBrushKind.Solid, $FFE0E0E0);
  FFill.OnChanged := FillChanged;
  FStroke := TStrokeBrush.Create(TBrushKind.None, $00000000);
  FStroke.OnChanged := StrokeChanged;
  FCorners := AllCorners;
  FXRadius := 0;
  FYRadius := 0;
  FSides := AllSides;
  FIsShow:=True;
  FCornerType:= TCornerType.Round;
end;

destructor TRectangleItem.Destroy;
begin
  FFill.Free;
  FStroke.Free;
  inherited;
end;

procedure TRectangleItem.DoResize;
begin
  inherited;
end;

procedure TRectangleItem.FillChanged(Sender: TObject);
begin
  Invalidate;
end;

function TRectangleItem.GetShapeRect: TRectF;
begin
  Result := LocalRect;
  if FStroke.Kind <> TBrushKind.None then
    InflateRect(Result, -(FStroke.Thickness / 2), -(FStroke.Thickness / 2));
end;

procedure TRectangleItem.Render(const Canvas: TCanvas;
  const DrawItemIndex: Integer; const DrawStates: TListItemDrawStates;
  const Resources: TListItemStyleResources;
  const Params: TListItemDrawable.TParams; const SubPassNo: Integer);
var
  LShapeRect: TRectF;
  Off: Single;
  StrokeThicknessRestoreValue: Single;
  FillShape, DrawShape: Boolean;
begin
  if (SubPassNo <> 0) or (not FIsShow) then
    Exit;
  StrokeThicknessRestoreValue := FStroke.Thickness;
  try
    LShapeRect := GetDrawingShapeRectAndSetThickness(Self, False, FillShape, DrawShape, StrokeThicknessRestoreValue);

    if Sides <> AllSides then
    begin
      Off := LShapeRect.Left;
      if not(TSide.Top in FSides) then
        LShapeRect.Top := LShapeRect.Top - Off;
      if not(TSide.Left in FSides) then
        LShapeRect.Left := LShapeRect.Left - Off;
      if not(TSide.Bottom in FSides) then
        LShapeRect.Bottom := LShapeRect.Bottom + Off;
      if not(TSide.Right in FSides) then
        LShapeRect.Right := LShapeRect.Right + Off;
      if FillShape then
        Canvas.FillRect(LShapeRect, XRadius, YRadius, FCorners, 1, FFill, CornerType);
      if DrawShape then
        Canvas.DrawRectSides(GetShapeRect, XRadius, YRadius, FCorners,  1, Sides, FStroke, CornerType);
    end
    else
    begin
      if FillShape then
        Canvas.FillRect(LShapeRect, XRadius, YRadius, FCorners, 1, FFill, CornerType);
      if DrawShape then
        Canvas.DrawRect(LShapeRect, XRadius, YRadius, FCorners, 1, FStroke, CornerType);
    end;
  finally
    if StrokeThicknessRestoreValue <> FStroke.Thickness then
      FStroke.Thickness := StrokeThicknessRestoreValue;
  end;
end;

procedure TRectangleItem.SetCorners(const Value: TCorners);
begin
  if FCorners <> Value then
  begin
    FCorners := Value;
    Invalidate;
  end;
end;

procedure TRectangleItem.SetCornerType(const Value: TCornerType);
begin
  if FCornerType <> Value then
  begin
    FCornerType := Value;
    Invalidate;
  end;
end;

procedure TRectangleItem.SetFill(const Value: TBrush);
begin
  FFill.Assign(Value);
end;

procedure TRectangleItem.SetIsShow(const Value: Boolean);
begin
  if FIsShow <> Value then
  begin
    FIsShow := Value;
    Invalidate;
  end;
end;

procedure TRectangleItem.SetSides(const Value: TSides);
begin
  if FSides <> Value then
  begin
    FSides := Value;
    Invalidate;
  end;

end;

procedure TRectangleItem.SetStroke(const Value: TStrokeBrush);
begin
  FStroke.Assign(Value);
end;

procedure TRectangleItem.SetXRadius(const Value: Single);
begin
  if not SameValue(FXRadius, Value, TEpsilon.Vector) then
  begin
    FXRadius := Value;
    Invalidate;
  end;
end;

procedure TRectangleItem.SetYRadius(const Value: Single);
begin
  if not SameValue(FYRadius, Value, TEpsilon.Vector) then
  begin
    FYRadius := Value;
    Invalidate;
  end;
end;

procedure TRectangleItem.StrokeChanged(Sender: TObject);
begin
  Invalidate;
end;

{ TRectangleObjectAppearance }

procedure TRectangleObjectAppearance.AssignTo(ADest: TPersistent);
var
  DstDrawable: TRectangleItem;
  DstAppearance: TRectangleObjectAppearance;
begin
  if ADest is TRectangleObjectAppearance then
  begin
    DstAppearance := TRectangleObjectAppearance(ADest);
    DstAppearance.BeginUpdate;
    try
      DstAppearance.FSides:=FSides;
      DstAppearance.FYRadius:=FYRadius;
      DstAppearance.FXRadius:=FXRadius;
      if FIsAssignBrush then
      begin
        DstAppearance.FFill.Assign(FFill);
        DstAppearance.FStroke.Assign(FStroke);
      end;
      DstAppearance.FCorners:=FCorners;
      DstAppearance.FCornerType:=FCornerType;
      inherited AssignTo(ADest);
    finally
      DstAppearance.EndUpdate;
    end;
  end
  else if ADest is TRectangleItem then
  begin
    DstDrawable := TRectangleItem(ADest);
    DstDrawable.BeginUpdate;
    try
      DstDrawable.FSides:=FSides;
      DstDrawable.FYRadius:=FYRadius;
      DstDrawable.FXRadius:=FXRadius;
      if FIsAssignBrush then
      begin
        DstDrawable.FFill.Assign(FFill);
        DstDrawable.FStroke.Assign(FStroke);
      end;
      if FCorners<>[] then
        DstDrawable.FCorners:=FCorners;
      DstDrawable.FCornerType:=FCornerType;
      inherited AssignTo(ADest);
    finally
      DstDrawable.EndUpdate;
    end;
  end
  else
    inherited;


end;

constructor TRectangleObjectAppearance.Create;
begin
  inherited;
  FIsAssignBrush:=False;
  FFill := TBrush.Create(TBrushKind.Solid, $FFE0E0E0);
  FFill.OnChanged := FillChanged;
  FStroke := TStrokeBrush.Create(TBrushKind.None, $00000000);
  FStroke.OnChanged := StrokeChanged;
  FCorners := AllCorners;
  FXRadius := 0;
  FYRadius := 0;
  FSides := AllSides;
  FCornerType:= TCornerType.Round;
end;

procedure TRectangleObjectAppearance.CreateObject(const AListViewItem
  : TListViewItem);
var
  LItem: TRectangleItem;
begin
  LItem := TRectangleItem.Create(AListViewItem);
  LItem.BeginUpdate;
  try
    LItem.Assign(Self);
    LItem.Name := Name;
  finally
    LItem.EndUpdate;
  end;

end;

destructor TRectangleObjectAppearance.Destroy;
begin
  FFill.Free;
  FStroke.Free;
  inherited;
end;

procedure TRectangleObjectAppearance.FillChanged(Sender: TObject);
begin
  DoChange;
end;

procedure TRectangleObjectAppearance.ResetObject(const AListViewItem
  : TListViewItem);
begin
  ResetObjectT<TRectangleItem>(AListViewItem);

end;

procedure TRectangleObjectAppearance.SetCorners(const Value: TCorners);
begin
  if FCorners <> Value then
  begin
    FCorners := Value;
    DoChange;
  end;
end;

procedure TRectangleObjectAppearance.SetCornerType(const Value: TCornerType);
begin
  if FCornerType <> Value then
  begin
    FCornerType := Value;
    DoChange;
  end;
end;

procedure TRectangleObjectAppearance.SetFill(const Value: TBrush);
begin
  FFill.Assign(Value);
end;

procedure TRectangleObjectAppearance.SetIsAssignBrush(const Value: Boolean);
begin
  if FIsAssignBrush <> Value then
  begin
    FIsAssignBrush := Value;
    DoChange;
  end;
end;

procedure TRectangleObjectAppearance.SetSides(const Value: TSides);
begin
  if FSides <> Value then
  begin
    FSides := Value;
    DoChange;
  end;
end;

procedure TRectangleObjectAppearance.SetStroke(const Value: TStrokeBrush);
begin
  FStroke.Assign(Value);
end;

procedure TRectangleObjectAppearance.SetXRadius(const Value: Single);
begin
  if not SameValue(FXRadius, Value, TEpsilon.Vector) then
  begin
    FXRadius := Value;
    DoChange;
  end;
end;

procedure TRectangleObjectAppearance.SetYRadius(const Value: Single);
begin
  if not SameValue(FYRadius, Value, TEpsilon.Vector) then
  begin
    FYRadius := Value;
    DoChange;
  end;
end;

procedure TRectangleObjectAppearance.StrokeChanged(Sender: TObject);
begin
  DoChange;
end;

end.
