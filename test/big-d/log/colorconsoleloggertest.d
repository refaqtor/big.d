/**
* Copyright: 2017 © LLC CERERIS
* License: MIT
* Authors: LLC CERERIS
*/

module test.big.log.colorconsoleloggertest;

import big.log.colorconsolelogger;
import checkit.assertion;
import checkit.bdd;
import std.datetime: DateTime, msecs;
import std.experimental.logger: Logger, LogLevel;
import std.algorithm.searching: canFind;
import std.stdio: File;
import std.file: remove, readText;

unittest
{
  scenario!("Color logging into console", ["log"])
  ({
    given!"Color console logger"
    ({
      auto outFile = File("color_console_test.log", "w"); 
      auto logger = new ColorConsoleLogger(LogLevel.all, outFile);

      when!"Color logging custom message"
      ({
        logger.trace("Trace message\n");
        logger.info("Info message\n");
        logger.warning("Warning message\n");
        logger.error("Error message\n");
        logger.critical("Critical message\n");
        outFile.close();

        then!"Color logger succes logging message"
        ({
          auto data = readText("color_console_test.log");
          remove("color_console_test.log");

          (canFind(data, "\033[0;256;266;24;29;21m  \033[0;256;266;24;29;21m [\033[0;256;266;24;29;21mtrace" ~
                         "\033[0;256;266;24;29;21m] Trace message")).shouldBeTrue();  
          (canFind(data, "\033[1;34;44;24;29;21m  \033[0;256;266;24;29;21m [\033[1;34;266;24;29;21minfo" ~
                         "\033[0;256;266;24;29;21m] Info message")).shouldBeTrue();  
          (canFind(data, "\033[1;33;43;24;29;21m  \033[0;256;266;24;29;21m [\033[1;33;266;24;29;21mwarning" ~
                         "\033[0;256;266;24;29;21m] Warning message")).shouldBeTrue();
          (canFind(data, "\033[1;31;41;24;29;21m  \033[0;256;266;24;29;21m [\033[1;31;266;24;29;21merror" ~
                         "\033[0;256;266;24;29;21m] Error message")).shouldBeTrue();
          (canFind(data, "\033[1;35;45;24;29;21m  \033[0;256;266;24;29;21m [\033[1;35;266;24;29;21mcritical" ~
                         "\033[0;256;266;24;29;21m] Critical message")).shouldBeTrue();
        });
      });
    });
  });
}
