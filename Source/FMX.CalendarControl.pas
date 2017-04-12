unit FMX.CalendarControl;

interface

uses
  System.Classes, System.SysUtils, System.Types, System.UITypes, System.DateUtils, FMX.Platform, FMX.Controls, FMX.Layouts, FMX.Types, FMX.Calendar, FMX.ListView, FMX.ListView.Types, FMX.CalendarItemAppearance;

const
  TWeeks: array [0 .. 6] of string = ('日', '一', '二', '三', '四',
    '五', '六');
    (*
  TMonths: array [1 .. 12] of string = ('一月', '二月', '三月', '四月', '五月', '六月',
    '七月', '八月', '九月', '十月', '十一月', '十二月'); *)
  TMonths: array [1 .. 12] of String = (
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  );
type
  TWeekLayout = class(TControl)
  private
    procedure DoDrawDay(LocRect:TRectF; AIndex:Integer);
  protected
    procedure Paint; override;
  end;

  TCalendarControl = class(TControl)
  private
    FFirstDayOfWeekNum:Integer;
    FWeekLayout:TWeekLayout;
    FCalenderView:TCalenderView;

    FSelectedItem:TClendarDayItem;
    FIsClickDayItem:Boolean;
    FAtPoint:TPointF;
    FOnGetItemIsMark:TOnGetItemIsMark;
    FOnSelectedItem:TNotifyEvent;

    FNeedFillDays:Boolean;
    FStartDate: TDate;
    FEndDate: TDate;

    procedure SetSelectedDate(const Value: TDate);
    function GetModel: TCalendarModel;
    function DefineItemIndexOfFirstDayInMonth(ADate:TDate):Integer;
    procedure FillDays;
    procedure DoCalenderViewMouseDown(Sender:TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure DoCalenderViewMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Single);
    procedure DoCalenderViewItemClickEx(const Sender: TObject; ItemIndex: Integer; const LocalClickPos: TPointF; const ItemObject: TListItemDrawable);
    procedure DoGetItemIsMark(ADayItem:TClendarDayItem; var AIsMark:Boolean);
    function GetSelectedDate: TDate;
    function CheckDateChnaged(NewValue, OldValue:TDate; IsStartDate:Boolean = True):Boolean;
    procedure SetEndDate(const Value: TDate);
    procedure SetStartDate(const Value: TDate);
  protected
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property StartData:TDate read FStartDate write SetStartDate;
    property EndData:TDate read FEndDate write SetEndDate;
    property FirstDayOfWeek:Integer read FFirstDayOfWeekNum write FFirstDayOfWeekNum;
    property SelectedDate:TDate read GetSelectedDate write SetSelectedDate;
    property OnGetItemIsMark:TOnGetItemIsMark read FOnGetItemIsMark write FOnGetItemIsMark;
    property OnSelectedItem:TNotifyEvent read FOnSelectedItem write FOnSelectedItem;
  end;

implementation

{ TWeekLayout }

procedure TWeekLayout.DoDrawDay(LocRect: TRectF; AIndex: Integer);
begin
  Canvas.Fill.Color:=$FF000000;
  Canvas.FillText(LocRect, TWeeks[AIndex], False , 1, [], TTextAlign.Center, TTextAlign.Center);
end;

procedure TWeekLayout.Paint;
var
  i: Integer;
  ARect:TRectF;
  OffSetX:Single;
begin
  OffSetX:=ClipRect.Width / 7;
  ARect.Top:=ClipRect.Top;
  ARect.Left:=ClipRect.Left;
  ARect.Height:=ClipRect.Height;
  ARect.Width:= OffSetX;
  for i := 0 to 6 do
  begin
    DoDrawDay(ARect, i);
    ARect.Offset(OffSetX, 0);
  end;
end;

{ TCalendarControl }

function TCalendarControl.CheckDateChnaged(NewValue, OldValue: TDate; IsStartDate:Boolean = True): Boolean;
begin
  if (MonthOf(NewValue)<MonthOf(OldValue)) and IsStartDate then
    Result:=True
  else
  if (MonthOf(NewValue)>MonthOf(OldValue)) and (not IsStartDate) then
    Result:=True
  else
    Result:=False;
end;

constructor TCalendarControl.Create(AOwner: TComponent);
var
  LocaleService:IFMXLocaleService;
begin
  inherited;
  //默认 最近两个月
  FStartDate:=Now;
  FEndDate:=IncMonth(Now, 1);

  FSelectedItem:=nil;

  if TPlatformServices.Current.SupportsPlatformService(IFMXLocaleService, LocaleService) then
    FFirstDayOfWeekNum := LocaleService.GetFirstWeekday
  else
    FFirstDayOfWeekNum := DayMonday;

  FWeekLayout:=TWeekLayout.Create(Self);
  FWeekLayout.Height:=28;
  FWeekLayout.Parent:=Self;
  FWeekLayout.Align:=TAlignLayout.Top;

  FCalenderView:=TCalenderView.Create(Self);
  FCalenderView.Parent:=Self;
  FCalenderView.Align:=TAlignLayout.Client;
  FCalenderView.OnMouseDown:=DoCalenderViewMouseDown;
  FCalenderView.OnMouseMove:=DoCalenderViewMouseMove;
  FCalenderView.OnItemClickEx:=DoCalenderViewItemClickEx;
  FCalenderView.OnGetItemIsMark:=DoGetItemIsMark;
  FCalenderView.ItemAppearanceName:='ClendarDayListItem';
  FCalenderView.CanSwipeDelete:=False;
  FCalenderView.ShowSelection:=False;

  FWeekLayout.Margins.Left:= FCalenderView.ItemSpaces.Left;
  FWeekLayout.Margins.Right:= FCalenderView.ItemSpaces.Right;

  FNeedFillDays:=True;
end;

function TCalendarControl.DefineItemIndexOfFirstDayInMonth(ADate:TDate): Integer;
var
  Interval: Integer;
  BeginDate: TDateTime;
begin
  Interval := DaysPerWeek - FFirstDayOfWeekNum;
  BeginDate := RecodeDay(ADate, 1);
  Result := (Interval + DayOfTheWeek(BeginDate)) mod DaysPerWeek;
end;

destructor TCalendarControl.Destroy;
begin
  FSelectedItem:=nil;
  FWeekLayout.Free;
  FCalenderView.Free;
  inherited;
end;

procedure TCalendarControl.DoCalenderViewItemClickEx(const Sender: TObject;
  ItemIndex: Integer; const LocalClickPos: TPointF;
  const ItemObject: TListItemDrawable);
begin
  if FIsClickDayItem and (ItemObject is TClendarDayItem) then
  begin
    if TClendarDayItem(ItemObject).Day = 0 then exit;
    if FSelectedItem<>nil then
      FSelectedItem.IsSelected:=False;
    FSelectedItem:=TClendarDayItem(ItemObject);
    FSelectedItem.IsSelected:=True;
    if Assigned(FOnSelectedItem) then
      FOnSelectedItem(FSelectedItem);
  end;
end;

procedure TCalendarControl.DoCalenderViewMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  FIsClickDayItem := True;
  FAtPoint := TPointF.Create(X, Y);
end;

procedure TCalendarControl.DoCalenderViewMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Single);
begin
  if FIsClickDayItem then
  begin
    // 偏移了10 认为不是点击
    if (Abs(FAtPoint.X - X) > 10) or (Abs(FAtPoint.Y - Y) > 10) then
      FIsClickDayItem := False;
  end;
end;

procedure TCalendarControl.DoGetItemIsMark(ADayItem: TClendarDayItem; var AIsMark: Boolean);
begin
  if Assigned(FOnGetItemIsMark) then
    FOnGetItemIsMark(ADayItem, AIsMark);
end;

procedure TCalendarControl.FillDays;
var
  FDate:TDate;
  First: Word;
  Year:Word;
  ItemIndex, NewIndex:Integer;
  AItem:TClendarWeekListViewItem;
  procedure FillDaysOfMonth(ADate:TDate);
  var
    DaysInMonthTmp: Word;
    Day:Word;
    I: Word;
  begin
    //FillMonth
    ItemIndex:= -1;
    DaysInMonthTmp := DaysInMonth(ADate);
    for I := First to First + DaysInMonthTmp - 1 do
    begin
      NewIndex:= i div 7;
      if NewIndex>ItemIndex then
      begin
        AItem:=TClendarWeekListViewItem(FCalenderView.Items.Add);
        ItemIndex:= NewIndex;
      end;
      Day:= I - First + 1;
      case (i+FFirstDayOfWeekNum) mod 7 of
        0:AItem.SunDayItem.Day:= Trunc(RecodeDay(ADate, Day));
        1:AItem.MonDayItem.Day:= Trunc(RecodeDay(ADate, Day));
        2:AItem.TurDayItem.Day:= Trunc(RecodeDay(ADate, Day));
        3:AItem.WedDayItem.Day:= Trunc(RecodeDay(ADate, Day));
        4:AItem.ThuDayItem.Day:= Trunc(RecodeDay(ADate, Day));
        5:AItem.RuiDayItem.Day:= Trunc(RecodeDay(ADate, Day));
        6:AItem.SatDayItem.Day:= Trunc(RecodeDay(ADate, Day));
      end;
    end;
  end;
  procedure FillMonth(ADate:TDate);
  var
    AYear:Word;
  begin
    AYear:=YearOf(ADate);
    //FillYear
    if (Year=0) or (AYear<>Year) then
    begin
      Year:=AYear;
      AItem:=TClendarWeekListViewItem(FCalenderView.Items.Add);
      AItem.Height:=28;
      AItem.YearItem.Year:=Year;
    end;
    AItem:=TClendarWeekListViewItem(FCalenderView.Items.Add);
    AItem.Text:=TMonths[MonthOf(ADate)];
    First := DefineItemIndexOfFirstDayInMonth(ADate);
    case (First+FFirstDayOfWeekNum) mod 7 of
      0:AItem.Objects.TextObject.PlaceOffset.X:=AItem.SunDayItem.PlaceOffset.X;
      1:AItem.Objects.TextObject.PlaceOffset.X:=AItem.MonDayItem.PlaceOffset.X;
      2:AItem.Objects.TextObject.PlaceOffset.X:=AItem.TurDayItem.PlaceOffset.X;
      3:AItem.Objects.TextObject.PlaceOffset.X:=AItem.WedDayItem.PlaceOffset.X;
      4:AItem.Objects.TextObject.PlaceOffset.X:=AItem.ThuDayItem.PlaceOffset.X;
      5:AItem.Objects.TextObject.PlaceOffset.X:=AItem.RuiDayItem.PlaceOffset.X;
      6:AItem.Objects.TextObject.PlaceOffset.X:=AItem.SatDayItem.PlaceOffset.X;
    end;
    FillDaysOfMonth(ADate);
  end;
begin
  FCalenderView.Items.Clear;
  FCalenderView.BeginUpdate;
  try
    Year:=0;
    FDate:=FStartDate;
    while (FDate<FEndDate) or (Monthof(FDate)<=Monthof(FEndDate)) do
    begin
      FillMonth(FDate);
      FDate:=IncMonth(FDate);
    end;
  finally
    FCalenderView.EndUpdate;
  end;
end;


function TCalendarControl.GetModel: TCalendarModel;
begin

end;

function TCalendarControl.GetSelectedDate: TDate;
begin
  if FSelectedItem = nil then
    Result:=Trunc(Now)
  else
    Result:=FSelectedItem.Day;
end;

procedure TCalendarControl.Paint;
begin
  if FNeedFillDays then
  begin
    FillDays;
    FNeedFillDays:=False;
  end;
  inherited;
end;

procedure TCalendarControl.SetEndDate(const Value: TDate);
begin
  if CheckDateChnaged(Value, FEndDate, False) then
  begin
    FEndDate := Value;
    FNeedFillDays:=True;
  end;
end;

procedure TCalendarControl.SetSelectedDate(const Value: TDate);
var
  i:integer;
  AItem:TClendarWeekListViewItem;
  LObject:TClendarDayItem;
  NewDay:Int64;
begin
  LObject:=nil;
  NewDay:=Trunc(Value);
  if (FSelectedItem = nil) or (FSelectedItem.Day<>NewDay) then
  begin
    if FSelectedItem <>nil then
      FSelectedItem.IsSelected:=False;
    for i := 0 to FCalenderView.Items.Count-1 do
    begin
      AItem:=TClendarWeekListViewItem(FCalenderView.Items[i]);
      LObject:=AItem.FindDayItem(NewDay);
      if LObject<>nil then
      begin
        FSelectedItem:=LObject;
        FSelectedItem.IsSelected:=True;
        Break;
      end;
    end;
  end;
end;

procedure TCalendarControl.SetStartDate(const Value: TDate);
begin
  if CheckDateChnaged(Value, FStartDate, True) then
  begin
    FStartDate := Value;
    FNeedFillDays:=True;
  end;
end;

end.
