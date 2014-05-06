unit Logging4D.UnitTest.Standard;

interface

uses
  TestFramework,
  System.Classes,
  System.SysUtils,
  System.TypInfo,
  Logging4D,
  Logging4D.Drivers.Standard;

type

  TTestLogging4DStd = class(TTestCase)
  private
    FFileName: string;
    FStdLogging: ILogging;
    FAppender: TLoggerAppender;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestStd();
  end;

implementation

{ TTestLogging4DStd }

procedure TTestLogging4DStd.SetUp;
begin
  inherited;
  FFileName := ExtractFilePath(ParamStr(0)) + 'Log.txt';

  FAppender := procedure(pArg: string)
    var
      vStrList: TStringList;
    begin
      vStrList := TStringList.Create;
      try
        if FileExists(FFileName) then
          DeleteFile(FFileName);

        vStrList.Add(pArg);

        vStrList.SaveToFile(FFileName);
      finally
        FreeAndNil(vStrList);
      end;
    end;

  TStdLoggingSingleton.Configure('Std', FAppender);
  FStdLogging := TStdLoggingSingleton.Get();
end;

procedure TTestLogging4DStd.TearDown;
begin
  inherited;

end;

procedure TTestLogging4DStd.TestStd;
const
  cFatal = 'Level:Fatal | Keywords:Test1; | Owner:Ezequiel1 | Message:Fatal Test | Marker:Delphi';
  cError = 'Level:Error | Keywords:Test2; | Owner:Ezequiel2 | Message:Error Test | Marker:Delphi';
  cWarn = 'Level:Warn | Keywords:Test3; | Owner:Ezequiel3 | Message:Warn Test | Marker:Delphi';
  cInfo = 'Level:Info | Keywords:Test4; | Owner:Ezequiel4 | Message:Info Test | Marker:Delphi';
  cDebug = 'Level:Debug | Keywords:Test5; | Owner:Ezequiel5 | Message:Debug Test | Marker:Delphi';
  cTrace = 'Level:Trace | Keywords:Test6; | Owner:Ezequiel6 | Message:Trace Test | Marker:Delphi';
  cTraceEx = 'Level:Trace | Keywords:Test6; | Owner:Ezequiel6 | Message:Trace Test | Marker:Delphi | Exception:Ex';
var
  vStrList: TStringList;
  vEx: Exception;
begin
  vStrList := TStringList.Create;
  try
    FStdLogging.Fatal(
      Logger
      .Keywords(TLoggerKeywords.Create('Test1'))
      .Owner('Ezequiel1')
      .Message('Fatal Test')
      .Marker('Delphi')
      );
    vStrList.LoadFromFile(FFileName);
    CheckEqualsString(cFatal, vStrList[0]);

    FStdLogging.Error(
      Logger
      .Keywords(TLoggerKeywords.Create('Test2'))
      .Owner('Ezequiel2')
      .Message('Error Test')
      .Marker('Delphi')
      );
    vStrList.LoadFromFile(FFileName);
    CheckEqualsString(cError, vStrList[0]);

    FStdLogging.Warn(
      Logger
      .Keywords(TLoggerKeywords.Create('Test3'))
      .Owner('Ezequiel3')
      .Message('Warn Test')
      .Marker('Delphi')
      );
    vStrList.LoadFromFile(FFileName);
    CheckEqualsString(cWarn, vStrList[0]);

    FStdLogging.Info(
      Logger
      .Keywords(TLoggerKeywords.Create('Test4'))
      .Owner('Ezequiel4')
      .Message('Info Test')
      .Marker('Delphi')
      );
    vStrList.LoadFromFile(FFileName);
    CheckEqualsString(cInfo, vStrList[0]);

    FStdLogging.Debug(
      Logger
      .Keywords(TLoggerKeywords.Create('Test5'))
      .Owner('Ezequiel5')
      .Message('Debug Test')
      .Marker('Delphi')
      );
    vStrList.LoadFromFile(FFileName);
    CheckEqualsString(cDebug, vStrList[0]);

    FStdLogging.Trace(
      Logger
      .Keywords(TLoggerKeywords.Create('Test6'))
      .Owner('Ezequiel6')
      .Message('Trace Test')
      .Marker('Delphi')
      );
    vStrList.LoadFromFile(FFileName);
    CheckEqualsString(cTrace, vStrList[0]);

    vEx := Exception.Create('Ex');
    FStdLogging.Trace(
      Logger
      .Keywords(TLoggerKeywords.Create('Test6'))
      .Owner('Ezequiel6')
      .Message('Trace Test')
      .Exception(vEx)
      .Marker('Delphi')
      );
    vStrList.LoadFromFile(FFileName);
    CheckEqualsString(cTraceEx, vStrList[0]);
    FreeAndNil(vEx);
  finally
    FreeAndNil(vStrList);
  end;
end;

initialization

RegisterTest(TTestLogging4DStd.Suite);

end.
