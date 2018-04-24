unit FormulaFunction;

interface

uses
  System.SysUtils;

implementation

uses FormulaAnalysisService, System.Math;

type
  TMaxFunction = class(TFormulaFunction)
    class function Calculate(Numbers:array of Double; Count:Integer):Double; override;
  end;

  TMinFunction = class(TFormulaFunction)
    class function Calculate(Numbers:array of Double; Count:Integer):Double; override;
  end;

  TAbsFunction = class(TFormulaFunction)
    class function Calculate(Numbers:array of Double; Count:Integer):Double; override;
  end;

  TSumFunction = class(TFormulaFunction)
    class function Calculate(Numbers:array of Double; Count:Integer):Double; override;
  end;

  TAvgFunction = class(TFormulaFunction)
    class function Calculate(Numbers:array of Double; Count:Integer):Double; override;
  end;

  TStddevFunction = class(TFormulaFunction)
    class function Calculate(Numbers:array of Double; Count:Integer):Double; override;
  end;

  TModFunction = class(TFormulaFunction)
    class function Calculate(Numbers:array of Double; Count:Integer):Double; override;
  end;


procedure RegisterFunction;
begin
  //注册内置的方法函数
  TFormulaAnalysisService.RegisterFunction('MAX', TMaxFunction);
  TFormulaAnalysisService.RegisterFunction('MIN', TMinFunction);
  TFormulaAnalysisService.RegisterFunction('ABS', TAbsFunction);
  TFormulaAnalysisService.RegisterFunction('SUM', TSumFunction);
  TFormulaAnalysisService.RegisterFunction('AVG', TAvgFunction);
  TFormulaAnalysisService.RegisterFunction('STDDEV', TStddevFunction);
  TFormulaAnalysisService.RegisterFunction('MOD', TModFunction);
end;

{ TMaxFunction }

class function TMaxFunction.Calculate(Numbers: array of Double; Count:Integer): Double;
begin
  if Count<2 then
    raise Exception.Create('function Max parame error');
  Result := MaxValue(Numbers);
end;


{ TMinFunction }

class function TMinFunction.Calculate(Numbers: array of Double; Count:Integer): Double;
begin
  if Count<2 then
    raise Exception.Create('function Min parame error');
  Result := MinValue(Numbers);
end;

{ TAbsFunction }

class function TAbsFunction.Calculate(Numbers: array of Double; Count:Integer): Double;
begin
  if Count<>1 then
    raise Exception.Create('function Abs parame error');
  Result := Abs(Numbers[0]);
end;

{ TModFunction }

class function TModFunction.Calculate(Numbers: array of Double; Count:Integer): Double;
begin
  if Count<>2 then
    raise Exception.Create('function Mod parame error');
  Result := Trunc(Numbers[1]) mod Trunc(Numbers[0]);
end;

{ TSumFunction }

class function TSumFunction.Calculate(Numbers: array of Double; Count:Integer): Double;
var
  i:Integer;
begin
  Result:=0;
  if Count<1 then
    raise Exception.Create('function Sum parame error');
  for i := 0 to Count - 1 do
    Result := Result + Numbers[i];

end;

{ TAvgFunction }

class function TAvgFunction.Calculate(Numbers: array of Double; Count:Integer): Double;
var
  i:Integer;
begin
  if Count<1 then
    raise Exception.Create('function Avg parame error');
  for i := 0 to Count - 1 do
    Result := Result + Numbers[i];
  Result := Result / Count;
end;

{ TStddevFunction }

class function TStddevFunction.Calculate(Numbers: array of Double;
  Count: Integer): Double;
var
  i:Integer;
  AvgV:Double;
begin
  if Count<1 then
    raise Exception.Create('function Stddev parame error');
  AvgV := 0;
  for i := 0 to Count - 1 do
    AvgV := AvgV + Numbers[i];
  AvgV := AvgV / Count;
  Result := 0;
  for i := 0 to Count - 1 do
    Result := Result + Power((Numbers[i] - AvgV), 2);
  Result := Sqrt(Result / (Count - 1));
end;

initialization
  RegisterFunction;

end.
