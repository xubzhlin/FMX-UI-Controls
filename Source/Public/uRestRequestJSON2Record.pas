unit uRestRequestJSON2Record;
//REST 返回 JSON 转 结构体
//Web Service 返回 数据 转 结构体

interface

uses
  IdURI, IdGlobal, System.JSON, System.SysUtils, uDataDefineUnit, uAWSChatCommUnit;

type
  //泛型 回调
  TJSON2RecFunc<R> = reference to function (Arg1: TJSONValue): R;

  TJSON2Record = class
  private
    class function DoGetValue<T>(AJson:TJSONValue; APath:String; var AValue:T):Boolean; static;
    class function DoRESTGetJSONObject<R>(Func:TJSON2RecFunc<R>; AData:String):R; static;  //REST 服务里返回的数据格式
    class function DoWEBGetJSONObject<R>(Func:TJSON2RecFunc<R>; AData:String):R; static;   //WebService 返回的数据格式
    class function DoHTTPGetJSONObject<R>(Func:TJSON2RecFunc<R>; AData:String):R; static;  //HTTP 返回的数据格式
    class function DoJSONValueToDateTime(AJson:TJSONValue; APath:String; const IsUTC:Boolean = False):TDateTime;static;
    class function DoAWSChatJSONObject<R>(Func:TJSON2RecFunc<R>; AData:String):R; static;  //AWS返回的数据格式
  public
    //Broker REST
    class function JSON2LoginResponse(AData:string):TLoginResponseRec; static; //解析登录信息

    //HCC REST
    class function JSON2BesideTailer(AData:string):TBesideTailerRec; static; //解析前后跟机
    class function JSON2MNTOptionDateTime(AData:string):TDateTime; static;  //解析完成时间
    class function JSON2Version(AData:string):TVersionInfo; static; //解析版本信息
    class function JSON2NextFlights(AData:string):TArray<TNextFlightRec>;
    class function JSON2RESTBoolean(AData:string):Boolean; static;      //解析Boolean类型
    class function JSON2RESTInteger(AData:string):Integer; static;      //解析Integer类型

    //TS REST
    class function JSON2TSBoolean(AData:string):Boolean; static;      //解析Boolean类型
    class function JSON2DateResult(AData:string):TDateResultRec; static;  //解析返回的时间

    //Web Service
    class function JSON2MNTTasks(AData:String):TArray<TMNTTaskRec>; static;  //最近维修任务
    class function JSON2MNTFiles(AData:String):TArray<TMNTFileRec>; static;  //最近维修任务
    class function JSON2TailerTasks(AData:String):TArray<TTailerTaskRec>; static;  //最近跟机维修任务
    class function JSON2TailerTaskFlights(AData:String):TArray<TTailerTaskFlightRec>; static;  //最近跟机维修任务航班
    class function JSON2MNTOtherTasks(AData:String):TArray<TMNTOtherTaskRec>; static;  //最近维修任务

    //AWS REST
    class function JSON2MTChats(AData:String):TArray<TAWSIotChatRec>; static;  //最近维修任务
    class function JSON2MTChat(AData:String):TAWSIotChatRec; static;  //新消息
    class function JSON2MTLatest(AData:String):TArray<TAWSIotLatestChatRec>; static; //最后一条消息

  end;

function Content2ExtInfo(Content:string; ContentType:TChatContentType):TAWSIotExtInfo; overload;
function Content2ExtInfo(Content:TJSONValue; ContentType:TChatContentType):TAWSIotExtInfo; overload;

implementation

uses
  uCommonTypesUnit, System.DateUtils, AWS.IoT.Comm, System.NetEncoding;



procedure SetSysDateFormat;
begin
  // 设定程序本身所使用的日期时间格式
  FormatSettings.LongDateFormat := 'yyyy-MM-dd';
  FormatSettings.ShortDateFormat := 'yyyy-MM-dd';
  FormatSettings.LongTimeFormat := 'hh:nn:ss';
  FormatSettings.ShortTimeFormat := 'hh:nn:ss';
  FormatSettings.DateSeparator := '-';
  FormatSettings.timeSeparator := ':';
end;


function Content2ExtInfo(Content:string; ContentType:TChatContentType):TAWSIotExtInfo;
var
  AJSON:TJSONValue;
begin
  try
    AJSON := TJSONObject.ParseJSONValue(Content);
    Result := Content2ExtInfo(AJSON, ContentType);
  finally
    AJSON.Free;
  end;
end;

function Content2ExtInfo(Content:TJSONValue; ContentType:TChatContentType):TAWSIotExtInfo; overload;
begin
  case ContentType of
    cctNote:;
    cctWord:
      Result.Text:=Content.GetValue<string>('text');//TNetEnCoding.URL.Decode(Content.GetValue<string>('text'));
    cctPicture:
      begin
        Result.FileName:=Content.GetValue<string>('filename');
        Result.Width:=Content.GetValue<Integer>('width');
        Result.Height:=Content.GetValue<Integer>('height');
      end;
    cctVoice, cctVideo:
      begin
        Result.FileName:=Content.GetValue<string>('filename');
        Result.Size:=Content.GetValue<Integer>('second');
      end;
    cctOther:
      begin
        Result.FileName:=Content.GetValue<string>('filename');
        Result.Sourcename:=Content.GetValue<string>('sourcename');
        Result.Size:=Content.GetValue<Integer>('size');
      end;
  end;
end;

{ TJSON2Record }

class function TJSON2Record.DoHTTPGetJSONObject<R>(Func: TJSON2RecFunc<R>;
  AData: String): R;
var
  AJson:TJSONValue;
  AStr:String;
begin
  //空格编码为加号替换掉
  AStr := ReplaceAll(AData, '+', ' ');
  AJson:=nil;
  try
     AJson:=TJSONObject.ParseJSONValue(AStr);
  finally
    //回调 JSON解析 函数
    if (AJson <> nil) and (AJson is TJSONObject) then
      Result:=Func(AJson)
    else
      Result:=Func(nil);
    AJson.Free;
  end;

end;

class function TJSON2Record.DoJSONValueToDateTime(AJson: TJSONValue;
  APath: String; const IsUTC:Boolean = False): TDateTime;
var
  s:String;
begin
  Result:=0;
  if AJson.TryGetValue(APath, s) then
  begin
    if s<>'' then
    begin
      if TryStrToDateTime(s, Result) then
      begin
        if IsUTC then
          Result := IncHour(Result, 8);
      end else
        Result:=0;
    end;
  end;

end;

class function TJSON2Record.DoRESTGetJSONObject<R>(Func:TJSON2RecFunc<R>; AData:String):R;
var
  AJson:TJSONObject;
  AArray:TJSONArray;
  AStr:String;
begin
  //空格编码为加号替换掉
  AStr := ReplaceAll(AData, '+', ' ');
  AJson:=nil;
  AArray:=nil;
  try
    AJson:=TJSONObject.ParseJSONValue(AStr) as TJSONObject;
    AArray := AJson.Values['result'] as TJSONArray;
  finally
    //回调 JSON解析 函数
    if (AArray<>nil) and (AArray.Count = 1) then
      Result:=Func(AArray.Items[0])
    else
      Result:=Func(nil);
    AJson.Free;
  end;

end;

class function TJSON2Record.DoWEBGetJSONObject<R>(Func: TJSON2RecFunc<R>;
  AData: String): R;
var
  AJSON:TJSONValue;
  AStr:String;
begin
  //空格编码为加号替换掉
  AStr := ReplaceAll(AData, '+', ' ');
  AJSON:=nil;
  try
    AJSON:=TJSONObject.ParseJSONValue(AStr);
  finally
    //回调 JSON解析 函数
    if (AJSON <> nil) and (AJSON is TJSONArray) then
      Result:=Func(AJSON)
    else
      Result:=Func(nil);
    AJSON.Free;
  end;

end;

class function TJSON2Record.DoAWSChatJSONObject<R>(Func: TJSON2RecFunc<R>;
  AData: String): R;
var
  AJson:TJSONValue;
  AStr:String;
begin
  //空格编码为加号替换掉
  AStr := ReplaceAll(AData, '+', ' ');
  AJson:=nil;
  try
    AJson:=TJSONObject.ParseJSONValue(AStr);
  finally
    //回调 JSON解析 函数
    if (AJson<>nil) and (AJson is TJSONArray) then
      Result:=Func(AJson)
    else
      Result:=Func(nil);
    AJson.Free;
  end;
end;

class function TJSON2Record.DoGetValue<T>(AJson: TJSONValue; APath: String;
  var AValue: T): Boolean;
var
  AStr:String;
  iLen:Integer;
begin
  Result:=False;
  try
    FillChar(AValue, Sizeof(T), 0);
    AStr:=AJson.GetValue<string>(APath);
    iLen:=Length(AStr)*SizeOf(Char);
    if iLen>SizeOf(T) then iLen:=SizeOf(T);
  {$IFDEF POSIX}
    System.Move(AStr[0], AValue, iLen);
  {$ELSE}
    System.Move(AStr[1], AValue, iLen);
  {$ENDIF}
    Result:=True;
  except
  end;

end;


class function TJSON2Record.JSON2BesideTailer(AData: string): TBesideTailerRec;
begin
  Result:=TJSON2Record.DoRESTGetJSONObject<TBesideTailerRec>(
    function(AJson:TJSONValue):TBesideTailerRec
    var
      AArray:TJSONArray;
      AItem:TJSONValue;
      AType:string;
    begin
      FillChar(Result, Sizeof(TBesideTailerRec), 0);
      if AJson <> nil then
      begin
        AJson.TryGetValue<Boolean>('ISDEPT', Result.IsDept);
        AJson.GetValue<Boolean>('ISOVER', Result.IsOver);
        if AJson.TryGetValue<TJSONValue>('CURRENT', AItem) then
        begin
          Result.Current:=AItem.GetValue<Int64>('EMPLOYEENUM')
        end;
        if AJson.TryGetValue<TJSONValue>('NEXT', AItem) then
        begin
          Result.Next:=AItem.GetValue<Int64>('EMPLOYEENUM')
        end;
      end;
    end, AData);
end;

class function TJSON2Record.JSON2DateResult(AData: string): TDateResultRec;
begin
  Result:=TJSON2Record.DoRESTGetJSONObject<TDateResultRec>(
    function(AJson:TJSONValue):TDateResultRec
    var
      Value:String;
    begin
      Result.State:=False;
      Result.DateTime:=0;
      if AJson <> nil then
      begin
        AJson.TryGetValue<Boolean>('result', Result.State);
        Result.DateTime:=DoJSONValueToDateTime(AJson, 'StateDateTime');
      end;
    end, AData);
end;

class function TJSON2Record.JSON2RESTBoolean(AData: string): Boolean;
begin
  Result:=TJSON2Record.DoRESTGetJSONObject<Boolean>(
    function(AJson:TJSONValue):Boolean
    var
      Value:String;
    begin
      if AJson = nil then
        Result:=False
      else
      begin
        Value:=UpperCase(AJson.ToJSON);
        if Value = 'TRUE' then Result:=True
        else if Value = 'FALSE' then Result:=False
        else Result:=False
      end;
    end, AData);
end;

class function TJSON2Record.JSON2RESTInteger(AData: string): Integer;
begin
  Result:=TJSON2Record.DoRESTGetJSONObject<Integer>(
    function(AJson:TJSONValue):Integer
    begin
      if AJson = nil then
        Result:=0
      else
      begin
        if not AJson.TryGetValue<Integer>('MAXID', Result) then
          Result:=0;
      end;
    end, AData);
end;

class function TJSON2Record.JSON2LoginResponse(
  AData: string): TLoginResponseRec;
begin
  Result:=TJSON2Record.DoRESTGetJSONObject<TLoginResponseRec>(
    function(AJson:TJSONValue):TLoginResponseRec
    var
      AItem:TJSONValue;
      Statue:string;
    begin
      FillChar(Result, Sizeof(TLoginResponseRec), 0);
      if AJson <> nil then
      begin
        Statue:=AJson.GetValue<string>('status');
        if Statue = 'success' then
        begin
          Result.Statue:=True;
          AItem:=(AJson as TJSONObject).Values['result'];
          if (AItem<>nil) and (not AItem.Null) then
          begin
            AItem.TryGetValue<Integer>('employeeNum', Result.EmployeeNum);
            AItem.TryGetValue<Integer>('departmentID', Result.DepartmentID);
            AItem.TryGetValue<Integer>('subDepartment', Result.SubDepartment);
            Result.UserDutyType:=TUserDutyType(AItem.GetValue<Integer>('userDutyType'));
            AItem.TryGetValue<Integer>('checkCode', Result.CheckCode);
            AItem.TryGetValue<string>('host', Result.Host);
            AItem.TryGetValue<Integer>('port', Result.Port);
          end;
        end
        else
        begin
          Result.Statue:=False;
          Result.Code:=AJson.GetValue<Integer>('ErrorCode');
        end;
      end;
    end, AData);
end;


class function TJSON2Record.JSON2MNTFiles(AData: String): TArray<TMNTFileRec>;
begin
  Result:=TJSON2Record.DoHTTPGetJSONObject<TArray<TMNTFileRec>>(
    function(AJson:TJSONValue):TArray<TMNTFileRec>
    var
      AItem:TJSONValue;
      AArray:TJSONArray;
      i:integer;
      MNTFile:TMNTFileRec;
    begin
      if AJson = nil then
        SetLength(Result, 0)
      else
      begin
        AArray :=AJson.GetValue<TJSONArray>('FILE');
        SetLength(Result, AArray.Count);
        for i := 0 to AArray.Count -1  do
        begin
          AItem:=AArray.Items[i];
          MNTFile.taskid:=AItem.GetValue<string>('taskid');
          MNTFile.msgkey:=AItem.GetValue<string>('msgkey');
          MNTFile.sourcename:=AItem.GetValue<string>('sourcename');
          MNTFile.filename:=AItem.GetValue<string>('filename');
          MNTFile.size:=AItem.GetValue<Integer>('size');
          MNTFile.otime:=DoJSONValueToDateTime(AItem, 'taskid');
          MNTFile.empid:=AItem.GetValue<Int64>('empid');

          Result[i]:=MNTFile;
        end;
      end;
    end, AData);

end;

class function TJSON2Record.JSON2MNTOptionDateTime(AData: string): TDateTime;
begin
//'{"result":[{"result":"true","resulttaskid":"266","resulcreatetime":"2018-03-30 13:21:25"}]}'
  Result:=TJSON2Record.DoRESTGetJSONObject<TDateTime>(
    function(AJson:TJSONValue):TDateTime
    var
      AItem:TJSONValue;
      Statue:string;
    begin
      Result:=0;
      if AJson <> nil then
      begin
        Statue:=AJson.GetValue<string>('result');
        if Statue = 'true' then
        begin
          Result:=DoJSONValueToDateTime(AJson, 'resulcreatetime');
        end;
      end;
    end, AData);
end;

class function TJSON2Record.JSON2MNTOtherTasks(
  AData: String): TArray<TMNTOtherTaskRec>;
begin
  Result:=TJSON2Record.DoWEBGetJSONObject<TArray<TMNTOtherTaskRec>>(
    function(AJson:TJSONValue):TArray<TMNTOtherTaskRec>
    var
      AItem:TJSONValue;
      AArray:TJSONArray;
      EmployeeNum:TJSONArray;
      i, j, State:integer;
      OtherTask:TMNTOtherTaskRec;
    begin
      if AJson = nil then
        SetLength(Result, 0)
      else
      begin
        AArray :=AJson as TJSONArray;
        SetLength(Result, AArray.Count);
        for i := 0 to AArray.Count -1  do
        begin
          AItem:=AArray.Items[i];
          OtherTask.TASKID:=AItem.GetValue<string>('TASKID');
          OtherTask.TASK_TITLE:=AItem.GetValue<string>('TASK_TITLE');
          if not AItem.TryGetValue<string>('TITLE', OtherTask.TITLE) then
            OtherTask.TITLE := '';
          if OtherTask.TASKID.IndexOf(TMNTTaskTypeNames[TMNTTaskType.mttAfterDep]) >= 0 then
            OtherTask.TaskType := TMNTTaskType.mttAfterDep
          else
          if OtherTask.TASKID.IndexOf(TMNTTaskTypeNames[TMNTTaskType.mttEndJob]) >= 0 then
            OtherTask.TaskType := TMNTTaskType.mttEndJob
          else
          if OtherTask.TASKID.IndexOf(TMNTTaskTypeNames[TMNTTaskType.mttRelease]) >= 0 then
            OtherTask.TaskType := TMNTTaskType.mttRelease
          else
            OtherTask.TaskType := TMNTTaskType.mttNone;

          OtherTask.ProcessState:= TMNTProcessState.mtpsNone;
          SetLength(OtherTask.EmployeeNum, 0);
          if AItem.TryGetValue<TJSONArray>('EmployeeNum', EmployeeNum) then
          begin
            SetLength(OtherTask.EmployeeNum, EmployeeNum.Count);
            for j := 0 to EmployeeNum.Count - 1 do
            begin
              AItem := EmployeeNum.Items[j];
              OtherTask.EmployeeNum[j]:=AItem.GetValue<Integer>('EMPID');
              State:=AItem.GetValue<Integer>('STATE');
              if State > ord(OtherTask.ProcessState) then
                OtherTask.ProcessState := TMNTProcessState(State);
            end;
          end;
          Result[i]:=OtherTask;
        end;
      end;
    end, AData);

end;

class function TJSON2Record.JSON2MTChat(AData: String): TAWSIotChatRec;
var
  ContentType:string;
  AJson:TJSONValue;
  Content:TJSONValue;
begin
  FillChar(Result, Sizeof(TAWSIotChatRec), 0);
  AJson:=TJSONObject.ParseJSONValue(AData);
  try
    Result.TopicRec._ChatClassType:=TChatClassType.cgtFlight;
    Result.TopicRec._ReceiverID:=AJson.GetValue<Int64>('FLTID');
    Result.TopicRec._Topic:=AJson.GetValue<string>('THEME');
    Result.TopicRec._Qos:=TAWSIoTMQTTQoS.AWSIoTMQTTQoSMessageDeliveryAttemptedAtLeastOnce;
    //Result.MsgRec._BaseName:=
    Result.MsgRec._ChatId:=AJson.GetValue<Int64>('MESSAGE_ID');
    Result.MsgRec._EmployeeNum:=AJson.GetValue<Int64>('EMPLOYEE_NUM');
    Result.MsgRec._ChatDateTime:=DoJSONValueToDateTime(AJson, 'CHAT_DATETIME');
    ContentType:=AJson.GetValue<string>('CHAT_CONTENT_TYPE');
    if TAWSIotContentTypes[TChatContentType.cctNote] = ContentType then
      Result.MsgRec._ChatContentType:=TChatContentType.cctNote
    else if TAWSIotContentTypes[TChatContentType.cctWord] = ContentType then
      Result.MsgRec._ChatContentType:=TChatContentType.cctWord
    else if TAWSIotContentTypes[TChatContentType.cctPicture] = ContentType then
      Result.MsgRec._ChatContentType:=TChatContentType.cctPicture
    else if TAWSIotContentTypes[TChatContentType.cctVoice] = ContentType then
      Result.MsgRec._ChatContentType:=TChatContentType.cctVoice
    else if TAWSIotContentTypes[TChatContentType.cctVideo] = ContentType then
      Result.MsgRec._ChatContentType:=TChatContentType.cctVideo
    else if TAWSIotContentTypes[TChatContentType.cctOther] = ContentType then
      Result.MsgRec._ChatContentType:=TChatContentType.cctOther;

    Content := AJson.GetValue<TJSONValue>('CHAT_CONTENT');
    Result.MsgRec._Chatstring := Content.ToJSON;
    Result.MsgRec._ExtInfo := Content2ExtInfo(Content, Result.MsgRec._ChatContentType);

    Result.MsgRec._Key:=AJson.GetValue<string>('KEY');
  finally
    AJson.Free;
  end;

end;

class function TJSON2Record.JSON2MTChats(AData: String): TArray<TAWSIotChatRec>;
begin
  Result:=TJSON2Record.DoAWSChatJSONObject<TArray<TAWSIotChatRec>>(
    function(AJson:TJSONValue):TArray<TAWSIotChatRec>
    var
      AItem:TJSONValue;
      Content:TJSONValue;
      AArray:TJSONArray;
      i:integer;
      ContentType:string;
      ChatRec:TAWSIotChatRec;
    begin
      if AJson = nil then
        SetLength(Result, 0)
      else
      begin
        AArray :=AJson as TJSONArray;
        SetLength(Result, AArray.Count);
        for i := 0 to AArray.Count -1  do
        begin
          AItem:=AArray.Items[i];
          ChatRec.TopicRec._ChatClassType:=TChatClassType.cgtFlight;
          ChatRec.TopicRec._ReceiverID:=Trunc(AItem.GetValue<Double>('FLTID'));
          ChatRec.MsgRec._ChatId:=Trunc(AItem.GetValue<Double>('MESSAGE_ID'));
          ChatRec.MsgRec._BaseName:=AItem.GetValue<string>('BASE_NAME');

          ChatRec.MsgRec._ChatDateTime:=DoJSONValueToDateTime(AItem, 'CHAT_DATETIME');
          ChatRec.MsgRec._EmployeeNum:=Trunc(AItem.GetValue<Double>('EMPLOYEE_NUM'));
          ContentType:=AItem.GetValue<string>('CHAT_CONTENT_TYPE');
          if TAWSIotContentTypes[TChatContentType.cctNote] = ContentType then
            ChatRec.MsgRec._ChatContentType:=TChatContentType.cctNote
          else if TAWSIotContentTypes[TChatContentType.cctWord] = ContentType then
            ChatRec.MsgRec._ChatContentType:=TChatContentType.cctWord
          else if TAWSIotContentTypes[TChatContentType.cctPicture] = ContentType then
            ChatRec.MsgRec._ChatContentType:=TChatContentType.cctPicture
          else if TAWSIotContentTypes[TChatContentType.cctVoice] = ContentType then
            ChatRec.MsgRec._ChatContentType:=TChatContentType.cctVoice
          else if TAWSIotContentTypes[TChatContentType.cctVideo] = ContentType then
            ChatRec.MsgRec._ChatContentType:=TChatContentType.cctVideo
          else if TAWSIotContentTypes[TChatContentType.cctOther] = ContentType then
            ChatRec.MsgRec._ChatContentType:=TChatContentType.cctOther;

          Content := AItem.GetValue<TJSONValue>('CHAT_CONTENT');
          ChatRec.MsgRec._Chatstring := Content.ToJSON;
          ChatRec.MsgRec._ExtInfo := Content2ExtInfo(Content, ChatRec.MsgRec._ChatContentType);

          ChatRec.MsgRec._Key:=AItem.GetValue<string>('KEY');
          ChatRec.TopicRec._Topic:=AItem.GetValue<string>('THEME');
          ChatRec.TopicRec._Qos:=TAWSIoTMQTTQoS.AWSIoTMQTTQoSMessageDeliveryAttemptedAtLeastOnce;

          Result[i]:=ChatRec;
        end;
      end;
    end, AData);
end;

class function TJSON2Record.JSON2MTLatest(
  AData: String): TArray<TAWSIotLatestChatRec>;
begin
  Result:=TJSON2Record.DoAWSChatJSONObject<TArray<TAWSIotLatestChatRec>>(
    function(AJson:TJSONValue):TArray<TAWSIotLatestChatRec>
    var
      AItem,Content:TJSONValue;
      AArray:TJSONArray;
      i:integer;
      ContentType:string;
      Latest:TAWSIotLatestChatRec;
    begin
      if AJson = nil then
        SetLength(Result, 0)
      else
      begin
        AArray :=AJson as TJSONArray;
        SetLength(Result, AArray.Count);
        for i := 0 to AArray.Count -1  do
        begin
          FillChar(Latest, SizeOf(TAWSIotLatestChatRec), 0);
          AItem:=AArray.Items[i];
          Latest.IsFirstRead:=False;
          Latest.IsSub:=False;
          Latest.Unread:=AItem.GetValue<Integer>('Unread');
          AItem:=AItem.GetValue<TJSONObject>('Item');

          if (AItem as TJSONObject).Count <> 0 then
          begin
            Latest.ChatRec.TopicRec._ChatClassType:=TChatClassType.cgtFlight;
            Latest.ChatRec.TopicRec._ReceiverID:=Trunc(AItem.GetValue<Double>('FLTID'));
            Latest.ChatRec.MsgRec._ChatId:=Trunc(AItem.GetValue<Double>('MESSAGE_ID'));
            Latest.ChatRec.MsgRec._BaseName:=AItem.GetValue<string>('BASE_NAME');

            Latest.ChatRec.MsgRec._ChatDateTime:=DoJSONValueToDateTime(AItem, 'CHAT_DATETIME');
            Latest.ChatRec.MsgRec._EmployeeNum:=Trunc(AItem.GetValue<Double>('EMPLOYEE_NUM'));
            ContentType:=AItem.GetValue<string>('CHAT_CONTENT_TYPE');
            if TAWSIotContentTypes[TChatContentType.cctNote] = ContentType then
              Latest.ChatRec.MsgRec._ChatContentType:=TChatContentType.cctNote
            else if TAWSIotContentTypes[TChatContentType.cctWord] = ContentType then
              Latest.ChatRec.MsgRec._ChatContentType:=TChatContentType.cctWord
            else if TAWSIotContentTypes[TChatContentType.cctPicture] = ContentType then
              Latest.ChatRec.MsgRec._ChatContentType:=TChatContentType.cctPicture
            else if TAWSIotContentTypes[TChatContentType.cctVoice] = ContentType then
              Latest.ChatRec.MsgRec._ChatContentType:=TChatContentType.cctVoice
            else if TAWSIotContentTypes[TChatContentType.cctVideo] = ContentType then
              Latest.ChatRec.MsgRec._ChatContentType:=TChatContentType.cctVideo
            else if TAWSIotContentTypes[TChatContentType.cctOther] = ContentType then
              Latest.ChatRec.MsgRec._ChatContentType:=TChatContentType.cctOther;

            Content := AItem.GetValue<TJSONValue>('CHAT_CONTENT');
            Latest.ChatRec.MsgRec._Chatstring := Content.ToJSON;
            Latest.ChatRec.MsgRec._ExtInfo := Content2ExtInfo(Content, Latest.ChatRec.MsgRec._ChatContentType);

            Latest.ChatRec.MsgRec._Key:=AItem.GetValue<string>('KEY');
            Latest.ChatRec.TopicRec._Topic:= AItem.GetValue<string>('THEME');
            Latest.ChatRec.TopicRec._Qos:=TAWSIoTMQTTQoS.AWSIoTMQTTQoSMessageDeliveryAttemptedAtLeastOnce;
          end;
          Result[i]:=Latest;
        end;
      end;
    end, AData);
end;

class function TJSON2Record.JSON2NextFlights(
  AData: string): TArray<TNextFlightRec>;
begin
  Result:=TJSON2Record.DoRESTGetJSONObject<TArray<TNextFlightRec>>(
    function(AJson:TJSONValue):TArray<TNextFlightRec>
    var
      AItem:TJSONValue;
      AArray:TJSONArray;
      i:integer;
      NextFlightRec:TNextFlightRec;
    begin
      if AJson = nil then
        SetLength(Result, 0)
      else
      begin
        AArray :=AJson as TJSONArray;
        SetLength(Result, AArray.Count);
        for i := 0 to AArray.Count -1  do
        begin
          AItem:=AArray.Items[i];
          NextFlightRec.FLTID:=AItem.GetValue<Int64>('FLTID');
          NextFlightRec.FLTNO:=AItem.GetValue<string>('FLTNO');
          NextFlightRec.DEPSTN:=AItem.GetValue<string>('DEPSTN');
          if not AItem.TryGetValue<string>('DEPPOS', NextFlightRec.DEPPOS) then
            NextFlightRec.DEPPOS := '';
          NextFlightRec.ARRSTN:=AItem.GetValue<string>('ARRSTN');
          if not AItem.TryGetValue<string>('ARRPOS', NextFlightRec.ARRPOS) then
            NextFlightRec.ARRPOS := '';
          NextFlightRec.ATD:=DoJSONValueToDateTime(AItem, 'ATD');
          NextFlightRec.ATA:=DoJSONValueToDateTime(AItem, 'ATA');

          Result[i]:=NextFlightRec;
        end;
      end;
    end, AData);
end;

class function TJSON2Record.JSON2MNTTasks(AData: String): TArray<TMNTTaskRec>;
begin
  Result:=TJSON2Record.DoHTTPGetJSONObject<TArray<TMNTTaskRec>>(
    function(AJson:TJSONValue):TArray<TMNTTaskRec>
    var
      AItem:TJSONValue;
      AArray:TJSONArray;
      AMRODATA:TJSONValue;
      i:integer;
      MTTask:TMNTTaskRec;
      FlightState:string;
      State:Integer;
    begin
      if AJson = nil then
        SetLength(Result, 0)
      else
      begin
        AArray :=AJson.GetValue<TJSONArray>('DATA');
        SetLength(Result, AArray.Count);
        for i := 0 to AArray.Count -1  do
        begin
          FillChar(MTTask, SizeOf(TMNTTaskRec), 0);
          AItem:=AArray.Items[i];
          MTTask.TASKID:=AItem.GetValue<string>('TASKID');

          if MTTask.TASKID.IndexOf(TMNTTaskTypeNames[TMNTTaskType.mttAfterDep]) >= 0 then
            MTTask.TaskType := TMNTTaskType.mttAfterDep
          else
          if MTTask.TASKID.IndexOf(TMNTTaskTypeNames[TMNTTaskType.mttEndJob]) >= 0 then
            MTTask.TaskType := TMNTTaskType.mttEndJob
          else
          if MTTask.TASKID.IndexOf(TMNTTaskTypeNames[TMNTTaskType.mttRelease]) >= 0 then
            MTTask.TaskType := TMNTTaskType.mttRelease
          else
            MTTask.TaskType := TMNTTaskType.mttNone;

          MTTask.TASKMode:=TMNTaskMode(AItem.GetValue<Integer>('TASKMODE'));
          MTTask.ProcessState:=TMNTProcessState(AItem.GetValue<Integer>('PROCESSSTATE'));
          MTTask.STATEDATETIME:=DoJSONValueToDateTime(AItem, 'STATEDATETIME');
          MTTask.FltId:=AItem.GetValue<Int64>('FLTID');
          MTTask.STC:=AItem.GetValue<Char>('STC');
          MTTask.AC:=AItem.GetValue<string>('AC');
          MTTask.FltNo:=AItem.GetValue<string>('FLTNO');
          MTTask.DEPSTN:=AItem.GetValue<string>('DEPSTN');
          MTTask.DEPPOS:=AItem.GetValue<string>('DEPPOS');
          MTTask.ARRSTN:=AItem.GetValue<string>('ARRSTN');
          MTTask.ARRPOS:=AItem.GetValue<string>('ARRPOS');
          MTTask.ATD:=DoJSONValueToDateTime(AItem, 'ATD', True);
          MTTask.ATA:=DoJSONValueToDateTime(AItem, 'ATA', True);

          FlightState:=UpperCase(AItem.GetValue<string>('STATUS'));
          if FlightState = TEnglishStatusTypes[TStatusType.stNone] then
            MTTask.STATUS:=TStatusType.stNone
          else if FlightState = TEnglishStatusTypes[TStatusType.stNone] then
            MTTask.STATUS:=TStatusType.stNone
          else if FlightState = TEnglishStatusTypes[TStatusType.stSCH] then
            MTTask.STATUS:=TStatusType.stSCH
          else if FlightState = TEnglishStatusTypes[TStatusType.stCNL] then
            MTTask.STATUS:=TStatusType.stCNL
          else if FlightState = TEnglishStatusTypes[TStatusType.stDLA] then
            MTTask.STATUS:=TStatusType.stDLA
          else if FlightState = TEnglishStatusTypes[TStatusType.stDEP] then
            MTTask.STATUS:=TStatusType.stDEP
          else if FlightState = TEnglishStatusTypes[TStatusType.stATA] then
            MTTask.STATUS:=TStatusType.stATA
          else if FlightState = TEnglishStatusTypes[TStatusType.stDIV] then
            MTTask.STATUS:=TStatusType.stDIV
          else if FlightState = TEnglishStatusTypes[TStatusType.stChange] then
            MTTask.STATUS:=TStatusType.stChange
          else if FlightState = TEnglishStatusTypes[TStatusType.stReturn] then
            MTTask.STATUS:=TStatusType.stReturn;

          AMRODATA:=TJSONObject.ParseJSONValue(AItem.GetValue<string>('AMRODATA'));
          try


            AMRODATA.TryGetValue<string>('TASK_TITLE', MTTask.AMOR.TASKTITLE);
            AMRODATA.TryGetValue<string>('TITLE', MTTask.AMOR.TITLE);
            MTTask.AMOR.START_DATE:=DoJSONValueToDateTime(AMRODATA, 'START_DATE');
            MTTask.AMOR.END_DATE:=DoJSONValueToDateTime(AMRODATA, 'END_DATE');
            AMRODATA.TryGetValue<string>('WS_NO', MTTask.AMOR.WS_NO);
            AMRODATA.TryGetValue<string>('NOTICE_NO', MTTask.AMOR.NOTICE_NO);
            AMRODATA.TryGetValue<string>('PO_NO', MTTask.AMOR.PO_NO);
            AMRODATA.TryGetValue<string>('ACNO', MTTask.AMOR.ACNO);
            AMRODATA.TryGetValue<string>('TASK_TYPE', MTTask.AMOR.TASK_TYPE);
            AMRODATA.TryGetValue<string>('TASK_NO', MTTask.AMOR.TASK_NO);
            AMRODATA.TryGetValue<string>('MT_BASE', MTTask.AMOR.MT_BASE);
            AMRODATA.TryGetValue<string>('MT_BASE_NAME', MTTask.AMOR.MT_BASE_NAME);
            AMRODATA.TryGetValue<string>('MT_TYPE', MTTask.AMOR.MT_TYPE);
            AMRODATA.TryGetValue<string>('MT_UNIT', MTTask.AMOR.MT_UNIT);
            AMRODATA.TryGetValue<string>('ITEM_SEQ', MTTask.AMOR.ITEM_SEQ);
            AMRODATA.TryGetValue<string>('JC_NO', MTTask.AMOR.JC_NO);
            AMRODATA.TryGetValue<string>('JC_VER', MTTask.AMOR.JC_VER);
            AMRODATA.TryGetValue<string>('ITEM_NO', MTTask.AMOR.ITEM_NO);
            AMRODATA.TryGetValue<string>('ITEM_VER', MTTask.AMOR.ITEM_VER);
            AMRODATA.TryGetValue<string>('CTR_INTERVAL', MTTask.AMOR.CTR_INTERVAL);
            AMRODATA.TryGetValue<string>('WS_STATE', MTTask.AMOR.WS_STATE);
            AMRODATA.TryGetValue<string>('INSPECTION_LEVEL', MTTask.AMOR.INSPECTION_LEVEL);
          finally
            AMRODATA.Free;
          end;

          MTTask.FltState:=TFltProcessState.fpsNone;
          AMRODATA:=TJSONObject.ParseJSONValue(AItem.GetValue<string>('ASTATE'));
          try
            if (MTTask.FltState=TFltProcessState.fpsNone) and AMRODATA.TryGetValue<Integer>('O', State) then
            begin
              if State = 1 then
                MTTask.FltState := TFltProcessState.fpsComplet;
            end;

            if (MTTask.FltState=TFltProcessState.fpsNone) and AMRODATA.TryGetValue<Integer>('S', State) then
            begin
              if State = 1 then
                MTTask.FltState := TFltProcessState.fpsRelease;
            end;

          finally
            AMRODATA.Free;
          end;

          Result[i]:=MTTask;
        end;
      end;
    end, AData);

end;

class function TJSON2Record.JSON2TailerTaskFlights(
  AData: String): TArray<TTailerTaskFlightRec>;
begin
  Result:=TJSON2Record.DoWEBGetJSONObject<TArray<TTailerTaskFlightRec>>(
    function(AJson:TJSONValue):TArray<TTailerTaskFlightRec>
    var
      AItem:TJSONValue;
      AArray:TJSONArray;
      i:integer;
      TailerTaskFlight:TTailerTaskFlightRec;
      Status:TStatusType;
      EnglishStatus:string;
    begin
      if AJson = nil then
        SetLength(Result, 0)
      else
      begin
        AArray :=AJson as TJSONArray;
        SetLength(Result, AArray.Count);
        for i := 0 to AArray.Count -1  do
        begin
          AItem:=AArray.Items[i];
          TailerTaskFlight.FLTNO:=AItem.GetValue<string>('FLTNO');
          TailerTaskFlight.AC:=AItem.GetValue<string>('AC');
          TailerTaskFlight.DEPSTN:=AItem.GetValue<string>('DEPSTN');
          TailerTaskFlight.ARRSTN:=AItem.GetValue<string>('ARRSTN');
          TailerTaskFlight.ATD:=DoJSONValueToDateTime(AItem, 'ATD');
          TailerTaskFlight.ATA:=DoJSONValueToDateTime(AItem, 'ATA');
          EnglishStatus := AItem.GetValue<string>('STATUS');
          TailerTaskFlight.Status := TStatusType.stNone;
          for Status := low(TStatusType) to high(TStatusType) do
          begin
            if TEnglishStatusTypes[Status] = EnglishStatus then
            begin
              TailerTaskFlight.Status := Status;
              Break;
            end;
          end;
          Result[i]:=TailerTaskFlight;
        end;
      end;
    end, AData);

end;

class function TJSON2Record.JSON2TailerTasks(
  AData: String): TArray<TTailerTaskRec>;
begin
  Result:=TJSON2Record.DoWEBGetJSONObject<TArray<TTailerTaskRec>>(
    function(AJson:TJSONValue):TArray<TTailerTaskRec>
    var
      AItem:TJSONValue;
      AArray:TJSONArray;
      i:integer;
      TailerTask:TTailerTaskRec;
    begin
      if AJson = nil then
        SetLength(Result, 0)
      else
      begin
        AArray :=AJson as TJSONArray;
        SetLength(Result, AArray.Count);
        for i := 0 to AArray.Count -1  do
        begin
          AItem:=AArray.Items[i];
          TailerTask.TaskId:=AItem.GetValue<Integer>('TASKID');
          TailerTask.TaskRoute:=AItem.GetValue<string>('TASKROUTE');
          TailerTask.BeginTime:=DoJSONValueToDateTime(AItem, 'TASKBEGTIME');
          TailerTask.EndTime:=DoJSONValueToDateTime(AItem, 'TASKENDTIME');
          TailerTask.Date:=Trunc(TailerTask.BeginTime);
          Result[i]:=TailerTask;
        end;
      end;
    end, AData);
end;

class function TJSON2Record.JSON2TSBoolean(AData: string): Boolean;
begin
  Result:=TJSON2Record.DoRESTGetJSONObject<Boolean>(
    function(AJson:TJSONValue):Boolean
    var
      Value:String;
    begin
      Result:=False;
      if AJson <> nil then
      begin
        AJson.TryGetValue<Boolean>('result', Result);
      end;
    end, AData);
end;

class function TJSON2Record.JSON2Version(AData: string): TVersionInfo;
begin
  Result:=TJSON2Record.DoRESTGetJSONObject<TVersionInfo>(
    function(AJson:TJSONValue):TVersionInfo
    begin
      FillChar(Result, Sizeof(TVersionInfo), 0);
      Result.V1:=AJson.GetValue<integer>('V1');
      Result.V2:=AJson.GetValue<integer>('V2');
      Result.V3:=AJson.GetValue<integer>('V3');
      Result.V4:=AJson.GetValue<integer>('V4');
      Result.V5:=TVersionType(AJson.GetValue<integer>('V5'));
    {$IFDEF iOS}
      Result.URL:=AJson.GetValue<string>('IOSURL');
    {$ENDIF}
    {$IFDEF Android}
      Result.URL:=AJson.GetValue<string>('ANDORIDURL');
    {$ENDIF}
    {$IFDEF MSWINDOWS}
      Result.URL:=AJson.GetValue<string>('ANDORIDURL');
    {$ENDIF}
    end, AData);
end;

initialization
  SetSysDateFormat;

end.
