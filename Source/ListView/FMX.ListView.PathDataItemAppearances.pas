unit FMX.ListView.PathDataItemAppearances;

interface

uses
  System.Classes, System.Types, FMX.ListView.Types, FMX.ListView.Appearances, FMX.Graphics, FMX.Objects;

type
  TPathDataItem = class(TListItemDrawable)
  private
    FData: TPathData;
    FCurrent: TPathData;
    FWrapMode: TPathWrapMode;
    FNeedUpdate: Boolean;
    FFill: TBrush;
    FStroke: TStrokeBrush;
    procedure SetFill(const Value: TBrush);
    procedure SetStroke(const Value: TStrokeBrush);
    procedure FillChanged(Sender: TObject);
    procedure StrokeChanged(Sender: TObject);
    procedure DoChanged(Sender: TObject);
    procedure UpdateCurrent(ARect: TRectF);
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
    property Data: TPathData read FData write FData;
    property Fill: TBrush read FFill write SetFill;
    property Stroke: TStrokeBrush read FStroke write SetStroke;
  end;

  TPathDataObjectAppearance = class(TCommonObjectAppearance)
  private
    FWrapMode: TPathWrapMode;
    FFill: TBrush;
    FStroke: TStrokeBrush;
    procedure SetFill(const Value: TBrush);
    procedure SetStroke(const Value: TStrokeBrush);
    procedure SetWrapMode(const Value: TPathWrapMode);
    procedure FillChanged(Sender: TObject);
    procedure StrokeChanged(Sender: TObject);
  protected
    procedure AssignTo(ADest: TPersistent); override;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure CreateObject(const AListViewItem: TListViewItem); override;
    procedure ResetObject(const AListViewItem: TListViewItem); override;
  published
    property WrapMode: TPathWrapMode read FWrapMode write SetWrapMode;
    property Fill: TBrush read FFill write SetFill;
    property Stroke: TStrokeBrush read FStroke write SetStroke;
  end;

implementation

{ TPathDataItem }

procedure TPathDataItem.CalculateLocalRect(const DestRect: TRectF;
  const SceneScale: Single; const DrawStates: TListItemDrawStates;
  const Item: TListItem);
begin
  inherited;

end;

constructor TPathDataItem.Create(const AOwner: TListItem);
begin
  inherited;
  FWrapMode:=TPathWrapMode.Fit;
  FFill := TBrush.Create(TBrushKind.Solid, $FFE0E0E0);
  FFill.OnChanged := FillChanged;
  FStroke := TStrokeBrush.Create(TBrushKind.None, $00000000);
  FStroke.OnChanged := StrokeChanged;
  FData := TPathData.Create;
  FData.OnChanged := DoChanged;
  FCurrent := TPathData.Create;
  FNeedUpdate:=True;
end;

destructor TPathDataItem.Destroy;
begin
  FFill.Free;
  FStroke.Free;
  FData.Free;
  FCurrent.Free;
  inherited;
end;

procedure TPathDataItem.DoChanged(Sender: TObject);
begin
  FNeedUpdate := True;
  Invalidate;
end;

procedure TPathDataItem.DoResize;
begin
  FNeedUpdate := True;
  inherited;
end;

procedure TPathDataItem.FillChanged(Sender: TObject);
begin
  FNeedUpdate := True;
  Invalidate;
end;

procedure TPathDataItem.Render(const Canvas: TCanvas;
  const DrawItemIndex: Integer; const DrawStates: TListItemDrawStates;
  const Resources: TListItemStyleResources;
  const Params: TListItemDrawable.TParams; const SubPassNo: Integer);
var
  State: TCanvasSaveState;
  procedure PaintInternal;
  var
    R: TRectF;
    I, J: Integer;
    TempPath: TPathData;
    PrevDelta, Delta: TPointF;
  begin
    case FWrapMode of
      TPathWrapMode.Original, TPathWrapMode.Fit, TPathWrapMode.Stretch:
        begin
          Canvas.FillPath(FCurrent, 1, FFill);
          Canvas.DrawPath(FCurrent, 1, FStroke);
        end;
      TPathWrapMode.Tile:
        begin
          R := FCurrent.GetBounds;
          TempPath := TPathData.Create;
          try
            TempPath.Assign(FCurrent);
            PrevDelta := TPointF.Zero;
            for J := 0 to Round(Height / R.Height) do
              for I := 0 to Round(Width / R.Width) do
              begin
                Delta := TPointF.Create(LocalRect.Left + I *
                  (R.Width + LocalRect.Left * 2),
                  LocalRect.Top + J * (R.Height + LocalRect.Top * 2));
                TempPath.Translate(Delta - PrevDelta);
                PrevDelta := Delta;
                Canvas.FillPath(TempPath, 1, FFill);
                Canvas.DrawPath(TempPath, 1, FStroke);
              end;
          finally
            TempPath.Free;
          end;
        end;
    end;
  end;

begin
  if (SubPassNo <> 0)  then
    Exit;
  UpdateCurrent(LocalRect);

  if not FCurrent.IsEmpty then
  begin
    PaintInternal;
    {
    if (FWrapMode in [TPathWrapMode.Original, TPathWrapMode.Tile]) or
      ((Stroke.Kind <> TBrushKind.None) and (Stroke.Thickness > 1) and
      (Stroke.Join = TStrokeJoin.Miter)) then
    begin
      State := Canvas.SaveState;
      try
        Canvas.IntersectClipRect(LocalRect);
        PaintInternal;
      finally
        Canvas.RestoreState(State);
      end;
    end
    else
      PaintInternal;
    }
  end;
end;

procedure TPathDataItem.SetFill(const Value: TBrush);
begin
  FFill.Assign(Value);
end;

procedure TPathDataItem.SetStroke(const Value: TStrokeBrush);
begin
  FStroke.Assign(Value);
end;

procedure TPathDataItem.StrokeChanged(Sender: TObject);
begin
  FNeedUpdate := True;
  Invalidate;
end;

procedure TPathDataItem.UpdateCurrent(ARect: TRectF);
var
  B: TRectF;
  P: TPathData;
begin
  if FNeedUpdate then
  begin
    P := FData;
    if FData.ResourcePath <> nil then
      P := FData.ResourcePath;
    if not P.IsEmpty then
    begin
      case FWrapMode of
        TPathWrapMode.Original:
          FCurrent.Assign(P);
        TPathWrapMode.Fit:
          begin
            FCurrent.Assign(P);
            FCurrent.FitToRect(ARect);
          end;
        TPathWrapMode.Stretch:
          begin
            B := P.GetBounds;
            if (B.Width > 0) and (B.Height > 0) then
            begin
              FCurrent.Assign(P);
              FCurrent.Translate(-B.Left, -B.Top);
              FCurrent.Scale(ARect.Width / B.Width, ARect.Height / B.Height);
            end;
          end;
        TPathWrapMode.Tile:
          begin
            B := P.GetBounds;
            FCurrent.Assign(P);
            FCurrent.Translate(-B.Left, -B.Top);
          end;
      end;
      if Stroke.Kind <> TBrushKind.None then
        FCurrent.Translate(Stroke.Thickness / 2, Stroke.Thickness / 2);
    end
    else
      FCurrent.Clear;
  end;
end;

{ TPathDataObjectAppearance }

procedure TPathDataObjectAppearance.AssignTo(ADest: TPersistent);
var
  DstDrawable: TPathDataItem;
  DstAppearance: TPathDataObjectAppearance;
begin
  if ADest is TPathDataObjectAppearance then
  begin
    DstAppearance := TPathDataObjectAppearance(ADest);
    DstAppearance.BeginUpdate;
    try
      DstAppearance.FWrapMode := FWrapMode;
      DstAppearance.FFill.Assign(FFill);
      DstAppearance.FStroke.Assign(FStroke);
      inherited AssignTo(ADest);
    finally
      DstAppearance.EndUpdate;
    end;
  end
  else if ADest is TPathDataItem then
  begin
    DstDrawable := TPathDataItem(ADest);
    DstDrawable.BeginUpdate;
    try
      DstDrawable.FWrapMode := FWrapMode;
      DstDrawable.FFill.Assign(FFill);
      DstDrawable.FStroke.Assign(FStroke);
      inherited AssignTo(ADest);
    finally
      DstDrawable.EndUpdate;
    end;
  end
  else
    inherited;


end;

constructor TPathDataObjectAppearance.Create;
begin
  inherited;
  FFill := TBrush.Create(TBrushKind.Solid, $FFE0E0E0);
  FFill.OnChanged := FillChanged;
  FStroke := TStrokeBrush.Create(TBrushKind.None, $00000000);
  FStroke.OnChanged := StrokeChanged;

end;

procedure TPathDataObjectAppearance.CreateObject(const AListViewItem
  : TListViewItem);
var
  LItem: TPathDataItem;
begin
  LItem := TPathDataItem.Create(AListViewItem);
  LItem.BeginUpdate;
  try
    LItem.Assign(Self);
    LItem.Name := Name;
  finally
    LItem.EndUpdate;
  end;

end;

destructor TPathDataObjectAppearance.Destroy;
begin
  FFill.Free;
  FStroke.Free;
  inherited;
end;

procedure TPathDataObjectAppearance.FillChanged(Sender: TObject);
begin
  DoChange;
end;

procedure TPathDataObjectAppearance.ResetObject(const AListViewItem
  : TListViewItem);
begin
  ResetObjectT<TPathDataItem>(AListViewItem);

end;

procedure TPathDataObjectAppearance.SetFill(const Value: TBrush);
begin
  FFill.Assign(Value);
end;

procedure TPathDataObjectAppearance.SetStroke(const Value: TStrokeBrush);
begin
  FStroke.Assign(Value);
end;

procedure TPathDataObjectAppearance.SetWrapMode(const Value: TPathWrapMode);
begin
  if FWrapMode <> Value then
  begin
    FWrapMode := Value;
    DoChange;
  end;
end;

procedure TPathDataObjectAppearance.StrokeChanged(Sender: TObject);
begin
  DoChange;
end;

end.
