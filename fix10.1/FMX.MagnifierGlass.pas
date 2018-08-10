{*******************************************************}
{                                                       }
{              Delphi FireMonkey Platform               }
{                                                       }
{ Copyright(c) 2016 Embarcadero Technologies, Inc.      }
{              All rights reserved                      }
{                                                       }
{*******************************************************}

unit FMX.MagnifierGlass;

interface

{$SCOPEDENUMS ON}

uses
  System.Types, System.Classes, System.UITypes, FMX.Controls, FMX.Types, FMX.Objects, FMX.Graphics,
  FMX.Controls.Presentation;

const
  DEFAULT_LOUPE_SCALE = 1.4 deprecated 'Use TCustomMagnifierGlass.DefaultLoupeScale instead';

type

{ TMagnifierGlass }

  /// <summary> Two options of display of a magnifying glass - a round and rectangular lens "TMagnifierGlass".</summary>
  TLoupeMode = (Circle, Rectangle);

  TLoupeModeHelper = record helper for TLoupeMode
  const
    lmCircle = TLoupeMode.Circle deprecated 'Use TLoupeMode.Circle';
    lmRectangle = TLoupeMode.Rectangle deprecated 'Use TLoupeMode.Rectangle';
  end;

  TZoomMode = (Absolute, Relative);

  TZoomModeHelper = record helper for TZoomMode
  const
    zmAbsolute = TZoomMode.Absolute deprecated 'Use TZoomMode.Absolute';
    zmRelative = TZoomMode.Relative deprecated 'Use TZoomMode.Relative';
  end;

  TCustomMagnifierGlass = class(TPresentedControl)
  public const
    DefaultLoupeScale = 1.4;
  strict private
    FLoupeMode: TLoupeMode;
    FLoupeScale: Single;
    FZoomRegionCenter: TPosition;
    FZoomMode: TZoomMode;
    FBackgroundColor: TAlphaColor;
    FScreenshot: TBitmap;
    FScaledScreenshot: TBitmap;
    FContent: TShape;
    procedure SetLoupeMode(const Value: TLoupeMode);
    procedure SetLoupeScale(const Value: Single);
    procedure SetZoomMode(const Value: TZoomMode);
    procedure SetBackgroundColor(const Value: TAlphaColor);
    function IsLoupeScaleStored: Boolean;
    function GetScreenScale: Single;
    function GetCenter: TPointF;
    procedure MakeScreenshot;
    procedure DoZoomRegionChanged(Sender: TObject);
    procedure DoContentPaint(Sender: TObject; Canvas: TCanvas; const ARect: TRectF);
  protected
    procedure SetZoomRegionCenter(const Value: TPosition); virtual;
    function GetZoomRect: TRectF; virtual;
    { Style }
    procedure ApplyStyle; override;
    procedure FreeStyle; override;
    function GetDefaultStyleLookupName: string; override;
    function HasContent: Boolean;
    function GetDefaultSize: TSizeF; override;
    { Painting }
    procedure Paint; override;
    property ScreenScale: Single read GetScreenScale;
    property Center: TPointF read GetCenter;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    ///<summary>Area center round which the image will be increased. Uses only, when <c>ZoomMode = TZoomMode.Absolute</c></summary>
    property ZoomRegionCenter: TPosition read FZoomRegionCenter write SetZoomRegionCenter;
    property ZoomMode: TZoomMode read FZoomMode write SetZoomMode default TZoomMode.Relative;
    property BackgroundColor: TAlphaColor read FBackgroundColor write SetBackgroundColor default TAlphaColorRec.White;
    property LoupeMode: TLoupeMode read FLoupeMode write SetLoupeMode default TLoupeMode.Circle;
    property LoupeScale: Single read FLoupeScale write SetLoupeScale stored IsLoupeScaleStored nodefault;
    property ScaledScreenshot: TBitmap read FScaledScreenshot;
  end;

  /// <summary><para>Magnifying glass increasing area parent control. Allows to change scaling coefficient |LoupeScale|.
  /// Has two options of display - a circular and rectangular lens |LoupeMode|.</para></summary>
  /// <remarks>It is recommended to use for increase in components of the small size.</remarks>
  TMagnifierGlass = class(TCustomMagnifierGlass)
  published
    property BackgroundColor;
    property LoupeMode;
    property LoupeScale;
    property Align;
    property Anchors;
    property ClipChildren default False;
    property ClipParent default False;
    property ControlType;
    property Cursor default crDefault;
    property DragMode default TDragMode.dmManual;
    property EnableDragHighlight default True;
    property Enabled default True;
    property Locked default False;
    property Height;
    property HitTest default False;
    property Padding;
    property Opacity;
    property Margins;
    property PopupMenu;
    property Position;
    property RotationAngle;
    property RotationCenter;
    property Scale;
    property Size;
    property StyleLookup;
    property Visible default True;
    property Width;
    property ZoomMode;
    property ZoomRegionCenter;
    {Drag and Drop events}
    property OnDragEnter;
    property OnDragLeave;
    property OnDragOver;
    property OnDragDrop;
    property OnDragEnd;
    {Mouse events}
    property OnClick;
    property OnDblClick;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnPainting;
    property OnPaint;
    property OnResize;
  end;

  /// <summary>Service displays a magnifying glass for the current form. Works with absolute coordinates. Also it is
  /// intended for use of one magnifying glass different controls. Therefore before each use of a magnifying glass
  /// through service, it is recommended to initialize all values of service anew.</summary>
  ILoupeService = interface
  ['{EAFDFBA9-F24A-4DF0-920E-F0D2BC6E8B33}']
    procedure SetLoupeMode(const AMode: TLoupeMode);
    procedure SetLoupeScale(const AScale: Single);
    function GetWidth: Single;
    function GetHeight: Single;
    procedure SetZoomRegionCenter(const AZoomPoint: TPointF);
    procedure SetPosition(const AAbsolutePosition: TPointF);
    procedure ShowFor(AControl: TControl);
    procedure Hide;
  end;

  TLoupeFactoryService = class(TInterfacedObject, ILoupeService)
  strict private
    [Weak] FForControl: TControl;
    FLoupe: TMagnifierGlass;
  public
    constructor Create;
    destructor Destroy; override;
    { ILoupeFactoryService }
    procedure SetLoupeMode(const AMode: TLoupeMode);
    procedure SetLoupeScale(const AScale: Single);
    function GetWidth: Single;
    function GetHeight: Single;
    procedure SetZoomRegionCenter(const AZoomPoint: TPointF);
    procedure SetPosition(const AAbsolutePosition: TPointF);
    procedure ShowFor(AControl: TControl);
    procedure Hide;
  end;

implementation

uses
  System.Math, System.Math.Vectors, System.TypInfo, FMX.Forms, FMX.Consts, FMX.BehaviorManager, FMX.Platform;

const
  MAX_BOUNDARY_TOP = 20;
  OFFSET_ZOOM_FOR_TOP_CONTROL = 35;

{ TMagnifierGlass }

constructor TCustomMagnifierGlass.Create(AOwner: TComponent);
begin
  inherited;
  SetAcceptsControls(False);
  FLoupeMode := TLoupeMode.Circle;
  FLoupeScale := 1;
  FBackgroundColor := TAlphaColorRec.White;
  FScreenshot := TBitmap.Create;
  FScaledScreenshot := TBitmap.Create;
  FZoomMode := TZoomMode.Relative;
  FZoomRegionCenter := TPosition.Create(PointF(0, 0));
  FZoomRegionCenter.OnChange := DoZoomRegionChanged;
  HitTest := False;
end;

destructor TCustomMagnifierGlass.Destroy;
begin
  FZoomRegionCenter.Free;
  FScaledScreenshot.Free;
  FScreenshot.Free;
  inherited;
end;

procedure TCustomMagnifierGlass.DoContentPaint(Sender: TObject; Canvas: TCanvas; const ARect: TRectF);
begin
  if HasContent and (FContent.Scene <> nil) then
  begin
    FContent.Scene.DisableUpdating;
    try
      FContent.Fill.Bitmap.Bitmap.FreeHandle;
    finally
      FContent.Scene.EnableUpdating;
    end;
  end;
end;

procedure TCustomMagnifierGlass.DoZoomRegionChanged(Sender: TObject);
begin
  Repaint;
end;

procedure TCustomMagnifierGlass.ApplyStyle;
begin
  inherited;
  if FindStyleResource<TShape>('content', FContent) then
  begin
    FContent.Fill.Kind := TBrushKind.Bitmap;
    FContent.Fill.Bitmap.WrapMode := TWrapMode.TileStretch;
    FContent.OnPaint := DoContentPaint;
  end;
end;

procedure TCustomMagnifierGlass.FreeStyle;
begin
  if FContent <> nil then
    FContent.OnPaint := nil;
  FContent := nil;
  inherited;
end;

function TCustomMagnifierGlass.GetCenter: TPointF;
begin
  Result := Position.Point + TPointF.Create(Width / 2, Height / 2);
end;

function TCustomMagnifierGlass.GetDefaultSize: TSizeF;
var
  DeviceInfo: IDeviceBehavior;
begin
  Result := TSizeF.Create(0, 0);
  if TBehaviorServices.Current.SupportsBehaviorService(IDeviceBehavior, DeviceInfo, Self) and
    (DeviceInfo.GetOSPlatform(Self) = TOSPlatform.iOS) then
    if LoupeMode = TLoupeMode.Circle then
      Result := TSizeF.Create(126, 126)
    else
      Result := TSizeF.Create(136, 54);

  if Result.IsZero then
    if LoupeMode = TLoupeMode.Circle then
      Result := TSize.Create(150, 150)
    else
      Result := TSize.Create(136, 54);
end;

function TCustomMagnifierGlass.GetDefaultStyleLookupName: string;
begin
  if LoupeMode = TLoupeMode.Rectangle then
    Result := 'magnifierglassrectanglestyle'
  else
    Result := 'magnifierglassstyle';
end;

function TCustomMagnifierGlass.GetZoomRect: TRectF;
var
  ZoomPoint: TPointF;
  ZoomRectPos: TPointF;
  ZoomRectWidth: Single;
  ZoomRectHeight: Single;
begin
  if HasContent then
  begin
    case ZoomMode of
      TZoomMode.Absolute:
        ZoomPoint := ZoomRegionCenter.Point;
      TZoomMode.Relative:
        ZoomPoint := Center + ZoomRegionCenter.Point;
    end;
    ZoomRectPos := TPointF.Create(ZoomPoint.X - FContent.Width / LoupeScale / 2,
      ZoomPoint.Y - FContent.Height / LoupeScale / 2);
    ZoomRectWidth := FContent.Width / LoupeScale;
    ZoomRectHeight := FContent.Height / LoupeScale;
    Result := TRectF.Create(ZoomRectPos, ZoomRectWidth, ZoomRectHeight);
  end
  else
    Result := TRectF.Empty;
end;

function TCustomMagnifierGlass.GetScreenScale: Single;
begin
  if Scene <> nil then
    Result := Scene.GetSceneScale
  else
    Result := 1;
end;

function TCustomMagnifierGlass.HasContent: Boolean;
begin
  Result := FContent <> nil;
end;

function TCustomMagnifierGlass.IsLoupeScaleStored: Boolean;
begin
  Result := not SameValue(LoupeScale, 1, TEpsilon.Scale);
end;

procedure TCustomMagnifierGlass.MakeScreenshot;
var
  Form: TCommonCustomForm;
  Child: TFmxObject;
  ChildControl: TControl;
  TargetRect: TRectF;
  ZoomOffset: TPointF;
begin
  if not FScreenshot.IsEmpty and  FScreenshot.Canvas.BeginScene then
  try
    // Clear old screenshot image
    FScreenshot.Canvas.Clear(FBackgroundColor);
    FDisablePaint := True;
    ZoomOffset := - GetZoomRect.TopLeft;
    if Parent is TCommonCustomForm then
    begin
      // Making screenshot of parent form
      Form := Parent as TCommonCustomForm;
      for Child in Form.Children do
        if (Child is TControl) and TControl(Child).Visible then
        begin
          ChildControl := TControl(Child);
          TargetRect := ChildControl.BoundsRect;
          TargetRect.Offset(ZoomOffset);
          ChildControl.PaintTo(FScreenshot.Canvas, TargetRect);
        end;
    end
    else
      // Making screnshot of parent control
      if ParentControl <> nil then
      begin
        TargetRect := TRectF.Create(ZoomOffset, ParentControl.BoundsRect.Width, ParentControl.BoundsRect.Height);
        ParentControl.PaintTo(FScreenshot.Canvas, TargetRect);
      end;
  finally
    FDisablePaint := False;
    FScreenshot.Canvas.EndScene;
  end;
end;

procedure TCustomMagnifierGlass.Paint;

  function IsSizeChanged(ABitmap: TBitmap; const ANewSize: TSizeF): Boolean;
  begin
    Result := not (Round(ANewSize.Width * ABitmap.BitmapScale) = ABitmap.Width) or
              not (Round(ANewSize.Height * ABitmap.BitmapScale) = ABitmap.Height);
  end;

  procedure SetSizeWithScreenScale(ABitmap: TBitmap; const ANewSize: TSizeF);
  begin
    ABitmap.BitmapScale := ScreenScale;
    ABitmap.SetSize(Round(ANewSize.Width * ScreenScale), Round(ANewSize.Height * ScreenScale));
  end;

  procedure ScaleScreenshot(ASource: TBitmap; var ADest: TBitmap);
  var
    DestRect: TRectF;
    SrcRect: TRectF;
  begin
    if ADest.Canvas.BeginScene then
      try
        SrcRect := TRectF.Create(0, 0, ASource.Width, ASource.Height);
        DestRect := TRectF.Create(0, 0, ADest.Width / ScreenScale, ADest.Height / ScreenScale);
        ADest.Canvas.DrawBitmap(ASource, SrcRect, DestRect, 1, True);
      finally
        ADest.Canvas.EndScene;
      end;
  end;

var
  OriginalScreenshotSize: TSizeF;
  ScaledScreenshotSize: TSizeF;
begin
  inherited;

  if HasContent and HasParent then
  begin
    // Init Size of Screenshot Bitmap
    OriginalScreenshotSize := TSizeF.Create(FContent.Width / LoupeScale, FContent.Height / LoupeScale);
    if IsSizeChanged(FScreenshot, OriginalScreenshotSize) then
      SetSizeWithScreenScale(FScreenshot, OriginalScreenshotSize);

    // Init Size of scaled screenshot
    ScaledScreenshotSize := TSizeF.Create(FContent.Width, FContent.Height);
    if IsSizeChanged(FScaledScreenshot, ScaledScreenshotSize) then
      SetSizeWithScreenScale(FScaledScreenshot, ScaledScreenshotSize);

    // Make screenshot and fit screenshot to loupe size
    MakeScreenshot;
    ScaleScreenshot(FScreenshot, FScaledScreenshot);

    // Set ScaledScreenshot as Bitmap Brush using IBitmapLink.
    if FContent.Scene <> nil then
    begin
      FContent.Scene.DisableUpdating;
      try
        FContent.Fill.Bitmap.Bitmap.Assign(FScaledScreenshot);
      finally
        FContent.Scene.EnableUpdating;
      end;
      if FContent.Scene <> Scene then
        FContent.Repaint;
    end;
  end;
end;

procedure TCustomMagnifierGlass.SetBackgroundColor(const Value: TAlphaColor);
begin
  if FBackgroundColor <> Value then
  begin
    FBackgroundColor := Value;
    Repaint;
  end;
end;

procedure TCustomMagnifierGlass.SetZoomMode(const Value: TZoomMode);
begin
  if ZoomMode <> Value then
  begin
    FZoomMode := Value;
    Repaint;
  end;
end;

procedure TCustomMagnifierGlass.SetZoomRegionCenter(const Value: TPosition);
begin
  if (Value <> nil) and (ZoomRegionCenter.Point <> Value.Point) then
  begin
    FZoomRegionCenter.Assign(Value);
    Repaint;
  end;
end;

procedure TCustomMagnifierGlass.SetLoupeMode(const Value: TLoupeMode);
begin
  if LoupeMode <> Value then
  begin
    FLoupeMode := Value;
    NeedStyleLookup;
    ApplyStyleLookup;
    RecalcSize;
  end;
end;

procedure TCustomMagnifierGlass.SetLoupeScale(const Value: Single);
const
  MinScale = 0.1;
begin
  if not SameValue(LoupeScale, Value, TEpsilon.Scale) then
  begin
    FLoupeScale := Max(Value, MinScale);
    Repaint;
  end;
end;

{ TLoupeFactoryService }

constructor TLoupeFactoryService.Create;
begin
  FLoupe := TMagnifierGlass.Create(nil);
  FLoupe.ZoomMode := TZoomMode.Absolute;
end;

destructor TLoupeFactoryService.Destroy;
begin
  FLoupe.Free;
  inherited;
end;

function TLoupeFactoryService.GetHeight: Single;
begin
  Result := FLoupe.Height;
end;

function TLoupeFactoryService.GetWidth: Single;
begin
  Result := FLoupe.Width;
end;

procedure TLoupeFactoryService.Hide;
begin
  FLoupe.Parent := nil;
  FLoupe.Visible := False;
end;

procedure TLoupeFactoryService.SetLoupeMode(const AMode: TLoupeMode);
begin
  FLoupe.LoupeMode := AMode;
end;

procedure TLoupeFactoryService.SetLoupeScale(const AScale: Single);
begin
  FLoupe.LoupeScale := AScale;
end;

procedure TLoupeFactoryService.SetPosition(const AAbsolutePosition: TPointF);
var
  NewPosition: TPointF;
begin
  // If loupe was located in top form, we need make offset for usability
  if FLoupe.LoupeMode = TLoupeMode.Circle then
  begin
    if AAbsolutePosition.Y <= -FLoupe.Height / 3 then
      NewPosition := TPointF.Create(AAbsolutePosition.X, -FLoupe.Height / 3)
    else
      NewPosition := AAbsolutePosition;
  end
  else
  begin
    if AAbsolutePosition.Y <= 0 then
      NewPosition := TPointF.Create(AAbsolutePosition.X, 0)
    else
      NewPosition := AAbsolutePosition;
  end;
  if NewPosition <> FLoupe.Position.Point then
    FLoupe.Position.Point := NewPosition;
end;

procedure TLoupeFactoryService.SetZoomRegionCenter(const AZoomPoint: TPointF);
var
  NewZoomCenter: TPointF;
begin
  if (FForControl <> nil) and (FForControl.Position.Y <= MAX_BOUNDARY_TOP) then
    NewZoomCenter := AZoomPoint - TPointF.Create(0, OFFSET_ZOOM_FOR_TOP_CONTROL)
  else
    NewZoomCenter := AZoomPoint;

  if NewZoomCenter <> FLoupe.ZoomRegionCenter.Point then
    FLoupe.ZoomRegionCenter.Point := NewZoomCenter;
end;

procedure TLoupeFactoryService.ShowFor(AControl: TControl);
var
  NeedUpdateStyle: Boolean;
begin
  //fix by xubzhlin 2017.5.4
  //解决iOS 原生Edit Memo 放大镜冲突
  Assert(AControl <> nil);
  Assert(AControl.Root <> nil);
  Assert(AControl.Root.GetObject <> nil);

  //<-----------------------------------------------
//  FForControl := AControl;
//  NeedUpdateStyle := FLoupe.Parent <> AControl.Root.GetObject;
//  FLoupe.Parent := AControl.Root.GetObject;
//  if NeedUpdateStyle then
//    FLoupe.ApplyStyleLookup;
//  FLoupe.ControlType := TControlType.Platform;
//  FLoupe.Visible := True;
  //-------------------------------------------------->
  //<++++++++++++++++++++++++++++++++++++++++++++++++++
  if not (AControl is TPresentedControl) and
    not (TPresentedControl(AControl).ControlType = TControlType.Platform) then
  begin
    FForControl := AControl;
    NeedUpdateStyle := FLoupe.Parent <> AControl.Root.GetObject;
    FLoupe.Parent := AControl.Root.GetObject;
    if NeedUpdateStyle then
      FLoupe.ApplyStyleLookup;
    FLoupe.ControlType := TControlType.Platform;
    FLoupe.Visible := True;
  end;
  //++++++++++++++++++++++++++++++++++++++++++++++++++>
end;

procedure RegisterAliases;
begin
  AddEnumElementAliases(TypeInfo(TLoupeMode), ['lmCircle', 'lmRectangle']);
  AddEnumElementAliases(TypeInfo(TZoomMode), ['zmAbsolute', 'zmRelative']);
end;

procedure UnregisterAliases;
begin
  RemoveEnumElementAliases(TypeInfo(TLoupeMode));
  RemoveEnumElementAliases(TypeInfo(TZoomMode));
end;

initialization
  RegisterAliases;
  RegisterFmxClasses([TMagnifierGlass]);
{$IFDEF IOS}
  TPlatformServices.Current.AddPlatformService(ILoupeService, TLoupeFactoryService.Create);
{$ENDIF}
finalization
  UnregisterAliases;
end.
