unit Logging4D.Driver.Standard;

interface

uses
  System.SysUtils,
  System.TypInfo,
  Logging4D,
  Logging4D.Driver.Base;

type

  TStandardLogging = class(TDriverLogging, ILogging)
  private
    fAppender: TLoggerAppender;
  protected
    procedure DoLog(logger: ILogger; level: TLoggerLevel); override;
  public
    constructor Create(appender: TLoggerAppender);
  end;

implementation

{ TStandardLogging }

constructor TStandardLogging.Create(appender: TLoggerAppender);
begin
  inherited Create;

  if not Assigned(appender) then
    raise ELoggerException.Create('Log Appender Undefined.');

  fAppender := appender;
end;

procedure TStandardLogging.DoLog(logger: ILogger; level: TLoggerLevel);
var
  msg: string;
  keywords: string;
  i: Integer;
begin
  inherited;
  msg := 'Level: ' + GetEnumName(TypeInfo(TLoggerLevel), Integer(level));

  keywords := '';
  for i := Low(logger.GetKeywords) to High(logger.GetKeywords) do
    keywords := keywords + logger.GetKeywords[i] + ';';

  if not keywords.IsEmpty then
    msg := msg + ' | Keywords: ' + keywords;

  if not logger.GetOwner.IsEmpty then
    msg := msg + ' | Owner: ' + logger.GetOwner;

  if not logger.GetMessage.IsEmpty then
    msg := msg + ' | Message: ' + logger.GetMessage;

  if Assigned(logger.GetMarker) and not logger.GetMarker.GetName.IsEmpty then
    msg := msg + ' | Marker: ' + logger.GetMarker.GetName;

  if Assigned(logger.GetException) then
    msg := msg + ' | Exception: ' + logger.GetException.ToString;

  msg := msg + sLineBreak;

  FAppender(msg);
end;

end.
