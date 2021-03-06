/**
* Copyright: 2017 © LLC CERERIS
* License: MIT
* Authors: LLC CERERIS
*/

module test.big.log.logserviceinitmanager;

import big.config.configservice: ConfigService, InitPriority;
import big.core.application: app;
import big.log.colorconsolelogger: ColorConsoleLogger;
import big.log.consolelogger: ConsoleLogger;
import big.log.logservice: log, LogService;
import big.log.logserviceinitmanager: LogServiceInitManager;
import big.log.tcplogger: TCPLogger;
import big.log.udplogger: UDPLogger;
import big.utils.composite: Attribute, Component, Composite;
import checkit.assertion;
import checkit.bdd;
import std.experimental.logger: LogLevel;	

class ConfigServiceMock: ConfigService
{
  public:
    override void subscribe(string name, ConfigHandler handler, InitPriority priority)
    { 
      _handler = handler;
      _name = name;
      _priority = priority;
    }
    
    ConfigHandler _handler;
    string _name;
    InitPriority _priority;
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
          config._priority.shouldEqual(InitPriority.HIGH);
        });
        
        then!"LogServiceInitManager init ConsoleLogger"
        ({
          auto loggerData = new Composite("Logger");
          loggerData.add(new Attribute("name", "ConsoleLogger"));
          loggerData.add(new Attribute("type", "console"));
          loggerData.add(new Attribute("level", "trace"));
          loggerData.add(new Attribute("group", "test"));
          config._handler([loggerData]);
          
          auto logger = log("test").getFirstLogger("ConsoleLogger");
          logger.shouldBeInstanceOf!ConsoleLogger();
          logger.logLevel().shouldEqual(LogLevel.trace);
        });
        
        then!"LogServiceInitManager init ColorConsoleLogger"
        ({
          auto loggerData = new Composite("Logger");
          loggerData.add(new Attribute("name", "ColorConsoleLogger"));
          loggerData.add(new Attribute("type", "color"));
          loggerData.add(new Attribute("level", "info"));
          config._handler([loggerData]);
          
          auto logger = log().getFirstLogger("ColorConsoleLogger");
          logger.shouldBeInstanceOf!ColorConsoleLogger();
          logger.logLevel().shouldEqual(LogLevel.info);
        });
        
        then!"LogServiceInitManager init UDPLogger"
        ({
          auto loggerData = new Composite("Logger");
          loggerData.add(new Attribute("name", "UDPLogger"));
          loggerData.add(new Attribute("type", "udp"));
          loggerData.add(new Attribute("level", "warning"));
          config._handler([loggerData]);
          
          auto logger = log().getFirstLogger("UDPLogger");
          logger.shouldBeInstanceOf!UDPLogger();
          logger.logLevel().shouldEqual(LogLevel.warning);
        });
        
        then!"LogServiceInitManager init TCPLogger"
        ({
          auto loggerData = new Composite("Logger");
          loggerData.add(new Attribute("name", "TCPLogger"));
          loggerData.add(new Attribute("type", "tcp"));
          loggerData.add(new Attribute("level", "error"));
          config._handler([loggerData]);
          
          auto logger = log().getFirstLogger("TCPLogger");
          logger.shouldBeInstanceOf!TCPLogger();
          logger.logLevel().shouldEqual(LogLevel.error);
        });	
        
        then!"LogServiceInitManager init default"
        ({
          auto loggerData = new Composite("Logger");
          config._handler([loggerData]);
          log().getFirstLogger("").shouldBeNull();
          
          loggerData.remove("level");
          loggerData.remove("name");
          loggerData.add(new Attribute("level", "critical"));
          loggerData.add(new Attribute("name", "1"));
          config._handler([loggerData]);
          log().getFirstLogger("1").shouldBeInstanceOf!ConsoleLogger();
          log().getFirstLogger("1").logLevel().shouldEqual(LogLevel.critical);
          
          loggerData.remove("level");
          loggerData.remove("name");
          loggerData.add(new Attribute("level", "fatal"));
          loggerData.add(new Attribute("name", "2"));
          config._handler([loggerData]);
          log().getFirstLogger("2").shouldBeInstanceOf!ConsoleLogger();
          log().getFirstLogger("2").logLevel().shouldEqual(LogLevel.fatal);
          
          loggerData.remove("level");
          loggerData.remove("name");
          loggerData.add(new Attribute("level", "all"));
          loggerData.add(new Attribute("name", "3"));
          config._handler([loggerData]);
          log().getFirstLogger("3").shouldBeInstanceOf!ConsoleLogger();
          log().getFirstLogger("3").logLevel().shouldEqual(LogLevel.all);
          
          loggerData.remove("level");
          loggerData.remove("name");
          loggerData.add(new Attribute("level", "cereris"));
          loggerData.add(new Attribute("name", "4"));
          config._handler([loggerData]);
          log().getFirstLogger("4").shouldBeInstanceOf!ConsoleLogger();
          log().getFirstLogger("4").logLevel().shouldEqual(LogLevel.off);
          
          loggerData.remove("level");
          loggerData.remove("name");
          loggerData.add(new Attribute("name", "5"));
          loggerData.add(new Attribute("type", "cereris"));
          config._handler([loggerData]);
          log().getFirstLogger("5").shouldBeNull();
        });
      });
    });
  });
}
