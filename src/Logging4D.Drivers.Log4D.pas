unit Logging4D.Drivers.Log4D;

interface

uses
  Log4D,
  Logging4D,
  Logging4D.Drivers.Base,
  System.SyncObjs,
  System.SysUtils;

type

  TLog4DAnonymousAppender = class(TLogCustomAppender)
  strict private
    FAppender: TLoggerAppender;
  protected
    procedure DoAppend(const Message: string); override;
  public
    constructor Create(const pAppender: TLoggerAppender); reintroduce;
    destructor Destroy; override;
  end;

  TLog4DLoggingAdapter = class(TDriverLogging, ILogging)
  strict private
    FLogLogger: TLogLogger;
  strict protected
    procedure DoConfigure(); override;
    procedure DoLog(const pLevel: TLoggerLevel; const pLogger: ILogger); override;
  end;

  TLog4DLoggingSingleton = class sealed(TDriverLoggingSingleton)
  strict private
    class var FName: string;
    class var FAppender: TLoggerAppender;
  public
    class procedure Configure(const pName: string; pAppender: TLoggerAppender);
    class function Get(): ILogging;
  end;

procedure DefineFileNamePropertyConfigurator(const pPropsFileName: string);

implementation

var
  _vLogging: ILogging = nil;
  _vLog4DLevels: array [TLoggerLevel] of TLogLevel;
  _vPropsFileName: string = '';

procedure DefineFileNamePropertyConfigurator(const pPropsFileName: string);
begin
  _vPropsFileName := pPropsFileName;
end;

procedure RegisterLog4DLevels();
begin
  _vLog4DLevels[TLoggerLevel.Off] := Log4D.Off;
  _vLog4DLevels[TLoggerLevel.Fatal] := Log4D.Fatal;
  _vLog4DLevels[TLoggerLevel.Error] := Log4D.Error;
  _vLog4DLevels[TLoggerLevel.Warn] := Log4D.Warn;
  _vLog4DLevels[TLoggerLevel.Info] := Log4D.Info;
  _vLog4DLevels[TLoggerLevel.Debug] := Log4D.Debug;
  _vLog4DLevels[TLoggerLevel.Trace] := Log4D.Trace;
  _vLog4DLevels[TLoggerLevel.All] := Log4D.All;
end;

function LoggerLevelToLog4DLevel(const pLoggerLevel: TLoggerLevel): TLogLevel;
begin
  Result := _vLog4DLevels[pLoggerLevel];
end;

{ TLog4DAnonymousAppender }

constructor TLog4DAnonymousAppender.Create(const pAppender: TLoggerAppender);
begin
  inherited Create(EmptyStr);
  FAppender := pAppender;
end;

destructor TLog4DAnonymousAppender.Destroy;
begin
  FAppender := nil;
  inherited;
end;

procedure TLog4DAnonymousAppender.DoAppend(const Message: string);
begin
  if Assigned(FAppender) then
    FAppender(Message);
end;

{ TLog4DLoggingAdapter }

procedure TLog4DLoggingAdapter.DoConfigure;
const
  cDefaultLog4DFile = 'log4d.props';
var
  vFilePathName: string;
begin
  DefaultHierarchy.ResetConfiguration;

  if not _vPropsFileName.IsEmpty then
    vFilePathName := _vPropsFileName
  else
    vFilePathName := ExtractFilePath(ParamStr(0)) + cDefaultLog4DFile;

  if FileExists(vFilePathName) then
    TLogPropertyConfigurator.Configure(vFilePathName)
  else
  begin
    TLogBasicConfigurator.Configure();
    TLogLogger.GetRootLogger.Level := LoggerLevelToLog4DLevel(TLoggerLevel.All);
  end;

  FLogLogger := TLogLogger.GetLogger(FName);

  if Assigned(FAppender) then
    FLogLogger.AddAppender(TLog4DAnonymousAppender.Create(FAppender));
end;

procedure TLog4DLoggingAdapter.DoLog(const pLevel: TLoggerLevel;
  const pLogger: ILogger);
var
  vMsg: string;
  vKeywords: string;
begin
  vMsg := 'Log';

  vKeywords := KeywordsToString(pLogger.GetKeywords);
  if (vKeywords <> EmptyStr) then
    vMsg := vMsg + ' | Keywords:' + KeywordsToString(pLogger.GetKeywords);

  if (pLogger.GetOwner <> EmptyStr) then
    vMsg := vMsg + ' | Owner:' + pLogger.GetOwner;

  if (pLogger.GetMessage <> EmptyStr) then
    vMsg := vMsg + ' | Message:' + pLogger.GetMessage;

  if (pLogger.GetMarker <> nil) and (pLogger.GetMarker.GetName <> EmptyStr) then
    vMsg := vMsg + ' | Marker:' + pLogger.GetMarker.GetName;

  if (pLogger.GetException <> nil) then
    vMsg := vMsg + ' | Exception:' + pLogger.GetException.ToString;

  FLogLogger.Log(LoggerLevelToLog4DLevel(pLevel), vMsg, pLogger.GetException);
end;

{ TLog4DLoggingSingleton }

class procedure TLog4DLoggingSingleton.Configure(const pName: string;
  pAppender: TLoggerAppender);
begin
  if (pName = EmptyStr) then
    raise ELoggerNameNotDefined.Create('Logging name not defined!');

  TLog4DLoggingSingleton.FName := Trim(pName);
  TLog4DLoggingSingleton.FAppender := pAppender;
end;

class function TLog4DLoggingSingleton.Get: ILogging;
begin
  if (_vLogging = nil) then
  begin
    if (TLog4DLoggingSingleton.FName <> EmptyStr) then
    begin
      CriticalSectionLogger.Enter;
      try
        _vLogging := TLog4DLoggingAdapter.Create(TLog4DLoggingSingleton.FName, TLog4DLoggingSingleton.FAppender);
      finally
        CriticalSectionLogger.Leave;
      end;
    end
    else
      raise ELoggerException.Create('Settings not set call the Configure method!!');
  end;
  Result := _vLogging;
end;

initialization

RegisterLog4DLevels();

RegisterAppender(TLog4DAnonymousAppender);

end.
