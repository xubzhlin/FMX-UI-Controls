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
    background: TRectangle;
  protected const
    MinimalSpeedThreshold = 150;
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
    FNeedFreeAfterBack: Boolean;
    FShowAnimation: TFloatAnimation;
    FOnAfterShow: TNotifyEvent;
    FOnAfterBack: TNotifyEvent;
    FTarget: TList<TFmxObject>;
    FDrawerCaptured: Boolean;
    FMousePressedAbsolutePosition: TPointF;
    FPreviousOffset: Single;
    FTracksInfo:TList<TTrackingInfo>;
    FIsShowing:Boolean;
    FIsCanClicked:Boolean;

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

    function GetTarget: TFmxObject;
    procedure SetTarget(const Value: TFmxObject);

    procedure SetTargetOrder;

    procedure SetMainTargetToTarget;
    function GetMainTaget(CurreTarget:TFmxObject):TFrmBaseAniFrame;

    procedure DoAddTarget(const Value: TFmxObject);
    procedure SetIsShowing(const Value: Boolean);

  protected
    //在 FIsShowing 没有在前台显示得时候 不绘制
    //重载了 Paint PaintChildren
    procedure Paint; override;
    procedure PaintChildren; override;
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
    procedure Back; virtual;
    procedure Show; virtual;

    procedure TargetBack; virtual;
    procedure TargetShow; virtual;

    constructor Create(AOwner: TComponent; AParent: TFmxObject; ATarget:TFmxObject); virtual;
    destructor Destroy; override;
  published
    property NeedFreeAfterBack:Boolean read FNeedFreeAfterBack write FNeedFreeAfterBack;
    property OnAfterShow:TNotifyEvent read FOnAfterShow write FOnAfterShow;
    property OnAfterBack:TNotifyEvent read FOnAfterBack write FOnAfterBack;
    property Target: TFmxObject read GetTarget write SetTarget;
    property IsShowing:Boolean read FIsShowing write SetIsShowing;
    property IsCanClicked:Boolean read FIsCanClicked write FIsCanClicked;
  end;
var

  GShadowedOverlay:TShadowedOverlayLayout;
  //公用一个 TShadowedOverlayLayout
implementation



{$R *.fmx}

procedure RegisterDetailOverlay;
begin
  GShadowedOverlay:=TShadowedOverlayLayout.Create(nil);
  GShadowedOverlay.Stored := False;
  GShadowedOverlay.Mode := TOverlayMode.LeftSide;
  GShadowedOverlay.Color := TAlphaColors.Black;
  GShadowedOverlay.Opacity := 1;
  GShadowedOverlay.Align := TAlignLayout.Contents;
  GShadowedOverlay.Lock;
end;
procedure UnregisterDetailOverlay;
begin
  GShadowedOverlay.DisposeOf;
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
  if (Interval.Time = 0) or (Distance < 0) then
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
    background.EndUpdate
  else
    background.BeginUpdate;
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

  FTracksInfo:=TList<TTrackingInfo>.Create;

  Align:=TAlignLayout.None;
  Parent:=AParent;
  Parent.AddFreeNotify(Self);
  DoAddTarget(ATarget);

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
  if Target is TFrmBaseAniFrame then
    Position.X:=Width
  else
    Position.X:=0;
  Position.Y:=0;
  {$IFNDEF ANDROID}
  Application.ProcessMessages;
  {$ENDIF}
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

  FTarget.Free;
  FTracksInfo.Free;
  FShowAnimation.Free;
  inherited Destroy;
end;

procedure TFrmBaseAniFrame.DoAddTarget(const Value: TFmxObject);
begin
  if FTarget=nil then
    FTarget:=TList<TFMXObject>.Create;
  FTarget.Add(Value);
end;

procedure TFrmBaseAniFrame.DoAfterBack(Sender: TObject);
begin
  IsShowing := False;
  if Assigned(FOnAfterBack) then
    FOnAfterBack(Sender);
  if (FTarget<>nil) and (FTarget.Count>0) then
    FTarget.Delete(FTarget.Count-1);
  // 在 Back 后 释放掉自己
  if FNeedFreeAfterBack then
  begin
    Parent:=nil;
    DisposeOf;
  end;
end;

procedure TFrmBaseAniFrame.DoAfterShow(Sender: TObject);
begin
  SetMainTargetToTarget;
  FIsCanClicked:=True;
  if Assigned(FOnAfterShow) then
    FOnAfterShow(Sender);
end;

procedure TFrmBaseAniFrame.DoAfterTargetBack(Sender: TObject);
begin
  IsShowing:=True;
end;

procedure TFrmBaseAniFrame.DoAfterTargetShow(Sender: TObject);
begin
  SetTargetOrder;
  FIsCanClicked:=True;
end;

procedure TFrmBaseAniFrame.DoBack(ASpeed: Single);
begin
  DoBeforeBack;
  //返回上一级
  if Target is TFrmBaseAniFrame then
  begin
    TFrmBaseAniFrame(Target).IsShowing := True;
    TFrmBaseAniFrame(Target).LinkDetailOverlayToSelf;
    TFrmBaseAniFrame(Target).TargetShow;
  end;

  if SameValue(ASpeed, DefaultDurationSliding, TEpsilon.Vector) then
    FShowAnimation.Duration := DefaultDurationSliding
  else
    FShowAnimation.Duration := CalculateSlidingTime(ASpeed);
  FShowAnimation.StartValue:=Position.X;
  FShowAnimation.StopValue:=Self.Width;
  FShowAnimation.OnFinish:=DoAfterBack;
  FShowAnimation.Start;

end;

procedure TFrmBaseAniFrame.DoBeforeBack;
begin
  FIsCanClicked:=False;
end;

procedure TFrmBaseAniFrame.DoBeforeShow;
begin
  IsShowing:=True;
end;

procedure TFrmBaseAniFrame.DoBeforeTargetBack;
begin
  FIsCanClicked:=False;
end;

procedure TFrmBaseAniFrame.DoBeforeTargetShow;
begin
  IsShowing:=True;
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
  if not (Target is TFrmBaseAniFrame) then exit;
  FShowAnimation.Stop;
  if (Target<>nil) and (Target is TFrmBaseAniFrame) then
  begin
    TFrmBaseAniFrame(Target).FShowAnimation.Stop;
    TFrmBaseAniFrame(Target).IsShowing := True;
  end;
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
      if Target is TFrmBaseAniFrame then
      begin
        TFrmBaseAniFrame(Target).Position.X := TFrmBaseAniFrame(Target)
          .Position.X + (Offset - FPreviousOffset) / 2;
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
  FTracksInfo.Clear;
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
  IsShowing := True;
  LinkDetailOverlayToSelf;
  DetailOverlay.BringToFront;
  BringToFront;
  if SameValue(ASpeed, DefaultDurationSliding, TEpsilon.Vector) then
    FShowAnimation.Duration := DefaultDurationSliding
  else
    FShowAnimation.Duration := CalculateSlidingTime(ASpeed)*1.5;
  FShowAnimation.StartValue:=Position.X;
  FShowAnimation.StopValue:=0;
  FShowAnimation.OnFinish:=DoAfterShow;
  FShowAnimation.Start;

  if Target is TFrmBaseAniFrame then
    TFrmBaseAniFrame(Target).TargetBack;
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
  FShowAnimation.Start;
end;

procedure TFrmBaseAniFrame.DoTargetShow(ASpeed: Single);
begin
  DoBeforeTargetShow;
  //BringToFront;
  if SameValue(ASpeed, DefaultDurationSliding, TEpsilon.Vector) then
    FShowAnimation.Duration := DefaultDurationSliding
  else
    FShowAnimation.Duration := CalculateSlidingTime(ASpeed)*1.5;
  FShowAnimation.StartValue:=Position.X;
  FShowAnimation.StopValue:=0;
  FShowAnimation.OnFinish:= DoAfterTargetShow;
  FShowAnimation.Start;
end;

function TFrmBaseAniFrame.GetDetailOverlay: TShadowedOverlayLayout;
begin
  Result := GShadowedOverlay;
end;

function TFrmBaseAniFrame.GetMainTaget(CurreTarget:TFmxObject): TFrmBaseAniFrame;
var
  ATarget:TFmxObject;
begin
  //if Self = CurreTarget then

  ATarget:=Target;
  if (ATarget is TFrmBaseAniFrame) then
  begin
    FTarget.Delete(FTarget.Count-1);
    Result:=TFrmBaseAniFrame(ATarget).GetMainTaget(CurreTarget);
    DoAfterBack(Self);
  end
  else
    Result:=Self;
end;

function TFrmBaseAniFrame.GetTarget: TFmxObject;
begin
  if (FTarget<>nil) and (FTarget.Count>0) then
    Result:=FTarget.Last
  else
    Result:=nil;
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
  begin
    if ASpeed>0 then
      Result := True
    else
      Result:=False;
  end;
end;

procedure TFrmBaseAniFrame.Paint;
begin
  if FIsShowing then
    inherited;
end;

procedure TFrmBaseAniFrame.PaintChildren;
begin
  if FIsShowing then
    inherited;
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
  // 移动端 屏幕旋转的时候 重新设置Size and Position
  if not SameValue(AWidth, Width) or not SameValue(AHeight, Height) then
  begin
    if TPlatformServices.Current.SupportsPlatformService(IFMXScreenService,
      ScreenService) then
    begin
      ScreenWidth := ScreenService.GetScreenSize.X;
      ScreenHeight := ScreenService.GetScreenSize.Y;
      if FIsShowing then
        inherited SetBounds(0, 0, ScreenWidth, ScreenHeight)
      else
        inherited SetBounds(-ScreenWidth / 2, 0, ScreenWidth, ScreenHeight);
    end
    else
      inherited SetBounds(X, Y, AWidth, AHeight);
  end
  else
    inherited SetBounds(X, Y, AWidth, AHeight);
{$ELSE}
  inherited SetBounds(X, Y, AWidth, AHeight);
{$ENDIF}

end;

procedure TFrmBaseAniFrame.SetIsShowing(const Value: Boolean);
begin
  if FIsShowing<>Value then
  begin
    FIsShowing := Value;

    if FIsShowing then
      Repaint;
  end;
end;

procedure TFrmBaseAniFrame.SetMainTargetToTarget;
var
  MainTarget:TFrmBaseAniFrame;
begin
  // 在打开公用Frame时  并且多次调用 下次返回直接 返回到 Main
  // 这里主要针对 聊天窗口
  if (not FNeedFreeAfterBack) and (FTarget.Count>1) then
  begin
    MainTarget:=GetMainTaget(Self);
    FTarget.Clear;
    FTarget.Add(MainTarget);
  end;
end;

procedure TFrmBaseAniFrame.SetTarget(const Value: TFmxObject);
begin
  if (FTarget<>nil) and (FTarget.Count>0) then
  begin
    if Value = nil then
      FTarget.Clear
    else
    begin
      if FTarget.Last = Value then
        Exit;
    end;
  end;
  if Value<>nil then
    DoAddTarget(Value);

end;

procedure TFrmBaseAniFrame.SetTargetOrder;
var
  Idx,TIdx: Integer;
begin
  //Parent 都是一样的
  if (Target is TFrmBaseAniFrame) and (Parent<>nil) and (Target.Parent = Parent) then
  begin
    if Parent.Children <> nil then
    begin
      if (Index - Target.Index<>1) then
      begin
        Target.Index:= (Index - 1);
        TFrmBaseAniFrame(Target).Position.X:= -Width / 2;
        TFrmBaseAniFrame(Target).Position.Y:=0;
      end;
    end;
  end;
end;

procedure TFrmBaseAniFrame.Show;
begin
  Position.X:=Width;
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
