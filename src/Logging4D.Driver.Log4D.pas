unit Logging4D.Driver.Log4D;

interface

uses
  System.SysUtils,
  Logging4D,
  Logging4D.Driver.Base,
  Log4D;

type

  TLog4DLogging = class(TDriverLogging, ILogging)
  private
    fLog4DLogger: TLogLogger;
  protected
    procedure DoLog(logger: ILogger; level: TLoggerLevel); override;
  public
    constructor Create(const id, configFileName: string; appender: TLoggerAppender = nil);
  end;

implementation

var
  LOG4D_LEVELS: array [TLoggerLevel] of TLogLevel;

type

  TLog4DAnonymousAppender = class(TLogCustomAppender)
  private
    fAppender: TLoggerAppender;
  protected
    procedure DoAppend(const message: string); override;
  public
    constructor Create(appender: TLoggerAppender); reintroduce;
  end;

  { TLog4DLogging }

constructor TLog4DLogging.Create(const id, configFileName: string; appender: TLoggerAppender);
begin
  inherited Create;
  if id.IsEmpty then
    raise ELoggerException.Create('Log Identifier Undefined.');

  if configFileName.IsEmpty then
    raise ELoggerException.Create('Log Configuration File Name Undefined.');

  DefaultHierarchy.ResetConfiguration;

  TLogPropertyConfigurator.Configure(configFileName);

  FLog4DLogger := TLogLogger.GetLogger(id);

  if Assigned(appender) then
    FLog4DLogger.AddAppender(TLog4DAnonymousAppender.Create(appender));
end;

procedure TLog4DLogging.DoLog(logger: ILogger; level: TLoggerLevel);
var
  msg: string;
  keywords: string;
  i: Integer;
begin
  inherited;
  msg := 'Log';

  keywords := '';
  for i := Low(logger.GetKeywords) to High(logger.GetKeywords) do
    keywords := keywords + logger.GetKeywords[i] + ';';

  if not keywords.IsEmpty then
    msg := msg + ' | Keywords:' + keywords;

  if not logger.GetOwner.IsEmpty then
    msg := msg + ' | Owner: ' + logger.GetOwner;

  if not logger.GetMessage.IsEmpty then
    msg := msg + ' | Message: ' + logger.GetMessage;

  if Assigned(logger.GetMarker) and not logger.GetMarker.GetName.IsEmpty then
    msg := msg + ' | Marker: ' + logger.GetMarker.GetName;

  if Assigned(logger.GetException) then
    msg := msg + ' | Exception: ' + logger.GetException.ToString;

  msg := msg + sLineBreak;

  FLog4DLogger.Log(LOG4D_LEVELS[level], msg, logger.GetException);
end;

{ TLog4DAnonymousAppender }

constructor TLog4DAnonymousAppender.Create(appender: TLoggerAppender);
begin
  inherited Create('');
  fAppender := appender;
end;

procedure TLog4DAnonymousAppender.DoAppend(const message: string);
begin
  inherited;
  if Assigned(fAppender) then
    fAppender(message);
end;

initialization

LOG4D_LEVELS[TLoggerLevel.Off] := Log4D.Off;
LOG4D_LEVELS[TLoggerLevel.Fatal] := Log4D.Fatal;
LOG4D_LEVELS[TLoggerLevel.Error] := Log4D.Error;
LOG4D_LEVELS[TLoggerLevel.Warn] := Log4D.Warn;
LOG4D_LEVELS[TLoggerLevel.Info] := Log4D.Info;
LOG4D_LEVELS[TLoggerLevel.Debug] := Log4D.Debug;
LOG4D_LEVELS[TLoggerLevel.Trace] := Log4D.Trace;
LOG4D_LEVELS[TLoggerLevel.All] := Log4D.All;

RegisterAppender(TLog4DAnonymousAppender);

end.
