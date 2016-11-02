unit Logging4D.Driver.Base;

interface

uses
  {$IFDEF VER210}
  SysUtils,
  {$ELSE}
  System.SysUtils,
  {$ENDIF}
  Logging4D,
  Logging4D.Impl;

type

  TDriverLogging = class abstract(TInterfacedObject, ILogging)
  private
    { private declarations }
  protected
    procedure Fatal(logger: ILogger); overload;
    procedure Fatal(const logMsg: string); overload;

    procedure Error(logger: ILogger); overload;
    procedure Error(const logMsg: string); overload;

    procedure Warn(logger: ILogger); overload;
    procedure Warn(const logMsg: string); overload;

    procedure Info(logger: ILogger); overload;
    procedure Info(const logMsg: string); overload;

    procedure Debug(logger: ILogger); overload;
    procedure Debug(const logMsg: string); overload;

    procedure Trace(logger: ILogger); overload;
    procedure Trace(const logMsg: string); overload;

    procedure Log(logger: ILogger; level: TLoggerLevel); overload;
    procedure Log(const logMsg: string; level: TLoggerLevel); overload;
  protected
    procedure DoLog(logger: ILogger; level: TLoggerLevel); virtual; abstract;
  public
    { public declarations }
  end;

implementation

{ TDriverLogging }

procedure TDriverLogging.Debug(const logMsg: string);
begin
  Debug(TLogger.New.Message(logMsg));
end;

procedure TDriverLogging.Debug(logger: ILogger);
begin
  Log(logger, TLoggerLevel.Debug);
end;

procedure TDriverLogging.Error(const logMsg: string);
begin
  Error(TLogger.New.Message(logMsg));
end;

procedure TDriverLogging.Error(logger: ILogger);
begin
  Log(logger, TLoggerLevel.Error);
end;

procedure TDriverLogging.Fatal(const logMsg: string);
begin
  Fatal(TLogger.New.Message(logMsg));
end;

procedure TDriverLogging.Fatal(logger: ILogger);
begin
  Log(logger, TLoggerLevel.Fatal);
end;

procedure TDriverLogging.Info(const logMsg: string);
begin
  Info(TLogger.New.Message(logMsg));
end;

procedure TDriverLogging.Info(logger: ILogger);
begin
  Log(logger, TLoggerLevel.Info);
end;

procedure TDriverLogging.Log(const logMsg: string; level: TLoggerLevel);
begin
  Log(TLogger.New.Message(logMsg), level);
end;

procedure TDriverLogging.Log(logger: ILogger; level: TLoggerLevel);
begin
  DoLog(logger, level);
end;

procedure TDriverLogging.Trace(const logMsg: string);
begin
  Trace(TLogger.New.Message(logMsg));
end;

procedure TDriverLogging.Trace(logger: ILogger);
begin
  Log(logger, TLoggerLevel.Trace);
end;

procedure TDriverLogging.Warn(const logMsg: string);
begin
  Warn(TLogger.New.Message(logMsg));
end;

procedure TDriverLogging.Warn(logger: ILogger);
begin
  Log(logger, TLoggerLevel.Warn);
end;

end.
