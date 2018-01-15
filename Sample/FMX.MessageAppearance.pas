unit FMX.MessageAppearance;

interface

uses
  System.Classes, System.SysUtils, FMX.Types, FMX.Controls, System.UITypes,
  FMX.Objects, FMX.ListView, FMX.Graphics, System.Types, System.Rtti,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.Graphics.Helper,
  System.Math, System.Math.Vectors;

const
  MvPath3 = 'M122 226c-18,-17 -28,-41 -28,-68 0,-26 10,-50 27,-68l10 11c-14,14 -23,35 -23,57 0,23 9,43 24,58l-10 10z';
  MvPath2 = 'm35 -35c-9,-9 -14,-20 -14,-33 0,-12 5,-24 13,-32l-10 -10c-10,11 -17,26 -17,42 0,17 7,32 18,43l10 -10z';
  MvPath1 = 'm15 -15c-4,-5 -7,-11 -7,-18 0,-6 2,-12 6,-17l17 18 -16 17z';
{
  MvPath1 = 'M1097.45202636719,2527.5849609375 C1102.8720703125,2533.92602539063'
    + ' 1106.15307617188,2542.14892578125 1106.15307617188,2551.14599609375 ' +
    'C1106.15307617188,2560.14111328125 1102.8720703125,2568.36596679688 ' +
    '1097.45202636719,2574.7060546875 L1069.8759765625,2551.14599609375 L1097.45202636719,'
    + '2527.5849609375 Z';
  MvPath2 = 'M1128.12805175781,2551.14599609375 C1128.12805175781,2536.72192382813 '
    + '1122.84704589844,2523.51611328125 1114.13403320313,2513.33203125 L1131.55407714844,'
    + '2498.44604492188 C1143.70007324219,2512.64013671875 1151.06005859375,2531.044921875 '
    + '1151.06005859375,2551.14599609375 C1151.06005859375,2571.2470703125 1143.70104980469,'
    + '2589.65087890625 1131.55407714844,2603.84497070313 L1114.13403320313,2588.958984375 '
    + 'C1122.84704589844,2578.77490234375 1128.12805175781,2565.56811523438 1128.12805175781,'
    + '2551.14599609375 Z';
  MvPath3 = 'M1174.96594238281,2551.14599609375 C1174.96594238281,2525.125 1165.43896484375,'
    + '2501.30102539063 1149.71789550781,2482.92797851563 L1167.16088867188,2468.02587890625 '
    + 'C1186.30883789063,2490.40795898438 1197.89685058594,2519.44799804688 1197.89685058594,'
    + '2551.14599609375 C1197.89685058594,2582.84399414063 1186.30883789063,2611.88305664063 '
    + '1167.16088867188,2634.26611328125 L1149.71789550781,2619.36303710938 C1165.43798828125,'
    + '2600.98901367188 1174.96594238281,2577.166015625 1174.96594238281,2551.14599609375 Z ';
}
type
  TMessageAlign = (maNone, maLeft, maRight);
  TMessageType = (mtText, mtImage, mtVoice, mtVideo, mtFile);
  TMessageVoice = (mv0, mv1, mv2, mv3);

  TMessageListItemAppearanceNames = class
  public const
    ListItem = 'MessageListItem';
    // ListItemCheck = ListItem + 'ShowCheck';
    // ListItemDelete = ListItem + 'Delete';
    // Text = Name  Image = header
    MessageTextName = 'MessageText'; // 文本内容
    MessageImageName = 'MessageImage'; // 图片信息
    MessageVoiceName = 'MessageVoice'; // 声音信息
    MessageVideoName = 'MessageVideo'; // 视频信息
    MessageFileName = 'MessageFile'; //文件信息
  end;

type
  TMessageListViewItem = class;

  TMessageCustomItem = class(TListItemDrawable)
  private
    FOwner: TMessageListViewItem;
    FIsNeedUpItemSize: Boolean;
    FItemRect: TRectF;
    FMessageType: TMessageType;
    FMessageAlign: TMessageAlign;
    FLeftBackground: TBitMap;
    FRightBackground: TBitMap;
    procedure SetMessageAlign(const Value: TMessageAlign);
    procedure DrawFrameLine(const ACanvas: TCanvas; const ARect: TRectF);
    procedure SetItemSize; virtual;
    function GetRelHeight: Single;
  public
    constructor Create(const AOwner: TListItem); override;
    procedure CalculateLocalRect(const DestRect: TRectF;
      const SceneScale: Single; const DrawStates: TListItemDrawStates;
      const Item: TListItem); override;
    function UpdateSizes: Single;
    function InItemRect(const Position: TPointF): Boolean;
    property MessageAlign: TMessageAlign read FMessageAlign
      write SetMessageAlign;
    property MessageType: TMessageType read FMessageType write FMessageType;
    property LeftBackground: TBitMap read FLeftBackground write FLeftBackground;
    property RightBackground: TBitMap read FRightBackground
      write FRightBackground;
    property ItemRect:TRectF read FItemRect;
  end;

  TMessageCustomObjectAppearance = class(TCommonObjectAppearance)
  private type
    TNotify = class(TComponent)
    private
      FOwner: TMessageCustomObjectAppearance;
    protected
      procedure Notification(AComponent: TComponent;
        Operation: TOperation); override;
    end;
  private
    FLeftBackground: TImage;
    FRightBackground: TImage;
    FLeftNotify: TNotify;
    FRightNotify: TNotify;
    procedure SetLeftBackground(const Value: TImage);
    procedure SetRightBackground(const Value: TImage);
    function FindMessageCustomObject(const AListViewItem: TListViewItem)
      : TMessageCustomItem;
  public
    destructor Destroy; override;
    procedure ResetObject(const AListViewItem: TListViewItem); override;
  published
    property LeftBackground: TImage read FLeftBackground
      write SetLeftBackground;
    property RightBackground: TImage read FRightBackground
      write SetRightBackground;
  end;

  // 文本内容
  TMessageTextItem = class(TMessageCustomItem)
  private
    FMessageText: String;
    FTextColor: TAlphaColor;
    FTextVertAlign: TTextAlign;
    FTextAlign: TTextAlign;
    FTextFont: TFont;
    FFileName : String;
    FMessageDateTime : String;
    FisLoadData: Boolean;

    function GetTextHeight(Canvas: TCanvas; AWidth: Single): Integer;
    function GetTextWidth(Canvas: TCanvas): Integer;
    procedure SetTextColor(const Value: TAlphaColor);
    procedure SetMessageText(const Value: String);
    procedure SetTextAlign(const Value: TTextAlign);
    procedure SetTextVertAlign(const Value: TTextAlign);
    procedure SetTextFont(const Value: TFont);
    procedure FontChanged(Sender: TObject);
    procedure SetItemSize; override;
  public
    constructor Create(const AOwner: TListItem); override;
    destructor Destroy; override;
    procedure Render(const Canvas: TCanvas; const DrawItemIndex: Integer;
      const DrawStates: TListItemDrawStates;
      const Resources: TListItemStyleResources;
      const Params: TListItemDrawable.TParams;
      const SubPassNo: Integer = 0); override;
  published
    property MessageAlign;
    property LeftBackground;
    property RightBackground;
    property MessageText: string read FMessageText write SetMessageText;
    property TextColor: TAlphaColor read FTextColor write SetTextColor;
    property TextAlign: TTextAlign read FTextAlign write SetTextAlign;
    property TextVertAlign: TTextAlign read FTextVertAlign
      write SetTextVertAlign;
    property TextFont: TFont read FTextFont write SetTextFont;
    property FileName:String Read FFileName write FFileName;
    property MessageDateTime:String Read FMessageDateTime write FMessageDateTime;
    property isLoadData:Boolean read FisLoadData write FisLoadData;
  end;

  TMessageTextObjectAppearance = class(TMessageCustomObjectAppearance)
  protected
    procedure AssignTo(ADest: TPersistent); override;
  public
    procedure CreateObject(const AListViewItem: TListViewItem); override;
  published
    property LeftBackground;
    property RightBackground;
  end;

  // 语音内容
  TMessageVoiceItem = class(TMessageCustomItem)
  private const
    MinWidth = 60;
  private
    FVoiceSec: Single;
    FIsRead: Boolean;
    FVoicePath: TPathData;
    FVoicePosition: TMessageVoice;
    FEndbled: Boolean;
    procedure SetIsRead(const Value: Boolean);
    procedure SetVoiceSec(const Value: Single);
    procedure SetVoicePosition(const Value: TMessageVoice);
    function GetEnabled: Boolean;
    procedure SetEndbled(const Value: Boolean);
    procedure SetItemSize; override;
  public
    constructor Create(const AOwner: TListItem); override;
    destructor Destroy; override;
    procedure Render(const Canvas: TCanvas; const DrawItemIndex: Integer;
      const DrawStates: TListItemDrawStates;
      const Resources: TListItemStyleResources;
      const Params: TListItemDrawable.TParams;
      const SubPassNo: Integer = 0); override;
    procedure Paly;
    procedure Stop;
    property VoiceSec: Single read FVoiceSec write SetVoiceSec;
    property IsRead: Boolean read FIsRead write SetIsRead;
    property VoicePosition: TMessageVoice read FVoicePosition
      write SetVoicePosition;
    property Enabled: Boolean read GetEnabled write SetEndbled;
  end;

  TMessageVoiceObjectAppearance = class(TMessageCustomObjectAppearance)
  protected
    procedure AssignTo(ADest: TPersistent); override;
  public
    procedure CreateObject(const AListViewItem: TListViewItem); override;
  published
    property LeftBackground;
    property RightBackground;
  end;

  // 图片内容
  TMessageImageItem = class(TMessageCustomItem)
  private
    FMessageImage: TBitMap;
    function GetScale(MaxWidth: Single): Single;
    function GetMessageImage: TBitMap;
    procedure SetMessageImage(const Value: TBitMap);
    procedure SetItemSize; override;
    procedure DoMessageImageChanged(Sender: TObject);
  public
    constructor Create(const AOwner: TListItem); override;
    destructor Destroy; override;
    procedure Render(const Canvas: TCanvas; const DrawItemIndex: Integer;
      const DrawStates: TListItemDrawStates;
      const Resources: TListItemStyleResources;
      const Params: TListItemDrawable.TParams;
      const SubPassNo: Integer = 0); override;
  published
    property LeftBackground;
    property RightBackground;
    property MessageImage: TBitMap read GetMessageImage write SetMessageImage;
  end;

  TMessageImageObjectAppearance = class(TMessageCustomObjectAppearance)
  protected
    procedure AssignTo(ADest: TPersistent); override;
  public
    procedure CreateObject(const AListViewItem: TListViewItem); override;
  published
    property LeftBackground;
    property RightBackground;
  end;

  // 视频内容
  TMessageVideoItem = class(TMessageImageItem)
  public
    constructor Create(const AOwner: TListItem); override;
  published
    property LeftBackground;
    property RightBackground;
    property MessageImage;
  end;

  TMessageVideoObjectAppearance = class(TMessageCustomObjectAppearance)
  protected
    procedure AssignTo(ADest: TPersistent); override;
  public
    procedure CreateObject(const AListViewItem: TListViewItem); override;
  published
    property LeftBackground;
    property RightBackground;
  end;

  // 文件内容
  TMessageFileItem = class(TMessageImageItem)
  public
    constructor Create(const AOwner: TListItem); override;
  published
    property LeftBackground;
    property RightBackground;
    property MessageImage;
  end;

  TMessageFileObjectAppearance = class(TMessageCustomObjectAppearance)
  protected
    procedure AssignTo(ADest: TPersistent); override;
  public
    procedure CreateObject(const AListViewItem: TListViewItem); override;
  published
    property LeftBackground;
    property RightBackground;
  end;

  TMessageListViewItem = class(TListViewItem)
  private
    procedure SetMessageImage(const Value: TBitMap);
    procedure SetMessageText(const Value: String);
    function GetMessageText: String;
    procedure SetMessageVoiceSec(const Value: Single);
    function GetMessageVoiceSec: Single;
    function GetMessageAlign: TMessageAlign;
    procedure SetMessageAlign(const Value: TMessageAlign);
    function GetMessageImage: TBitMap;
    function FindMessageItem: TMessageCustomItem;
    function GetMessageType: TMessageType;
    procedure SetMessageType(const Value: TMessageType);
    function GetMessageFont: TFont;
    procedure SetMessageFont(const Value: TFont);
    function GetMessageVoiceIsRead: Boolean;
    procedure SetMessageVoiceIsRead(const Value: Boolean);
    function GetMessageVideoImage: TBitMap;
    procedure SetMessageVideoImage(const Value: TBitMap);
    function GetMessageFileImage: TBitMap;
    procedure SetMessageFileImage(const Value: TBitMap);
    function GetFileName: String;
    procedure SetFileName(const Value: String);
    function GetMessageDateTime: String;
    procedure SetMessageDateTime(const Value: String);
    function GetLoadData: Boolean;
    procedure SetLoadData(const Value: Boolean);
    function GetMessageVoicePosition: TMessageVoice;
    procedure SetMessageVoicePosition(const Value: TMessageVoice);
    function GetisLoading: Boolean;
    procedure SetisLoading(const Value: Boolean);
  public
    function GetListItemDrawable(const AName: string): TListItemDrawable;
    function GetRelHeight: Single;
    property MessageAlign: TMessageAlign read GetMessageAlign
      write SetMessageAlign;
    property MessageText: String read GetMessageText write SetMessageText;
    property MessageFont: TFont read GetMessageFont write SetMessageFont;
    property MessageImage: TBitMap read GetMessageImage write SetMessageImage;
    property MessageVoiceSec: Single read GetMessageVoiceSec
      write SetMessageVoiceSec;
    property MessageVoiceIsRead: Boolean read GetMessageVoiceIsRead
      write SetMessageVoiceIsRead;
    property MessageVoicePosition: TMessageVoice read GetMessageVoicePosition
      write SetMessageVoicePosition;
    property MessageVideoImage: TBitMap read GetMessageVideoImage
      write SetMessageVideoImage;
    property MessageFileImage:TBitMap read GetMessageFileImage
      write SetMessageFileImage;
    property MessageType: TMessageType read GetMessageType;
    property FileName: String read GetFileName write SetFileName;
    property MessageDateTime: String read GetMessageDateTime write SetMessageDateTime;
    property isLoadData:Boolean read GetLoadData write SetLoadData;
  end;

implementation

type
  TMessageListItemAppearance = class(TPresetItemObjects)
  public const
    cDefaultHeight = 40;
  private
    FMessageTextObject: TMessageTextObjectAppearance;
    FMessageImageObject: TMessageImageObjectAppearance;
    FMessageVoiceObject: TMessageVoiceObjectAppearance;
    FMessageVideoObject: TMessageVideoObjectAppearance;
    FMessageFileObject: TMessageFileObjectAppearance;
    procedure SetMessageText(Value: TMessageTextObjectAppearance);
    procedure SetMessageImage(const Value: TMessageImageObjectAppearance);
    procedure SetMessageVoice(const Value: TMessageVoiceObjectAppearance);
    procedure SetMessageVideo(const Value: TMessageVideoObjectAppearance);
    procedure SetMessageFile(const Value: TMessageFileObjectAppearance);
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
  published
    property Text;
    property Detail;
    property Image;
    property MessageText: TMessageTextObjectAppearance read FMessageTextObject
      write SetMessageText;
    property MessageImage: TMessageImageObjectAppearance
      read FMessageImageObject write SetMessageImage;
    property MessageVoice: TMessageVoiceObjectAppearance
      read FMessageVoiceObject write SetMessageVoice;
    property MessageVideoObject: TMessageVideoObjectAppearance
      read FMessageVideoObject write SetMessageVideo;
    property MessageFileObject: TMessageFileObjectAppearance
      read FMessageFileObject write SetMessageFile;
  end;

  TMessageListItemDeleteAppearance = class(TMessageListItemAppearance)
  private const
    cDefaultGlyph = TGlyphButtonType.Delete;
  public
    constructor Create(const Owner: TControl); override;
  published
    property GlyphButton;
  end;

  TMessageListItemShowCheckAppearance = class(TMessageListItemAppearance)
  private const
    cDefaultGlyph = TGlyphButtonType.Checkbox;
  public
    constructor Create(const Owner: TControl); override;
  published
    property GlyphButton;
  end;

  { TMessageTextObjectAppearance }

procedure TMessageTextObjectAppearance.AssignTo(ADest: TPersistent);
var
  DstDrawable: TMessageTextItem;
  DstAppearance: TMessageTextObjectAppearance;
begin
  if ADest is TMessageTextObjectAppearance then
  begin
    DstAppearance := TMessageTextObjectAppearance(ADest);
    DstAppearance.BeginUpdate;
    try
      DstAppearance.FLeftBackground := Self.FLeftBackground;
      DstAppearance.FRightBackground := Self.FRightBackground;
      inherited AssignTo(ADest);
    finally
      DstAppearance.EndUpdate;
    end;
  end
  else if ADest is TMessageTextItem then
  begin
    DstDrawable := TMessageTextItem(ADest);
    DstDrawable.BeginUpdate;
    try
      if Self.FLeftBackground <> nil then
        DstDrawable.LeftBackground := FLeftBackground.BitMap//Self.FLeftBackground.MultiResBitmap.Items[0].Bitmap
      else
        DstDrawable.LeftBackground := nil;

      if Self.FRightBackground <> nil then
        DstDrawable.RightBackground := RightBackground.BitMap//Self.RightBackground.MultiResBitmap.Items[0].Bitmap
      else
        DstDrawable.RightBackground := nil;
      inherited AssignTo(ADest);
    finally
      DstDrawable.EndUpdate;
    end;
  end
  else
    inherited;

end;

procedure TMessageTextObjectAppearance.CreateObject(const AListViewItem
  : TListViewItem);
var
  LItem: TMessageTextItem;
begin
  LItem := TMessageTextItem.Create(AListViewItem);
  LItem.BeginUpdate;
  try
    LItem.Name := Name;
    LItem.Assign(Self);
  finally
    LItem.EndUpdate;
  end;
end;

{ TMessageTextItem }

constructor TMessageTextItem.Create(const AOwner: TListItem);
begin
  inherited;
  FMessageType := TMessageType.mtText;
  FTextColor := TAlphaColors.Black;
  FTextVertAlign := TTextAlign.Center;
  FTextAlign := TTextAlign.Leading;
  FTextFont := TFont.Create;
  FTextFont.Size:=16;
  FTextFont.OnChanged := FontChanged;

end;

destructor TMessageTextItem.Destroy;
begin
  FTextFont.Free;
  inherited;
end;

procedure TMessageTextItem.FontChanged(Sender: TObject);
begin
  Invalidate;
end;

function TMessageTextItem.GetTextHeight(Canvas: TCanvas;
  AWidth: Single): Integer;
var
  R: TRectF;
begin
  R := RectF(0, 0, AWidth, 10000);
  Canvas.MeasureText(R, FMessageText, True, [], TTextAlign.Leading,
    TTextAlign.Leading);
  Result := Round(R.Bottom);
  // Result := Round(Canvas.TextHeight(Text) + 0.5);
end;

function TMessageTextItem.GetTextWidth(Canvas: TCanvas): Integer;
begin
  Result := Round(Canvas.TextWidth(FMessageText) + 0.5);
end;

procedure TMessageTextItem.Render(const Canvas: TCanvas;
  const DrawItemIndex: Integer; const DrawStates: TListItemDrawStates;
  const Resources: TListItemStyleResources;
  const Params: TListItemDrawable.TParams; const SubPassNo: Integer = 0);
var
  ARect: TRectF;
  BitMap: TBitMap;
  Scale:Single;
begin
  Scale:=Canvas.Scale;
  if (SubPassNo <> 0) or (FMessageText = '') then
    Exit;
  UpdateSizes;
  // 获取文字的Rect
  case FMessageAlign of
    maLeft:
      begin
        ARect.Left := LocalRect.Left +8;
      end;
    maRight:
      begin
        ARect.Left := LocalRect.Right - FItemRect.Width;
      end;
  end;

  ARect.Top := LocalRect.Top + 1;
  ARect.Width := FItemRect.Width;
  ARect.Height := FItemRect.Height + 2;

  DrawFrameLine(Canvas, ARect);
  // Draw Background
  BitMap := TBitMap.Create;
  try
    case FMessageAlign of
      maLeft:
        begin
          BitMap.Assign(FLeftBackground);
          //BitMap.FlipHorizontal;
        end;
      maRight:
        begin
          BitMap.Assign(FRightBackground);
          //BitMap.FlipHorizontal;
        end;
    end;
    if (BitMap.Width <> 0) and (BitMap.Height <> 0) then
    begin
//      Canvas.DrawBitmapCapInsets(BitMap, TRectF.Create(ARect.Left - 12, ARect.Top - 8,
//        ARect.Right + 8, ARect.Bottom + 8), TRectF.Create(24, 24, 6, 6), 1, False);
//      Canvas.DrawBitmapCapInsets(BitMap, TRectF.Create(ARect.Left - 12, ARect.Top - 8,
//        ARect.Right + 8, ARect.Bottom + 8), TRectF.Create(24, 24, 6, 6), 1, False);
      Canvas.DrawBitmapCapInsets1(BitMap, TRectF.Create(ARect.Left - 12, ARect.Top - 8,
        ARect.Right + 8, ARect.Bottom + 8), TRectF.Create(24*Canvas.Scale, 24*Canvas.Scale, 6*Canvas.Scale, 6*Canvas.Scale), 1);
    end
    else
    begin
      Canvas.Fill.Kind:=TBrushKind.Solid;
      Canvas.Fill.Color := $FFE0E0E0;
      Canvas.FillRect(ARect, 4, 4, AllCorners, Opacity);
    end;
  finally
    BitMap.Free;
  end;

  // Draw Text
  Canvas.Font.Assign(FTextFont);
  Canvas.Fill.Kind:=TBrushKind.Solid;
  Canvas.Fill.Color := FTextColor;
  Canvas.FillText(ARect, FMessageText, True, 1, [], TextAlign, TextVertAlign);
end;

procedure TMessageTextItem.SetItemSize;
var
  Canvas: TCanvas;
  ClientWidth, ARectWidth: Single;
  TextWidth, TextHeight: Integer;
begin
  if (FOwner <> nil) and (FOwner.Controller <> nil) then
  begin
    Canvas := TListViewBase(FOwner.Controller).Canvas;
    Canvas.Font.Assign(FTextFont);
    TextWidth := GetTextWidth(Canvas);
    ClientWidth := Canvas.Width - 140;
    if TextWidth < ClientWidth then
      ARectWidth := TextWidth + 8
    else
      ARectWidth := Round(ClientWidth);
    TextHeight := GetTextHeight(Canvas, ARectWidth);
    FItemRect.Top := 0;
    FItemRect.Left := 0;
    FItemRect.Width := ARectWidth;
    FItemRect.Height := TextHeight;
  end;

end;

procedure TMessageTextItem.SetMessageText(const Value: String);
begin
  if Value <> FMessageText then
  begin
    FMessageText := Value;
    Invalidate;
  end;
end;

procedure TMessageTextItem.SetTextAlign(const Value: TTextAlign);
begin
  if Value <> FTextAlign then
  begin
    FTextAlign := Value;
    Invalidate;
  end;
end;

procedure TMessageTextItem.SetTextColor(const Value: TAlphaColor);
begin
  if Value <> FTextColor then
  begin
    FTextColor := Value;
    Invalidate;
  end;
end;

procedure TMessageTextItem.SetTextFont(const Value: TFont);
begin
  FTextFont.Assign(Value);
end;

procedure TMessageTextItem.SetTextVertAlign(const Value: TTextAlign);
begin
  if Value <> FTextAlign then
  begin
    FTextAlign := Value;
    Invalidate;
  end;
end;

{ TMessageListItemAppearance }

constructor TMessageListItemAppearance.Create(const Owner: TControl);
begin
  inherited;

  Text.Visible := True;
  Text.Align := TListItemAlign.Leading;
  Text.VertAlign := TListItemAlign.Leading;
  Text.TextVertAlign := TTextAlign.Leading;
  Text.TextAlign := TTextAlign.Trailing;
  Text.Height := 18;
  Text.Width := 200;
  Text.Font.Size := 13;
  Text.TextColor:=$FF747474;

  Image.Visible := True;
  Image.Align := TListItemAlign.Leading;
  Image.VertAlign := TListItemAlign.Leading;
  Image.Height := 36;
  Image.Width := 36;

  FMessageTextObject := TMessageTextObjectAppearance.Create;
  FMessageTextObject.Owner := Self;
  FMessageTextObject.Visible := True;
  FMessageTextObject.Name := TMessageListItemAppearanceNames.MessageTextName;
  FMessageTextObject.DataMembers := TObjectAppearance.TDataMembers.Create
    (TObjectAppearance.TDataMember.Create
    (TMessageListItemAppearanceNames.MessageTextName, Format('Data["%s"]',
    [TMessageListItemAppearanceNames.MessageTextName])));
  FMessageTextObject.Width := 100;
  FMessageTextObject.Align := TListItemAlign.Leading;
  FMessageTextObject.RestoreDefaults;

  FMessageImageObject := TMessageImageObjectAppearance.Create;
  FMessageImageObject.Visible := False;
  FMessageImageObject.Owner := Self;
  FMessageImageObject.Name := TMessageListItemAppearanceNames.MessageImageName;
  FMessageImageObject.DataMembers := TObjectAppearance.TDataMembers.Create
    (TObjectAppearance.TDataMember.Create
    (TMessageListItemAppearanceNames.MessageImageName,
    // Displayed by LiveBindings
    Format('Data["%s"]', [TMessageListItemAppearanceNames.MessageImageName])));
  // Expression to access value from TListViewItem
  FMessageTextObject.Width := 100;
  FMessageTextObject.Align := TListItemAlign.Leading;
  FMessageTextObject.RestoreDefaults;

  FMessageVoiceObject := TMessageVoiceObjectAppearance.Create;
  FMessageVoiceObject.Visible := False;
  FMessageVoiceObject.Owner := Self;
  FMessageVoiceObject.Name := TMessageListItemAppearanceNames.MessageVoiceName;
  FMessageVoiceObject.DataMembers := TObjectAppearance.TDataMembers.Create
    (TObjectAppearance.TDataMember.Create
    (TMessageListItemAppearanceNames.MessageVoiceName,
    // Displayed by LiveBindings
    Format('Data["%s"]', [TMessageListItemAppearanceNames.MessageVoiceName])));
  // Expression to access value from TListViewItem
  FMessageVoiceObject.Width := 100;
  FMessageVoiceObject.Align := TListItemAlign.Leading;
  FMessageVoiceObject.RestoreDefaults;

  FMessageVideoObject := TMessageVideoObjectAppearance.Create;
  FMessageVideoObject.Visible := False;
  FMessageVideoObject.Owner := Self;
  FMessageVideoObject.Name := TMessageListItemAppearanceNames.MessageVideoName;
  FMessageVideoObject.DataMembers := TObjectAppearance.TDataMembers.Create
    (TObjectAppearance.TDataMember.Create
    (TMessageListItemAppearanceNames.MessageVideoName,
    // Displayed by LiveBindings
    Format('Data["%s"]', [TMessageListItemAppearanceNames.MessageVideoName])));
  // Expression to access value from TListViewItem
  FMessageVideoObject.Width := 100;
  FMessageVideoObject.Align := TListItemAlign.Leading;
  FMessageVideoObject.RestoreDefaults;

  FMessageFileObject := TMessageFileObjectAppearance.Create;
  FMessageFileObject.Visible := False;
  FMessageFileObject.Owner := Self;
  FMessageFileObject.Name := TMessageListItemAppearanceNames.MessageFileName;
  FMessageFileObject.DataMembers := TObjectAppearance.TDataMembers.Create
    (TObjectAppearance.TDataMember.Create
    (TMessageListItemAppearanceNames.MessageFileName,
    // Displayed by LiveBindings
    Format('Data["%s"]', [TMessageListItemAppearanceNames.MessageFileName])));
  // Expression to access value from TListViewItem
  FMessageFileObject.Width := 100;
  FMessageFileObject.Align := TListItemAlign.Leading;
  FMessageFileObject.RestoreDefaults;

  AddObject(Text, True);
  AddObject(FMessageTextObject, True);
  AddObject(FMessageImageObject, True);
  AddObject(FMessageVoiceObject, True);
  AddObject(FMessageVideoObject, True);
  AddObject(FMessageFileObject, True);
  AddObject(Image, True);
  AddObject(Accessory, True);
  AddObject(GlyphButton, IsItemEdit);
end;

function TMessageListItemAppearance.DefaultHeight: Integer;
begin
  Result := cDefaultHeight;
end;

destructor TMessageListItemAppearance.Destroy;
begin
  FMessageTextObject.Free;
  FMessageImageObject.Free;
  FMessageVideoObject.Free;
  FMessageFileObject.Free;
  FMessageVoiceObject.Free;
  inherited;
end;

function TMessageListItemAppearance.GetGroupClass
  : TPresetItemObjects.TGroupClass;
begin
  Result := TMessageListItemAppearance;
end;

procedure TMessageListItemAppearance.SetMessageFile(
  const Value: TMessageFileObjectAppearance);
begin
  FMessageFileObject.Assign(Value);
end;

procedure TMessageListItemAppearance.SetMessageImage
  (const Value: TMessageImageObjectAppearance);
begin
  FMessageImageObject.Assign(Value);
end;

procedure TMessageListItemAppearance.SetMessageText
  (Value: TMessageTextObjectAppearance);
begin
  FMessageTextObject.Assign(Value);
end;

procedure TMessageListItemAppearance.SetMessageVideo
  (const Value: TMessageVideoObjectAppearance);
begin
  FMessageVideoObject.Assign(Value);
end;

procedure TMessageListItemAppearance.SetMessageVoice
  (const Value: TMessageVoiceObjectAppearance);
begin
  FMessageVoiceObject.Assign(Value);
end;

procedure TMessageListItemAppearance.SetObjectData(const AListViewItem
  : TListViewItem; const AIndex: string; const AValue: TValue;
  var AHandled: Boolean);
begin
  inherited;
end;

procedure TMessageListItemAppearance.UpdateSizes(const ItemSize: TSizeF);
var
  Offset: Single;
begin
  inherited;
  try
    BeginUpdate;
    Image.PlaceOffset.Y := 4;
    Text.PlaceOffset.Y := 0;
    Offset := 0 ;
    FMessageTextObject.PlaceOffset.X := Offset;
    FMessageImageObject.PlaceOffset.X := Offset;
    FMessageVoiceObject.PlaceOffset.X := Offset;
    FMessageVideoObject.PlaceOffset.X := Offset;
    Offset := Text.Height ;
    FMessageTextObject.PlaceOffset.Y := Offset + 8;
    FMessageImageObject.PlaceOffset.Y := Offset+ 8;
    FMessageVoiceObject.PlaceOffset.Y := Offset+ 8;
    FMessageVideoObject.PlaceOffset.Y := Offset+ 8;
    inherited;
  finally
    EndUpdate;
  end;

end;

{ TMessageListViewItem }
function TMessageListViewItem.FindMessageItem: TMessageCustomItem;
var
  LObject: TListItemDrawable;
begin
  for LObject in Objects.ViewList do
    if (LObject is TMessageCustomItem) and TMessageCustomItem(LObject).Visible
    then
      Exit(TMessageCustomItem(LObject));
  Result := nil;
end;

function TMessageListViewItem.GetListItemDrawable(const AName: string)
  : TListItemDrawable;
begin
  Result := Objects.FindDrawable(AName);
end;

function TMessageListViewItem.GetMessageAlign: TMessageAlign;
var
  LObject: TMessageCustomItem;
begin
  LObject := FindMessageItem;
  if LObject = nil then
    Result := TMessageAlign.maLeft
  else
    Result := LObject.MessageAlign;
end;

function TMessageListViewItem.GetMessageFileImage: TBitMap;
begin
  Result := TMessageFileItem
    (GetListItemDrawable(TMessageListItemAppearanceNames.MessageFileName)
    ).MessageImage;
end;

function TMessageListViewItem.GetMessageFont: TFont;
begin
  Result := TMessageTextItem
    (GetListItemDrawable(TMessageListItemAppearanceNames.MessageTextName)
    ).TextFont;
end;

function TMessageListViewItem.GetMessageImage: TBitMap;
begin
  Result := TMessageImageItem
    (GetListItemDrawable(TMessageListItemAppearanceNames.MessageImageName))
    .MessageImage;
end;

function TMessageListViewItem.GetMessageText: String;
begin

  Result := TMessageTextItem
    (GetListItemDrawable(TMessageListItemAppearanceNames.MessageTextName))
    .MessageText;
end;

function TMessageListViewItem.GetMessageType: TMessageType;
var
  LObject: TMessageCustomItem;
begin
  LObject := FindMessageItem;
  if LObject = nil then
    Result := TMessageType.mtText
  else
    Result := LObject.MessageType;
end;

function TMessageListViewItem.GetMessageVideoImage: TBitMap;
begin
  Result := TMessageVideoItem
    (GetListItemDrawable(TMessageListItemAppearanceNames.MessageVideoName))
    .MessageImage;
end;

function TMessageListViewItem.GetMessageVoiceIsRead: Boolean;
begin
  Result := TMessageVoiceItem
    (GetListItemDrawable(TMessageListItemAppearanceNames.
    MessageVoiceName)).IsRead;
end;

function TMessageListViewItem.GetMessageVoicePosition: TMessageVoice;
begin
  Result := TMessageVoiceItem
    (GetListItemDrawable(TMessageListItemAppearanceNames.
    MessageVoiceName)).VoicePosition;
end;

function TMessageListViewItem.GetMessageVoiceSec: Single;
begin
  Result := TMessageVoiceItem
    (GetListItemDrawable(TMessageListItemAppearanceNames.MessageVoiceName)
    ).VoiceSec;
end;

function TMessageListViewItem.GetRelHeight: Single;
begin
  Result := FindMessageItem.GetRelHeight;
end;


function TMessageListViewItem.GetFileName: String;
begin
  Result := TMessageTextItem
    (GetListItemDrawable(TMessageListItemAppearanceNames.MessageTextName))
    .FileName;
end;

function TMessageListViewItem.GetisLoading: Boolean;
begin


end;

procedure TMessageListViewItem.SetFileName(const Value: String);
begin
  TMessageTextItem
    (GetListItemDrawable(TMessageListItemAppearanceNames.MessageTextName))
    .FileName := Value;
end;

procedure TMessageListViewItem.SetisLoading(const Value: Boolean);
begin

end;

function TMessageListViewItem.GetLoadData: Boolean;
begin
  Result := TMessageTextItem
    (GetListItemDrawable(TMessageListItemAppearanceNames.MessageTextName))
    .isLoadData;
end;

procedure TMessageListViewItem.SetLoadData(const Value: Boolean);
begin
  TMessageTextItem
    (GetListItemDrawable(TMessageListItemAppearanceNames.MessageTextName)).isLoadData := Value;
end;

function TMessageListViewItem.GetMessageDateTime: String;
begin
  Result := TMessageTextItem
    (GetListItemDrawable(TMessageListItemAppearanceNames.MessageTextName)).MessageDateTime;
end;

procedure TMessageListViewItem.SetMessageDateTime(const Value: String);
begin
  TMessageTextItem
    (GetListItemDrawable(TMessageListItemAppearanceNames.MessageTextName))
    .MessageDateTime := Value;
end;


procedure TMessageListViewItem.SetMessageAlign(const Value: TMessageAlign);
var
  LObject: TMessageCustomItem;
begin
  LObject := FindMessageItem;
  if LObject <> nil then
  begin
    LObject.MessageAlign := Value;
  end;
end;

procedure TMessageListViewItem.SetMessageFileImage(const Value: TBitMap);
var
  AItem: TMessageFileItem;
begin
  AItem:=TMessageFileItem(GetListItemDrawable(TMessageListItemAppearanceNames.MessageFileName));
  AItem.MessageImage := Value;
  AItem.MessageAlign := MessageAlign;
  case MessageType of
    mtText:
      begin
        TMessageTextItem
          (GetListItemDrawable(TMessageListItemAppearanceNames.MessageTextName))
          .MessageText := '';
        GetListItemDrawable(TMessageListItemAppearanceNames.MessageTextName)
          .Visible := False;
      end;
    mtVoice:
      begin
        TMessageVoiceItem
          (GetListItemDrawable(TMessageListItemAppearanceNames.MessageVoiceName)
          ).VoiceSec := 0;
        GetListItemDrawable(TMessageListItemAppearanceNames.MessageVoiceName)
          .Visible := False;
      end;
    mtVideo:
      begin
        TMessageVideoItem
          (GetListItemDrawable(TMessageListItemAppearanceNames.MessageVideoName)
          ).MessageImage.SetSize(0, 0);
        GetListItemDrawable(TMessageListItemAppearanceNames.MessageVideoName)
          .Visible := False;
      end;
    mtImage:
      begin
        TMessageVideoItem
          (GetListItemDrawable(TMessageListItemAppearanceNames.MessageImageName)
          ).MessageImage.SetSize(0, 0);
        GetListItemDrawable(TMessageListItemAppearanceNames.MessageImageName)
          .Visible := False;
      end;
  else
    Exit;
  end;
  AItem.Visible := True;
end;

procedure TMessageListViewItem.SetMessageFont(const Value: TFont);
begin
  TMessageTextItem(GetListItemDrawable
    (TMessageListItemAppearanceNames.MessageTextName)).TextFont := Value;
end;

procedure TMessageListViewItem.SetMessageImage(const Value: TBitMap);
var
  AItem: TMessageImageItem;
begin
  AItem := TMessageImageItem
    (GetListItemDrawable(TMessageListItemAppearanceNames.MessageImageName));
  AItem.MessageImage := Value;
  AItem.MessageAlign := MessageAlign;
  case MessageType of
    mtText:
      begin
        TMessageTextItem
          (GetListItemDrawable(TMessageListItemAppearanceNames.MessageTextName))
          .MessageText := '';
        GetListItemDrawable(TMessageListItemAppearanceNames.MessageTextName)
          .Visible := False;
      end;
    mtVoice:
      begin
        TMessageVoiceItem
          (GetListItemDrawable(TMessageListItemAppearanceNames.MessageVoiceName)
          ).VoiceSec := 0;
        GetListItemDrawable(TMessageListItemAppearanceNames.MessageVoiceName)
          .Visible := False;
      end;
    mtVideo:
      begin
        TMessageVideoItem
          (GetListItemDrawable(TMessageListItemAppearanceNames.MessageVideoName)
          ).MessageImage.SetSize(0, 0);
        GetListItemDrawable(TMessageListItemAppearanceNames.MessageVideoName)
          .Visible := False;
      end;
    mtFile:
      begin
        TMessageVideoItem
          (GetListItemDrawable(TMessageListItemAppearanceNames.MessageFileName)
          ).MessageImage.SetSize(0, 0);
        GetListItemDrawable(TMessageListItemAppearanceNames.MessageFileName)
          .Visible := False;
      end;
  else
    Exit;
  end;
  AItem.Visible := True;
end;

procedure TMessageListViewItem.SetMessageText(const Value: String);
var
  AItem: TMessageTextItem;
begin
  AItem := TMessageTextItem
    (GetListItemDrawable(TMessageListItemAppearanceNames.MessageTextName));
  AItem.MessageText := Value;
  AItem.MessageAlign := MessageAlign;
  case MessageType of
    mtImage:
      begin
        TMessageImageItem
          (GetListItemDrawable(TMessageListItemAppearanceNames.MessageImageName)
          ).MessageImage.SetSize(0, 0);
        GetListItemDrawable(TMessageListItemAppearanceNames.MessageImageName)
          .Visible := False;
      end;
    mtVoice:
      begin
        TMessageVoiceItem
          (GetListItemDrawable(TMessageListItemAppearanceNames.MessageVoiceName)
          ).VoiceSec := 0;
        GetListItemDrawable(TMessageListItemAppearanceNames.MessageVoiceName)
          .Visible := False;
      end;
    mtVideo:
      begin
        TMessageVideoItem
          (GetListItemDrawable(TMessageListItemAppearanceNames.MessageVideoName)
          ).MessageImage.SetSize(0, 0);
        GetListItemDrawable(TMessageListItemAppearanceNames.MessageVideoName)
          .Visible := False;
      end;
    mtFile:
      begin
        TMessageVideoItem
          (GetListItemDrawable(TMessageListItemAppearanceNames.MessageFileName)
          ).MessageImage.SetSize(0, 0);
        GetListItemDrawable(TMessageListItemAppearanceNames.MessageFileName)
          .Visible := False;
      end;
  else
    Exit;
  end;
  AItem.Visible := True;
end;

procedure TMessageListViewItem.SetMessageType(const Value: TMessageType);
var
  LObject: TMessageCustomItem;
begin
  // do nothing
  {
    LObject := FindMessageItem;
    if LObject <> nil then
    begin
    LObject.MessageType := Value;
    end;
  }
end;

procedure TMessageListViewItem.SetMessageVideoImage(const Value: TBitMap);
var
  AItem: TMessageVideoItem;
begin
  AItem := TMessageVideoItem
    (GetListItemDrawable(TMessageListItemAppearanceNames.MessageVideoName));
  AItem.MessageImage := Value;
  AItem.MessageAlign := MessageAlign;
  case MessageType of
    mtText:
      begin
        TMessageTextItem
          (GetListItemDrawable(TMessageListItemAppearanceNames.MessageTextName))
          .MessageText := '';
        GetListItemDrawable(TMessageListItemAppearanceNames.MessageTextName)
          .Visible := False;
      end;
    mtVoice:
      begin
        TMessageVoiceItem
          (GetListItemDrawable(TMessageListItemAppearanceNames.MessageVoiceName)
          ).VoiceSec := 0;
        GetListItemDrawable(TMessageListItemAppearanceNames.MessageVoiceName)
          .Visible := False;
      end;
    mtImage:
      begin
        TMessageImageItem
          (GetListItemDrawable(TMessageListItemAppearanceNames.MessageImageName)
          ).MessageImage.SetSize(0, 0);
        GetListItemDrawable(TMessageListItemAppearanceNames.MessageImageName)
          .Visible := False;
      end;
    mtFile:
      begin
        TMessageVideoItem
          (GetListItemDrawable(TMessageListItemAppearanceNames.MessageFileName)
          ).MessageImage.SetSize(0, 0);
        GetListItemDrawable(TMessageListItemAppearanceNames.MessageFileName)
          .Visible := False;
      end;
  else
    Exit;
  end;
  AItem.Visible := True;

end;

procedure TMessageListViewItem.SetMessageVoiceIsRead(const Value: Boolean);
var
  AItem: TMessageVoiceItem;
begin
  AItem := TMessageVoiceItem
    (GetListItemDrawable(TMessageListItemAppearanceNames.MessageVoiceName));
  AItem.IsRead := Value;
end;

procedure TMessageListViewItem.SetMessageVoicePosition(const Value: TMessageVoice);
var
  AItem: TMessageVoiceItem;
begin
  AItem := TMessageVoiceItem
    (GetListItemDrawable(TMessageListItemAppearanceNames.MessageVoiceName));
  AItem.VoicePosition := Value;

end;

procedure TMessageListViewItem.SetMessageVoiceSec(const Value: Single);
var
  AItem: TMessageVoiceItem;
begin
  AItem := TMessageVoiceItem
    (GetListItemDrawable(TMessageListItemAppearanceNames.MessageVoiceName));
  AItem.VoiceSec := Value;
  AItem.MessageAlign := MessageAlign;

  case MessageType of
    mtText:
      begin
        TMessageTextItem
          (GetListItemDrawable(TMessageListItemAppearanceNames.MessageTextName))
          .MessageText := '';
        GetListItemDrawable(TMessageListItemAppearanceNames.MessageTextName)
          .Visible := False;
      end;
    mtImage:
      begin
        TMessageImageItem
          (GetListItemDrawable(TMessageListItemAppearanceNames.MessageImageName)
          ).MessageImage.SetSize(0, 0);
        GetListItemDrawable(TMessageListItemAppearanceNames.MessageImageName)
          .Visible := False;
      end;
    mtVideo:
      begin
        TMessageVideoItem
          (GetListItemDrawable(TMessageListItemAppearanceNames.MessageVideoName)
          ).MessageImage.SetSize(0, 0);
        GetListItemDrawable(TMessageListItemAppearanceNames.MessageVideoName)
          .Visible := False;
      end;
    mtFile:
      begin
        TMessageVideoItem
          (GetListItemDrawable(TMessageListItemAppearanceNames.MessageFileName)
          ).MessageImage.SetSize(0, 0);
        GetListItemDrawable(TMessageListItemAppearanceNames.MessageFileName)
          .Visible := False;
      end;
  else
    Exit;
  end;
  AItem.Visible := True;
end;

{ TMessageImageObjectApprarance }

procedure TMessageImageObjectAppearance.AssignTo(ADest: TPersistent);
var
  DstDrawable: TMessageImageItem;
  DstAppearance: TMessageImageObjectAppearance;
begin
  if ADest is TMessageImageObjectAppearance then
  begin
    DstAppearance := TMessageImageObjectAppearance(ADest);
    DstAppearance.BeginUpdate;
    try
      DstAppearance.FLeftBackground := Self.FLeftBackground;
      DstAppearance.FRightBackground := Self.FRightBackground;
      inherited AssignTo(ADest);
    finally
      DstAppearance.EndUpdate;
    end;
  end
  else if ADest is TMessageImageItem then
  begin
    DstDrawable := TMessageImageItem(ADest);
    DstDrawable.BeginUpdate;
    try
      if Self.FLeftBackground <> nil then
        DstDrawable.LeftBackground := Self.FLeftBackground.BitMap
      else
        DstDrawable.LeftBackground := nil;
      if Self.FRightBackground <> nil then
        DstDrawable.RightBackground := Self.FRightBackground.BitMap
      else
        DstDrawable.RightBackground := nil;
      inherited AssignTo(ADest);
    finally
      DstDrawable.EndUpdate;
    end;
  end
  else
    inherited;

end;

procedure TMessageImageObjectAppearance.CreateObject(const AListViewItem
  : TListViewItem);
var
  LItem: TMessageImageItem;
begin
  LItem := TMessageImageItem.Create(AListViewItem);
  LItem.BeginUpdate;
  try
    LItem.Assign(Self);
    LItem.Name := Name;
  finally
    LItem.EndUpdate;
  end;
end;

{ TMessageCustomItem }

procedure TMessageCustomItem.CalculateLocalRect(const DestRect: TRectF;
  const SceneScale: Single; const DrawStates: TListItemDrawStates;
  const Item: TListItem);
begin
  if Width <> DestRect.Width then
  begin
    Width := DestRect.Width;
    FIsNeedUpItemSize := True;
  end;
  inherited;
end;

constructor TMessageCustomItem.Create(const AOwner: TListItem);
begin
  inherited;
  FOwner := TMessageListViewItem(AOwner);
  FIsNeedUpItemSize := True;
  FMessageAlign := TMessageAlign.maNone;
  FItemRect := TRectF.Empty;
end;

procedure TMessageCustomItem.DrawFrameLine(const ACanvas: TCanvas;
  const ARect: TRectF);
var
  SepRect: TRectF;
begin
  Exit;
  {
    if (Owner.Purpose = TListItemPurpose.None) and
    ((Owner.Index >= Owner.Adapter.Count - 1) or
    (Owner.Adapter[Owner.Index + 1].Purpose = TListItemPurpose.None)) then
    begin

    SepRect.Left := 0;
    SepRect.Right := ACanvas.Width;
    SepRect.Top := ARect.Bottom + 15;
    SepRect.Bottom := SepRect.Top + 1;
    ACanvas.Fill.Color := $FFFFFFFF;
    ACanvas.FillRect(SepRect, 0, 0, AllCorners, Opacity);
    end;
  }
end;

function TMessageCustomItem.GetRelHeight: Single;
begin
  if FIsNeedUpItemSize then
  begin
    SetItemSize;
    if FItemRect.Width = 0 then
      FOwner.Height := Round(PlaceOffset.Y + 24) + 32
    else
      FOwner.Height := Round(PlaceOffset.Y + FItemRect.Height) + 32;
    FIsNeedUpItemSize := False;
  end;
  Result := FOwner.Height;
end;

function TMessageCustomItem.InItemRect(const Position: TPointF): Boolean;
var
  APos: TPointF;
  ARect: TRectF;
  OffSetX: Single;
begin
  case FMessageAlign of
    maLeft:
      begin
        OffSetX := LocalRect.Left + 16;
      end;
    maRight:
      begin
        OffSetX := LocalRect.Right - FItemRect.Width - 16;
      end;
  end;
  APos := Position;
  APos.Offset(-OffSetX, -PlaceOffset.Y);
  Result := FItemRect.Contains(APos);
end;

procedure TMessageCustomItem.SetItemSize;
begin
  FItemRect := TRectF.Empty;
end;

procedure TMessageCustomItem.SetMessageAlign(const Value: TMessageAlign);
begin
  if Value <> FMessageAlign then
  begin
    FMessageAlign := Value;
    UpdateSizes;
    Invalidate;
  end;
end;

function TMessageCustomItem.UpdateSizes: Single;
var
  Item: TListItemDrawable;
  Offset: Single;
begin
  Offset := 0;
  case FMessageAlign of
    maLeft:
      begin
        // 头像位置
        Item := FOwner.GetListItemDrawable('I');
        Item.Align := TListItemAlign.Leading;
        Item.PlaceOffset.X := 0;
        Offset := Item.Width + 12;

        Item := FOwner.GetListItemDrawable('T');
        Item.Align := TListItemAlign.Leading;
        TListItemText(Item).TextAlign := TTextAlign.Leading;
        Item.PlaceOffset.X := Offset;
        Item.Width := Width;

        PlaceOffset.X := Offset;
      end;
    maRight:
      begin
        // 头像位置
        Item := FOwner.GetListItemDrawable('I');
        Item.Align := TListItemAlign.Trailing;
        Item.PlaceOffset.X := 0;
        Offset := Item.Width + 12;

        Item := FOwner.GetListItemDrawable('T');
        Item.PlaceOffset.X := -Offset;
        Item.Align := TListItemAlign.Trailing;
        TListItemText(Item).TextAlign := TTextAlign.Trailing;
        Item.Width := Width;

        PlaceOffset.X := -Offset;
      end;
  end;
  Result := Offset;
end;

{ TMessageImageItem }

constructor TMessageImageItem.Create(const AOwner: TListItem);
begin
  inherited;
  FMessageType := TMessageType.mtImage;
end;

destructor TMessageImageItem.Destroy;
begin
  FMessageImage.Free;
  inherited;
end;

procedure TMessageImageItem.DoMessageImageChanged(Sender: TObject);
begin
  FIsNeedUpItemSize:=True;
  Invalidate;
end;

function TMessageImageItem.GetMessageImage: TBitMap;
begin
  if FMessageImage = nil then
  begin
    FMessageImage := TBitMap.Create(0, 0);
    FMessageImage.OnChange := DoMessageImageChanged;
  end;
  Result := FMessageImage;
end;

function TMessageImageItem.GetScale(MaxWidth: Single): Single;
begin

  if FMessageImage.Width < MaxWidth then
    Result := 1
  else
    Result := MaxWidth / FMessageImage.Width;

end;

procedure TMessageImageItem.Render(const Canvas: TCanvas;
  const DrawItemIndex: Integer; const DrawStates: TListItemDrawStates;
  const Resources: TListItemStyleResources;
  const Params: TListItemDrawable.TParams; const SubPassNo: Integer = 0);
var
  ARect: TRectF;
  BitMap: TBitMap;
begin
  if (SubPassNo <> 0) or (FMessageImage = nil) or (FMessageImage.Width = 0) or
    (FMessageImage.Height = 0) then
    Exit;
  UpdateSizes;
  // 获取图片的Rect
  case FMessageAlign of
    maLeft:
      begin
        ARect.Left := LocalRect.Left + 4;
      end;
    maRight:
      begin
        ARect.Left := LocalRect.Right - FItemRect.Width - 8;
      end;
  end;
  ARect.Top := LocalRect.Top ;
  ARect.Width := FItemRect.Width;
  ARect.Height := FItemRect.Height;

  DrawFrameLine(Canvas, ARect);
  // Draw Background
  {
  BitMap := TBitMap.Create;
  try
    case FMessageAlign of
      maLeft:
        begin
          BitMap.Assign(FLeftBackground);
          BitMap.FlipHorizontal;
        end;
      maRight:
        BitMap.Assign(FRightBackground);
    end;
    if (BitMap.Width <> 0) and (BitMap.Height <> 0) then
    begin
      Canvas.DrawBitmapCapInsets(BitMap, TRectF.Create(Trunc(ARect.Left) - 16,
        Trunc(ARect.Top) - 16, Round(ARect.Right) + 16,
        Round(ARect.Bottom) + 16), TRectF.Create(28, 23, 28, 23), 1, False);
    end
    else
    begin
      Canvas.Fill.Color := $FFE0E0E0;
      Canvas.FillRect(TRectF.Create(ARect.Left - 8, ARect.Top - 8,
        ARect.Right + 8, ARect.Bottom + 8), 4, 4, AllCorners, Opacity);
    end;
  finally
    BitMap.Free;
  end;
  }
  // Draw Image
 Canvas.Fill.Kind:=TBrushKind.Bitmap;
 Canvas.Fill.Bitmap.WrapMode:=TWrapMode.TileStretch;
 Canvas.Fill.Bitmap.Bitmap.Assign(FMessageImage);
 Canvas.FillRect(ARect, 4, 4, AllCorners, 1, Canvas.Fill, TCornerType.Round);
//  Canvas.DrawBitmap(FMessageImage, TRectF.Create(0, 0, FMessageImage.Width,
//    FMessageImage.Height), ARect, 1, True);

end;

procedure TMessageImageItem.SetItemSize;
var
  Canvas: TCanvas;
  AScale, ClientWidth, ARectWidth: Single;
begin
  if (FOwner <> nil) and (FOwner.Controller <> nil) then
  begin
    Canvas := TListViewBase(FOwner.Controller).Canvas;
    ClientWidth := Canvas.Width / 2;
    AScale := GetScale(ClientWidth);
    ARectWidth := FMessageImage.Width * AScale;
    FItemRect.Top := 0;
    FItemRect.Left := 0;
    FItemRect.Width := ARectWidth;
    FItemRect.Height := FMessageImage.Height * AScale;
  end;
end;

procedure TMessageImageItem.SetMessageImage(const Value: TBitMap);
begin
  if (FMessageImage = nil) and (Value <> nil) then
  begin
    FMessageImage := TBitMap.Create(0, 0);
    FMessageImage.OnChange := DoMessageImageChanged;
    Invalidate;
  end;
  if (FMessageImage <> nil) then
    FMessageImage.Assign(Value);
end;

{ TMessageListItemDeleteAppearance }

constructor TMessageListItemDeleteAppearance.Create(const Owner: TControl);
begin
  inherited;
  GlyphButton.DefaultValues.ButtonType := cDefaultGlyph;
  GlyphButton.DefaultValues.Visible := True;
  GlyphButton.RestoreDefaults;
end;

{ TMessageListItemShowCheckAppearance }

constructor TMessageListItemShowCheckAppearance.Create(const Owner: TControl);
begin
  inherited;
  GlyphButton.DefaultValues.ButtonType := cDefaultGlyph;
  GlyphButton.DefaultValues.Visible := True;
  GlyphButton.RestoreDefaults;
end;

{ TMessageVoiceItem }

constructor TMessageVoiceItem.Create(const AOwner: TListItem);
begin
  inherited;
  FMessageType := TMessageType.mtVoice;
  FVoicePath := TPathData.Create;
  FVoicePosition := mv0;
  FVoiceSec := 0;
  FIsRead := False;
  FEndbled := False;
end;

destructor TMessageVoiceItem.Destroy;
begin
  FVoicePath.Free;
  inherited;
end;

function TMessageVoiceItem.GetEnabled: Boolean;
begin
  Result := FEndbled;
end;

procedure TMessageVoiceItem.Paly;
begin
  if not FIsRead then
    FIsRead:=False;
end;

procedure TMessageVoiceItem.Render(const Canvas: TCanvas;
  const DrawItemIndex: Integer; const DrawStates: TListItemDrawStates;
  const Resources: TListItemStyleResources;
  const Params: TListItemDrawable.TParams; const SubPassNo: Integer = 0);
var
  ClientWidth: Single;
  ARect: TRectF;
  BitMap: TBitMap;
begin
  if (SubPassNo <> 0) or (FVoiceSec = 0) then
    Exit;
  UpdateSizes;
  // 计算 语音长度  每秒增加 20像素
  case FMessageAlign of
    maLeft:
      begin
        ARect.Left := LocalRect.Left + 8;
      end;
    maRight:
      begin
        ARect.Left := LocalRect.Right - FItemRect.Width - 16;
      end;
  end;
  ARect.Top := LocalRect.Top +1;
  ARect.Width := FItemRect.Width;
  ARect.Height := 24;

  DrawFrameLine(Canvas, ARect);
  // Draw Background

  BitMap := TBitMap.Create;
  try
    case FMessageAlign of
      maLeft:
        begin
          BitMap.Assign(FLeftBackground);
          //BitMap.FlipHorizontal;
        end;
      maRight:
        begin
          BitMap.Assign(FRightBackground);
        end;
    end;
    if (BitMap.Width <> 0) and (BitMap.Height <> 0) then
    begin
//      Canvas.DrawBitmapCapInsets(BitMap, TRectF.Create(ARect.Left - 12, ARect.Top - 8,
//        ARect.Right + 8, ARect.Bottom + 8), TRectF.Create(24, 24, 6, 6), 1, False);
//      Canvas.DrawBitmapCapInsets(BitMap, TRectF.Create(ARect.Left - 12, ARect.Top - 8,
//        ARect.Right + 8, ARect.Bottom + 8), TRectF.Create(24, 24, 6, 6), 1, False);
      Canvas.DrawBitmapCapInsets1(BitMap, TRectF.Create(ARect.Left - 12, ARect.Top - 8,
        ARect.Right + 8, ARect.Bottom + 8), TRectF.Create(24*Canvas.Scale, 24*Canvas.Scale, 6*Canvas.Scale, 6*Canvas.Scale), 1);
    end
    else
    begin
      Canvas.Fill.Kind:=TBrushKind.Solid;
      Canvas.Fill.Color := $FFE0E0E0;
      Canvas.FillRect(ARect, 4, 4, AllCorners, Opacity);
    end;
  finally
    BitMap.Free;
  end;

  // Draw path 3
  case FVoicePosition of
    mv0, mv3:
      begin
        FVoicePath.Data :=MvPath3+ MvPath2+ MvPath1 ;
        ClientWidth := 12;
      end;
    mv1:
      begin
        FVoicePath.Data := MvPath1;
        ClientWidth := 4;
      end;
    mv2:
      begin
        FVoicePath.Data := MvPath2 + MvPath1;
        ClientWidth := 8;
      end;
  end;
  case FMessageAlign of
    maLeft:
      begin
        FVoicePath.ApplyMatrix(TMatrix.CreateRotation(-135));
        FVoicePath.FitToRect(TRectF.Create(ARect.Left, ARect.Top ,
          ARect.Left + ClientWidth, ARect.Bottom ));
      end;
    maRight:
      begin
        FVoicePath.ApplyMatrix(TMatrix.CreateRotation(0));
        FVoicePath.FitToRect(TRectF.Create(ARect.Right - ClientWidth, ARect.Top ,
          ARect.Right, ARect.Bottom));
      end;
  end;
  Canvas.Fill.Kind:=TBrushKind.Solid;
  Canvas.Fill.Color := $1B000000;
  Canvas.Stroke.Color := $1B000000;
  Canvas.FillPath(FVoicePath, 1);
  Canvas.DrawPath(FVoicePath, 1);

  // Draw VoiceSec
  Canvas.Font.Size := 13;
  Canvas.Fill.Color := $FF747474;
  ARect.Top:= ARect.Bottom - 10;
  ARect.Height:=16;
  case FMessageAlign of
    maLeft:
      begin
        ARect.Left := ARect.Right + 16;
        ARect.Right := LocalRect.Right;
        Canvas.FillText(ARect, floatToStr(FVoiceSec) + '"', False, 1, [],
          TTextAlign.Leading, TTextAlign.Center);
      end;
    maRight:
      begin
        ARect.Right := ARect.Left - 16;
        ARect.Left := 0;
        Canvas.FillText(ARect, floatToStr(FVoiceSec) + '"', False, 1, [],
          TTextAlign.Trailing, TTextAlign.Center);
      end;
  end;

  {
  // Draw mark
  if not FIsRead then
  begin
    case FMessageAlign of
      maLeft:
        ARect.Left := ARect.Left - 32;
      maRight:
        ARect.Left := ARect.Right + 22;
    end;
    ARect.Width := 10;
    ARect.Height := 10;
    Canvas.Fill.Color := TAlphaColors.Red;
    Canvas.FillRect(ARect, 5, 5, AllCorners, 1, TCornerType.Round);
  end;
 }

   // Draw mark
  if not FIsRead then
  begin
    ARect.Top:=LocalRect.Top - 4;
    ARect.Width := 8;
    ARect.Height := 8;
    Canvas.Fill.Color := TAlphaColors.Red;
    Canvas.FillRect(ARect, 4, 4, AllCorners, 1, TCornerType.Round);
  end;
end;

procedure TMessageVoiceItem.SetEndbled(const Value: Boolean);
begin
  if Value <> FEndbled then
  begin
    FEndbled := Value;
    if FEndbled then
    begin
      FVoicePosition := mv1;
      FIsRead := True;
    end
    else
      FVoicePosition := mv0;
    Invalidate;
  end;
end;

procedure TMessageVoiceItem.SetIsRead(const Value: Boolean);
begin
  if Value <> FIsRead then
  begin
    FIsRead := Value;
    Invalidate;
  end;
end;

procedure TMessageVoiceItem.SetItemSize;
var
  Canvas: TCanvas;
  ClientWidth, ARectWidth: Single;
begin

  if (FOwner <> nil) and (FOwner.Controller <> nil) then
  begin
    Canvas := TListViewBase(FOwner.Controller).Canvas;
    ClientWidth := Canvas.Width / 2;
    ARectWidth := Max(MinWidth, 20 * FVoiceSec);
    ARectWidth := Min(ClientWidth, ARectWidth);

    FItemRect.Top := 0;
    FItemRect.Left := 0;
    FItemRect.Width := ARectWidth;
    FItemRect.Height := 24;
  end;

end;

procedure TMessageVoiceItem.SetVoicePosition(const Value: TMessageVoice);
begin
  if FVoicePosition <> Value then
  begin
    FVoicePosition := Value;
    Invalidate;
  end;
end;

procedure TMessageVoiceItem.SetVoiceSec(const Value: Single);
begin
  if Value <> FVoiceSec then
  begin
    FVoiceSec := Value;
    Invalidate;
  end;
end;

procedure TMessageVoiceItem.Stop;
begin

end;

{ TMessageCustomObjectAppearance }

destructor TMessageCustomObjectAppearance.Destroy;
begin
  FLeftNotify.Free;
  FRightNotify.Free;
  inherited;
end;

function TMessageCustomObjectAppearance.FindMessageCustomObject
  (const AListViewItem: TListViewItem): TMessageCustomItem;
var
  LObject: TListItemDrawable;
begin
  for LObject in AListViewItem.Objects.ViewList do
    if (LObject is TMessageCustomItem) and LObject.Visible then
      Exit(TMessageCustomItem(LObject));
  Result := nil;
end;

procedure TMessageCustomObjectAppearance.ResetObject(const AListViewItem
  : TListViewItem);
var
  LObject: TMessageCustomItem;
begin
  LObject := FindMessageCustomObject(AListViewItem);
  if LObject <> nil then
    LObject.UpdateSizes;
end;

procedure TMessageCustomObjectAppearance.SetLeftBackground(const Value: TImage);
begin
  if FLeftBackground <> Value then
  begin
    if FLeftNotify = nil then
    begin
      FLeftNotify := TNotify.Create(nil);
      FLeftNotify.FOwner := Self;
    end;
    if FLeftBackground <> nil then
      FLeftBackground.RemoveFreeNotification(FLeftNotify);
    FLeftBackground := Value;
    if FLeftBackground <> nil then
      FLeftBackground.FreeNotification(FLeftNotify);
  end;
end;

procedure TMessageCustomObjectAppearance.SetRightBackground
  (const Value: TImage);
begin
  if FRightBackground <> Value then
  begin
    if FRightNotify = nil then
    begin
      FRightNotify := TNotify.Create(nil);
      FRightNotify.FOwner := Self;
    end;
    if FRightBackground <> nil then
      FRightBackground.RemoveFreeNotification(FRightNotify);
    FRightBackground := Value;
    if FRightBackground <> nil then
      FRightBackground.FreeNotification(FRightNotify);
  end;
end;

{ TMessageCustomObjectAppearance.TNotify }

procedure TMessageCustomObjectAppearance.TNotify.Notification
  (AComponent: TComponent; Operation: TOperation);
begin
  inherited;
  if Operation = TOperation.opRemove then
  begin
    if AComponent = FOwner.LeftBackground then
      FOwner.LeftBackground := nil;
    if AComponent = FOwner.RightBackground then
      FOwner.RightBackground := nil;
  end;
end;

{ TMessageVoiceObjectAppearance }

procedure TMessageVoiceObjectAppearance.AssignTo(ADest: TPersistent);
var
  DstDrawable: TMessageVoiceItem;
  DstAppearance: TMessageVoiceObjectAppearance;
begin
  if ADest is TMessageVoiceObjectAppearance then
  begin
    DstAppearance := TMessageVoiceObjectAppearance(ADest);
    DstAppearance.BeginUpdate;
    try
      DstAppearance.FLeftBackground := Self.FLeftBackground;
      DstAppearance.FRightBackground := Self.FRightBackground;
      inherited AssignTo(ADest);
    finally
      DstAppearance.EndUpdate;
    end;
  end
  else if ADest is TMessageVoiceItem then
  begin
    DstDrawable := TMessageVoiceItem(ADest);
    DstDrawable.BeginUpdate;
    try
      if Self.FLeftBackground <> nil then
        DstDrawable.LeftBackground := Self.FLeftBackground.BitMap
      else
        DstDrawable.LeftBackground := nil;

      if Self.FRightBackground <> nil then
        DstDrawable.RightBackground := Self.FRightBackground.BitMap
      else
        DstDrawable.RightBackground := nil;
      inherited AssignTo(ADest);
    finally
      DstDrawable.EndUpdate;
    end;
  end
  else
    inherited;

end;

procedure TMessageVoiceObjectAppearance.CreateObject(const AListViewItem
  : TListViewItem);
var
  LItem: TMessageVoiceItem;
begin
  LItem := TMessageVoiceItem.Create(AListViewItem);
  LItem.BeginUpdate;
  try
    LItem.Assign(Self);
    LItem.Name := Name;
  finally
    LItem.EndUpdate;
  end;

end;

const
  sThisUnit = 'FMX.MessageAppearance';

  { TMessageVideoItem }

constructor TMessageVideoItem.Create(const AOwner: TListItem);
begin
  inherited;
  FMessageType := TMessageType.mtVideo;
end;

{ TMessageVideoObjectAppearance }

procedure TMessageVideoObjectAppearance.AssignTo(ADest: TPersistent);
var
  DstDrawable: TMessageVideoItem;
  DstAppearance: TMessageVideoObjectAppearance;
begin
  if ADest is TMessageVideoObjectAppearance then
  begin
    DstAppearance := TMessageVideoObjectAppearance(ADest);
    DstAppearance.BeginUpdate;
    try
      DstAppearance.FLeftBackground := Self.FLeftBackground;
      DstAppearance.FRightBackground := Self.FRightBackground;
      inherited AssignTo(ADest);
    finally
      DstAppearance.EndUpdate;
    end;
  end
  else if ADest is TMessageVideoItem then
  begin
    DstDrawable := TMessageVideoItem(ADest);
    DstDrawable.BeginUpdate;
    try
      if Self.FLeftBackground <> nil then
        DstDrawable.LeftBackground := Self.FLeftBackground.BitMap
      else
        DstDrawable.LeftBackground := nil;
      if Self.FRightBackground <> nil then
        DstDrawable.RightBackground := Self.FRightBackground.BitMap
      else
        DstDrawable.RightBackground := nil;
      inherited AssignTo(ADest);
    finally
      DstDrawable.EndUpdate;
    end;
  end
  else
    inherited;

end;

procedure TMessageVideoObjectAppearance.CreateObject(const AListViewItem
  : TListViewItem);
var
  LItem: TMessageVideoItem;
begin
  LItem := TMessageVideoItem.Create(AListViewItem);
  LItem.BeginUpdate;
  try
    LItem.Assign(Self);
    LItem.Name := Name;
  finally
    LItem.EndUpdate;
  end;

end;

{ TMessageFileItem }

constructor TMessageFileItem.Create(const AOwner: TListItem);
begin
  inherited;
  FMessageType := TMessageType.mtFile;
end;

{ TMessageFileObjectAppearance }

procedure TMessageFileObjectAppearance.AssignTo(ADest: TPersistent);
var
  DstDrawable: TMessageFileItem;
  DstAppearance: TMessageFileObjectAppearance;
begin
  if ADest is TMessageFileObjectAppearance then
  begin
    DstAppearance := TMessageFileObjectAppearance(ADest);
    DstAppearance.BeginUpdate;
    try
      DstAppearance.FLeftBackground := Self.FLeftBackground;
      DstAppearance.FRightBackground := Self.FRightBackground;
      inherited AssignTo(ADest);
    finally
      DstAppearance.EndUpdate;
    end;
  end
  else if ADest is TMessageFileItem then
  begin
    DstDrawable := TMessageFileItem(ADest);
    DstDrawable.BeginUpdate;
    try
      if Self.FLeftBackground <> nil then
        DstDrawable.LeftBackground := Self.FLeftBackground.BitMap
      else
        DstDrawable.LeftBackground := nil;
      if Self.FRightBackground <> nil then
        DstDrawable.RightBackground := Self.FRightBackground.BitMap
      else
        DstDrawable.RightBackground := nil;
      inherited AssignTo(ADest);
    finally
      DstDrawable.EndUpdate;
    end;
  end
  else
    inherited;

end;

procedure TMessageFileObjectAppearance.CreateObject(
  const AListViewItem: TListViewItem);
var
  LItem: TMessageFileItem;
begin
  LItem := TMessageFileItem.Create(AListViewItem);
  LItem.BeginUpdate;
  try
    LItem.Assign(Self);
    LItem.Name := Name;
  finally
    LItem.EndUpdate;
  end;

end;

initialization

TAppearancesRegistry.RegisterAppearance(TMessageListItemAppearance,
  TMessageListItemAppearanceNames.ListItem, [TRegisterAppearanceOption.Item],
  sThisUnit);

finalization

TAppearancesRegistry.UnregisterAppearances
  (TArray<TItemAppearanceObjectsClass>.Create(TMessageListItemAppearance));

end.
