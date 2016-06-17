unit Logging4D.UnitTest.Standard;

interface

uses
  TestFramework,
  System.Classes,
  System.SysUtils,
  System.TypInfo,
  Logging4D,
  Logging4D.Impl,
  Logging4D.Driver.Standard;

type

  TTestLogging4DStandard = class(TTestCase)
  private
    fFileName: string;
    fLogging: ILogging;
    fAppender: TLoggerAppender;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestStandard;
  end;

implementation

{ TTestLogging4DStandard }

procedure TTestLogging4DStandard.SetUp;
begin
  inherited;
  fFileName := ExtractFilePath(ParamStr(0)) + 'Log.txt';

  fAppender := procedure(msg: string)
    var
      strList: TStringList;
    begin
      strList := TStringList.Create;
      try
        if FileExists(fFileName) then
          DeleteFile(fFileName);

        strList.Add(msg);

        strList.SaveToFile(fFileName);
      finally
        FreeAndNil(strList);
      end;
    end;

  fLogging := TStandardLogging.Create(fAppender);
end;

procedure TTestLogging4DStandard.TearDown;
begin
  inherited;

end;

procedure TTestLogging4DStandard.TestStandard;
const
  FATAL_MSG = 'Level: Fatal | Keywords: Test1; | Owner: Ezequiel1 | Message: Fatal Test | Marker: Delphi';
  ERROR_MSG = 'Level: Error | Keywords: Test2; | Owner: Ezequiel2 | Message: Error Test | Marker: Delphi';
  WARN_MSG = 'Level: Warn | Keywords: Test3; | Owner: Ezequiel3 | Message: Warn Test | Marker: Delphi';
  INFO_MSG = 'Level: Info | Keywords: Test4; | Owner: Ezequiel4 | Message: Info Test | Marker: Delphi';
  DEBUG_MSG = 'Level: Debug | Keywords: Test5; | Owner: Ezequiel5 | Message: Debug Test | Marker: Delphi';
  TRACE_MSG = 'Level: Trace | Keywords: Test6; | Owner: Ezequiel6 | Message: Trace Test | Marker: Delphi';
  TRACE_EX_MSG = 'Level: Trace | Keywords: Test6; | Owner: Ezequiel6 | Message: Trace Test | Marker: Delphi | Exception: Ex';
var
  strList: TStringList;
  ex: Exception;
begin
  strList := TStringList.Create;
  try
    fLogging.Fatal(
      TLogger.New
      .Keywords(['Test1'])
      .Owner('Ezequiel1')
      .Message('Fatal Test')
      .Marker('Delphi')
      );
    strList.LoadFromFile(fFileName);
    CheckEqualsString(FATAL_MSG, strList[0]);

    fLogging.Error(
      TLogger.New
      .Keywords(['Test2'])
      .Owner('Ezequiel2')
      .Message('Error Test')
      .Marker('Delphi')
      );
    strList.LoadFromFile(fFileName);
    CheckEqualsString(ERROR_MSG, strList[0]);

    fLogging.Warn(
      TLogger.New
      .Keywords(['Test3'])
      .Owner('Ezequiel3')
      .Message('Warn Test')
      .Marker('Delphi')
      );
    strList.LoadFromFile(fFileName);
    CheckEqualsString(WARN_MSG, strList[0]);

    fLogging.Info(
      TLogger.New
      .Keywords(['Test4'])
      .Owner('Ezequiel4')
      .Message('Info Test')
      .Marker('Delphi')
      );
    strList.LoadFromFile(fFileName);
    CheckEqualsString(INFO_MSG, strList[0]);

    fLogging.Debug(
      TLogger.New
      .Keywords(['Test5'])
      .Owner('Ezequiel5')
      .Message('Debug Test')
      .Marker('Delphi')
      );
    strList.LoadFromFile(fFileName);
    CheckEqualsString(DEBUG_MSG, strList[0]);

    fLogging.Trace(
      TLogger.New
      .Keywords(['Test6'])
      .Owner('Ezequiel6')
      .Message('Trace Test')
      .Marker('Delphi')
      );
    strList.LoadFromFile(fFileName);
    CheckEqualsString(TRACE_MSG, strList[0]);

    ex := Exception.Create('Ex');
    fLogging.Trace(
      TLogger.New
      .Keywords(['Test6'])
      .Owner('Ezequiel6')
      .Message('Trace Test')
      .Exception(ex)
      .Marker('Delphi')
      );
    strList.LoadFromFile(fFileName);
    CheckEqualsString(TRACE_EX_MSG, strList[0]);
    FreeAndNil(ex);
  finally
    FreeAndNil(strList);
  end;
end;

initialization

RegisterTest(TTestLogging4DStandard.Suite);

end.
