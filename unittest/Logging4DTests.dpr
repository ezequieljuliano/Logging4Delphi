program Logging4DTests;

{

  Delphi DUnit Test Project
  -------------------------
  This project contains the DUnit test framework and the GUI/Console test runners.
  Add "CONSOLE_TESTRUNNER" to the conditional defines entry in the project options
  to use the console test runner.  Otherwise the GUI test runner will be used by
  default.

}

{$IFDEF CONSOLE_TESTRUNNER}
{$APPTYPE CONSOLE}
{$ENDIF}


uses
  DUnitTestRunner,
  Logging4D in '..\src\Logging4D.pas',
  Logging4D.Driver.Base in '..\src\Logging4D.Driver.Base.pas',
  Logging4D.Driver.Standard in '..\src\Logging4D.Driver.Standard.pas',
  Logging4D.UnitTest.Standard in 'Logging4D.UnitTest.Standard.pas',
  Logging4D.Driver.Log4D in '..\src\Logging4D.Driver.Log4D.pas',
  Logging4D.UnitTest.Log4D in 'Logging4D.UnitTest.Log4D.pas',
  Logging4D.Impl in '..\src\Logging4D.Impl.pas';

{$R *.RES}


begin

  ReportMemoryLeaksOnShutdown := True;

  DUnitTestRunner.RunRegisteredTests;

end.
