unit Logging4D.UnitTest.Log4D;

interface

uses
  TestFramework,
  System.Classes,
  System.SysUtils,
  System.TypInfo,
  Logging4D,
  Logging4D.Impl,
  Logging4D.Driver.Log4D;

type

  TTestLogging4DLog4D = class(TTestCase)
  private
    fLogging: ILogging;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestLog4D;
  end;

implementation

const
  LOG4D_PROPS_FILE_NAME = 'log4d.props';

  LOG4D_PROPS_FILE_BODY = 'log4d.debug=TRUE' + sLineBreak +
    'log4d.loggerFactory=TLogDefaultLoggerFactory' + sLineBreak +
    'log4d.rootLogger=ALL,ROOT' + sLineBreak + sLineBreak +
    'log4d.appender.ROOT=TLogRollingFileAppender' + sLineBreak +
    'log4d.appender.ROOT.append=TRUE' + sLineBreak +
    'log4d.appender.ROOT.fileName=Log_Log4D.txt' + sLineBreak +
    'log4d.appender.ROOT.errorHandler=TLogOnlyOnceErrorHandler' + sLineBreak +
    'log4d.appender.ROOT.layout=TLogPatternLayout' + sLineBreak +
    'log4d.appender.ROOT.layout.dateFormat=yyyy-mm-dd hh:MM:ss,zzz' + sLineBreak +
    'log4d.appender.ROOT.layout.pattern=%d [%p] %c (%t) - %m%n' + sLineBreak +
    'log4d.appender.ROOT.maxBackupIndex=9' + sLineBreak +
    'log4d.appender.ROOT.maxFileSize=2MB';

  { TTestLogging4DLog4D }

procedure TTestLogging4DLog4D.SetUp;
var
  fileName: string;
  strList: TStringList;
begin
  inherited;
  fileName := ExtractFilePath(ParamStr(0)) + LOG4D_PROPS_FILE_NAME;

  if FileExists(fileName) then
    DeleteFile(fileName);

  strList := TStringList.Create;
  try
    strList.Text := LOG4D_PROPS_FILE_BODY;
    strList.SaveToFile(fileName);
  finally
    strList.Free;
  end;

  fLogging := TLog4DLogging.Create('Log4D', fileName);
end;

procedure TTestLogging4DLog4D.TearDown;
begin
  inherited;

end;

procedure TTestLogging4DLog4D.TestLog4D;
var
  fileName: string;
  ex: Exception;
begin
  fileName := ExtractFilePath(ParamStr(0)) + 'Log_Log4D.txt';

  if FileExists(fileName) then
    DeleteFile(fileName);

  fLogging.Fatal(
    TLogger.New
    .Keywords(['Test1'])
    .Owner('Ezequiel1')
    .Message('Fatal Test')
    .Marker('Delphi')
    );

  fLogging.Error(
    TLogger.New
    .Keywords(['Test2'])
    .Owner('Ezequiel2')
    .Message('Error Test')
    .Marker('Delphi')
    );

  fLogging.Warn(
    TLogger.New
    .Keywords(['Test3'])
    .Owner('Ezequiel3')
    .Message('Warn Test')
    .Marker('Delphi')
    );

  fLogging.Info(
    TLogger.New
    .Keywords(['Test4'])
    .Owner('Ezequiel4')
    .Message('Info Test')
    .Marker('Delphi')
    );

  fLogging.Debug(
    TLogger.New
    .Keywords(['Test5'])
    .Owner('Ezequiel5')
    .Message('Debug Test')
    .Marker('Delphi')
    );

  fLogging.Trace(
    TLogger.New
    .Keywords(['Test6'])
    .Owner('Ezequiel6')
    .Message('Trace Test')
    .Marker('Delphi')
    );

  ex := Exception.Create('Ex');
  fLogging.Trace(
    TLogger.New
    .Keywords(['Test6'])
    .Owner('Ezequiel6')
    .Message('Trace Test')
    .Exception(ex)
    .Marker('Delphi')
    );
  FreeAndNil(ex);

  CheckTrue(FileExists(fileName));
end;

initialization

RegisterTest(TTestLogging4DLog4D.Suite);

end.
