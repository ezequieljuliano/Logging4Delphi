unit Logging4D.Driver.Base;

interface

uses
  System.Classes,
  System.SysUtils,
  Logging4D;

type

  TDriverLogging = class abstract(TInterfacedObject, ILogging)
  strict protected
    procedure DoLog(const pLevel: TLoggerLevel; pLogger: ILogger); virtual; abstract;
  public
    procedure Fatal(pLogger: ILogger); overload;
    procedure Fatal(const pLogMsg: string); overload;

    procedure Error(pLogger: ILogger); overload;
    procedure Error(const pLogMsg: string); overload;

    procedure Warn(pLogger: ILogger); overload;
    procedure Warn(const pLogMsg: string); overload;

    procedure Info(pLogger: ILogger); overload;
    procedure Info(const pLogMsg: string); overload;

    procedure Debug(pLogger: ILogger); overload;
    procedure Debug(const pLogMsg: string); overload;

    procedure Trace(pLogger: ILogger); overload;
    procedure Trace(const pLogMsg: string); overload;

    procedure Log(const pLevel: TLoggerLevel; pLogger: ILogger); overload;
    procedure Log(const pLevel: TLoggerLevel; const pLogMsg: string); overload;
  end;

implementation

{ TDriverLogging }

procedure TDriverLogging.Debug(const pLogMsg: string);
begin
  Debug(NewLogger.Message(pLogMsg));
end;

procedure TDriverLogging.Debug(pLogger: ILogger);
begin
  Log(TLoggerLevel.Debug, pLogger);
end;

procedure TDriverLogging.Error(const pLogMsg: string);
begin
  Error(NewLogger.Message(pLogMsg));
end;

procedure TDriverLogging.Error(pLogger: ILogger);
begin
  Log(TLoggerLevel.Error, pLogger);
end;

procedure TDriverLogging.Fatal(const pLogMsg: string);
begin
  Fatal(NewLogger.Message(pLogMsg));
end;

procedure TDriverLogging.Fatal(pLogger: ILogger);
begin
  Log(TLoggerLevel.Fatal, pLogger);
end;

procedure TDriverLogging.Info(const pLogMsg: string);
begin
  Info(NewLogger.Message(pLogMsg));
end;

procedure TDriverLogging.Info(pLogger: ILogger);
begin
  Log(TLoggerLevel.Info, pLogger);
end;

procedure TDriverLogging.Log(const pLevel: TLoggerLevel; pLogger: ILogger);
begin
  DoLog(pLevel, pLogger);
end;

procedure TDriverLogging.Log(const pLevel: TLoggerLevel; const pLogMsg: string);
begin
  DoLog(pLevel, NewLogger.Message(pLogMsg));
end;

procedure TDriverLogging.Trace(const pLogMsg: string);
begin
  Trace(NewLogger.Message(pLogMsg));
end;

procedure TDriverLogging.Trace(pLogger: ILogger);
begin
  Log(TLoggerLevel.Trace, pLogger);
end;

procedure TDriverLogging.Warn(pLogger: ILogger);
begin
  Log(TLoggerLevel.Warn, pLogger);
end;

procedure TDriverLogging.Warn(const pLogMsg: string);
begin
  Warn(NewLogger.Message(pLogMsg));
end;

end.
