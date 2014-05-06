unit Logging4D;

interface

uses
  System.Generics.Collections,
  System.SysUtils,
  System.SyncObjs;

type

  ELoggerException = class(Exception);
  ELoggerNameNotDefined = class(ELoggerException);
  ELoggerAppenderNotFound = class(ELoggerException);

  TLoggerKeywords = TArray<string>;
  TLoggerAppender = TProc<string>;

  TLoggerLevel = (Off, Fatal, Error, Warn, Info, Debug, Trace, All);

  ILoggerMarker = interface
    ['{1A3E7857-90FF-415D-B69B-3A5202C400C0}']
    procedure SetName(const pName: string);
    function GetName(): string;

    procedure SetParent(const pMarker: ILoggerMarker);
    function GetParent(): ILoggerMarker;
  end;

  ILogger = interface
    ['{449A6325-37D4-45F4-A3AF-E581FF2A4A70}']
    function Keywords(const pKeywords: TLoggerKeywords): ILogger;
    function Owner(const pOwner: string): ILogger;
    function Message(const pMessage: string): ILogger;
    function Exception(const pException: Exception): ILogger;
    function Marker(const pName: string; pParent: ILoggerMarker = nil): ILogger;

    function GetKeywords(): TLoggerKeywords;
    function GetOwner(): string;
    function GetMessage(): string;
    function GetException(): Exception;
    function GetMarker(): ILoggerMarker;
  end;

  ILogging = interface
    ['{04148C83-66F4-4269-91C2-166CD192DE95}']
    procedure Fatal(const pLogger: ILogger);
    procedure Error(const pLogger: ILogger);
    procedure Warn(const pLogger: ILogger);
    procedure Info(const pLogger: ILogger);
    procedure Debug(const pLogger: ILogger);
    procedure Trace(const pLogger: ILogger);

    procedure Log(const pLevel: TLoggerLevel; const pLogger: ILogger);
  end;

function Logger(): ILogger;
function CriticalSectionLogger(): TCriticalSection;
function KeywordsToString(const pKeywords: TLoggerKeywords): string;

implementation

var
  _vCriticalSection: TCriticalSection;

type

  TLoggerMarker = class(TInterfacedObject, ILoggerMarker)
  strict private
    FName: string;
    FParent: ILoggerMarker;
  public
    constructor Create(const pName: string; const pParent: ILoggerMarker);

    procedure SetName(const pName: string);
    function GetName(): string;

    procedure SetParent(const pMarker: ILoggerMarker);
    function GetParent(): ILoggerMarker;
  end;

  TLogger = class(TInterfacedObject, ILogger)
  strict private
    FKeywords: TLoggerKeywords;
    FOwner: string;
    FMessage: string;
    FException: Exception;
    FMarker: ILoggerMarker;
  public
    constructor Create();

    function Keywords(const pKeywords: TLoggerKeywords): ILogger;
    function Owner(const pOwner: string): ILogger;
    function Message(const pMessage: string): ILogger;
    function Exception(const pException: Exception): ILogger;
    function Marker(const pName: string; pParent: ILoggerMarker = nil): ILogger;

    function GetKeywords(): TLoggerKeywords;
    function GetOwner(): string;
    function GetMessage(): string;
    function GetException(): Exception;
    function GetMarker(): ILoggerMarker;
  end;

function Logger(): ILogger;
begin
  Result := TLogger.Create();
end;

function CriticalSectionLogger(): TCriticalSection;
begin
  Result := _vCriticalSection;
end;

function KeywordsToString(const pKeywords: TLoggerKeywords): string;
var
  vStr: string;
begin
  Result := EmptyStr;
  for vStr in pKeywords do
    Result := Result + vStr + ';';
end;

{ TLoggerMarker }

constructor TLoggerMarker.Create(const pName: string;
  const pParent: ILoggerMarker);
begin
  FName := pName;
  FParent := pParent;
end;

function TLoggerMarker.GetName: string;
begin
  Result := FName;
end;

function TLoggerMarker.GetParent: ILoggerMarker;
begin
  Result := FParent;
end;

procedure TLoggerMarker.SetName(const pName: string);
begin
  FName := pName;
end;

procedure TLoggerMarker.SetParent(const pMarker: ILoggerMarker);
begin
  FParent := pMarker;
end;

{ TLogger }

constructor TLogger.Create;
begin
  FKeywords := nil;
  FOwner := EmptyStr;
  FMessage := EmptyStr;
  FException := nil;
  FMarker := nil;
end;

function TLogger.Exception(const pException: Exception): ILogger;
begin
  FException := pException;
  Result := Self;
end;

function TLogger.GetException: Exception;
begin
  Result := FException;
end;

function TLogger.GetKeywords: TLoggerKeywords;
begin
  Result := FKeywords;
end;

function TLogger.GetMarker: ILoggerMarker;
begin
  Result := FMarker;
end;

function TLogger.GetMessage: string;
begin
  Result := FMessage;
end;

function TLogger.GetOwner: string;
begin
  Result := FOwner;
end;

function TLogger.Keywords(const pKeywords: TLoggerKeywords): ILogger;
begin
  FKeywords := pKeywords;
  Result := Self;
end;

function TLogger.Marker(const pName: string; pParent: ILoggerMarker): ILogger;
begin
  FMarker := TLoggerMarker.Create(pName, pParent);
  Result := Self;
end;

function TLogger.Message(const pMessage: string): ILogger;
begin
  FMessage := pMessage;
  Result := Self;
end;

function TLogger.Owner(const pOwner: string): ILogger;
begin
  FOwner := pOwner;
  Result := Self;
end;

initialization

_vCriticalSection := TCriticalSection.Create();

finalization

FreeAndNil(_vCriticalSection);

end.
