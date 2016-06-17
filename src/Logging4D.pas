unit Logging4D;

interface

uses
  System.SysUtils;

type

  ELoggerException = class(Exception);

  TLoggerLevel = (Off, Fatal, Error, Warn, Info, Debug, Trace, All);

  TLoggerKeywords = array of string;

  TLoggerAppender = TProc<string>;

  ILoggerMarker = interface
    ['{5CB2B15B-B12C-4FA0-AA19-60E2D4ABA516}']
    function Name(const name: string): ILoggerMarker;
    function Parent(marker: ILoggerMarker): ILoggerMarker;

    function GetName: string;
    function GetParent: ILoggerMarker;
  end;

  ILogger = interface
    ['{73CAB0E1-B7E0-448B-B949-27D031BD195C}']
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
  end;

  ILogging = interface
    ['{E67FFDE7-A790-4E4F-94DA-7BBB56B6E8CA}']
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
  end;

implementation

end.
