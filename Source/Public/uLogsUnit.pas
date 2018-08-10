unit uLogsUnit;

interface

procedure LogInfo(const AFormat: string; const Params: array of const); overload;
procedure LogInfo(const AFormat: string); overload;

implementation

uses
{$IFDEF iOS}
  iOSapi.Foundation, Macapi.Helpers,
{$ENDIF}
{$IFDEF ANDROID}
  Androidapi.Log,
{$ENDIF}
  System.SysUtils;
procedure LogInfo(const AFormat: string); overload;
{$IFDEF iOS}
begin
  NSLog(StringToID(AFormat));
{$ENDIF}
{$IFDEF ANDROID}
var
  M: TMarshaller;
begin
  LogI(M.AsAnsi(AFormat).ToPointer);
{$ENDIF}
{$IFDEF MSWINDOWS}
begin
{$ENDIF}
end;

procedure LogInfo(const AFormat: string; const Params: array of const);
begin
  LogInfo(Format(AFormat, Params));
end;

end.
