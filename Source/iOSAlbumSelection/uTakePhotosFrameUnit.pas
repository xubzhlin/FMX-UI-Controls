unit uTakePhotosFrameUnit;
//iOS 选取照片 界面

interface


uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.Layouts, FMX.ListView, FMX.Objects, FMX.Controls.Presentation,
  iOSapi.Photos.Manager;
type
  TListView = class(FMX.ListView.TListView)
  protected
    procedure ApplyStyle; override;
  end;

  TPhotoSuccessRetrue = procedure(BitMap:TBitMap) of object;


  TFTakePhotosFrame = class(TFrame)
    lstPhoto: TListView;
    ltyLeft: TLayout;
    txtTitle: TText;
    ltyRight: TLayout;
    btnBack: TSpeedButton;
    btnCancal: TSpeedButton;
    rectTop: TRectangle;
    procedure btnBackTap(Sender: TObject; const Point: TPointF);
    procedure btnCancalTap(Sender: TObject; const Point: TPointF);
    procedure lstPhotoItemClickEx(const Sender: TObject; ItemIndex: Integer;
      const LocalClickPos: TPointF; const ItemObject: TListItemDrawable);
    procedure lstPhotoResize(Sender: TObject);
  private
    { Private declarations }
    FPhotosManager:TiOSPhotosManager;
    FPhotoIndex:Integer; //点击的照片Index
    FOnPhotoRetrue:TPhotoSuccessRetrue;

    procedure CollectionCallBack(Sender:TObject);  //相册列表获取完成
    procedure PhontoCallBack(Sender:TObject);  //照片列表获取完成
    procedure HignQualityBack(Sender:TObject); //高清搞皮获取完成
    procedure PhotoChange(Sender:TObject);   //照片发生变化
  public
    { Public declarations }
    procedure ShowPhotos(AParent:TFmxObject; OnPhotoRetrue:TPhotoSuccessRetrue); //打开相册
    procedure HidePhotos;
    property OnPhotoRetrue:TPhotoSuccessRetrue read FOnPhotoRetrue write FOnPhotoRetrue;
  end;


procedure ShowPhotosFrame(AParent:TFmxObject; OnPhotoRetrue:TPhotoSuccessRetrue);

var
  GPhotosFrame:TFTakePhotosFrame;

implementation


uses FMX.ListView.Photos.Appearances.iOS;

{$R *.fmx}

procedure ShowPhotosFrame(AParent:TFmxObject; OnPhotoRetrue:TPhotoSuccessRetrue);
begin
  if GPhotosFrame = nil  then
    GPhotosFrame:=TFTakePhotosFrame.Create(nil);
  GPhotosFrame.ShowPhotos(AParent, OnPhotoRetrue);
end;

{ TFTakePhotosFrame }

procedure TFTakePhotosFrame.btnBackTap(Sender: TObject; const Point: TPointF);
var
  i:integer;
  Collection:TAssetCollectionCache;
  Item:TListViewItem;
begin
  lstPhoto.Items.Clear;
  lstPhoto.ItemAppearanceName:='ImageListItem';
  lstPhotoResize(Sender);
  lstPhoto.ItemAppearanceObjects.ItemObjects.Text.TextColor := $FFFFFFFF;
  lstPhoto.ItemAppearanceObjects.ItemObjects.Image.Height := 75;
  lstPhoto.ItemAppearanceObjects.ItemObjects.Image.Width := 75;
  for i := 0 to FPhotosManager.CollectionCacheList.Count - 1 do
  begin
    Collection:=FPhotosManager.CollectionCacheList[i];
    Item:=lstPhoto.Items.Add;
    Item.Text:=Collection.Title+'('+InttoStr(Collection.PhotoCount)+')';
    Item.Detail:=Collection.Identifier;
    Item.ButtonText:=Collection.Title;
    Item.Bitmap:=Collection.BitMap;
  end;
  txtTitle.Text:='相册';
  btnBack.Visible:=False;

end;

procedure TFTakePhotosFrame.btnCancalTap(Sender: TObject; const Point: TPointF);
begin
  //取消
  HidePhotos;
  if Assigned(FOnPhotoRetrue) then
    FOnPhotoRetrue(nil);
end;

procedure TFTakePhotosFrame.CollectionCallBack(Sender: TObject);
var
  i:integer;
  Collection:TAssetCollectionCache;
begin
  Collection:=nil;
  if (FPhotosManager.UserLibraryIndex <>-1) and (FPhotosManager.UserLibraryIndex > FPhotosManager.CollectionCacheList.Count -1 ) then
  begin
    //返回胶卷相册
    Collection:=FPhotosManager.CollectionCacheList[FPhotosManager.UserLibraryIndex];
  end
  else
  begin
    for i := 0 to FPhotosManager.CollectionCacheList.Count -1 do
    begin
      if FPhotosManager.CollectionCacheList[i].PhotoCount>0 then
      begin
        //返回第一个有照片的相册
        Collection:=FPhotosManager.CollectionCacheList[i];
        Break;
      end;
    end;
    if (Collection = nil) and (FPhotosManager.CollectionCacheList.Count>0) then
    begin
      //返回第一个相册
      Collection:=FPhotosManager.CollectionCacheList[0];
    end;
  end;
  if Collection<>nil then
  begin
    FPhotosManager.CureeCollectionIdentifier:=Collection.Identifier;
    txtTitle.Text:=Collection.Title + '('+InttoStr(Collection.PhotoCount)+')';
  end
  else
  begin
    TThread.Synchronize(nil, procedure
    begin
      Showmessage('没有相册!');
    end);
  end;

end;


procedure TFTakePhotosFrame.HidePhotos;
begin
  Parent:=nil;
  Hide;
  Visible:=False;
end;

procedure TFTakePhotosFrame.HignQualityBack(Sender: TObject);
begin
  if (Sender is TAssetPhotoCache) and (TAssetPhotoCache(Sender).Index = FPhotoIndex) then
  begin
    TThread.Synchronize(nil, procedure
    begin
      HidePhotos;
    end);
    //回调 高清图片
    if Assigned(FOnPhotoRetrue) then
      FOnPhotoRetrue(TAssetPhotoCache(Sender).HignQualityBitmap);
  end;
end;

procedure TFTakePhotosFrame.lstPhotoItemClickEx(const Sender: TObject;
  ItemIndex: Integer; const LocalClickPos: TPointF;
  const ItemObject: TListItemDrawable);
var
  Item:TListViewItem;

begin
  if ItemObject is TPhotoItem then
  begin
    //选择照片 获取 高清图像 返回结果
    //获取Index
    FPhotoIndex:=TPhotoItem(ItemObject).ImageIndex;

    if FPhotoIndex<0 then exit;
    if FPhotoIndex>FPhotosManager.PhotosCacheList.Count then exit;

    FPhotosManager.PhotosCacheList[FPhotoIndex].GetHignQualityBimap;
    //TPhotoItem(ItemObject).Selected := not TPhotoItem(ItemObject).Selected;
  end
  else if lstPhoto.ItemAppearanceName = 'ImageListItem' then
  begin
    //选择相册 加载相册照片
    if ItemIndex<0 then exit;
    if ItemIndex>lstPhoto.ItemCount - 1 then exit;
    
    Item:=lstPhoto.Items[ItemIndex];
    FPhotosManager.CureeCollectionIdentifier:=Item.Detail;
    txtTitle.Text:=Item.Text;
  end;
end;

procedure TFTakePhotosFrame.lstPhotoResize(Sender: TObject);
begin
  if lstPhoto.ItemAppearanceName = 'PhotoListItem' then
    lstPhoto.ItemAppearance.ItemHeight :=  Trunc((lstPhoto.Width - 24) / 5)
  else
    lstPhoto.ItemAppearance.ItemHeight := 80;
end;

procedure TFTakePhotosFrame.PhontoCallBack(Sender: TObject);
begin
  TThread.Synchronize(nil,
  procedure
  var
    i:integer;
    Item:TPhotoListItem;
    ItemAppearance:TPhotoListItemAppearance;
    AObjectIndex:Integer;
    BitMap:TBitMap;
  begin
    lstPhoto.Items.Clear;
    btnBack.Visible:=True;
    lstPhoto.ItemAppearanceName:='PhotoListItem';
    lstPhotoResize(Sender);
    if lstPhoto.ItemAppearanceObjects.ItemObjects is TPhotoListItemAppearance then
    begin
      ItemAppearance:= TPhotoListItemAppearance(lstPhoto.ItemAppearanceObjects.ItemObjects);
      for i := 0 to 4 do
      begin
        ItemAppearance.PhotoObjects[i].PhotoScalingMode:=TPhotoScalingMode.StretchWithFit;
//        ItemAppearance.PhotoObjects[i].SelecteBitMap:= Image1;
//        ItemAppearance.PhotoObjects[i].NormalBitMap:= Image2;
      end;
    end;
    AObjectIndex:=0;
    for i := 0 to FPhotosManager.PhotosCacheList.Count -1 do
    begin
      AObjectIndex := i mod 5;
      if AObjectIndex = 0 then
        Item:=TPhotoListItem(lstPhoto.Items.Add);
      Item.PhotoItems[AObjectIndex].Bitmap:=FPhotosManager.PhotosCacheList[i].BitMap;
      Item.PhotoItems[AObjectIndex].ImageIndex:=FPhotosManager.PhotosCacheList[i].Index;
    end;
    btnBack.Visible:=True;
  end);
end;

procedure TFTakePhotosFrame.PhotoChange(Sender: TObject);
begin
  TThread.Synchronize(nil,
  procedure
  var
    BitMap:TBitMap;
    Item:TPhotoListItem;
    ItemIndex, ObjectIndex:Integer;
  begin
    if Sender is TAssetPhotoCache then
    begin
      ItemIndex := TAssetPhotoCache(Sender).Index div 5;
      ObjectIndex := TAssetPhotoCache(Sender).Index mod 5;
      if ItemIndex<lstPhoto.ItemCount-1 then
      begin
        Item:=TPhotoListItem(lstPhoto.Items[ItemIndex]);
        Item.PhotoItems[ObjectIndex].Invalidate;
      end;
    end;
  end);
end;

procedure TFTakePhotosFrame.ShowPhotos(AParent:TFmxObject; OnPhotoRetrue:TPhotoSuccessRetrue);
begin
  Parent:=AParent;
  Align:=TAlignLayout.Contents;
  
  if FPhotosManager = nil then
  begin
    FPhotosManager:=TiOSPhotosManager.Create(TSize.Create(300, 300));
    FPhotosManager.OnCollectionSuccess:=CollectionCallBack;
    FPhotosManager.OnPhotoSuccess:=PhontoCallBack;
    FPhotosManager.OnPhotoChange:=PhotoChange;
    FPhotosManager.OnHignQualityBitMapSuccess:=HignQualityBack;
  end;
  FPhotoIndex:=-1;
  FPhotosManager.Init;
  FOnPhotoRetrue:=OnPhotoRetrue;
  Show;
  Visible:=True;
end;

{ TListView }

procedure TListView.ApplyStyle;
var
  StyleObject: TFmxObject;
begin
  StyleObject := Self.FindStyleResource('frame');
  if StyleObject is TColorObject then
    TColorObject(StyleObject).Color := $FF2F2D30;

  StyleObject := Self.FindStyleResource('background');
  if StyleObject is TColorObject then
    TColorObject(StyleObject).Color := $FF2F2D30;
  StyleObject := Self.FindStyleResource('itembackground');
  if StyleObject is TColorObject then
    TColorObject(StyleObject).Color := $FF2F2D30;
  inherited;
end;

initialization

finalization
  FreeAndNil(GPhotosFrame);

end.
