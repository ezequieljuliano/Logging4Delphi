unit Logging4D.Drivers.Base;

interface

uses
  System.Generics.Collections,
  System.Classes,
  System.SysUtils,
  System.SyncObjs,
  Logging4D;

type

  TDriverLogging = class abstract(TInterfacedObject, ILogging)
  strict protected
    FName: string;
    FAppender: TLoggerAppender;

    procedure DoConfigure(); virtual; abstract;
    procedure DoLog(const pLevel: TLoggerLevel; const pLogger: ILogger); virtual; abstract;
  public
    constructor Create(const pName: string; pAppender: TLoggerAppender = nil);
    destructor Destroy; override;

    procedure Fatal(const pLogger: ILogger);
    procedure Error(const pLogger: ILogger);
    procedure Warn(const pLogger: ILogger);
    procedure Info(const pLogger: ILogger);
    procedure Debug(const pLogger: ILogger);
    procedure Trace(const pLogger: ILogger);

    procedure Log(const pLevel: TLoggerLevel; const pLogger: ILogger);
  end;

  TDriverLoggingSingleton = class abstract;

implementation

{ TDriverLogging }

constructor TDriverLogging.Create(const pName: string; pAppender: TLoggerAppender);
begin
  FName := Trim(pName);

  if (FName = EmptyStr) then
    raise ELoggerNameNotDefined.Create('Logging name not defined!');

  FAppender := pAppender;

  DoConfigure();
end;

procedure TDriverLogging.Debug(const pLogger: ILogger);
begin
  Log(TLoggerLevel.Debug, pLogger);
end;

destructor TDriverLogging.Destroy;
begin
  FAppender := nil;
  inherited Destroy();
end;

procedure TDriverLogging.Error(const pLogger: ILogger);
begin
  Log(TLoggerLevel.Error, pLogger);
end;

procedure TDriverLogging.Fatal(const pLogger: ILogger);
begin
  Log(TLoggerLevel.Fatal, pLogger);
end;

procedure TDriverLogging.Info(const pLogger: ILogger);
begin
  Log(TLoggerLevel.Info, pLogger);
end;

procedure TDriverLogging.Log(const pLevel: TLoggerLevel;
  const pLogger: ILogger);
begin
  CriticalSectionLogger.Enter;
  try
    DoLog(pLevel, pLogger);
  finally
    CriticalSectionLogger.Leave;
  end;
end;

procedure TDriverLogging.Trace(const pLogger: ILogger);
begin
  Log(TLoggerLevel.Trace, pLogger);
end;

procedure TDriverLogging.Warn(const pLogger: ILogger);
begin
  Log(TLoggerLevel.Warn, pLogger);
end;

end.
