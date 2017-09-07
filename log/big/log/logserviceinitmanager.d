/**
* Copyright: 2017 © LLC CERERIS
* License: MIT
* Authors: LLC CERERIS
*/

module big.log.logserviceinitmanager;

import big.config.configservice: config;
import big.core.application: app;
import big.log.colorconsolelogger: ColorConsoleLogger;
import big.log.consolelogger: ConsoleLogger;
import big.log.logservice: bigLog, LogService;
import big.log.logservicetype: LogServiceType;
import big.utils.composite: Attribute, Composite;
import std.functional: toDelegate;
import std.experimental.logger : Logger, LogLevel, MultiLogger;

enum
{
  /// String name for load from config file
  LOG_SERVICE_CONFIG_TYPE = "Logger",
  LOG_SERVICE_GROUP = "group",
  DEFAULT_LOG_SERVICE_GROUP = "",
  LOG_SERVICE_NAME = "name",
  DEFAULT_LOG_SERVICE_NAME = "default",
  LOG_SERVICE_TYPE = "type",
  DEFAULT_LOG_SERVICE_TYPE = "console",
  LOG_SERVICE_LEVEL = "level",
  DEFAULT_LOG_SERVICE_LEVEL = "warning"
}

/// Provide init log system
final class LogServiceInitManager
{
  public:
    /// A constructor for the $(D LogServiceInitManager)
    this()
    {
      config().subscribe(LOG_SERVICE_CONFIG_TYPE, toDelegate(&init));
    }
    
  private:
    /** Init LogService from configuration
    * Params:
    *		configs = All configuration data for LogServise
    */
    void init(Composite[] configs)
    {   
      foreach(Composite loggerConfig; configs)
      {
        auto groupAttribute = loggerConfig.get!Attribute(LOG_SERVICE_GROUP);
        string group =  groupAttribute is null ? DEFAULT_LOG_SERVICE_GROUP : groupAttribute.getValue().get!string();
        
        auto nameAttribute = loggerConfig.get!Attribute(LOG_SERVICE_NAME);
        string name =  nameAttribute is null ? DEFAULT_LOG_SERVICE_NAME : nameAttribute.getValue().get!string();
        
        auto typeAttribute = loggerConfig.get!Attribute(LOG_SERVICE_TYPE);
        string type =  typeAttribute is null ? DEFAULT_LOG_SERVICE_TYPE : typeAttribute.getValue().get!string();
        
        auto levelAttribute = loggerConfig.get!Attribute(LOG_SERVICE_LEVEL);
        string level =  levelAttribute is null ? DEFAULT_LOG_SERVICE_LEVEL : levelAttribute.getValue().get!string();
        LogLevel logLevel;
        
        switch(level)
        {
          default:
            logLevel = LogLevel.off;
            break;
          case "trace":
            logLevel = LogLevel.trace;
            break;
          case "info":
            logLevel = LogLevel.info;
            break;
          case "warning":
            logLevel = LogLevel.warning;
            break;
          case "error":
            logLevel = LogLevel.error;
            break;
          case "critical":
            logLevel = LogLevel.critical;
            break;
          case "fatal":
            logLevel = LogLevel.fatal;
            break;
          case "all":
            logLevel = LogLevel.all;
            break;
        }
        
        /// Create LogService for group if needed      
        if(app().get!LogService(group) is null)
        {
          bigLog().trace("Create LogService: " ~ group);
          auto logService = new LogService();
          app().register(logService, group);
        }
     
        Logger logger = null;
        
        switch(type)
        {
          default: break;
          case "color":
            logger = new ColorConsoleLogger(logLevel);
            break;
          case "console":
            logger = new ConsoleLogger(logLevel);
            break;

          /// TODO: Add UDP/TCP logger  
        }
        
        if(logger)
        {
          app().get!LogService(group).insertLogger(name, logger);
        }
      }
    }    
}