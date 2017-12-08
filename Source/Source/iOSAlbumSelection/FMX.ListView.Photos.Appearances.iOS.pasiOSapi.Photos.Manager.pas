unit iOSapi.Photos.Manager;
// iOS 相册 缓存 单元
// 缓存 用户相册目录 与 最近展示的照片

interface

uses System.Classes, FMX.Graphics, iOSapi.Photos, Macapi.Helpers,
  Macapi.ObjectiveC,
  iOSapi.Foundation, iOSapi.CoreGraphics, iOSapi.UIKit, FMX.Helpers.iOS,
  System.Types, System.SysUtils, System.Generics.Collections, System.Math;


type
  TCustomCache = class(TObject)
  private
    FBitMap: TBitMap;
    FOnBitMapResultHandler: TNotifyEvent;
    FOnBitMapChange: TNotifyEvent;
  public
    constructor Create(OnBitMapResultHandler, OnBitMapChange: TNotifyEvent);
    property BitMap: TBitMap read FBitMap;
  end;

  // iOS相册资源类
  TAssetCollectionCache = class(TCustomCache)
  private
    FTitle: string; // 名称
    FIdentifier: string; // 识别码
    FPhotoCount: Integer;
    procedure DoGetBitMap(Collection: PHAssetCollection);
    procedure DoBitMapResultHandler(param1: UIImage; param2: NSDictionary);
  public
    constructor Create(OnBitMapResultHandler, OnBitMapChange: TNotifyEvent);
    procedure Init(Collection: PHAssetCollection);
    destructor Destroy; override;
    property Title: string read FTitle;
    property Identifier: string read FIdentifier;
    property PhotoCount:Integer read FPhotoCount;
  end;

  // iOS照片资源类
  TAssetPhotoCache = class(TCustomCache)
  private
    FIndex:Integer;
    FAsset: PHAsset;
    procedure DoBitMapResultHandler(param1: UIImage; param2: NSDictionary);
    procedure DoBitMapChange;
  private
    FHignQualityBitmap: TBitMap;
    FIsHignQuality: Boolean;
    FOnGetHignQualityBitMapSuccess: TNotifyEvent;
    procedure DoGetHignQualityBitmapResultHandler(param1: NSData;
      param2: NSString; param3: UIImageOrientation; param4: NSDictionary);
    procedure DoGetHignQualitySuccess;
    procedure DoGetBitMap;
  public
    constructor Create(Asset: PHAsset; OnBitMapResultHandler, OnGetHignQualityBitMapSuccess, OnBitMapChange: TNotifyEvent);
    procedure Init;
    destructor Destroy; override;
    procedure GetHignQualityBimap;
    property BitMap: TBitMap read FBitMap;
    property HignQualityBitmap: TBitMap read FHignQualityBitmap;
    property Index:Integer read FIndex;
  end;

  // iOS 照片管理类
  // 用于管理相册
  // 最近展示相册照片
  TiOSPhotosManager = class(TObject)
  private
    function StrToNSArray(AStr: String): NSArray;
  private
    // 相册 资产集合
    FUserLibraryIndex:Integer;  //胶卷相机 索引
    FCollectionSuccessCount:Integer;
    FCollectionCount:Integer;
    FCollectionCacheList: TObjectList<TAssetCollectionCache>; // 相册列表
    FOnCollectionSuccess: TNotifyEvent; // 相册回调
    procedure DoClearCollections;
    procedure DoInit;
    procedure DoGetCollections; // 获取相册列表
    procedure CollectionsHandler(param1: PHAuthorizationStatus); // 权限回调
    procedure CollectionsBlock(param1: ObjectType; param2: NSUInteger; param3: PBoolean);
    procedure DoGetCollectionsSuccess;
    procedure DoCollectionHandler(Sender: TObject);
  private
    // 照片 资产集合
    FPhotoSuccessCount:Integer;
    FPhotoCount:Integer;
    FPhotosCacheList: TObjectList<TAssetPhotoCache>;
    FCureeCollectionIdentifier: string; // 当前线程标识
    FOnPhotoSuccess: TNotifyEvent; // 相册回调
    FOnHignQualityBitMapSuccess: TNotifyEvent; //高清图片回调
    FOnPhotoChange:TNotifyEvent;
    procedure DoClearPhotos;
    procedure DoGetPhotos;
    procedure PhotosBlock(param1: ObjectType; param2: NSUInteger; param3: PBoolean);
    procedure DoPhotosSuccess;
    procedure DoGetPhotosHandler(Sender: TObject); // 获取当前相册照片
    procedure DoPhotoChange(Sender:TObject);
    procedure DoHignQualityPhotoChange(Sender:TObject);
    procedure SetCureeCollectionIdentifier(const Value: string);
  public
    constructor Create(ThumbnailSize:TSize);
    procedure Init;
    destructor Destroy; override;
    property OnCollectionSuccess: TNotifyEvent read FOnCollectionSuccess
      write FOnCollectionSuccess;
    property OnPhotoSuccess: TNotifyEvent read FOnPhotoSuccess
      write FOnPhotoSuccess;
    property OnHignQualityBitMapSuccess:TNotifyEvent read FOnHignQualityBitMapSuccess write FOnHignQualityBitMapSuccess;
    property OnPhotoChange:TNotifyEvent read FOnPhotoChange write FOnPhotoChange;
    property CureeCollectionIdentifier: string read FCureeCollectionIdentifier
      write SetCureeCollectionIdentifier;
    property CollectionCacheList: TObjectList<TAssetCollectionCache>
      read FCollectionCacheList;
    property PhotosCacheList: TObjectList<TAssetPhotoCache>
      read FPhotosCacheList;
    property UserLibraryIndex:Integer read FUserLibraryIndex;
  end;


implementation

var
  ThumbnailPhotoSize: TSize; // 图片 大小

{ TAssetCollectionCache }

constructor TAssetCollectionCache.Create(OnBitMapResultHandler, OnBitMapChange: TNotifyEvent);
begin
  inherited Create(OnBitMapResultHandler, OnBitMapChange);
end;

destructor TAssetCollectionCache.Destroy;
begin
  FreeAndNil(FBitMap);
  inherited;
end;

procedure TAssetCollectionCache.DoBitMapResultHandler(param1: UIImage;
  param2: NSDictionary);
var
  ABitMap:TBitMap;
  IsResult:Boolean;
begin
  if param1 <> nil then
  begin
    IsResult:= FBitMap<>nil;
    if not IsResult then
    begin
      FBitMap := UIImageToBitmap(param1, 0, TSize.Create(trunc(param1.size.Width),
        trunc(param1.size.Height)));
      if Assigned(FOnBitMapResultHandler) then
        FOnBitMapResultHandler(Self);
    end
    else
    begin
      //图片发生变化
      ABitMap := UIImageToBitmap(param1, 0, TSize.Create(trunc(param1.size.Width),
        trunc(param1.size.Height)));
      FBitMap.SetSize(ABitMap.Width, ABitMap.Height);
      FBitMap.CopyFromBitmap(ABitMap);
      FreeAndNil(ABitMap);
      if Assigned(FOnBitMapChange) then
        FOnBitMapChange(Self);
    end;
  end;

end;

procedure TAssetCollectionCache.DoGetBitMap(Collection: PHAssetCollection);
var
  Asset: PHAsset;
  Ret: PHFetchResult;
  Option: PHImageRequestOptions;
  size: CGSize;
begin
  Ret := TPHAsset.OCClass.fetchAssetsInAssetCollection(Collection, nil);
  FPhotoCount := Ret.count;
  if FPhotoCount > 0 then
  begin
    Asset := TPHAsset.Wrap(Ret.firstObject);
    Option := TPHImageRequestOptions.Wrap(TPHImageRequestOptions.OCClass.alloc);
    Option.setResizeMode(PHImageRequestOptionsResizeModeFast);
    Option.setNetworkAccessAllowed(True);
    size.Width := ThumbnailPhotoSize.cx;
    size.Height := ThumbnailPhotoSize.cy;
    TPHCachingImageManager.OCClass.defaultManager.requestImageForAsset(Asset,
      size, PHImageContentModeAspectFill, Option, DoBitMapResultHandler);
  end
  else
  begin
    //没有照片获取
    if Assigned(FOnBitMapResultHandler) then
      FOnBitMapResultHandler(Self);
  end;
end;

procedure TAssetCollectionCache.Init(Collection: PHAssetCollection);
begin
  FTitle := NSStrToStr(Collection.localizedTitle);
  FIdentifier := NSStrToStr(Collection.localIdentifier);
  DoGetBitMap(Collection);
end;

{ TiOSPhotosManager }

procedure TiOSPhotosManager.DoGetCollections;
var
  ret: PHFetchResult;
begin
  FCollectionCacheList.Clear;
  FCollectionCount:=0;
  FCollectionSuccessCount:=0;
  ret := TPHAssetCollection.OCClass.fetchAssetCollectionsWithType
    (PHAssetCollectionTypeSmartAlbum,
    PHAssetCollectionSubtypeAlbumRegular, nil);
  FCollectionCount := ret.count;
  if FCollectionCount>0 then
    ret.enumerateObjectsUsingBlock(CollectionsBlock)
  else
  begin
    DoGetCollectionsSuccess;
  end;
end;

procedure TiOSPhotosManager.DoGetCollectionsSuccess;
begin
  if Assigned(FOnCollectionSuccess) then
    FOnCollectionSuccess(Self);
end;

procedure TiOSPhotosManager.DoGetPhotos;
var
  ret: PHFetchResult;
  Collection: PHAssetCollection;
begin
  DoClearPhotos;
  FUserLibraryIndex:=-1;
  FPhotoSuccessCount:=0;
  FPhotoCount:=0;
  if FCureeCollectionIdentifier <> '' then
  begin
    ret := TPHAssetCollection.OCClass.fetchAssetCollectionsWithLocalIdentifiers
      (StrToNSArray(FCureeCollectionIdentifier), nil);

    if ret.count > 0 then
    begin
      Collection := TPHAssetCollection.Wrap(Ret.firstObject);
      ret := TPHAsset.OCClass.fetchAssetsInAssetCollection(Collection, nil);
      FPhotoCount:=ret.count;
      if FPhotoCount>0 then
        ret.enumerateObjectsUsingBlock(PhotosBlock)
      else
      begin
        DoPhotosSuccess;
      end;
    end
    else
    begin
      //照片加载完毕
      DoPhotosSuccess;
    end;
  end
  else
    DoPhotosSuccess;
end;

procedure TiOSPhotosManager.PhotosBlock(param1: ObjectType; param2: NSUInteger;
  param3: PBoolean);
var
  Asset: PHAsset;
  AssetPhoto: TAssetPhotoCache;
begin
  Asset := TPHAsset.Wrap(param1);
  AssetPhoto := TAssetPhotoCache.Create(Asset, DoGetPhotosHandler, DoHignQualityPhotoChange, DoPhotoChange);
  AssetPhoto.FIndex:= FPhotosCacheList.Count;
  FPhotosCacheList.Add(AssetPhoto);
  AssetPhoto.Init;
end;

procedure TiOSPhotosManager.DoGetPhotosHandler(Sender: TObject);
begin
  if Sender is TAssetPhotoCache then
  begin
    inc(FPhotoSuccessCount);
    if FPhotoCount = FPhotoSuccessCount then
    begin
      //相册数据加载完毕
      DoPhotosSuccess;
    end;
  end;
end;

procedure TiOSPhotosManager.DoHignQualityPhotoChange(Sender: TObject);
begin
  if Assigned(FOnHignQualityBitMapSuccess) then
    FOnHignQualityBitMapSuccess(Sender);
end;

procedure TiOSPhotosManager.CollectionsBlock(param1: ObjectType;
  param2: NSUInteger; param3: PBoolean);
var
  Collection: PHAssetCollection;
  AssetCollection: TAssetCollectionCache;
begin
  Collection := TPHAssetCollection.Wrap(param1);
  AssetCollection := TAssetCollectionCache.Create(DoCollectionHandler, DoPhotoChange);
  FCollectionCacheList.Add(AssetCollection);
  if Collection.assetCollectionSubtype = PHAssetCollectionSubtypeSmartAlbumUserLibrary then
    FUserLibraryIndex:= FCollectionCacheList.Count;
  AssetCollection.Init(Collection);
end;

constructor TiOSPhotosManager.Create(ThumbnailSize:TSize);
begin
  inherited Create;
  ThumbnailPhotoSize := ThumbnailSize;
  FCollectionCacheList := TObjectList<TAssetCollectionCache>.Create;
  FPhotosCacheList := TObjectList<TAssetPhotoCache>.Create;
  // 初始化 获取 相册列表
end;

destructor TiOSPhotosManager.Destroy;
begin
  DoClearCollections;
  FCollectionCacheList.Free;
  DoClearPhotos;
  FPhotosCacheList.Free;
  inherited;
end;

procedure TiOSPhotosManager.DoClearCollections;
var
  i:integer;
begin
  for i := 0 to FCollectionCacheList.count -1 do
    FCollectionCacheList[i].Free;
  FCollectionCacheList.Clear;
end;

procedure TiOSPhotosManager.DoClearPhotos;
var
  i:integer;
begin
  for i := 0 to FPhotosCacheList.count -1 do
    FPhotosCacheList[i].Free;
  FPhotosCacheList.Clear;
end;

procedure TiOSPhotosManager.DoCollectionHandler(Sender: TObject);

begin
  if Sender is TAssetCollectionCache then
  begin
    inc(FCollectionSuccessCount);
    if FCollectionCount = FCollectionSuccessCount then
    begin
      //相册数据加载完毕
      DoGetCollectionsSuccess;
    end;
  end;
end;

procedure TiOSPhotosManager.DoInit;
var
  Status: PHAuthorizationStatus;
begin
  Status := TPHPhotoLibrary.OCClass.authorizationStatus;
  case Status of
    PHAuthorizationStatusDenied, PHAuthorizationStatusRestricted:
      DoGetCollectionsSuccess;   //没有权限 直接返回
    PHAuthorizationStatusNotDetermined:
      begin
        TPHPhotoLibrary.OCClass.requestAuthorization(CollectionsHandler);
        //询问权限
      end;
    PHAuthorizationStatusAuthorized:
      begin
        DoGetCollections;
        //直接加载数据
      end;
  end;
end;

procedure TiOSPhotosManager.DoPhotoChange(Sender: TObject);
begin
  if Assigned(FOnPhotoChange) then
    FOnPhotoChange(Sender);
end;

procedure TiOSPhotosManager.DoPhotosSuccess;
begin
  if Assigned(FOnPhotoSuccess) then
    FOnPhotoSuccess(Self);
end;

procedure TiOSPhotosManager.Init;
begin
  DoInit;
end;

procedure TiOSPhotosManager.CollectionsHandler(param1: PHAuthorizationStatus);
begin
  if param1 = PHAuthorizationStatusAuthorized then
  begin
    DoGetCollections;
  end
  else
    DoGetCollectionsSuccess;
end;

procedure TiOSPhotosManager.SetCureeCollectionIdentifier(const Value: string);
begin
  if Value <> FCureeCollectionIdentifier then
  begin
    FCureeCollectionIdentifier := Value;
    DoGetPhotos;
  end
  else
    DoPhotosSuccess;
end;

function TiOSPhotosManager.StrToNSArray(AStr: String): NSArray;
begin
  Result := TNSArray.Wrap(TNSArray.OCClass.arrayWithObject
    ((StrToNSStr(AStr) as ILocalObject).GetObjectID));
end;

{ TAssetPhotoCache }

constructor TAssetPhotoCache.Create(Asset: PHAsset; OnBitMapResultHandler, OnGetHignQualityBitMapSuccess, OnBitMapChange: TNotifyEvent);
begin
  inherited Create(OnBitMapResultHandler, OnBitMapChange);
  FOnGetHignQualityBitMapSuccess:=OnGetHignQualityBitMapSuccess;
  FAsset := Asset;
  FAsset.retain;
end;

destructor TAssetPhotoCache.Destroy;
begin
  FAsset.release;
  FreeAndNil(FBitMap);
  inherited;
end;

procedure TAssetPhotoCache.DoGetHignQualityBitmapResultHandler(param1: NSData;
  param2: NSString; param3: UIImageOrientation; param4: NSDictionary);
var
  image: UIImage;
begin
  image := TUIImage.Wrap(TUIImage.OCClass.imageWithData(param1));
  if image <> nil then
  begin
    FHignQualityBitmap := UIImageToBitmap(image, 0,
      TSize.Create(trunc(image.size.Width), trunc(image.size.Height)));
    DoGetHignQualitySuccess;
  end;
end;

procedure TAssetPhotoCache.DoGetHignQualitySuccess;
begin
  if Assigned(FOnGetHignQualityBitMapSuccess) then
    FOnGetHignQualityBitMapSuccess(Self);
end;

procedure TAssetPhotoCache.DoBitMapChange;
begin
  if Assigned(FOnBitMapChange) then
    FOnBitMapChange(Self);
end;

procedure TAssetPhotoCache.DoBitMapResultHandler(param1: UIImage;
  param2: NSDictionary);
var
  ABitMap:TBitMap;
  IsResult:Boolean;
begin
  if param1 <> nil then
  begin
    IsResult:= FBitMap<>nil;
    if not IsResult then
    begin
      FBitMap := UIImageToBitmap(param1, 0, TSize.Create(trunc(param1.size.Width),
        trunc(param1.size.Height)));
      if Assigned(FOnBitMapResultHandler) then
        FOnBitMapResultHandler(Self);
    end
    else
    begin
      //图片发生变化
      ABitMap := UIImageToBitmap(param1, 0, TSize.Create(trunc(param1.size.Width),
        trunc(param1.size.Height)));
      FBitMap.SetSize(ABitMap.Width, ABitMap.Height);
      FBitMap.CopyFromBitmap(ABitMap);
      FreeAndNil(ABitMap);
      if Assigned(FOnBitMapChange) then
        FOnBitMapChange(Self);
    end;
  end;
end;

procedure TAssetPhotoCache.DoGetBitMap;
var
  Ret: PHFetchResult;
  Option: PHImageRequestOptions;
  size:CGSize;
begin
  if FAsset<>nil then
  begin
    Option := TPHImageRequestOptions.Wrap(TPHImageRequestOptions.OCClass.alloc);
    Option.setResizeMode(PHImageRequestOptionsResizeModeFast);
    Option.setNetworkAccessAllowed(True);
    size.width := ThumbnailPhotoSize.cx;
    size.Height := ThumbnailPhotoSize.cy;
    TPHCachingImageManager.OCClass.defaultManager.requestImageForAsset(FAsset,
      size, PHImageContentModeAspectFill, Option, DoBitMapResultHandler);
  end
  else
  begin
    if Assigned(FOnBitMapResultHandler) then
      FOnBitMapResultHandler(Self);
  end;
end;

procedure TAssetPhotoCache.GetHignQualityBimap;
begin
  if not FIsHignQuality then
  begin
    FIsHignQuality := True;
    TPHCachingImageManager.OCClass.defaultManager.requestImageDataForAsset
      (FAsset, nil, DoGetHignQualityBitmapResultHandler);
  end
  else
    DoGetHignQualitySuccess;
end;


procedure TAssetPhotoCache.Init;
begin
  DoGetBitMap;
end;

{ TCustomCache }

constructor TCustomCache.Create(OnBitMapResultHandler,
  OnBitMapChange: TNotifyEvent);
begin
  FBitMap:=nil;
  FOnBitMapResultHandler:=OnBitMapResultHandler;
  FOnBitMapChange:=OnBitMapChange;
end;

end.
