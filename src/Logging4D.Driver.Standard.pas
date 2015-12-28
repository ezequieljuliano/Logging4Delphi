unit Logging4D.Driver.Standard;

interface

uses
  Logging4D;

type

  TStdLoggingFactory = class sealed
  strict private
  const
    CanNotBeInstantiatedException = 'This class can not be instantiated!';
  strict private

    {$HINTS OFF}

    constructor Create;

    {$HINTS ON}

  public
    class function Build(pAppender: TLoggerAppender): ILogging; static;
  end;

implementation

uses
  System.SysUtils,
  System.TypInfo,
  Logging4D.Driver.Base;

type

  TStdLoggingAdapter = class(TDriverLogging, ILogging)
  strict private
    FAppender: TLoggerAppender;
  strict protected
    procedure DoLog(const pLevel: TLoggerLevel; pLogger: ILogger); override;
  public
    constructor Create(pAppender: TLoggerAppender);
  end;

  { TStdLoggingAdapter }

constructor TStdLoggingAdapter.Create(pAppender: TLoggerAppender);
begin
  if not Assigned(pAppender) then
    raise ELoggerException.Create('Log Appender Undefined!');
  FAppender := pAppender;
end;

procedure TStdLoggingAdapter.DoLog(const pLevel: TLoggerLevel; pLogger: ILogger);
var
  vMsg: string;
  vKeywords: string;
begin
  inherited;
  vMsg := 'Level:' + GetEnumName(TypeInfo(TLoggerLevel), Integer(pLevel));

  vKeywords := LoggerHelpful.KeywordsToString(pLogger.GetKeywords);
  if (vKeywords <> EmptyStr) then
    vMsg := vMsg + ' | Keywords:' + vKeywords;

  if (pLogger.GetOwner <> EmptyStr) then
    vMsg := vMsg + ' | Owner:' + pLogger.GetOwner;

  if (pLogger.GetMessage <> EmptyStr) then
    vMsg := vMsg + ' | Message:' + pLogger.GetMessage;

  if (pLogger.GetMarker <> nil) and (pLogger.GetMarker.GetName <> EmptyStr) then
    vMsg := vMsg + ' | Marker:' + pLogger.GetMarker.GetName;

  if (pLogger.GetException <> nil) then
    vMsg := vMsg + ' | Exception:' + pLogger.GetException.ToString;

  vMsg := vMsg + sLineBreak;

  FAppender(vMsg);
end;

{ TStdLoggingFactory }

class function TStdLoggingFactory.Build(pAppender: TLoggerAppender): ILogging;
begin
  Result := TStdLoggingAdapter.Create(pAppender);
end;

constructor TStdLoggingFactory.Create;
begin
  raise ELoggerException.Create(CanNotBeInstantiatedException);
end;

end.
