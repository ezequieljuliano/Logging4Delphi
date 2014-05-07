Logging For Delphi
==============

The Logging4Delphi is an API that facilitates the generation of logs in applications developed in Delphi. With this library you can configure the task of logging in an easy and simple way. Moreover, it enables the use of the framework Log4D that has a lot of classes and methods for generating logs.

The Logging4Delphi API was developed and tested in Delphi XE5.

Drivers Adapters
=================

The Logging4Delphi is available for the following data access drivers:

- Standard;
- Log4D;

External Dependencies
=====================

The Logging4Delphi makes use of some external dependencies. Therefore these dependences are included in the project within the "dependencies" folder. If you use the library parser you should add to the Path Log4D.

Using Logging4Delphi
====================

Using this API will is very simple, you simply add the Search Path of your IDE or your project the following directories:

- Logging4Delphi\src
- Logging4Delphi\dependencies\Log4D

Examples
===========

    procedure LogStd();
    var
      vFileName: string;
      vStdLogging: ILogging;
      vAppender: TLoggerAppender;
    begin
      vFileName := ExtractFilePath(ParamStr(0)) + 'Log.txt';
    
      vAppender := procedure(pArg: string)
    var
      vStrList: TStringList;
    begin
      vStrList := TStringList.Create;
      try
    if FileExists(vFileName) then
      DeleteFile(vFileName);
    
    vStrList.Add(pArg);
    
    vStrList.SaveToFile(vFileName);
      finally
    FreeAndNil(vStrList);
      end;
    end;
    
      TStdLoggingSingleton.Configure('Std', vAppender);
      vStdLogging := TStdLoggingSingleton.Get();
      
      vStdLogging.Fatal(
      Logger
      .Keywords(TLoggerKeywords.Create('Test'))
      .Owner('Ezequiel')
      .Message('Fatal Test')
      .Marker('Delphi')
      );
    end;


Analyze the unit tests they will assist you.