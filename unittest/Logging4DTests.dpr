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
  Logging4D.Drivers.Base in '..\src\Logging4D.Drivers.Base.pas',
  Logging4D.Drivers.Standard in '..\src\Logging4D.Drivers.Standard.pas',
  Logging4D.UnitTest.Standard in 'Logging4D.UnitTest.Standard.pas';

{$R *.RES}


begin

  ReportMemoryLeaksOnShutdown := True;

  DUnitTestRunner.RunRegisteredTests;

end.
