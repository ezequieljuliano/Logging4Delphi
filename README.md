Logging For Delphi
==============

The Logging4Delphi is an API that facilitates the generation of logs in applications developed in Delphi. With this library you can configure the task of logging in an easy and simple way. Moreover, it enables the use of the framework Log4D that has a lot of classes and methods for generating logs.

Drivers Adapters
=================

The Logging4Delphi is available for the following data access drivers:

- Logging with standard adapter;
- Logging with Log4D adapter;

External Dependencies
=====================

The Logging4Delphi makes use of some external dependencies. Therefore these dependences are included in the project within the "dependencies" folder. If you use the library parser you should add to the Path Log4D.

Using Logging4Delphi
====================

The Logging4Delphi requires Delphi XE or greater and to use this API will is very simple, you simply add the Search Path of your IDE or your project the following directories:

- Logging4Delphi\src
- Logging4Delphi\dependencies\Log4D

Examples
===========

    procedure LoggingWithStandardAdapter;
    var
       vStdLogging: ILogging;
       vStdAppender: TLoggerAppender;
       vFileName: string;
    begin
       vFileName := ExtractFilePath(ParamStr(0)) + 'Log.txt';
       vStdAppender := procedure(pArg: string)
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
    
       vStdLogging := TStdLoggingAdapter.Create(vStdAppender);
       //Using Logger
       vStdLogging.Fatal(NewLogger
          .Keywords(TLoggerKeywords.Create('Test'))
          .Owner('Program')
          .Message('Fatal Test')
          .Marker('Marker Test'));
       //Using String Message
       vStdLogging.Info('Info Test');
    end;

    procedure LoggingWithLog4DAdapter;
    var
       vLogging: ILogging;
    begin
       vLogging := TLog4DLoggingAdapter.Create('Log4D', 'log4d.props');
       //Using Logger
       vLogging.Fatal(NewLogger
          .Keywords(TLoggerKeywords.Create('Test'))
          .Owner('Program')
          .Message('Fatal Test')
          .Marker('Marker Test'));
       //Using String Message
       vLogging.Info('Info Test');
    end;
    
**Analyze the unit tests they will assist you.**