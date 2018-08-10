unit vkbdhelper;

{
  Force focused control visible when Android Virtual Keyboard showed or hiden
  How to use:
  place vkdbhelper into your project uses section.No more code needed.

  Changes
  =======
  2016.4.15
  + Add support for iOS

  2016.4.14
  + Add support for TMemo

  2016.1.16
  * Remove the timer for fast response(Use Idle message replace)
  * Fix a bug when a focus control reshow virtualkeyboard(Thanks 似水流年)
  * Fix a bug when use hide virtual keyboard by use hardware back key(Thanks 阿笨猫)
  * Fix a FMX bug :after virtual keyboard shown,can't use hardware back key to exit app
  2016.1.8
  * Fix a bug when user switch to other app
  2015.7.12
  * Fix space after hide ime and rotate
  * Fix rotate detection

}
interface

uses classes, sysutils, math, System.Types, System.Messaging, FMX.Types,
  FMX.Controls, System.Rtti,
  FMX.Layouts, FMX.text, FMX.scrollbox, FMX.VirtualKeyboard, FMX.Forms,
  FMX.Platform, typinfo
{$IFDEF ANDROID}, FMX.Platform.Android, FMX.Helpers.Android,
  FMX.VirtualKeyboard.Android, Androidapi.JNI.GraphicsContentViewText,
  Androidapi.JNI.Embarcadero {$ENDIF}
{$IFDEF IOS}
    , Macapi.Helpers, FMX.Platform.iOS, FMX.VirtualKeyboard.iOS,
  iOSapi.Foundation, iOSapi.UIKit
{$ENDIF}
    ;

type
  TVKVisibleChanged = procedure(Sender: TObject; OffSet: Single;
    var DefaultControl: TFmxObject) of Object;
  TVKStateHandler = class(TComponent)
  private
    FOnVKWillVisible: TVKVisibleChanged; //
    FOnVKWillDisVisble:TNotifyEvent;
  protected
    FVKMsgId: Integer; // TVKStateChangeMessage 消息的订阅ID
    FSizeMsgId: Integer; // TSizeChangedMessage 消息的订阅ID
    FIdleMsgId: Integer;
    FCurreControl: TControl;
    FLastControl: TControl; // 最后一次调整的ScrollBox

    FLastMargin: TPointF; // 原始缩进
    FLastAlign: TAlignLayout; // 原始对齐
    FLastBounds: TRectF; // 原始位置

    procedure DoVKVisibleChanged(const Sender: TObject;
      const Msg: System.Messaging.TMessage);
    procedure DoSizeChanged(const Sender: TObject;
      const Msg: System.Messaging.TMessage);
    procedure DoAppIdle(const Sender: TObject;
      const Msg: System.Messaging.TMessage);
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    procedure AdjustCtrl(ACtrl: TControl; AVKBounds, ACtrlBounds: TRectF;
      AVKVisible: Boolean; const DefaultAdjust:Boolean = False);
  public
    constructor Create(AOwner: TComponent); overload; override;
    destructor Destroy; override;
    procedure HideVirtualKeyboard;
    function NeedAdjust(ACtrl: TControl; var ACaretRect: TRectF; const DefaultAdjust:Boolean = False): Boolean;
    property OnVKWillVisible: TVKVisibleChanged read FOnVKWillVisible
      write FOnVKWillVisible;
    property OnVKWillDisVisble: TNotifyEvent read FOnVKWillDisVisble
      write FOnVKWillDisVisble;
  end;

var

  VKHandler: TVKStateHandler;

implementation

{$IFDEF ANDROID}

function GetVKBounds(var ARect: TRect): Boolean; overload;
var
  ContentRect, TotalRect: JRect;
begin
  ContentRect := TJRect.Create;
  TotalRect := TJRect.Create;
  MainActivity.getWindow.getDecorView.getWindowVisibleDisplayFrame(ContentRect);
  MainActivity.getWindow.getDecorView.getDrawingRect(TotalRect);
  Result := TotalRect.Bottom <> ContentRect.Bottom;
  if Result then
  begin
    ARect.Left := TotalRect.Left;
    ARect.Top := ContentRect.Bottom;
    ARect.Right := TotalRect.Right;
    ARect.Bottom := TotalRect.Bottom;
  end;
end;

function GetVKBounds: TRectF; overload;
var
  ContentRect, TotalRect: JRect;
begin
  ContentRect := TJRect.Create;
  TotalRect := TJRect.Create;
  MainActivity.getWindow.getDecorView.getWindowVisibleDisplayFrame(ContentRect);
  MainActivity.getWindow.getDecorView.getDrawingRect(TotalRect);
  Result := TRectF.Create(ConvertPixelToPoint(TPointF.Create(TotalRect.Left,
    TotalRect.Top + ContentRect.height)),
    ConvertPixelToPoint(TPointF.Create(TotalRect.Right, TotalRect.Bottom)));
end;
{$ELSE}
{$IFDEF IOS}

var
  _IOS_VKBounds: TRectF;

function GetVKBounds: TRectF; overload;
var
  ATop: Integer;
begin
  Result := _IOS_VKBounds;
  ATop := Screen.WorkAreaTop;
  Result.Top := Result.Top - ATop;
  Result.Bottom := Result.Bottom - ATop;
end;

function GetVKBounds(var ARect: TRect): Boolean; overload;
var
  ATemp: TRectF;
  AService: IFMXScreenService;
  AScale: Single;
begin
  ATemp := GetVKBounds;
  Result := not ATemp.IsEmpty;
  if Result then
  begin
    if TPlatformServices.Current.SupportsPlatformService(IFMXScreenService,
      AService) then
    begin
      AScale := AService.GetScreenScale;
      ARect.Left := Trunc(ATemp.Left * AScale);
      ARect.Top := Trunc(ATemp.Top * AScale);
      ARect.Right := Trunc(ATemp.Right * AScale);
      ARect.Bottom := Trunc(ATemp.Bottom * AScale);
    end;
  end;
end;

{$ENDIF}
{$ENDIF}

/// 根据MainActivity的可视区域和绘图区域大小来确定是否显示了虚拟键盘
function IsVKVisible: Boolean;
var
  R: TRect;
begin
  Result := GetVKBounds(R);
end;

{ TVKStateHandler }
procedure TVKStateHandler.AdjustCtrl(ACtrl: TControl;
  AVKBounds, ACtrlBounds: TRectF; AVKVisible: Boolean
  ;const DefaultAdjust:Boolean = False);
var
  ATarget, ACaretRect: TRectF;
  // 移动指定父上的子对象到新的父对象
  procedure MoveCtrls(AOldParent, ANewParent: TFmxObject);
  var
    I: Integer;
    AChild: TFmxObject;
  begin
    I := 0;
    while I < AOldParent.ChildrenCount do
    begin
      AChild := AOldParent.Children[I];
      if AChild <> ANewParent then
      begin
        if AChild.Parent = AOldParent then
        begin
          AChild.Parent := ANewParent;
          Continue;
        end;
      end;
      Inc(I);
    end;
  end;

  procedure AdjustByLayout(ARoot: TFmxObject; AOffset: Single);
  var
    ALayout: TLayout;
  begin
    if (ARoot.ChildrenCount = 1) and (ARoot.Children[0] is TLayout) then
    // 多于1个，说明没有添加Layout
    begin
      ALayout := ARoot.Children[0] as TLayout;
      if ALayout.Align <> TAlignLayout.None then
      begin
        FLastAlign := ALayout.Align;
      end;
      FLastBounds := ALayout.BoundsRect;
      FLastMargin.y := ALayout.Position.y;
      FLastMargin.x := ALayout.Position.x;
      ALayout.Align := TAlignLayout.None;
    end
    else
    begin
      ALayout := TLayout.Create(ARoot);
      ALayout.Parent := ARoot;
      ALayout.TagObject := Self;
      MoveCtrls(ARoot, ALayout);
      FLastMargin.y := 0;
      FLastMargin.x := 0;
      FLastAlign := TAlignLayout.Client;
      FLastBounds := TRectF.Create(0, 0, 0, 0);
    end;
    if ARoot is TForm then
    begin
      if (TForm(ARoot).width <> ALayout.width) or
        (TForm(ARoot).height <> ALayout.height) then
        ALayout.SetBounds(0, 0, TForm(ARoot).width, TForm(ARoot).height);
    end;
    // 如果没有滚动框，就加一个Layout，然后再将所有的元素移动到这个Layout上
    if ALayout.Position.y + AOffset > 0 then
      ALayout.Position.y := 0
    else
      ALayout.Position.y := ALayout.Position.y + AOffset;
    if FLastControl <> ALayout then
    begin
      if Assigned(FLastControl) then
        FLastControl.RemoveFreeNotification(Self);
      FLastControl := ALayout;
      FLastControl.FreeNotification(Self);
    end;
  end;
  function AdjustByScrollBox(AScrollBox: TCustomScrollBox): Boolean;
  var
    AParentBounds: TRectF;
    AOffset: Single;
  begin
    AParentBounds := AScrollBox.AbsoluteRect;
    Result := AParentBounds.Contains(ACaretRect);
    if Result then
    begin
      with AScrollBox.ViewportPosition do
        AOffset := y + AVKBounds.Top - ACaretRect.Bottom;
      if (FLastControl <> AScrollBox) then
      begin
        if Assigned(FLastControl) then
          FLastControl.RemoveFreeNotification(Self);
        FLastMargin.y := AScrollBox.Margins.Bottom;
        FLastMargin.x := AScrollBox.Margins.Left;
        FLastControl := AScrollBox;
        FLastControl.FreeNotification(Self);
      end;
      AScrollBox.Margins.Bottom := AParentBounds.Bottom - AVKBounds.Top;
      // 需要进一步调整客户区内容，以保证它能够调整到指定区域
      AScrollBox.ViewportPosition :=
        TPointF.Create(AScrollBox.ViewportPosition.x,
        AScrollBox.ViewportPosition.y + AOffset);
    end;
  end;

  function AdjustByPresentedScrollBox(AScrollBox
    : TCustomPresentedScrollBox): Boolean;
  var
    AParentBounds: TRectF;
    ALast, AOffset: TPointF;
  begin
    AParentBounds := AScrollBox.AbsoluteRect;
    Result := AParentBounds.Contains(ACaretRect);
    if Result then
    begin
      with AScrollBox.ViewportPosition do
      begin
        AOffset.x := x;
        if ACaretRect.Bottom < AVKBounds.Top then
          AOffset.y := y - ACaretRect.Top
        else
          AOffset.y := y + AVKBounds.Top - ACaretRect.Bottom;
      end;
      // 需要进一步调整客户区内容，以保证它能够调整到指定区域
      ALast := AScrollBox.ViewportPosition;
      AScrollBox.ScrollTo(AOffset.x, AOffset.y);
      Result := (SameValue(ALast.x - AScrollBox.ViewportPosition.x, AOffset.x)
        and SameValue(ALast.y - AScrollBox.ViewportPosition.y, AOffset.y));
      if Result then
      begin
        if (FLastControl <> AScrollBox) then
        begin
          if Assigned(FLastControl) then
            FLastControl.RemoveFreeNotification(Self);
          FLastMargin := AScrollBox.ViewportPosition;
          FLastControl := AScrollBox;
          FLastControl.FreeNotification(Self);
        end;
        AScrollBox.Margins.Bottom := AParentBounds.Bottom - AVKBounds.Top;
      end
      else
      begin
        with AScrollBox.ViewportPosition do
          OffsetRect(ACaretRect, ALast.x - x, ALast.y - y);
        AScrollBox.ViewportPosition := ALast;
      end;
    end;
  end;
/// 将指定的区域移动可视区
  procedure ScrollInToRect;
  var
    AParent, ALastParent: TFmxObject;
    AParentBounds: TRectF;
    AOffset: Single;
    NeedOffSet: Single;
    AHasScrollBox: Boolean;
  begin
    ALastParent := nil;
    AHasScrollBox := False;
    if ACaretRect.Bottom < AVKBounds.Top then
      NeedOffSet := ACaretRect.Bottom - ACtrlBounds.Top
    else
      NeedOffSet := AVKBounds.Top - ACtrlBounds.Bottom;
    ALastParent:=nil;
    if Assigned(FOnVKWillVisible) then
      FOnVKWillVisible(ACtrl, NeedOffSet, ALastParent);
    if not Assigned(ALastParent) then
    begin
      AParent := ACtrl;
      ALastParent := AParent.Parent;
      while Assigned(AParent) do
      begin
        if AParent is TCustomScrollBox then
        // 父有滚动框，则测试能不能滚动
        begin
          AHasScrollBox := True;
          if AdjustByScrollBox(AParent as TCustomScrollBox) then
            Exit;
        end
        else if AParent is TCustomPresentedScrollBox then
        begin
          AHasScrollBox := True;
          if AdjustByPresentedScrollBox(AParent as TCustomPresentedScrollBox)
          then
            Exit;
        end;
        ALastParent := AParent;
        AParent := AParent.Parent;
      end;
      if not AHasScrollBox then
        AdjustByLayout(ALastParent, NeedOffSet);
    end;
    // Fix By Xubzhlin
    { if AHasScrollBox then
      begin
      if ACaretRect.Bottom < AVKBounds.Top then
      AdjustByLayout(ALastParent, Screen.WorkAreaTop - ACaretRect.Top)
      else
      AdjustByLayout(ALastParent, AVKBounds.Top - ACaretRect.Bottom);
      end
      else
      begin
      if ACaretRect.Bottom < AVKBounds.Top then
      AdjustByLayout(ALastParent, ACaretRect.Bottom - ACtrlBounds.Top)
      else
      AdjustByLayout(ALastParent, AVKBounds.Top - ACtrlBounds.Bottom);

      end; }
  end;

  function ComparePos(V1, V2: Single): Integer;
  var
    ADelta: Single;
  begin
    ADelta := V1 - V2;
    if ADelta > 0.0001 then
      Result := 1
    else if ADelta < -0.0001 then
      Result := -1
    else
      Result := 0;
  end;
var
  ALastControl:TFmxObject;
begin
  if AVKVisible then
  begin
    if NeedAdjust(ACtrl, ACaretRect, DefaultAdjust) then
    begin
      ScrollInToRect;
    end
    else
    begin
      if Assigned(FOnVKWillVisible) then
        FOnVKWillVisible(ACtrl, 0, ALastControl);
    end
  end
  else
  begin
    if Assigned(FLastControl) then
    begin
      if (FLastControl is TCustomScrollBox) or
        (FLastControl is TCustomPresentedScrollBox) then
      begin
        FLastControl.Margins.Bottom := FLastMargin.y;
        FLastControl.Margins.Left := FLastMargin.x;
      end
      else
      begin
        if FLastAlign = TAlignLayout.None then
        begin
          FLastControl.Position.y := FLastMargin.y;
          FLastControl.Position.x := FLastMargin.x;
        end
        else
        begin
          FLastControl.BoundsRect := FLastBounds;
          FLastControl.Align := FLastAlign;
        end;
      end;
      FLastControl := nil;
    end;
  end;
end;

// 构造函数，订阅消息
constructor TVKStateHandler.Create(AOwner: TComponent);
var
  KeyboardToolbarService:IFMXVirtualKeyboardToolbarService;
begin
  inherited Create(AOwner);
  if TPlatformServices.Current.SupportsPlatformService(IFMXVirtualKeyboardToolbarService, KeyboardToolbarService) then
  begin
    //隐藏 工具栏
    KeyboardToolbarService.SetHideKeyboardButtonVisibility(False);
    //隐藏 Done
    KeyboardToolbarService.SetToolbarEnabled(False);
  end;
  FVKMsgId := TMessageManager.DefaultManager.SubscribeToMessage
    (TVKStateChangeMessage, DoVKVisibleChanged);
  FSizeMsgId := TMessageManager.DefaultManager.SubscribeToMessage
    (TSizeChangedMessage, DoSizeChanged);
  FIdleMsgId := TMessageManager.DefaultManager.SubscribeToMessage(TIdleMessage,
    DoAppIdle);
end;

/// 析构函数，取消消息订阅
destructor TVKStateHandler.Destroy;
begin
  TMessageManager.DefaultManager.Unsubscribe(TVKStateChangeMessage, FVKMsgId);
  TMessageManager.DefaultManager.Unsubscribe(TSizeChangedMessage, FSizeMsgId);
  TMessageManager.DefaultManager.Unsubscribe(TIdleMessage, FIdleMsgId);
  inherited;
end;

/// 在应用空闲时，检查虚拟键盘是否隐藏或是否覆盖住了当前获得焦点的控件
procedure TVKStateHandler.DoAppIdle(const Sender: TObject;
  const Msg: System.Messaging.TMessage);
{$IFDEF ANDROID}
  procedure FMXAndroidFix;
  var
    AService: IFMXVirtualKeyboardService;
    AVK: TVirtualKeyboardAndroid;
    AListener: TVKListener;
    AContext: TRttiContext;
    AType: TRttiType;
    AField: TRttiField;
  begin
    if TPlatformServices.Current.SupportsPlatformService
      (IFMXVirtualKeyboardService, AService) then
    begin
      AVK := AService as TVirtualKeyboardAndroid;
      AContext := TRttiContext.Create;
      AType := AContext.GetType(AVK.ClassType);
      if Assigned(AType) then
      begin
        AField := AType.GetField('FVKListener');
        if Assigned(AField) then
        begin
          AListener := AField.GetValue(AVK).AsObject as TVKListener;
          AListener.onVirtualKeyboardHidden;
        end;
      end;
      Screen.ActiveForm.Focused := nil;
    end;
  end;

  procedure UpdateAndroidKeyboardServiceState;
  var
    ASvc: IFMXVirtualKeyboardService;
    AContext: TRttiContext;
    AType: TRttiType;
    AField: TRttiField;
    AInst: TVirtualKeyboardAndroid;
  begin
    if (not Assigned(Screen.FocusControl)) and
      TPlatformServices.Current.SupportsPlatformService
      (IFMXVirtualKeyboardService, ASvc) then
    begin
      AInst := ASvc as TVirtualKeyboardAndroid;
      AContext := TRttiContext.Create;
      AType := AContext.GetType(TVirtualKeyboardAndroid);
      AField := AType.GetField('FState');
      if AField.GetValue(AInst).AsOrdinal <> 0 then
        PByte(AInst)[AField.OffSet] := 0;
    end;
  end;
{$ENDIF}
  procedure CheckHidden;
  var
    ACaretRect: TRectF;
    ACtrl: TControl;
  begin
    ACtrl := Screen.FocusControl.GetObject as TControl;
    if Assigned(ACtrl) then
    begin
      if NeedAdjust(ACtrl, ACaretRect, True) then
        AdjustCtrl(ACtrl, GetVKBounds, ACtrl.AbsoluteRect, True, True);
    end;
  end;

begin
  if not IsVKVisible then // 解决掉虚拟键盘隐藏后的问题
  begin
    if Assigned(FLastControl) then
    begin
      TMessageManager.DefaultManager.SendMessage(FLastControl,
        TVKStateChangeMessage.Create(False, TRect.Create(0, 0, 0, 0)));
    end
{$IFDEF ANDROID}
    else
      UpdateAndroidKeyboardServiceState;
{$ENDIF}
  end
  else if Assigned(Screen.FocusControl) then
    CheckHidden;
end;

/// 在横竖屏切换时，处理控件位置
procedure TVKStateHandler.DoSizeChanged(const Sender: TObject;
  const Msg: System.Messaging.TMessage);
var
  ASizeMsg: TSizeChangedMessage absolute Msg;
  R: TRect;
  AScene: IScene;
  AScale: Single;
begin
  if Sender = Screen.ActiveForm then
  begin
    if GetVKBounds(R) then
    begin
      if Assigned(FLastControl) then
      begin
        if FLastControl is TLayout then
        begin
          if FLastControl.TagObject = Self then
          begin
            FLastControl.SetBounds(0, 0, Screen.ActiveForm.width,
              Screen.ActiveForm.height);
          end;
        end
        else //
          TCustomScrollBox(FLastControl).Margins.Bottom := 0;
      end;
      if Supports(Sender, IScene, AScene) then
      begin
        AScale := AScene.GetSceneScale;
        R.Left := Trunc(R.Left / AScale);
        R.Top := Trunc(R.Top / AScale);
        R.Right := Trunc(R.Right / AScale);
        R.Bottom := Trunc(R.Bottom / AScale);
        TMessageManager.DefaultManager.SendMessage(Sender,
          TVKStateChangeMessage.Create(True, R));
      end;
    end
  end;
end;

/// 虚拟键盘可见性变更消息，调整或恢复控件位置
procedure TVKStateHandler.DoVKVisibleChanged(const Sender: TObject;
  const Msg: System.Messaging.TMessage);
var
  AVKMsg: TVKStateChangeMessage absolute Msg;
begin
  if AVKMsg.KeyboardVisible then // 键盘可见
  begin
{$IFDEF IOS}
    _IOS_VKBounds := TRectF.Create(AVKMsg.KeyboardBounds);
{$ENDIF}
    if Screen.FocusControl <> nil then
    begin
      FCurreControl := Screen.FocusControl.GetObject as TControl;
      AdjustCtrl(FCurreControl, GetVKBounds, FCurreControl.AbsoluteRect, True);
    end
  end
  else
  begin
{$IFDEF IOS}
    _IOS_VKBounds := TRectF.Empty;
{$ENDIF}
    if Assigned(FOnVKWillDisVisble) {fix 2017.5.23 and Assigned(FCurreControl)} then
      FOnVKWillDisVisble(FCurreControl);
    FCurreControl:=nil;
    if Assigned(FLastControl) then // 键盘隐藏
      AdjustCtrl(FLastControl, GetVKBounds, FLastControl.AbsoluteRect, False);
    FLastControl:=nil;
  end;
end;

procedure TVKStateHandler.HideVirtualKeyboard;
var
  KeyboardService:IFMXVirtualKeyboardService;
begin
  if TPlatformServices.Current.SupportsPlatformService(IFMXVirtualKeyboardService, KeyboardService) then
  begin
    KeyboardService.HideVirtualKeyboard;
  end;
end;

/// 响应组件释放通知，以避免访问无效地址
function TVKStateHandler.NeedAdjust(ACtrl: TControl;
  var ACaretRect: TRectF; const DefaultAdjust:Boolean = False): Boolean;
var
  ACaret: ICaret;
  ACaretObj: TCustomCaret;
  ACtrlBounds, AVKBounds: TRectF;
  AWorkArea: TRect;
  S: String;
  function GetRootTop: Single;
  var
    ALayout: TLayout;
    AObj: TFmxObject;
  begin
    AObj := ACtrl.Root.GetObject;
    Result := 0;
    if AObj is TForm then
    begin
      if TForm(AObj).ChildrenCount > 0 then
      begin
        AObj := TForm(AObj).Children[0];
        if AObj is TLayout then
        begin
          ALayout := AObj as TLayout;
          Result := ALayout.Position.y;
        end;
      end;
    end;
  end;

begin
  if Supports(ACtrl, ICaret, ACaret) then
  begin
    AVKBounds := GetVKBounds;
    ACtrlBounds := ACtrl.AbsoluteRect;
    ACaretObj := ACaret.GetObject;
    ACaretRect.TopLeft := ACtrl.LocalToAbsolute(ACaretObj.Pos);
    ACaretRect.Right := ACaretRect.Left + ACaretObj.size.cx;
    ACaretRect.Bottom := ACaretRect.Top + ACaretObj.size.cy + 5; // 下面加点余量
    // AWorkArea := Screen.WorkAreaRect;
    // FMX.Memo 依然有问题，向上时
    //Fix By xubzhlin Add DefaultAdjust
    //DefaultAdjust：需要变化
    if DefaultAdjust then
      Result := (AVKBounds.Top - ACtrlBounds.Bottom) < -4;
    if not Result then
      Result := ACaretRect.IntersectsWith(AVKBounds) or (ACaretRect.Top < 0);
  end;
end;

procedure TVKStateHandler.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  if Operation = opRemove then
  begin
    if FLastControl = AComponent then
      FLastControl := nil;
  end;
  inherited;
end;

initialization

// 仅支持Android+IOS
{$IF DEFINED(ANDROID) OR DEFINED(IOS)}
  VKHandler := TVKStateHandler.Create(nil);
{$ENDIF}

finalization

{$IF DEFINED(ANDROID)  OR DEFINED(IOS)}
  FreeAndNil(VKHandler);
{$ENDIF}

end.
