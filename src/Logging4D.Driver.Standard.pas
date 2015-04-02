unit Logging4D.Driver.Standard;

interface

uses
  Logging4D;

type

  TStdLoggingFactory = class sealed
  public
    class function Build(const pAppender: TLoggerAppender): ILogging; static;
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
    procedure DoLog(const pLevel: TLoggerLevel; const pLogger: ILogger); override;
  public
    constructor Create(const pAppender: TLoggerAppender);
  end;

{ TStdLoggingAdapter }

constructor TStdLoggingAdapter.Create(const pAppender: TLoggerAppender);
begin
  if not Assigned(pAppender) then
    raise ELoggerException.Create('Log Appender Undefined!');
  FAppender := pAppender;
end;

procedure TStdLoggingAdapter.DoLog(const pLevel: TLoggerLevel; const pLogger: ILogger);
var
  vMsg: string;
  vKeywords: string;
begin
  inherited;
  vMsg := 'Level:' + GetEnumName(TypeInfo(TLoggerLevel), Integer(pLevel));

  vKeywords := TLoggerUtil.KeywordsToString(pLogger.GetKeywords);
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

class function TStdLoggingFactory.Build(const pAppender: TLoggerAppender): ILogging;
begin
  Result := TStdLoggingAdapter.Create(pAppender);
end;

end.
