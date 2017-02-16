unit uCustomBaseAniFrame;
//Frame 基类 Frame之间切换动画

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Controls.Presentation, FMX.Layouts, FMX.Ani, FMX.MultiView.Types,
  System.Generics.Collections, FMX.Pickers, FMX.Platform, System.Math, System.Math.Vectors;

type

  TFrmBaseAniFrame = class(TFrame)
    content: TRectangle;
  protected const
  {$IFDEF POSIX}
    MinimalSpeedThreshold = 150;
  {$ELSE}
    MinimalSpeedThreshold = 400;
  {$ENDIF}
    HidingThreshold = 0.5;
    ClickAreaExpansion = 5;
    DefaultDurationSliding = 0.4;
    StorageTrackingTime = 0.25;
    SlidingSpeedReduction = 0.5;
    DefaultDeadZone = 1;
  protected type
    TTrackingInfo = record
      Position: TPointF;
      Time: TDateTime;
    end;
  private
    { Private declarations }
    FNeedFreeAfterBack:Boolean;
    FShowAnimation:TFloatAnimation;
    FOnAfterShow:TNotifyEvent;
    FOnAfterBack:TNotifyEvent;
    [waek] FTarget:TFmxObject;
    FDrawerCaptured:Boolean;
    FMousePressedAbsolutePosition: TPointF;
    FPreviousOffset: Single;
    FTracksInfo:TList<TTrackingInfo>;
    FIsShowing:Boolean;
    FCanRePaint:Boolean;

    procedure DoDetailOverlayMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X: Single; Y: Single); virtual;
    procedure DoDetailOverlayMouseMove(Sender: TObject; Shift: TShiftState; X: Single; Y: Single); virtual;
    procedure DoDetailOverlayMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X: Single; Y: Single); virtual;

    procedure LinkDetailOverlayToSelf;
    function GetDetailOverlay:TShadowedOverlayLayout;

    procedure CaptureDrawer(const AX, AY: Single);
    procedure TrackInfo(const AX, AY: Single);
    function CalculateMovingSpeed: Single;
    function CalculateSlidingTime(const ASpeed: Single): Single;
    function NeedHidePanel(const ASpeed: Single): Boolean;

    procedure DoBack(ASpeed:Single);
    procedure DoShow(ASpeed:Single);
    procedure DoTargetBack(ASpeed:Single);
    procedure DoTargetShow(ASpeed:Single);

    procedure SetCanRePaint(const Value: Boolean);

  protected
    procedure SetBounds(X, Y, AWidth, AHeight: Single); override;
    procedure DoBeforeBack; virtual;
    procedure DoBeforeTargetBack; virtual;
    procedure DoBeforeShow; virtual;
    procedure DoBeforeTargetShow; virtual;

    procedure DoAfterBack(Sender:TObject); virtual;
    procedure DoAfterTargetBack(Sender:TObject); virtual;
    procedure DoAfterShow(Sender:TObject); virtual;
    procedure DoAfterTargetShow(Sender:TObject); virtual;

    procedure CanRePaiintChanged; virtual;
    function DoPointInObjectEvent(Sender: TObject; const X, Y: Single): Boolean; virtual;
    procedure ResetFocus;
    procedure UpdateShadowOpacity(const AOpacity: Boolean);
    property DetailOverlay:TShadowedOverlayLayout read GetDetailOverlay;
    property ShowAnimation:TFloatAnimation read FShowAnimation;
  public
    { Public declarations }
    procedure Back;
    procedure Show;

    procedure TargetBack;
    procedure TargetShow;

    constructor Create(AOwner: TComponent; AParent: TFmxObject; ATarget:TFmxObject); virtual;
    destructor Destroy; override;
  published
    property NeedFreeAfterBack:Boolean read FNeedFreeAfterBack write FNeedFreeAfterBack;
    property OnAfterShow:TNotifyEvent read FOnAfterShow write FOnAfterShow;
    property OnAfterBack:TNotifyEvent read FOnAfterBack write FOnAfterBack;
    property Target:TFmxObject read FTarget write FTarget;
    property CanRePaint:Boolean read FCanRePaint write SetCanRePaint;
    property IsShowing:Boolean read FIsShowing write FIsShowing;
  end;

  TAniFrameManager = class(TObject)
  private

  end;

implementation

var
  GShadowedOverlay:TShadowedOverlayLayout;
  //公用一个 TShadowedOverlayLayout
{$R *.fmx}

procedure RegisterDetailOverlay;
begin
  GShadowedOverlay:=TShadowedOverlayLayout.Create(nil);
  GShadowedOverlay.Stored := False;
  GShadowedOverlay.Mode := TOverlayMode.AllLocalArea;
  GShadowedOverlay.Color := TAlphaColors.Black;
  GShadowedOverlay.Opacity := 1;
  GShadowedOverlay.Align := TAlignLayout.Contents;
  GShadowedOverlay.Lock;
end;
procedure UnregisterDetailOverlay;
begin
  GShadowedOverlay.Free;
end;
{ TFrmBaseFrame }

procedure TFrmBaseAniFrame.Back;
begin
  DoBack(DefaultDurationSliding);
end;

function TFrmBaseAniFrame.CalculateMovingSpeed: Single;
var
  Distance: Single;
  Interval: TTimeStamp;
begin
  Result := 0;
  if FTracksInfo.Count < 2 then
    Exit;
  Interval := DateTimeToTimeStamp(FTracksInfo.Last.Time - FTracksInfo.First.Time);
  Distance := FTracksInfo.Last.Position.X - FTracksInfo.First.Position.X;
  if Interval.Time = 0 then
    Result := DefaultDurationSliding
  else
    Result := (Distance / Interval.Time) * MSecsPerSec;

end;

function TFrmBaseAniFrame.CalculateSlidingTime(const ASpeed: Single): Single;
var
  Distance, Duration:Single;
begin
  if ASpeed<0 then
  begin
    Distance := Abs(Width - Position.X);
    Duration := Distance / Abs(ASpeed);
  end
  else
  begin
    Distance := Position.X;
    Duration := Distance / Abs(ASpeed);
  end;
  Result := Min(Duration, DefaultDurationSliding);
end;

procedure TFrmBaseAniFrame.CanRePaiintChanged;
begin
  if CanRePaint then
    content.EndUpdate
  else
    content.BeginUpdate;
end;

procedure TFrmBaseAniFrame.CaptureDrawer(const AX, AY: Single);
begin
  FMousePressedAbsolutePosition := DetailOverlay.LocalToAbsolute(TPointF.Create(AX, AY));
  FTracksInfo.Clear;
  TrackInfo(AX, AY);
end;

constructor TFrmBaseAniFrame.Create(AOwner: TComponent; AParent: TFmxObject; ATarget:TFmxObject);
begin
  inherited Create(AOwner);
  FNeedFreeAfterBack:=True;
  FCanRePaint:=True;

  FTracksInfo:=TList<TTrackingInfo>.Create;

  Align:=TAlignLayout.None;
  Parent:=AParent;
  FTarget:=ATarget;

  FShowAnimation:=TFloatAnimation.Create(nil);
  FShowAnimation.Parent := Self;
  FShowAnimation.PropertyName:='Position.X';
  FShowAnimation.StartFromCurrent := True;
  FShowAnimation.Interpolation:=TInterpolationType.Circular;
  FShowAnimation.AnimationType:=TAnimationType.Out;

  if AParent is TForm then
  begin
    Width:=TForm(AParent).ClientWidth;
    Height:=TForm(AParent).ClientHeight;
  end
  else
  begin
    Width:=TControl(AParent).Width;
    Height:=TControl(AParent).Height;
  end;
  if FTarget<>nil then
    Position.X:=Width
  else
    Position.X:=0;
  Position.Y:=0;
  Application.ProcessMessages;
end;

destructor TFrmBaseAniFrame.Destroy;
begin
  if DetailOverlay.Parent = Self then
  begin
    //如果DetailOverlay Parent 是自己 则设置Parent = nil
    DetailOverlay.Parent.RemoveFreeNotify(Self);
    DetailOverlay.Parent:=nil;
  end;

  if Parent<>nil then
  begin
    Parent.RemoveFreeNotify(Self);
    Parent:=nil;
  end;

  FTracksInfo.Free;
  FShowAnimation.Free;
  inherited Destroy;
end;

procedure TFrmBaseAniFrame.DoAfterBack(Sender: TObject);
begin
  if Assigned(FOnAfterBack) then
    FOnAfterBack(Sender);
  //在 Back 后 释放掉自己
  if FNeedFreeAfterBack then
    DisposeOf
end;

procedure TFrmBaseAniFrame.DoAfterShow(Sender: TObject);
begin
  CanRePaint:=True;
  if Assigned(FOnAfterShow) then
    FOnAfterShow(Sender);
end;

procedure TFrmBaseAniFrame.DoAfterTargetBack(Sender: TObject);
begin
  //在进入后面 不设置 CanRePaint 让他不刷新
  //CanRePaint:=True;
end;

procedure TFrmBaseAniFrame.DoAfterTargetShow(Sender: TObject);
begin
  CanRePaint:=True;
end;

procedure TFrmBaseAniFrame.DoBack(ASpeed: Single);
begin
  DoBeforeBack;
  //返回上一级
  FIsShowing:=False;
  if FTarget is TFrmBaseAniFrame then
  begin
    TFrmBaseAniFrame(FTarget).IsShowing:=True;
    TFrmBaseAniFrame(FTarget).LinkDetailOverlayToSelf;
  end;
  if SameValue(ASpeed, DefaultDurationSliding, TEpsilon.Vector) then
    FShowAnimation.Duration := DefaultDurationSliding
  else
    FShowAnimation.Duration := CalculateSlidingTime(ASpeed);
  FShowAnimation.StartValue:=Position.X;
  FShowAnimation.StopValue:=Self.Width;
  FShowAnimation.OnFinish:=DoAfterBack;
  FShowAnimation.Start;

  if FTarget is TFrmBaseAniFrame then
    TFrmBaseAniFrame(FTarget).TargetShow;
end;

procedure TFrmBaseAniFrame.DoBeforeBack;
begin
  //这里会使滚动条失效 不明白什么原因？
  //Frame Dispose 以后 再Create 如果里面有滚动的 偶尔会失效
  //CanRePaint:=False;
end;

procedure TFrmBaseAniFrame.DoBeforeShow;
begin
  //在显示得时候不设置 CanRePaint 需要初始化控件
  //在移动端会有一些问题 Windows 正常
{$IFNDEF POSIX}
  CanRePaint:=False;
{$ENDIF}
end;

procedure TFrmBaseAniFrame.DoBeforeTargetBack;
begin
  CanRePaint:=False;
end;

procedure TFrmBaseAniFrame.DoBeforeTargetShow;
begin
  CanRePaint:=False;
end;

procedure TFrmBaseAniFrame.DoDetailOverlayMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Single);
  function PointInFrame(AMouseAbsoultePos: TPointF): Boolean;
  begin
    Result := LocalRect.Contains(AbsoluteToLocal(AMouseAbsoultePos));
  end;
var
   MouseAbsoultePos: TPointF;
begin
  if Self.FTarget = nil then exit;
{$IFDEF ANDROID}
  MouseAbsoultePos := DetailOverlay.LocalToAbsolute(TPointF.Create(X, Y));
  if PointInFrame(MouseAbsoultePos) then
  begin
    CaptureDrawer(X, Y);
    FDrawerCaptured:=True;
  end;
{$ELSE}
  FDrawerCaptured:=True;
  CaptureDrawer(X, Y);
{$ENDIF}
  if (FTarget<>nil) and (FTarget is TFrmBaseAniFrame) and (not TFrmBaseAniFrame(FTarget).Visible) then
    TFrmBaseAniFrame(FTarget).Visible := True;
  ResetFocus;
end;

procedure TFrmBaseAniFrame.DoDetailOverlayMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Single);
  function CalculateOffset: Single;
  var
    MouseAbsoultePos: TPointF;
  begin
    MouseAbsoultePos := DetailOverlay.LocalToAbsolute(TPointF.Create(X, Y));
    Result := MouseAbsoultePos.X - FMousePressedAbsolutePosition.X;
  end;
var
  Offset: Single;
  MouseAbsoultePos: TPointF;
begin
  if not FDrawerCaptured then exit;
  MouseAbsoultePos := DetailOverlay.LocalToAbsolute(TPointF.Create(X, Y));
  if (ssLeft in Shift) and DetailOverlay.Pressed and FDrawerCaptured then
  begin
    Offset := CalculateOffset;
    if Offset<0 then
      Exit;
    if Abs(FPreviousOffset - Offset) > DefaultDeadZone then
    begin
      Position.X := Position.X + Offset - FPreviousOffset;
      TrackInfo(X, Y);
      if (FTarget<>nil) and (FTarget is TFrmBaseAniFrame) then
      begin
        TFrmBaseAniFrame(FTarget).Position.X:= TFrmBaseAniFrame(FTarget).Position.X + (Offset - FPreviousOffset) /2;
      end;
      UpdateShadowOpacity(True);
      FPreviousOffset := Offset;
    end;
  end;

end;

procedure TFrmBaseAniFrame.DoDetailOverlayMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Single);
  function IsClick: Boolean;
  var
    AbsolutePos: TPointF;
  begin
    AbsolutePos := DetailOverlay.LocalToAbsolute(TPointF.Create(X, Y));
    Result := FMousePressedAbsolutePosition.Distance(AbsolutePos) < ClickAreaExpansion;
  end;

var
  Speed: Single;
  NormalizedSpeed: Single;
begin
  Speed := CalculateMovingSpeed;
  NormalizedSpeed := Speed * (1 - SlidingSpeedReduction);
  if NeedHidePanel(Speed) then
    DoBack(NormalizedSpeed)
  else
    DoShow(NormalizedSpeed);
  FPreviousOffset:=0;
  FDrawerCaptured := False;
end;

function TFrmBaseAniFrame.DoPointInObjectEvent(Sender: TObject; const X,
  Y: Single): Boolean;
begin
  Result:=True;
end;

procedure TFrmBaseAniFrame.DoShow(ASpeed: Single);
begin

  DoBeforeShow;
  if FTarget is TFrmBaseAniFrame then
    TFrmBaseAniFrame(FTarget).IsShowing:=False;
  FIsShowing:=True;
  LinkDetailOverlayToSelf;
  BringToFront;
  if SameValue(ASpeed, DefaultDurationSliding, TEpsilon.Vector) then
    FShowAnimation.Duration := DefaultDurationSliding
  else
    FShowAnimation.Duration := CalculateSlidingTime(ASpeed)*1.5;
  FShowAnimation.StartValue:=Position.X;
  FShowAnimation.StopValue:=0;
  FShowAnimation.OnFinish:=DoAfterShow;
  FShowAnimation.Start;

  if FTarget is TFrmBaseAniFrame then
    TFrmBaseAniFrame(FTarget).TargetBack;
end;

procedure TFrmBaseAniFrame.DoTargetBack(ASpeed: Single);
begin
  DoBeforeTargetBack;
  if SameValue(ASpeed, DefaultDurationSliding, TEpsilon.Vector) then
    FShowAnimation.Duration := DefaultDurationSliding
  else
    FShowAnimation.Duration := CalculateSlidingTime(ASpeed)*1.5;
  FShowAnimation.StartValue:=Position.X;
  FShowAnimation.StopValue:= - Self.Width /2;
  FShowAnimation.OnFinish:= DoAfterTargetBack;
  CanRePaint:=False;
  FShowAnimation.Start;
end;

procedure TFrmBaseAniFrame.DoTargetShow(ASpeed: Single);
begin
  DoBeforeTargetShow;
  BringToFront;
  if SameValue(ASpeed, DefaultDurationSliding, TEpsilon.Vector) then
    FShowAnimation.Duration := DefaultDurationSliding
  else
    FShowAnimation.Duration := CalculateSlidingTime(ASpeed)*1.5;
  FShowAnimation.StartValue:=Position.X;
  FShowAnimation.StopValue:=0;
  FShowAnimation.OnFinish:= DoAfterTargetShow;
  CanRePaint:=False;
  FShowAnimation.Start;
end;

function TFrmBaseAniFrame.GetDetailOverlay: TShadowedOverlayLayout;
begin
  Result:=GShadowedOverlay;
end;

procedure TFrmBaseAniFrame.LinkDetailOverlayToSelf;
begin
  UpdateShadowOpacity(False);
  if DetailOverlay.Parent <> Self then
  begin
    if DetailOverlay.Parent <> nil then
      DetailOverlay.Parent.RemoveFreeNotify(Self);
    DetailOverlay.Parent := Self;
    DetailOverlay.Parent.AddFreeNotify(Self);
    DetailOverlay.OnMouseDown := DoDetailOverlayMouseDown;
    DetailOverlay.OnMouseMove := DoDetailOverlayMouseMove;
    DetailOverlay.OnMouseUp := DoDetailOverlayMouseUp;
    DetailOverlay.OnPointInObjectEvent := DoPointInObjectEvent;
  end;
end;

function TFrmBaseAniFrame.NeedHidePanel(const ASpeed: Single): Boolean;
begin
  if Abs(ASpeed) < MinimalSpeedThreshold then
    Result := Position.X >  Width * HidingThreshold
  else
    Result := ASpeed > 0;
end;

procedure TFrmBaseAniFrame.ResetFocus;
var
  PickerService: IFMXPickerService;
begin
  if (Root <> nil) and (Root.Focused <> nil) then
  begin
    Root.Focused := nil;
    if TPlatformServices.Current.SupportsPlatformService(IFMXPickerService, PickerService) then
      PickerService.CloseAllPickers;
  end;
end;

procedure TFrmBaseAniFrame.SetBounds(X, Y, AWidth, AHeight: Single);
var
  ScreenService:IFMXScreenService;
  ScreenWidth, ScreenHeight:Single;
begin
{$IFDEF POSIX}
  //移动端 屏幕旋转的时候 重新设置Size and Position
  if TPlatformServices.Current.SupportsPlatformService(IFMXScreenService, ScreenService) then
  begin
    ScreenWidth:= ScreenService.GetScreenSize.X;
    ScreenHeight:= ScreenService.GetScreenSize.Y;
    if FIsShowing then
      inherited SetBounds(0, 0, ScreenWidth, ScreenHeight)
    else
      inherited SetBounds(ScreenWidth / 2, 0, ScreenWidth, ScreenHeight);
  end
  else
    inherited SetBounds(X, Y, AWidth, AHeight);
{$ELSE}
  inherited SetBounds(X, Y, AWidth, AHeight);
{$ENDIF}

end;

procedure TFrmBaseAniFrame.SetCanRePaint(const Value: Boolean);
begin
  if FCanRePaint<>Value then
  begin
    FCanRePaint := Value;
    CanRePaiintChanged;
  end;
end;

procedure TFrmBaseAniFrame.Show;
begin
  DoShow(DefaultDurationSliding);
end;

procedure TFrmBaseAniFrame.TargetBack;
begin
  DoTargetBack(DefaultDurationSliding);
end;

procedure TFrmBaseAniFrame.TargetShow;
begin
  DoTargetShow(DefaultDurationSliding);
end;

procedure TFrmBaseAniFrame.TrackInfo(const AX, AY: Single);
var
  TrackingInfo: TTrackingInfo;
  Stopped: Boolean;
begin
  Stopped := False;
  while (FTracksInfo.Count > 0) and not Stopped do
    if (Now - FTracksInfo[0].Time) * SecsPerDay > StorageTrackingTime then
      FTracksInfo.Delete(0)
    else
      Stopped := True;

  TrackingInfo.Position := DetailOverlay.LocalToAbsolute(TPointF.Create(AX, AY));
  TrackingInfo.Time := Now;
  FTracksInfo.Add(TrackingInfo);

end;

procedure TFrmBaseAniFrame.UpdateShadowOpacity(const AOpacity: Boolean);
begin
  if AOpacity then
  begin
    if not DetailOverlay.EnabledShadow then
    begin
      DetailOverlay.EnabledShadow:=True;
      DetailOverlay.Opacity := 0.1;
    end;
  end
  else
  begin
    if DetailOverlay.EnabledShadow then
    begin
      DetailOverlay.EnabledShadow:=False;
    end;
  end;
end;

initialization
  RegisterDetailOverlay;
finalization
  UnregisterDetailOverlay;

end.
