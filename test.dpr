program test;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  DUnitX.TestFramework,
  DUnitX.Loggers.Console,
  uTALib in 'uTALib.pas';

type
    DoubleArray = array of Double;

    {$M+}
    [TestFixture]
    TTALibTests = class
    protected
       function calculate_MA(const input: DoubleArray; var output: DoubleArray; const nPeriod: NativeInt; const nMAType: TA_MAType = TA_MAType_SMA): TA_RetCode;
    public
       [Test]
       procedure Test_MA;
    end;

var
   runner: ITestRunner;
   logger: ITestLogger;
   results: IRunResults;

{ TTALibTests }

function TTALibTests.calculate_MA(const input: DoubleArray; var output: DoubleArray; const nPeriod: NativeInt; const nMAType: TA_MAType): TA_RetCode;
var
   c: NativeInt;

   startIdx: NativeInt;
   endIdx: NativeInt;

   outBegIdx: NativeInt;
   outNBElement: NativeInt;

   outReal: DoubleArray;

   i: NativeInt;
begin
     c := System.Length(input);
     System.SetLength(output, c);

     System.SetLength(outReal, c);

     startIdx := 0;
     endIdx := c - 1;

     result := TA_MA(
        startIdx,
        endIdx,
        @input[0],
        nPeriod,
        nMAType,
        @outBegIdx,
        @outNBElement,
        @outReal[0]
     );

     if result <> TA_SUCCESS then Exit;

     System.SetLength(outReal, outNBElement);

     for i := 0 to outNBElement - 1 do
         output[i + outBegIdx] := outReal[i];
end;

procedure TTALibTests.Test_MA;
var
   input,
   output: DoubleArray;

   retCode: TA_RetCode;
begin
     input := [1.0, 2.0, 3.0, 4.0, 5.0];

     retCode := calculate_MA(input, output, 2);

     Assert.AreEqual(TA_SUCCESS, retCode, 'retCode is not Equal to TA_SUCCESS');

     Assert.AreEqual(output[4], Double(4.5), 'Incorrect calculation result');
end;

begin
     try
        TDUnitX.RegisterTestFixture(TTALibTests);

        runner := TDUnitX.CreateRunner;
        runner.UseRTTI := TRUE;

        logger := TDUnitXConsoleLogger.Create;
        runner.AddLogger(logger);

        results := runner.Execute;

        System.Write('Done.. press <Enter> key to quit.');
        System.Readln;
     except
           on E: Exception do
           begin
                Writeln(E.ClassName, ': ', E.Message);
           end;
     end;
end.
