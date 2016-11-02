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

The Logging4Delphi requires Delphi 2010 or greater and to use this API will is very simple, you simply add the Search Path of your IDE or your project the following directories:

- Logging4Delphi\src
- Logging4Delphi\dependencies\Log4D

Examples
===========
	uses
	  Logging4D,
	  Logging4D.Impl,
	  Logging4D.Driver.Standard;

    procedure LoggingWithStandardAdapter;
    var
      logging: ILogging;
      appender: TLoggerAppender;
      fileName: string;
	begin
	  inherited;
	  fileName := ExtractFilePath(ParamStr(0)) + 'Log.txt';
	
	  appender := procedure(msg: string)
	    var
	      strList: TStringList;
	    begin
	      strList := TStringList.Create;
	      try
	        if FileExists(fileName) then
	          DeleteFile(fileName);
	
	        strList.Add(msg);
	
	        strList.SaveToFile(fileName);
	      finally
	        strList.Free;
	      end;
	    end;
	
	  logging := TStandardLogging.Create(appender);

       //Using Logger
       logging.Fatal(
      	TLogger.New
      	  .Keywords(['REST'])
      	  .Owner('AppOne')
          .Message('Fatal REST Request Error')
          .Marker('Delphi')
        );

       //Using String Message
       logging.Fatal('Fatal REST Request Error');
	end;

    procedure LoggingWithLog4DAdapter;
    var
       logging: ILogging;
    begin
       logging := TLog4DLogging.Create('Log4D', fileName);
       
      //Using Logger
       logging.Fatal(
      	TLogger.New
      	  .Keywords(['REST'])
      	  .Owner('AppOne')
          .Message('Fatal REST Request Error')
          .Marker('Delphi')
        );

       //Using String Message
       logging.Fatal('Fatal REST Request Error');
    end;
    
**Analyze the unit tests they will assist you.**