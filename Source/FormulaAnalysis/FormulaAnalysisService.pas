unit FormulaAnalysisService;
{
    四则运算
    内置运算数：整型、浮点型 (0123456789.)
    内置运算符: 加、减、乘、除、幕、百分号、阶乘 (+-*/^%!)
    运算方法
      多参数分隔符(,)
      运算方法格式：funciton(Parame1,parame2....)
      比如:max(Parame1,parame2....)、mod(Parame1,parame2)
          2 mod 2 属于非法的格式
    内置运算方法：
      统计函数：最大值(Max)、最小值(Min)、绝对值(Abs)、和(sum)、平均数(avg)、标准方差(stddev)
      后续会慢慢加上一些计算方法
    自定义运算方法:
      继承 TFormulaFunction 重载 Calculate

    不含参数的公式计算：
      TFormulaAnalysisService.Parse('2*(1+3)/2');
    含参数的公式计算：
      SignParame:=TStringList.Create;
      SignParame.Add('A=1');
      SignParame.Add('B=2');
      TFormulaAnalysisService.Parse('A*(1+B)/2', SignParame);
}

interface

uses
  System.SysUtils, System.Classes, System.StrUtils, System.Generics.Collections;

type

  //无、一元运算符、二元运算符、运算数、运算方法
  TPrefixType = (ptNone, ptOneOperation, ptBinaryOperation, ptOperand, ptFunction);

  TPrefixStack = record
    Operation:Char;
    Operand:string;
    FunctionName:string;
    PrefixType:TPrefixType;
  end;

  TFormulaFunctionClass = class of TFormulaFunction;

  TFormulaFunction = class(TObject)
    class function Calculate(Numbers:array of Double; Count:Integer):Double; virtual; abstract;
  end;

  TFormulaAnalysisService = class(TObject)
  private
    class function ReplaceSignParam(Formula:string; SignParam:TStrings = nil):string;
    class function isSignParam(Formula:string; SignPos:Integer):Boolean;
    class function isOperand(C: Char): Boolean;
    class function isOneOperation(C:Char):Boolean;     //是否是一元运算符
    class function isBinaryOperation(C:Char):Boolean;     //是否是二元运算符
    class function isFunction(C:Char):Boolean;    //是否是运算方法
    class function Priority(C:Char):Integer;      //获取优先级
    class function Calculate(Prefixs:TList<TPrefixStack>):Double; //计算波兰表达式
    class function AddPrefixStack(Prefixs:TList<TPrefixStack>; PrefixStack:TPrefixStack):TPrefixStack;
  public
    class procedure RegisterService;
    class procedure UnRegisterService;
    class procedure RegisterFunction(FunctionName:string; FunctionClass:TFormulaFunctionClass);
    class function Parse(Formula:string; SignParam:TStrings = nil):Double;
  end;

const
  NumbersSymbol = '0123456789.';
  OneOperandSymbol = '%!';
  BinaryOperandSymbol = '+-*/^';


implementation

uses
  System.Math;

var
  CustomFunctions:TDictionary<string, TFormulaFunctionClass>;
  //FOperations:TStack<TPrefixStack>;  //运算符
  //FOperands:TStack<Double>;  //运算数
  //FPrefixs:TList<TPrefixStack>; //波兰公式
  //FFormula:string;      //公式

{ TFormula }

class procedure TFormulaAnalysisService.RegisterFunction(
  FunctionName:string; FunctionClass: TFormulaFunctionClass);
begin
  //如果有相同的覆盖原有的方法
  CustomFunctions.AddOrSetValue(UpperCase(FunctionName), FunctionClass);
end;

class procedure TFormulaAnalysisService.RegisterService;
begin
  CustomFunctions:=TDictionary<string, TFormulaFunctionClass>.Create;
end;

class function TFormulaAnalysisService.ReplaceSignParam(Formula: string;
  SignParam: TStrings): string;
var
  i:Integer;
  IsSign:Boolean;
  SignPos:Integer;
begin
  Result := Formula;
  if SignParam = nil then exit;
  if SignParam.Count = 0 then exit;
  Result :=  Formula;
  for i := 0 to SignParam.Count - 1 do
  begin
    if SignParam.Names[i]<>'' then
    begin
      SignPos := Pos(SignParam.Names[i], Result, 1);
      while SignPos > 0 do
      begin
        IsSign := isSignParam(Result, SignPos);
        if IsSign then
        begin
          System.Delete(Result, SignPos, Length(SignParam.Names[i]));
          System.Insert(SignParam.ValueFromIndex[i], Result, SignPos);
        end;
        //替换下一个
        SignPos := Pos(SignParam.Names[i], Result, SignPos);
      end;
    end;
  end;
end;

class procedure TFormulaAnalysisService.UnRegisterService;
begin
  CustomFunctions.Clear;
  CustomFunctions.Free;
end;

class function TFormulaAnalysisService.AddPrefixStack(Prefixs:TList<TPrefixStack>; PrefixStack: TPrefixStack): TPrefixStack;
begin
  Prefixs.Add(PrefixStack);
  FillChar(Result, Sizeof(TPrefixStack), 0);
end;

class function TFormulaAnalysisService.Calculate(Prefixs:TList<TPrefixStack>): Double;
var
  i, nLen:Integer;
  C:Char;
  FunctionName:string;
  Factorial, Temp:Integer;
  Number1, Number2:Double;
  Numbers:array of Double;
  CustomFunction:TFormulaFunctionClass;
  Operands:TStack<Double>;
begin
  Operands:=TStack<Double>.Create;
  try
    i:=0;
    while i < Prefixs.Count do
    begin
      case Prefixs[i].PrefixType of
        ptNone:;
        ptOneOperation:
          begin
            Number1:=Operands.Pop;
            case Prefixs[i].Operation of
              '%':Operands.Push(Number1/100);
              '!':
                begin
                  if (Frac(Number1) = 0) and (Number1 >= 1)then // 为整数且小于150时
                  begin
                    Temp:=Trunc(Number1);
                    Factorial := 1;
                    while Temp >1 do    // 求阶乘
                    begin
                      Factorial := Factorial * Temp;
                      Dec(Temp);
                    end;
                    Operands.Push(Factorial);
                  end
                end;
            end;
          end;
        ptBinaryOperation:
          begin
            Number1:=Operands.Pop;
            Number2:=Operands.Pop;
            case Prefixs[i].Operation of
              '+':Operands.Push(Number1 + Number2);
              '-':Operands.Push(Number1 - Number2);
              '*':Operands.Push(Number1 * Number2);
              '/':Operands.Push(Number1 / Number2);
              '^':Operands.Push(Power(Number1,Number2));
            end;
          end;
        ptOperand:
          begin
            Operands.Push(StrToFloat(Prefixs[i].Operand));
          end;
        ptFunction:
          begin

            SetLength(Numbers, Operands.Count);
            while Operands.Count > 0 do
            begin
              Number1:=Operands.Pop;
              Numbers[Operands.Count]:=Number1;
            end;

            if CustomFunctions.TryGetValue(UpperCase(Prefixs[i].FunctionName), CustomFunction) then
              Operands.Push(CustomFunction.Calculate(Numbers, Length(Numbers)))
            else
              raise Exception.Create('function '+Prefixs[i].FunctionName+' not register');
          end;
      end;
      Inc(i);
    end;

    Result := Operands.Pop;
  finally
    Operands.Free;
  end;
end;

class function TFormulaAnalysisService.isBinaryOperation(C: Char): Boolean;
begin
  Result := BinaryOperandSymbol.Contains(C);
end;

class function TFormulaAnalysisService.isFunction(C: Char): Boolean;
begin
  Result:= C in ['a'..'z', 'A'..'Z', '_'];
end;

class function TFormulaAnalysisService.isOneOperation(C: Char): Boolean;
begin
  Result := OneOperandSymbol.Contains(C);
end;

class function TFormulaAnalysisService.isOperand(C: Char): Boolean;
begin
  Result := NumbersSymbol.Contains(C);
end;

class function TFormulaAnalysisService.isSignParam(Formula: string;
  SignPos: Integer): Boolean;
var
  PrevPos, NextPos:Integer;
begin
  Result := True;
  PrevPos := SignPos - 1;
  NextPos := SignPos + 1;
  if Result and (PrevPos > 0) and (isOperand(Formula[PrevPos]) or isFunction(Formula[PrevPos]))  then
    Result := False;
  if Result and (NextPos < Length(Formula) - 1) and (isOperand(Formula[NextPos]) or isFunction(Formula[NextPos]))  then
    Result := False;
end;

class function TFormulaAnalysisService.Parse(Formula:string; SignParam:TStrings = nil):Double;
var
  i, nLen:Integer;
  C:Char;
  Operation:TPrefixStack;
  PrefixStack:TPrefixStack;
  ParameCount:Integer;
  Operations:TStack<TPrefixStack>;
  Prefixs:TList<TPrefixStack>;
begin
  Operations:=TStack<TPrefixStack>.Create;
  Prefixs:=TList<TPrefixStack>.Create;
  try
    Formula := StringReplace(Formula, ' ', '', [rfReplaceAll]);
    Formula := ReplaceSignParam(Formula, SignParam);
    FillChar(PrefixStack, Sizeof(TPrefixStack), 0);
    nLen := Length(Formula);
    for i := nLen - 1 downto 0 do
    begin
      C:=Formula[i+1];
      if isFunction(C) then
      begin
        if PrefixStack.Operand <> '' then
        begin
          PrefixStack.FunctionName := PrefixStack.Operand;
          PrefixStack.Operand:='';
        end;
        PrefixStack.FunctionName := C + PrefixStack.FunctionName;
        PrefixStack.PrefixType := TPrefixType.ptFunction;
      end
      else
      if isOperand(C) then
      begin
        if PrefixStack.PrefixType in [TPrefixType.ptFunction] then
          PrefixStack.FunctionName := C + PrefixStack.FunctionName
        else
        begin
          PrefixStack.Operand := C + PrefixStack.Operand;
          PrefixStack.PrefixType := TPrefixType.ptOperand;
        end;
      end
      else
      if isOneOperation(C) then
      begin
        if PrefixStack.PrefixType in [TPrefixType.ptFunction, TPrefixType.ptOperand] then
          PrefixStack := AddPrefixStack(Prefixs, PrefixStack);

        if Operations.Count = 0 then
        begin
          Operation.Operation:=C;
          Operation.PrefixType:=TPrefixType.ptOneOperation;
          Operations.Push(Operation);
        end else
        begin
          while True do
          begin
            if (Operations.Count = 0) or (Priority(Operations.Peek.Operation) <= Priority(C)) then
              Break;
            PrefixStack := AddPrefixStack(Prefixs, Operations.Pop);
          end;

          Operation.Operation:=C;
          Operation.PrefixType:=TPrefixType.ptOneOperation;
          Operations.Push(Operation);
        end;
      end
      else
      if isBinaryOperation(C) then
      begin
        if PrefixStack.PrefixType in [TPrefixType.ptFunction, TPrefixType.ptOperand] then
          PrefixStack := AddPrefixStack(Prefixs, PrefixStack);

        if Operations.Count = 0 then
        begin
          Operation.Operation:=C;
          Operation.PrefixType:=TPrefixType.ptBinaryOperation;
          Operations.Push(Operation);
        end else
        begin
          while True do
          begin
            if (Operations.Count = 0) or (Priority(Operations.Peek.Operation) <= Priority(C)) then
              Break;
            PrefixStack := AddPrefixStack(Prefixs, Operations.Pop);
          end;

          Operation.Operation:=C;
          Operation.PrefixType:=TPrefixType.ptBinaryOperation;
          Operations.Push(Operation);
        end;
      end
      else
      if ')' = C then
      begin
        Operation.Operation:=C;
        Operation.PrefixType:=TPrefixType.ptNone;
        Operations.Push(Operation);
      end
      else
      if '(' = C then
      begin
        if PrefixStack.PrefixType in [TPrefixType.ptFunction, TPrefixType.ptOperand] then
          PrefixStack := AddPrefixStack(Prefixs, PrefixStack);

        Operation:=Operations.Pop;
        while Operation.Operation <> ')' do
        begin
          PrefixStack := AddPrefixStack(Prefixs, Operation);

          Operation:=Operations.Pop;
        end;
      end else
      if ',' = C then
      begin
        //参数分隔符
        if PrefixStack.PrefixType <> TPrefixType.ptNone then
          PrefixStack := AddPrefixStack(Prefixs, PrefixStack);

        while Operations.Count >0 do
        begin
          if Operations.Peek.PrefixType =  TPrefixType.ptNone then
            Break;
          PrefixStack := AddPrefixStack(Prefixs, Operations.Pop)
        end;
      end
      else
      begin
        //其他
        if PrefixStack.PrefixType <> TPrefixType.ptNone then
          PrefixStack := AddPrefixStack(Prefixs, PrefixStack);
      end;
    end;

    if PrefixStack.PrefixType <> TPrefixType.ptNone then
      PrefixStack := AddPrefixStack(Prefixs, PrefixStack);

    while Operations.Count >0 do
    begin
      PrefixStack := AddPrefixStack(Prefixs, Operations.Pop);
    end;
    Result := Calculate(Prefixs);
  finally
    Operations.Free;
    Prefixs.Free;
  end;
end;

class function TFormulaAnalysisService.Priority(C:Char): Integer;
begin
  case C of
    ')':Result := 0;
    '+','-':Result := 1;
    '*','/':Result := 2;
    '^','!','%':Result:=3;
  end;
end;

initialization
  TFormulaAnalysisService.RegisterService

finalization
  TFormulaAnalysisService.UnRegisterService;

end.
