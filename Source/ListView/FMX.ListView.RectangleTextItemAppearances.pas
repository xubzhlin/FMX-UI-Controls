unit FMX.ListView.RectangleTextItemAppearances;

interface

uses
  System.Classes, System.UITypes, FMX.Types, FMX.Graphics, FMX.ListView.Appearances,
  FMX.ListView.Types, FMX.ListView.RectangleItemAppearances;

type
  TRectangleTextItem = class(TRectangleItem)
  private
    FOwner:TListViewItem;
    FText:string;
    FTextColor:TAlphaColor;
    FFont:TFont;
    procedure SetText(const Value: String);
    procedure SetTextColor(const Value: TAlphaColor);
    procedure SetFont(const Value: TFont);
    procedure DoFontChang(Sender:TObject);
  public
    procedure Render(const Canvas: TCanvas; const DrawItemIndex: Integer;
      const DrawStates: TListItemDrawStates;
      const Resources: TListItemStyleResources;
      const Params: TListItemDrawable.TParams;
      const SubPassNo: Integer = 0); override;
    constructor Create(const AOwner: TListItem); override;
    destructor Destroy; override;
  published
    property Owner:TListViewItem read FOwner write FOwner;
    property Text:String read FText write SetText;
    property TextColor:TAlphaColor read FTextColor write SetTextColor;
    property Font:TFont read FFont write SetFont;
    property Fill;
    property Stroke;
    property Sides;
    property XRadius;
    property YRadius;
    property Corners;
    property CornerType;
    property IsShow;
  end;

  TRectangleTextObjectAppearance = class(TRectangleObjectAppearance)
  private
    FTextColor:TAlphaColor;
    FFont:TFont;
    procedure SetFont(const Value: TFont);
    procedure SetTextColor(const Value: TAlphaColor);
    procedure DoFontChange(Sender:TObject);
  protected
    procedure AssignTo(ADest: TPersistent); override;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure CreateObject(const AListViewItem: TListViewItem); override;
    procedure ResetObject(const AListViewItem: TListViewItem); override;
  published
    property TextColor:TAlphaColor read FTextColor write SetTextColor;
    property Font:TFont read FFont write SetFont;
    property Sides;
    property Fill;
    property Stroke;
    property XRadius;
    property YRadius;
    property Corners;
    property CornerType;
  end;
implementation

{ TRectangleTextItem }

constructor TRectangleTextItem.Create(const AOwner: TListItem);
begin
  inherited Create(AOwner);
  FOwner:=TListViewItem(AOwner);
  FText:='';
  FTextColor:=$FF000000;
  FFont:=TFont.Create;
  FFont.OnChanged:=DoFontChang;
end;

destructor TRectangleTextItem.Destroy;
begin
  FFont.Free;
  inherited;
end;

procedure TRectangleTextItem.DoFontChang(Sender: TObject);
begin
  Invalidate;
end;

procedure TRectangleTextItem.Render(const Canvas: TCanvas;
  const DrawItemIndex: Integer; const DrawStates: TListItemDrawStates;
  const Resources: TListItemStyleResources;
  const Params: TListItemDrawable.TParams; const SubPassNo: Integer);
begin
  if SubPassNo <> 0 then
    Exit;
  inherited;
  if FText<>'' then
  begin
    Canvas.Fill.Color := FTextColor;
    Canvas.Font.Assign(FFont);
    Canvas.FillText(LocalRect, FText, False, 1, [], TTextAlign.Center, TTextAlign.Center);
  end;
end;


procedure TRectangleTextItem.SetFont(const Value: TFont);
begin
  FFont.Assign(Value);
end;

procedure TRectangleTextItem.SetText(const Value: String);
begin
  if FText<>Value then
  begin
    FText := Value;
    Invalidate;
  end;
end;

procedure TRectangleTextItem.SetTextColor(const Value: TAlphaColor);
begin
  if FTextColor<>Value then
  begin
    FTextColor := Value;
    Invalidate;
  end;
end;

{ TRectangleTextObjectAppearance }

procedure TRectangleTextObjectAppearance.AssignTo(ADest: TPersistent);
var
  DstDrawable: TRectangleTextItem;
  DstAppearance: TRectangleTextObjectAppearance;
begin
  if ADest is TRectangleTextObjectAppearance then
  begin
    DstAppearance := TRectangleTextObjectAppearance(ADest);
    DstAppearance.BeginUpdate;
    try
      DstAppearance.FFont.Assign(FFont);
      DstAppearance.FTextColor:=FTextColor;
      inherited AssignTo(ADest);
    finally
      DstAppearance.EndUpdate;
    end;
  end
  else if ADest is TRectangleTextItem then
  begin
    DstDrawable := TRectangleTextItem(ADest);
    DstDrawable.BeginUpdate;
    try
      DstDrawable.FFont.Assign(FFont);
      DstDrawable.FTextColor:=FTextColor;
      inherited AssignTo(ADest);
    finally
      DstDrawable.EndUpdate;
    end;
  end
  else
    inherited;
end;

constructor TRectangleTextObjectAppearance.Create;
begin
  inherited Create;
  FFont:=TFont.Create;
  FFont.OnChanged:=DoFontChange;
  FTextColor:=$FF000000;
end;

procedure TRectangleTextObjectAppearance.CreateObject(
  const AListViewItem: TListViewItem);
var
  LItem: TRectangleTextItem;
begin
  LItem := TRectangleTextItem.Create(AListViewItem);
  LItem.BeginUpdate;
  try
    LItem.Assign(Self);
    LItem.Name := Name;
  finally
    LItem.EndUpdate;
  end;

end;

destructor TRectangleTextObjectAppearance.Destroy;
begin
  FFont.Free;
  inherited;
end;

procedure TRectangleTextObjectAppearance.DoFontChange(Sender: TObject);
begin
  DoChange;
end;

procedure TRectangleTextObjectAppearance.ResetObject(
  const AListViewItem: TListViewItem);
begin
  ResetObjectT<TRectangleItem>(AListViewItem);
end;

procedure TRectangleTextObjectAppearance.SetFont(const Value: TFont);
begin
  FFont.Assign(Value);
end;

procedure TRectangleTextObjectAppearance.SetTextColor(const Value: TAlphaColor);
begin
  if FTextColor<>Value then
  begin
    FTextColor := Value;
    DoChange;
  end;
end;

end.
