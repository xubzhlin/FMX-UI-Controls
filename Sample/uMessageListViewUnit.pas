unit uMessageListViewUnit;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  uCustomBaseFrame, FMX.Objects, FMX.Controls.Presentation, FMX.Layouts,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView, System.ImageList, FMX.ImgList;

type
  TListView = class(FMX.ListView.TListView)
  protected
    procedure ApplyStyle; override;
    function GetItemHeight(const Index: Integer): Integer; override;
  end;

  TfrmMessageListView = class(TfrmBaseFrame)
    lstChat: TListView;
    Image1: TImage;
    Image2: TImage;
    ImageList1: TImageList;
    procedure lstChatItemClickEx(const Sender: TObject; ItemIndex: Integer;
      const LocalClickPos: TPointF; const ItemObject: TListItemDrawable);
    procedure btnBackClick(Sender: TObject);
  private
    { Private declarations }
    procedure DoAfterBack(Sender:TObject); override;
    procedure DoAfterShow(Sender:TObject); override;
  public
    { Public declarations }
  end;

var
  frmMessageListView: TfrmMessageListView;

implementation

uses
  FMX.MessageAppearance;

{$R *.fmx}

{ TfrmMessageListView }

procedure TfrmMessageListView.btnBackClick(Sender: TObject);
begin
  Back;

end;

procedure TfrmMessageListView.DoAfterBack(Sender: TObject);
begin
  lstChat.Items.Clear;
  inherited;

end;

procedure TfrmMessageListView.DoAfterShow(Sender: TObject);
var
  ObjectAppearance:TCommonObjectAppearance;
  Item:TMessageListViewItem;
begin
  inherited;
  lstChat.ItemAppearanceName := TMessageListItemAppearanceNames.ListItem;
  for ObjectAppearance in lstChat.ItemAppearanceObjects.ItemObjects.Objects do
  begin
    if (ObjectAppearance is TMessageTextObjectAppearance) or
      (ObjectAppearance is TMessageVoiceObjectAppearance) then
    begin
      TMessageTextObjectAppearance(ObjectAppearance).LeftBackground:=Image1;
      TMessageTextObjectAppearance(ObjectAppearance).RightBackground:=Image2;
    end;
  end;

  Item:=TMessageListViewItem(lstChat.Items.Add);
  Item.MessageAlign:=TMessageAlign.maLeft;
  Item.ImageIndex:=0;
  Item.MessageText:='This is Message';

  Item:=TMessageListViewItem(lstChat.Items.Add);
  Item.MessageAlign:=TMessageAlign.maRight;
  Item.ImageIndex:=1;
  Item.MessageImage:=Imagelist1.Bitmap(TSize.Create(40, 40), 0);
  Item.FileName:='';  //File Path

  Item:=TMessageListViewItem(lstChat.Items.Add);
  Item.MessageAlign:=TMessageAlign.maLeft;
  Item.ImageIndex:=0;
  Item.MessageVoiceSec:=5;
  Item.MessageVoiceIsRead:=False;
  Item.FileName:='';  //File Path

  Item:=TMessageListViewItem(lstChat.Items.Add);
  Item.MessageAlign:=TMessageAlign.maLeft;
  Item.ImageIndex:=0;
  Item.MessageVoiceSec:=8;
  Item.MessageVoiceIsRead:=True;
  Item.FileName:='';  //File Path

  Item:=TMessageListViewItem(lstChat.Items.Add);
  Item.MessageAlign:=TMessageAlign.maRight;
  Item.ImageIndex:=1;
  Item.MessageVideoImage:=Imagelist1.Bitmap(TSize.Create(40, 40), 1);
  Item.FileName:='';  //File Path

  Item:=TMessageListViewItem(lstChat.Items.Add);
  Item.MessageAlign:=TMessageAlign.maRight;
  Item.ImageIndex:=1;
  Item.MessageFileImage:=Imagelist1.Bitmap(TSize.Create(40, 40), 1);
  Item.FileName:='';  //File Path
end;

procedure TfrmMessageListView.lstChatItemClickEx(const Sender: TObject;
  ItemIndex: Integer; const LocalClickPos: TPointF;
  const ItemObject: TListItemDrawable);
var
  AMsgItem:TMessageListViewItem;
  AImageItem:TMessageImageItem;
  ASize:TSize;
  ASounds,AEm:integer;
begin
  if ItemObject is TMessageVideoItem then
  begin
    if not TMessageVideoItem(ItemObject).InItemRect(LocalClickPos) then
      Exit;
    AMsgItem := TMessageListViewItem(lstChat.Items.Item[ItemIndex]);

    if AMsgItem.FileName.Length >0 then
    begin
      //Open Video File : AMsgItem.FileName
    end;
  end
  else
  if ItemObject is TMessageImageItem then
  begin
    if not TMessageImageItem(ItemObject).InItemRect(LocalClickPos) then
      Exit;
    AMsgItem := TMessageListViewItem(lstChat.Items.Item[ItemIndex]);
    if AMsgItem.FileName.Length >0 then
    begin
      //Open Image File £ºAMsgItem.FileName
    end;
  end
  else
  if ItemObject is TMessageVoiceItem then
  begin
    if not TMessageVoiceItem(ItemObject).InItemRect(LocalClickPos) then
      Exit;
    AMsgItem := TMessageListViewItem(lstChat.Items.Item[ItemIndex]);

    if AMsgItem.FileName.Length >0 then
    begin
      //Open Voice File : AMsgItem.FileName
    end;
    AMsgItem.MessageVoiceIsRead := True;
  end else
  if ItemObject is TListItemImage then
  begin
    AMsgItem := TMessageListViewItem(lstChat.Items.Item[ItemIndex]);
    //Open User Info
  end;
end;

{ TListView }

procedure TListView.ApplyStyle;
var
  StyleObject: TFmxObject;
begin

  StyleObject := Self.FindStyleResource('frame');
  if StyleObject is TColorObject then
    TColorObject(StyleObject).Color := $FFEBEBEB;

  StyleObject := Self.FindStyleResource('background');
  if StyleObject is TColorObject then
    TColorObject(StyleObject).Color := $FFEBEBEB;

  StyleObject := Self.FindStyleResource('itembackground');
  if StyleObject is TColorObject then
    TColorObject(StyleObject).Color := $FFEBEBEB;
  inherited;
end;

function TListView.GetItemHeight(const Index: Integer): Integer;
var
  Item: TListItem;
begin
  if (Index < 0) or (Index >= Adapter.Count) then
    Exit(0);
  Item := Adapter[Index];
  if ItemAppearance.ItemAppearance = 'MessageListItem' then
    Result := Round(TMessageListViewItem(Item).GetRelHeight)
  else
    Result := Item.Height;
  if Result < 1 then
    case Item.Purpose of
      TListItemPurpose.None:
        if EditMode then
          Result := ItemEditHeight
        else
          Result := ItemHeight;
      TListItemPurpose.Header:
        Result := HeaderHeight;
      TListItemPurpose.Footer:
        Result := FooterHeight;
    else
      Assert(False);
    end;

end;

end.
