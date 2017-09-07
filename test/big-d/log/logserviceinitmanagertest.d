/**
* Copyright: 2017 © LLC CERERIS
* License: MIT
* Authors: LLC CERERIS
*/

module test.big.log.logserviceinitmanager;

import big.config.configservice: ConfigService;
import big.core.application: app;
import big.log.consolelogger: ConsoleLogger;
import big.log.logservice: log, LogService;
import big.log.logserviceinitmanager: LogServiceInitManager;
import big.utils.composite: Attribute, Component, Composite;
import checkit.assertion;
import checkit.bdd;
import std.experimental.logger: LogLevel;

class ConfigServiceMock: ConfigService
{
  public:
    override void subscribe(string name, ConfigHandler handler)
    { 
      _handler = handler;
      _name = name;
    }
    
    ConfigHandler _handler;
    string _name;
}

unittest
{
  scenario!("LogServiceInitManager should init LogService from ConfigService", ["log"])
  ({
    given!"ConfigService instance"
    ({
      auto config = new ConfigServiceMock;

      when!"Create LogServuceInitManager"
      ({
        auto initManager = new LogServiceInitManager(config);

        then!"LogServiceInitManager init to ConfigService"
        ({
          config._name.shouldEqual("Logger");
          config._handler.shouldNotBeNull();
        });
        
        then!"LogServiceInitManager init ConsoleLogger"
        ({
          auto consoleLoggerData = new Composite("Logger");
          consoleLoggerData.add(new Attribute("name", "ConsoleLogger"));
          consoleLoggerData.add(new Attribute("type", "console"));
          consoleLoggerData.add(new Attribute("level", "trace"));
          consoleLoggerData.add(new Attribute("group", "test"));
          config._handler([consoleLoggerData]);
          
          auto logger = log("test").getLogger("ConsoleLogger");
          logger.shouldBeInstanceOf!ConsoleLogger();
          logger.logLevel().shouldEqual(LogLevel.trace);
        });
      });
    });
  });
}
