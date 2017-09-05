/**
* Copyright: 2017 © LLC CERERIS
* License: MIT
* Authors: LLC CERERIS
*/

module test.big.log.consoleloggertest;

import big.log.consolelogger;
import checkit.assertion;
import checkit.bdd;
import std.datetime: DateTime, msecs;
import std.experimental.logger: Logger, LogLevel;
import std.algorithm.searching: canFind;
import std.stdio: File;
import std.file: remove, readText;

unittest
{
  scenario!("Logging into console", ["log"])
  ({
    given!"Console logger"
    ({
      auto outFile = File("console_test.log", "w"); 
      ConsoleLogger logger = new ConsoleLogger(LogLevel.all, outFile);

      when!"Logging custom message"
      ({
        logger.info("Info message\n");
        outFile.close();

        then!"Console logger success log message"
        ({
          auto data = readText("console_test.log");
          remove("console_test.log");

          (canFind(data, "[info] Info message")).shouldBeTrue();
        });
      });
    });
  });
}
