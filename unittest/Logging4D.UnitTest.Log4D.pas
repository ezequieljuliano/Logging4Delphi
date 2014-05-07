unit Logging4D.UnitTest.Log4D;

interface

uses
  TestFramework,
  System.Classes,
  System.SysUtils,
  System.TypInfo,
  Logging4D,
  Logging4D.Drivers.Log4D;

type

  TTestLogging4DLog4D = class(TTestCase)
  private
    FLog4DLogging: ILogging;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestLog4D();
  end;

implementation

const
  _cLog4DPropsFileName = 'log4d.props';

  _cLog4DPropsFileText = 'log4d.debug=TRUE' + sLineBreak +
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
  vLog4DFilePathPropsName: string;
  vStrList: TStringList;
begin
  inherited;
  vLog4DFilePathPropsName := ExtractFilePath(ParamStr(0)) + _cLog4DPropsFileName;

  if FileExists(vLog4DFilePathPropsName) then
    DeleteFile(vLog4DFilePathPropsName);

  vStrList := TStringList.Create;
  try
    vStrList.Text := _cLog4DPropsFileText;
    vStrList.SaveToFile(vLog4DFilePathPropsName);
  finally
    vStrList.Free;
  end;

  TLog4DLoggingSingleton.Configure('Log4D', nil);
  FLog4DLogging := TLog4DLoggingSingleton.Get();
end;

procedure TTestLogging4DLog4D.TearDown;
begin
  inherited;

end;

procedure TTestLogging4DLog4D.TestLog4D;
var
  vLogFilePathName: string;
  vEx: Exception;
begin
  vLogFilePathName := ExtractFilePath(ParamStr(0)) + 'Log_Log4D.txt';

  if FileExists(vLogFilePathName) then
    DeleteFile(vLogFilePathName);

  FLog4DLogging.Fatal(
    Logger
    .Keywords(TLoggerKeywords.Create('Test1'))
    .Owner('Ezequiel1')
    .Message('Fatal Test')
    .Marker('Delphi')
    );

  FLog4DLogging.Error(
    Logger
    .Keywords(TLoggerKeywords.Create('Test2'))
    .Owner('Ezequiel2')
    .Message('Error Test')
    .Marker('Delphi')
    );

  FLog4DLogging.Warn(
    Logger
    .Keywords(TLoggerKeywords.Create('Test3'))
    .Owner('Ezequiel3')
    .Message('Warn Test')
    .Marker('Delphi')
    );

  FLog4DLogging.Info(
    Logger
    .Keywords(TLoggerKeywords.Create('Test4'))
    .Owner('Ezequiel4')
    .Message('Info Test')
    .Marker('Delphi')
    );

  FLog4DLogging.Debug(
    Logger
    .Keywords(TLoggerKeywords.Create('Test5'))
    .Owner('Ezequiel5')
    .Message('Debug Test')
    .Marker('Delphi')
    );

  FLog4DLogging.Trace(
    Logger
    .Keywords(TLoggerKeywords.Create('Test6'))
    .Owner('Ezequiel6')
    .Message('Trace Test')
    .Marker('Delphi')
    );

  vEx := Exception.Create('Ex');
  FLog4DLogging.Trace(
    Logger
    .Keywords(TLoggerKeywords.Create('Test6'))
    .Owner('Ezequiel6')
    .Message('Trace Test')
    .Exception(vEx)
    .Marker('Delphi')
    );
  FreeAndNil(vEx);

  CheckTrue(FileExists(vLogFilePathName));
end;

initialization

RegisterTest(TTestLogging4DLog4D.Suite);

end.
