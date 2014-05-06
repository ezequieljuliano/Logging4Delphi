unit Logging4D.Drivers.Standard;

interface

uses
  System.SysUtils,
  System.TypInfo,
  System.SyncObjs,
  Logging4D,
  Logging4D.Drivers.Base;

type

  TStdLoggingAdapter = class(TDriverLogging, ILogging)
  strict protected
    procedure DoConfigure(); override;
    procedure DoLog(const pLevel: TLoggerLevel; const pLogger: ILogger); override;
  end;

  TStdLoggingSingleton = class sealed
  strict private
    class var FName: string;
    class var FAppender: TLoggerAppender;
  public
    class procedure Configure(const pName: string; pAppender: TLoggerAppender);
    class function Get(): ILogging;
  end;

implementation

var
  _vLogging: ILogging = nil;

  { TStdLoggingAdapter }

procedure TStdLoggingAdapter.DoConfigure;
begin
  if (GetAppender = nil) then
    raise ELoggerAppenderNotFound.Create('Appender not found!');
end;

procedure TStdLoggingAdapter.DoLog(const pLevel: TLoggerLevel;
  const pLogger: ILogger);
var
  vMsg: string;
  vKeywords: string;
begin
  vMsg := 'Level:' + GetEnumName(TypeInfo(TLoggerLevel), Integer(pLevel));

  vKeywords := KeywordsToString(pLogger.GetKeywords);
  if (vKeywords <> EmptyStr) then
    vMsg := vMsg + ' | Keywords:' + KeywordsToString(pLogger.GetKeywords);

  if (pLogger.GetOwner <> EmptyStr) then
    vMsg := vMsg + ' | Owner:' + pLogger.GetOwner;

  if (pLogger.GetMessage <> EmptyStr) then
    vMsg := vMsg + ' | Message:' + pLogger.GetMessage;

  if (pLogger.GetMarker.GetName <> EmptyStr) then
    vMsg := vMsg + ' | Marker:' + pLogger.GetMarker.GetName;

  if (pLogger.GetException <> nil) then
    vMsg := vMsg + ' | Exception:' + pLogger.GetException.ToString;

  vMsg := vMsg + sLineBreak;

  GetAppender.Invoke(vMsg);
end;

{ TStdLoggingSingleton }

class procedure TStdLoggingSingleton.Configure(const pName: string; pAppender: TLoggerAppender);
begin
  if (pName = EmptyStr) then
    raise ELoggerNameNotDefined.Create('Logging name not defined!');

  TStdLoggingSingleton.FName := Trim(pName);

  if not Assigned(pAppender) then
    raise ELoggerAppenderNotFound.Create('Appender not found!');

  TStdLoggingSingleton.FAppender := pAppender;
end;

class function TStdLoggingSingleton.Get: ILogging;
begin
  if (_vLogging = nil) then
  begin
    if (TStdLoggingSingleton.FName <> EmptyStr) and (Assigned(TStdLoggingSingleton.FAppender)) then
    begin
      CriticalSectionLogger.Enter;
      try
        _vLogging := TStdLoggingAdapter.Create(TStdLoggingSingleton.FName, TStdLoggingSingleton.FAppender);
      finally
        CriticalSectionLogger.Leave;
      end;
    end
    else
      raise ELoggerException.Create('Settings not set call the Configure method!!');
  end;
  Result := _vLogging;
end;

end.
