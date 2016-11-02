unit Logging4D.Driver.Standard;

interface

uses
  {$IFDEF VER210}
  SysUtils,
  TypInfo,
  {$ELSE}
  System.SysUtils,
  System.TypInfo,
  {$ENDIF}

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

  {$IFDEF VER210}
  if not(keywords = '') then
  {$ELSE}
  if not keywords.IsEmpty then
  {$ENDIF}
    msg := msg + ' | Keywords: ' + keywords;

  {$IFDEF VER210}
  if not(logger.GetOwner = '') then
  {$ELSE}
  if not logger.GetOwner.IsEmpty then
  {$ENDIF}
    msg := msg + ' | Owner: ' + logger.GetOwner;

  {$IFDEF VER210}
  if not(logger.GetMessage = '') then
  {$ELSE}
  if not logger.GetMessage.IsEmpty then
  {$ENDIF}
    msg := msg + ' | Message: ' + logger.GetMessage;

  {$IFDEF VER210}
  if Assigned(logger.GetMarker) and not(logger.GetMarker.GetName = '') then
  {$ELSE}
  if Assigned(logger.GetMarker) and not logger.GetMarker.GetName.IsEmpty then
  {$ENDIF}
    msg := msg + ' | Marker: ' + logger.GetMarker.GetName;

  if Assigned(logger.GetException) then
    msg := msg + ' | Exception: ' + logger.GetException.ToString;

  msg := msg + sLineBreak;

  FAppender(msg);
end;

end.
