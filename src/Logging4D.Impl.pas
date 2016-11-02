unit Logging4D.Impl;

interface

uses
  {$IFDEF VER210}
  SysUtils,
  {$ELSE}
  System.SysUtils,
  {$ENDIF}
  Logging4D;

type

  TLoggerMarker = class(TInterfacedObject, ILoggerMarker)
  private
    fName: string;
    fMarker: ILoggerMarker;
  protected
    function Name(const name: string): ILoggerMarker;
    function Parent(marker: ILoggerMarker): ILoggerMarker;

    function GetName: string;
    function GetParent: ILoggerMarker;
  public
    constructor Create;

    class function New: ILoggerMarker; static;
  end;

  TLogger = class(TInterfacedObject, ILogger)
  private
    fKeywords: TLoggerKeywords;
    fOwner: string;
    fMessage: string;
    fException: Exception;
    fMarker: ILoggerMarker;
  protected
    function Keywords(const value: TLoggerKeywords): ILogger;
    function Owner(const value: string): ILogger;
    function Message(const value: string): ILogger;
    function Exception(value: Exception): ILogger;
    function Marker(const name: string): ILogger; overload;
    function Marker(const name: string; parent: ILoggerMarker): ILogger; overload;

    function GetKeywords: TLoggerKeywords;
    function GetOwner: string;
    function GetMessage: string;
    function GetException: Exception;
    function GetMarker: ILoggerMarker;
  public
    constructor Create;

    class function New: ILogger; static;
  end;

implementation

{ TLoggerMarker }

constructor TLoggerMarker.Create;
begin
  inherited Create;
  fName := '';
  fMarker := nil;
end;

function TLoggerMarker.GetName: string;
begin
  Result := fName;
end;

function TLoggerMarker.GetParent: ILoggerMarker;
begin
  Result := fMarker;
end;

function TLoggerMarker.Name(const name: string): ILoggerMarker;
begin
  fName := name;
  Result := Self;
end;

class function TLoggerMarker.New: ILoggerMarker;
begin
  Result := TLoggerMarker.Create;
end;

function TLoggerMarker.Parent(marker: ILoggerMarker): ILoggerMarker;
begin
  fMarker := marker;
  Result := Self;
end;

{ TLogger }

constructor TLogger.Create;
begin
  inherited Create;
  {$IFDEF VER210}
  fKeywords := nil;
  {$ELSE}
  fKeywords := [];
  {$ENDIF}
  fOwner := '';
  fMessage := '';
  fException := nil;
  fMarker := nil;
end;

function TLogger.GetException: Exception;
begin
  Result := fException;
end;

function TLogger.GetKeywords: TLoggerKeywords;
begin
  Result := fKeywords;
end;

function TLogger.GetMarker: ILoggerMarker;
begin
  Result := fMarker;
end;

function TLogger.GetMessage: string;
begin
  Result := fMessage;
end;

function TLogger.GetOwner: string;
begin
  Result := fOwner;
end;

function TLogger.Exception(value: Exception): ILogger;
begin
  fException := value;
  Result := Self;
end;

function TLogger.Keywords(const value: TLoggerKeywords): ILogger;
begin
  fKeywords := value;
  Result := Self;
end;

function TLogger.Marker(const name: string; parent: ILoggerMarker): ILogger;
begin
  FMarker := TLoggerMarker.New.Name(name).Parent(parent);
  Result := Self;
end;

function TLogger.Marker(const name: string): ILogger;
begin
  Result := Marker(name, nil);
end;

function TLogger.Message(const value: string): ILogger;
begin
  fMessage := value;
  Result := Self;
end;

function TLogger.Owner(const value: string): ILogger;
begin
  fOwner := value;
  Result := Self;
end;

class function TLogger.New: ILogger;
begin
  Result := TLogger.Create;
end;

end.
