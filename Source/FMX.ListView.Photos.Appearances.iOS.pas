unit FMX.ListView.Photos.Appearances.iOS;
//iOS 照片选择样式

interface

uses
  System.Classes, System.SysUtils, FMX.Types, FMX.Controls, System.UITypes,
  FMX.Objects, FMX.ListView, FMX.Graphics, System.Types, System.Rtti,
  FMX.ListView.Types, FMX.ListView.Appearances, System.Generics.Collections,
  System.Math, System.Math.Vectors;

type
  TPhotoListItemAppearanceNames = class
  public const
    ListItem = 'PhotoListItem';
    PhotoItem1 = 'PhotoItem1';
    PhotoItem2 = 'PhotoItem2';
    PhotoItem3 = 'PhotoItem3';
    PhotoItem4 = 'PhotoItem4';
    PhotoItem5 = 'PhotoItem5';
    PhotoItem6 = 'PhotoItem6';
    PhotoItem7 = 'PhotoItem7';
  end;
  TPhotoScalingMode = (StretchWithAspect, Original, Stretch, StretchWithFit);
  TPhotoItem = class(TListItemImage)
  private
    FNormalBitMap:TBitMap;
    FSelecteBitMap:TBitMap;
    FSelected:Boolean;
    FPhotoScalingMode:TPhotoScalingMode;
    procedure SetSelected(const Value: Boolean);
    procedure SetNormalBitMap(const Value: TBitMap);
    procedure SetSelecteBitMap(const Value: TBitMap);
    procedure SetPhotoScalingMode(const Value: TPhotoScalingMode);
    procedure FitInto(const ABitmap: TBitmap; var InputRect, DestinationRect: TRectF);
  protected
    procedure Render(const Canvas: TCanvas; const DrawItemIndex: Integer;
      const DrawStates: TListItemDrawStates;
      const Resources: TListItemStyleResources;
      const Params: TListItemDrawable.TParams;
      const SubPassNo: Integer = 0); override;
  public
    constructor Create(const AOwner: TListItem); override;
    destructor Destroy; override;
    property Selected:Boolean read FSelected write SetSelected;
    property NormalBitMap:TBitMap read FNormalBitMap write SetNormalBitMap;
    property SelecteBitMap:TBitMap read FSelecteBitMap write SetSelecteBitMap;
    property PhotoScalingMode:TPhotoScalingMode read FPhotoScalingMode write SetPhotoScalingMode;
  end;

  TPhotoObjectAppearance = class(TImageObjectAppearance)
  private type
    TNotify = class(TComponent)
    private
      FOwner: TPhotoObjectAppearance;
    protected
      procedure Notification(AComponent: TComponent;
        Operation: TOperation); override;
    end;
  private
    FNormalBitMap:TImage;
    FNormalNotify:TNotify;
    FSelecteBitMap:TImage;
    FSelecteNotify:TNotify;
    FPhotoScalingMode:TPhotoScalingMode;
    procedure SetNormalBitMap(const Value: TImage);
    procedure SetSelecteBitMap(const Value: TImage);
    procedure SetPhotoScalingMode(const Value: TPhotoScalingMode);
  protected
    procedure AssignTo(ADest: TPersistent); override;
  public
    procedure CreateObject(const AListViewItem: TListViewItem); override;
  published
    property NormalBitMap:TImage read FNormalBitMap write SetNormalBitMap;
    property SelecteBitMap:TImage read FSelecteBitMap write SetSelecteBitMap;
    property PhotoScalingMode:TPhotoScalingMode read FPhotoScalingMode write SetPhotoScalingMode;
    // Common
    property Width;
    property Height;
    property Align;
    property VertAlign;
    property Visible;
    property PlaceOffset;
    property Opacity;
  end;

  TPhotoListItemAppearance = class(TPresetItemObjects)
  public const
    cDefaultHeight = 40;
  private
    FPhotoObject1:TPhotoObjectAppearance;
    FPhotoObject2:TPhotoObjectAppearance;
    FPhotoObject3:TPhotoObjectAppearance;
    FPhotoObject4:TPhotoObjectAppearance;
    FPhotoObject5:TPhotoObjectAppearance;
    function DoCreatePhotoObject(AName:string):TPhotoObjectAppearance;
    function GetPhotoObject(index: integer): TPhotoObjectAppearance;
  protected
    function DefaultHeight: Integer; override;
    procedure UpdateSizes(const ItemSize: TSizeF); override;
    function GetGroupClass: TPresetItemObjects.TGroupClass; override;
    procedure SetObjectData(const AListViewItem: TListViewItem;
      const AIndex: string; const AValue: TValue;
      var AHandled: Boolean); override;
  public
    constructor Create(const Owner: TControl); override;
    destructor Destroy; override;
    property PhotoObjects[index:integer]:TPhotoObjectAppearance read GetPhotoObject;
  end;

  TPhotoListItem = class(TListViewItem)
  private
    function GetPhotoItems(index: integer): TPhotoItem;
  public
    property PhotoItems[index:integer]:TPhotoItem read GetPhotoItems;
  end;

implementation


{ TPhotoItem }

constructor TPhotoItem.Create(const AOwner: TListItem);
begin
  inherited;
  FSelected:=False;
end;

destructor TPhotoItem.Destroy;
begin
  inherited;
end;


procedure TPhotoItem.FitInto(const ABitmap: TBitmap; var InputRect,
  DestinationRect: TRectF);
  procedure ClipRects(var InpRect, DestRect: TRectF; const LocalRect: TRectF);
  var
    Delta: Single;
  begin
    if DestRect.Right > LocalRect.Right then
    begin
      Delta := 1 - ((DestRect.Right - LocalRect.Right) / DestRect.Width);

      InpRect.Right := InpRect.Left + InpRect.Width * Delta;
      DestRect.Right := LocalRect.Right;
    end;

    if DestRect.Bottom > LocalRect.Bottom then
    begin
      Delta := 1 - ((DestRect.Bottom - LocalRect.Bottom) / DestRect.Height);

      InpRect.Bottom := InpRect.Top + InpRect.Height * Delta;
      DestRect.Bottom := LocalRect.Bottom;
    end;
  end;

var
  LocRect, InpRect, DestRect: TRectF;
  Aspect: Single;
  XAspect, YAspect: Single;
begin
  LocRect := LocalRect;
  LocRect.Inflate(-2, -2);
  if SrcRect.Width < 1 then
  begin
    InpRect.Left := 0;
    InpRect.Right := Bitmap.Width;
  end
  else
  begin
    InpRect.Left := SrcRect.Left;
    InpRect.Right := SrcRect.Right;
  end;

  if SrcRect.Height < 1 then
  begin
    InpRect.Top := 0;
    InpRect.Bottom := Bitmap.Height;
  end
  else
  begin
    InpRect.Top := SrcRect.Top;
    InpRect.Bottom := SrcRect.Bottom;
  end;

  case FPhotoScalingMode of
    TPhotoScalingMode.Original:
      begin
        DestRect.Left := LocRect.Left;
        DestRect.Top := LocRect.Top;
        DestRect.Right := DestRect.Left + InpRect.Width;
        DestRect.Bottom := DestRect.Top + InpRect.Height;

        ClipRects(InpRect, DestRect, LocRect);

        // Center image
        DestRect.Offset((LocRect.Right - DestRect.Right) / 2, (LocRect.Bottom - DestRect.Bottom) / 2);
      end;

    TPhotoScalingMode.Stretch:
      DestRect := LocRect;

    TPhotoScalingMode.StretchWithAspect:
    begin
      // Calc ratios
      if InpRect.Width > 0 then
        XAspect := LocRect.Width / InpRect.Width
      else
        XAspect := 1;

      if InpRect.Height > 0 then
        YAspect := LocRect.Height / InpRect.Height
      else
        YAspect := 1;

      // Use smallest ratio
      if YAspect < XAspect then
        Aspect := YAspect
      else
        Aspect := XAspect;

      DestRect := LocRect;
      DestRect.Right := DestRect.Left + InpRect.Width * Aspect;
      DestRect.Bottom := DestRect.Top + InpRect.Height * Aspect;
      // Center image
      DestRect.Offset((LocRect.Right - DestRect.Right) / 2, (LocRect.Bottom - DestRect.Bottom) / 2);
    end;
    TPhotoScalingMode.StretchWithFit:
    begin
      //不失真平铺图形  截取图片中间部分
      // Calc ratios
      if InpRect.Width > 0 then
        XAspect := LocRect.Width / InpRect.Width
      else
        XAspect := 1;

      if InpRect.Height > 0 then
        YAspect := LocRect.Height / InpRect.Height
      else
        YAspect := 1;

      // Use smallest ratio
      if YAspect > XAspect then
        Aspect := YAspect
      else
        Aspect := XAspect;

      DestRect := LocRect;
      // Center image
      InpRect.Inflate(-(InpRect.Width - LocRect.Width / Aspect) /2, -(InpRect.Height - LocRect.Height / Aspect) /2);
    end;
  end;

  InputRect := InpRect;
  DestinationRect := DestRect;

end;

procedure TPhotoItem.Render(const Canvas: TCanvas; const DrawItemIndex: Integer;
  const DrawStates: TListItemDrawStates;
  const Resources: TListItemStyleResources;
  const Params: TListItemDrawable.TParams; const SubPassNo: Integer);
var
  ABitmap: TBitmap;
  InpRect, DestRect: TRectF;
begin
  if SubPassNo <> 0 then
    Exit;

{$IFDEF DRAW_ITEM_MARGINS}
  MarginBrush.Color := $50808000;
  Canvas.FillRect(LocalRect, 0, 0, AllCorners, 1, MarginBrush);
{$ENDIF}

  ABitmap := nil;
  if (ImageSource = TImageSource.ImageList) and (Params.Images <> nil) then
    ABitmap := Params.Images.Bitmap(TPointF(LocalRect.Size) * Canvas.Scale, ImageIndex)
  else
    ABitmap := BitMap;

  if ABitmap = nil then
    Exit;

  FitInto(ABitmap, InpRect, DestRect);

  DestRect.Inflate(-2, -2);

  Canvas.DrawBitmap(ABitmap, InpRect, DestRect, Params.AbsoluteOpacity);
  //绘制 勾选状态
  if not FSelected then
    ABitmap:=FNormalBitMap
  else
    ABitmap:=FSelecteBitMap;
  if ABitmap = nil then exit;

  InpRect:=TRectF.Create(0, 0, ABitmap.Width, ABitmap.Height);
  DestRect :=TRectF.Create(DestRect.Right - InpRect.Width  / Canvas.Scale, DestRect.Top, LocalRect.Right, LocalRect.Top + ABitmap.Height /Canvas.Scale);
  Canvas.DrawBitmap(ABitmap, InpRect, DestRect, 1, True);
end;


procedure TPhotoItem.SetNormalBitMap(const Value: TBitMap);
begin
  FNormalBitMap := Value;
  Invalidate;
end;

procedure TPhotoItem.SetPhotoScalingMode(const Value: TPhotoScalingMode);
begin
  if FPhotoScalingMode <> Value then
  begin
    FPhotoScalingMode := Value;
    Invalidate;
  end;
end;

procedure TPhotoItem.SetSelecteBitMap(const Value: TBitMap);
begin
  FSelecteBitMap := Value;
  Invalidate;
end;

procedure TPhotoItem.SetSelected(const Value: Boolean);
begin
  if Value <> FSelected then
  begin
    FSelected := Value;
    Invalidate;
  end;
end;

{ TPhotoObjectAppearance }

procedure TPhotoObjectAppearance.AssignTo(ADest: TPersistent);
var
  DstDrawable: TPhotoItem;
  DstAppearance: TPhotoObjectAppearance;
begin
  if ADest is TPhotoObjectAppearance then
  begin
    DstAppearance := TPhotoObjectAppearance(ADest);
    DstAppearance.BeginUpdate;
    try
      DstAppearance.FNormalBitMap := Self.FNormalBitMap;
      DstAppearance.FSelecteBitMap := Self.FSelecteBitMap;
      DstAppearance.FPhotoScalingMode:=Self.FPhotoScalingMode;
      inherited AssignTo(ADest);
    finally
      DstAppearance.EndUpdate;
    end;
  end
  else if ADest is TPhotoItem then
  begin
    DstDrawable := TPhotoItem(ADest);
    DstDrawable.BeginUpdate;
    try
      if Self.FNormalNotify <> nil then
        DstDrawable.FNormalBitMap := FNormalBitMap.BitMap
      else
        DstDrawable.FNormalBitMap := nil;

      if Self.FSelecteBitMap <> nil then
        DstDrawable.SelecteBitMap := FSelecteBitMap.BitMap
      else
        DstDrawable.SelecteBitMap := nil;
      DstDrawable.PhotoScalingMode:=FPhotoScalingMode;
      inherited AssignTo(ADest);
    finally
      DstDrawable.EndUpdate;
    end;
  end
  else
    inherited;

end;

procedure TPhotoObjectAppearance.CreateObject(
  const AListViewItem: TListViewItem);
var
  LItem: TPhotoItem;
begin
  LItem := TPhotoItem.Create(AListViewItem);
  LItem.BeginUpdate;
  try
    LItem.Name := Name;
    LItem.Assign(Self);
  finally
    LItem.EndUpdate;
  end;

end;

procedure TPhotoObjectAppearance.SetNormalBitMap(const Value: TImage);
begin
  if FNormalBitMap <> Value then
  begin
    if FNormalNotify = nil then
    begin
      FNormalNotify := TNotify.Create(nil);
      FNormalNotify.FOwner := Self;
    end;
    if FNormalBitMap <> nil then
      FNormalBitMap.RemoveFreeNotification(FNormalNotify);
    FNormalBitMap := Value;
    if FNormalBitMap <> nil then
      FNormalBitMap.FreeNotification(FNormalNotify);
  end;
end;

procedure TPhotoObjectAppearance.SetPhotoScalingMode(
  const Value: TPhotoScalingMode);
begin
  if FPhotoScalingMode <> Value then
  begin
    FPhotoScalingMode := Value;
    DoChange;
  end;
end;

procedure TPhotoObjectAppearance.SetSelecteBitMap(const Value: TImage);
begin
  if FSelecteBitMap <> Value then
  begin
    if FSelecteNotify = nil then
    begin
      FSelecteNotify := TNotify.Create(nil);
      FSelecteNotify.FOwner := Self;
    end;
    if FSelecteBitMap <> nil then
      FSelecteBitMap.RemoveFreeNotification(FSelecteNotify);
    FSelecteBitMap := Value;
    if FSelecteBitMap <> nil then
      FSelecteBitMap.FreeNotification(FSelecteNotify);
  end;
end;

{ TPhotoListItemAppearance }

constructor TPhotoListItemAppearance.Create(const Owner: TControl);
begin
  inherited;
  FPhotoObject1:=DoCreatePhotoObject(TPhotoListItemAppearanceNames.PhotoItem1);
  FPhotoObject2:=DoCreatePhotoObject(TPhotoListItemAppearanceNames.PhotoItem2);
  FPhotoObject3:=DoCreatePhotoObject(TPhotoListItemAppearanceNames.PhotoItem3);
  FPhotoObject4:=DoCreatePhotoObject(TPhotoListItemAppearanceNames.PhotoItem4);
  FPhotoObject5:=DoCreatePhotoObject(TPhotoListItemAppearanceNames.PhotoItem5);

  AddObject(FPhotoObject1, True);
  AddObject(FPhotoObject2, True);
  AddObject(FPhotoObject3, True);
  AddObject(FPhotoObject4, True);
  AddObject(FPhotoObject5, True);
end;

function TPhotoListItemAppearance.DefaultHeight: Integer;
begin
  Result:=cDefaultHeight;
end;

destructor TPhotoListItemAppearance.Destroy;
begin
  FPhotoObject1.Free;
  FPhotoObject2.Free;
  FPhotoObject3.Free;
  FPhotoObject4.Free;
  FPhotoObject5.Free;
  inherited;
end;

function TPhotoListItemAppearance.DoCreatePhotoObject(
  AName: string): TPhotoObjectAppearance;
begin
  Result:=TPhotoObjectAppearance.Create;
  Result.Owner := Self;
  Result.Visible := True;
  Result.Name := AName;
  Result.Height:=0;
  Result.PhotoScalingMode:=TPhotoScalingMode.StretchWithFit;
  Result.DataMembers := TObjectAppearance.TDataMembers.Create
    (TObjectAppearance.TDataMember.Create(AName, Format('Data["%s"]',
    [AName])));
end;

function TPhotoListItemAppearance.GetGroupClass: TPresetItemObjects.TGroupClass;
begin
  Result:=TPhotoListItemAppearance;
end;

function TPhotoListItemAppearance.GetPhotoObject(
  index: integer): TPhotoObjectAppearance;
begin
  Result:=nil;
  case index of
    0:Result:=FPhotoObject1;
    1:Result:=FPhotoObject2;
    2:Result:=FPhotoObject3;
    3:Result:=FPhotoObject4;
    4:Result:=FPhotoObject5;
  end;
end;

procedure TPhotoListItemAppearance.SetObjectData(
  const AListViewItem: TListViewItem; const AIndex: string;
  const AValue: TValue; var AHandled: Boolean);
begin
  inherited;

end;

procedure TPhotoListItemAppearance.UpdateSizes(const ItemSize: TSizeF);
var
  AWidth, Offset: Single;
begin
  try
    BeginUpdate;
    AWidth:=ItemSize.Width / 5;
    FPhotoObject1.Width:=AWidth;
    FPhotoObject2.Width:=AWidth;
    FPhotoObject3.Width:=AWidth;
    FPhotoObject4.Width:=AWidth;
    FPhotoObject5.Width:=AWidth;
    Offset := 0 ;
    FPhotoObject1.PlaceOffset.X := Offset;
    Offset:=Offset+AWidth;
    FPhotoObject2.PlaceOffset.X := Offset;
    Offset:=Offset+AWidth;
    FPhotoObject3.PlaceOffset.X := Offset;
    Offset:=Offset+AWidth;
    FPhotoObject4.PlaceOffset.X := Offset;
    Offset:=Offset+AWidth;
    FPhotoObject5.PlaceOffset.X := Offset;
    inherited;
  finally
    EndUpdate;
  end;

end;

const
  sThisUnit = 'FMX.ListView.Photos.Appearances.iOS';

{ TPhotoObjectAppearance.TNotify }

procedure TPhotoObjectAppearance.TNotify.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if Operation = TOperation.opRemove then
  begin
    if AComponent = FOwner.NormalBitMap then
      FOwner.NormalBitMap := nil;
    if AComponent = FOwner.SelecteBitMap then
      FOwner.SelecteBitMap := nil;
  end;
end;

{ TPhotoListItem }

function TPhotoListItem.GetPhotoItems(index: integer): TPhotoItem;
begin
  Result:=nil;
  case index of
    0:Result := TPhotoItem(Objects.FindDrawable(TPhotoListItemAppearanceNames.PhotoItem1));
    1:Result := TPhotoItem(Objects.FindDrawable(TPhotoListItemAppearanceNames.PhotoItem2));
    2:Result := TPhotoItem(Objects.FindDrawable(TPhotoListItemAppearanceNames.PhotoItem3));
    3:Result := TPhotoItem(Objects.FindDrawable(TPhotoListItemAppearanceNames.PhotoItem4));
    4:Result := TPhotoItem(Objects.FindDrawable(TPhotoListItemAppearanceNames.PhotoItem5));
  end;
end;


initialization

TAppearancesRegistry.RegisterAppearance(TPhotoListItemAppearance,
  TPhotoListItemAppearanceNames.ListItem, [TRegisterAppearanceOption.Item],
  sThisUnit);

finalization

TAppearancesRegistry.UnregisterAppearances
  (TArray<TItemAppearanceObjectsClass>.Create(TPhotoListItemAppearance));

end.
