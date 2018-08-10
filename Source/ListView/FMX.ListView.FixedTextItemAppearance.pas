unit FMX.ListView.FixedTextItemAppearance;

interface

uses
  System.Types, System.Classes, System.UITypes, System.Math, FMX.ListView.Types, FMX.ListView.Appearances;

type
  TFixedTextItem = class(TListItemText)
    procedure CalculateLocalRect(const DestRect: TRectF; const SceneScale: Single;
      const DrawStates: TListItemDrawStates; const Item: TListItem); override;
  end;

  TFixedTextObjectAppearance = class(TTextObjectAppearance)
  protected
    procedure AssignTo(ADest: TPersistent); override;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure CreateObject(const AListViewItem: TListViewItem); override;
    procedure ResetObject(const AListViewItem: TListViewItem); override;
  end;

implementation

{ TFixedTextItem }

procedure TFixedTextItem.CalculateLocalRect(const DestRect: TRectF;
  const SceneScale: Single; const DrawStates: TListItemDrawStates;
  const Item: TListItem);
var
  NewRect: TRectF;
  DeadSpace: Single;
begin
  if TListItemDrawState.EditMode in DrawStates then
  begin
    NewRect := DestRect;

    if Item.Controller <> nil then
    begin
      DeadSpace := Item.Controller.GetItemEditOffset(Item) * Item.Controller.EditModeTransitionAlpha;
      NewRect.Left := NewRect.Left + DeadSpace;

      if IsDetailText then
        NewRect.Right := Max(NewRect.Right + DeadSpace, NewRect.Left);
    end;

    inherited CalculateLocalRect(DestRect, SceneScale, DrawStates, Item);
  end
  else
    inherited;
end;

{ TFixedTextObjectAppearance }

procedure TFixedTextObjectAppearance.AssignTo(ADest: TPersistent);
begin
  inherited AssignTo(ADest);
end;

constructor TFixedTextObjectAppearance.Create;
begin
  inherited;

end;

procedure TFixedTextObjectAppearance.CreateObject(
  const AListViewItem: TListViewItem);
var
  LItem: TFixedTextItem;
begin
  LItem := TFixedTextItem.Create(AListViewItem);
  LItem.BeginUpdate;
  try
    LItem.Assign(Self);
    LItem.Name := Name;
  finally
    LItem.EndUpdate;
  end;

end;

destructor TFixedTextObjectAppearance.Destroy;
begin

  inherited;
end;

procedure TFixedTextObjectAppearance.ResetObject(
  const AListViewItem: TListViewItem);
begin
  ResetObjectT<TFixedTextItem>(AListViewItem);;
end;

end.
