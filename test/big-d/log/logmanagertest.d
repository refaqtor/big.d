/**
* Copyright: 2017 © LLC CERERIS
* License: MIT
* Authors: LLC CERERIS
*/

module test.big.log.logmanagertest;

import big.log.logmanager;
import checkit.assertion;
import checkit.bdd;
import std.experimental.logger;

unittest
{
  scenario!("Insert log by name", ["log"])
  ({
    given!"Empty LogManager"
    ({
      auto manager = new LogManager();

      when!"Add many loggers"
      ({
        auto firstLogger = new NullLogger;
        auto secondLogger = new NullLogger;
        manager.insertLogger("FirstLogger", firstLogger);
        manager.insertLogger("SecondLogger", secondLogger);

        then!"Loggers succes get by name"
        ({
          manager.get("FirstLogger").shouldBeInstanceOf!NullLogger();
          manager.get("SecondLogger").shouldBeInstanceOf!NullLogger();
        });
      });
    });
  });
}
