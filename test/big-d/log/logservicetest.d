/**
* Copyright: 2017 © LLC CERERIS
* License: MIT
* Authors: LLC CERERIS
*/

module test.big.log.logservicetest;

import big.log.logservice;
import checkit.assertion;
import checkit.bdd;
import std.experimental.logger;

unittest
{
  scenario!("Insert log by name", ["log"])
  ({
    given!"Empty LogService"
    ({
      auto logService = new LogService();

      when!"Add many loggers"
      ({
        auto firstLogger = new NullLogger;
        auto secondLogger = new NullLogger;
        logService.insertLogger("FirstLogger", firstLogger);
        logService.insertLogger("SecondLogger", secondLogger);

        then!"Loggers succes get by name"
        ({
            logService.getLogger("FirstLogger").shouldBeInstanceOf!NullLogger();
            logService.getLogger("SecondLogger").shouldBeInstanceOf!NullLogger();
        });
      });
    });
  });
  scenario!("Get a nonexistent logger by name", ["log"])
  ({
    given!"Empty LogService"
    ({
      auto logService = new LogService();

      when!"Try get nonexistent logger"
      ({
        then!"Get null value"
        ({
            logService.getLogger("nonexistent_logger").shouldBeNull();
        });
      });
    });
  });
}
