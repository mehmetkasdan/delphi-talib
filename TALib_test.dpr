program TALib_test;

{$APPTYPE CONSOLE}

{$R *.res}

uses System.SysUtils,

     Math,

     uTALib in 'uTALib.pas';

type
    DoubleArray = array of Double;

    DoubleArrayHelper = record helper for DoubleArray
    public
       function Value(const nLookback: NativeInt = 0): Double;
       function ValueByIndex(const nIndex: NativeInt): Double;

       function Sum: Double;
       function Avg: Double;
    end;

{ DoubleArrayHelper }

function DoubleArrayHelper.Avg: Double;
begin
     result := Math.Mean(Self);
end;

function DoubleArrayHelper.Sum: Double;
begin
     result := Math.Sum(Self);
end;

function DoubleArrayHelper.Value(const nLookback: NativeInt): Double;
var
   I, C: NativeInt;
begin
     C := System.Length(Self);

     I := (C - 1) - nLookback;

     result := ValueByIndex(I);
end;

function DoubleArrayHelper.ValueByIndex(const nIndex: NativeInt): Double;
var
   C: NativeInt;
begin
     result := Math.NaN;

     C := System.Length(Self);

     if (nIndex < 0) or (nIndex >= C) then Exit;

     result := Self[nIndex];
end;

const
     const_test_limit: NativeInt = 10;

var
   startIdx: NativeInt;
   endIdx: NativeInt;

   optInTimePeriod: NativeInt;
   optInMAType: TA_MAType;

   outBegIdx: NativeInt;
   outNBElement: NativeInt;
   outReal: DoubleArray;

   input,
   output: DoubleArray;

   success: Boolean;

   i: NativeInt;
begin
     try
        Randomize;

        // Fill random data
        System.SetLength(input, const_test_limit);

        for i := 1 to const_test_limit do
            input[i] := RandomRange(1, 10);

        // make output same length with input
        System.SetLength(outReal, const_test_limit);

        System.SetLength(output, const_test_limit);

        writeLn(Format('input length: %d', [const_test_limit]));
        write(Format('data: ', [const_test_limit]));
        for i := 0 to const_test_limit - 1 do
            write(Format('%8.2f', [input.ValueByIndex(i)]));

        writeLn('');
        writeLn('');
        writeLn(Format('Sum: %8.2f', [input.Sum()]));
        writeLn(Format('Avg: %8.2f', [input.Avg()]));

        // Calculate by period
        optInTimePeriod := 3;
        optInMAType := TA_MAType_SMA;

        startIdx := 0;
        endIdx := const_test_limit - 1;

        success := TA_MA(
           startIdx,
           endIdx,
           @input[0],
           optInTimePeriod,
           optInMAType,
           @outBegIdx,
           @outNBElement,
           @outReal[0]
        ) = TA_SUCCESS;

        if not success then Exit;

        System.SetLength(outReal, outNBElement);

        for i := 0 to outNBElement - 1 do
            output[i + outBegIdx] := outReal[i];

        // Show results
        writeLn('');
        writeLn(Format('%d period latest SMA value: %8.2f', [optInTimePeriod, output.Value()]));
        writeLn('');

        for i := 0 to const_test_limit - 1 do
            writeLn(Format('%d period SMA value for input[%d]: %8.2f', [optInTimePeriod, i, output.ValueByIndex(i)]));

        writeLn('');
        writeLn('press <ENTER> to exit.');

        Readln;
     except
           on E: Exception do
           begin
                Writeln(E.ClassName, ': ', E.Message);
           end;
     end;
end.
