/**
* Copyright: 2017 © LLC CERERIS
* License: MIT
* Authors: LLC CERERIS
*/

module big.log.logserviceinitmanager;

import big.config.configservice: config, ConfigService;
import big.core.application: app;
import big.log.colorconsolelogger: ColorConsoleLogger;
import big.log.consolelogger: ConsoleLogger;
import big.log.logservicetype: LogServiceType;
import big.log.logservice: bigLog, LogService;
import big.log.tcplogger: TCPLogger;
import big.log.udplogger: UDPLogger;
import big.utils.composite: Attribute, Composite;
import std.conv: to;
import std.experimental.logger : Logger, LogLevel, MultiLogger;
import std.functional: toDelegate;

enum
{
  /// String name for load from config file
  LOG_SERVICE_CONFIG_TYPE = "Logger",
  /// String name of group defenition
  LOG_SERVICE_GROUP = "group",
  /// Default group name
  DEFAULT_LOG_SERVICE_GROUP = "",
  /// String name of name defenition
  LOG_SERVICE_NAME = "name",
  /// Default name
  DEFAULT_LOG_SERVICE_NAME = "default",
  /// String name of type defenition
  LOG_SERVICE_TYPE = "type",
  /// Default type
  DEFAULT_LOG_SERVICE_TYPE = "console",
  /// String name of level defenition
  LOG_SERVICE_LEVEL = "level",
  /// Default log level
  DEFAULT_LOG_SERVICE_LEVEL = "warning",
  /// String name of host defenition
  LOG_SERVICE_HOST = "host",
  /// Default host name
  DEFAULT_LOG_SERVICE_HOST = "0.0.0.0",
  /// String name of port defenition
  LOG_SERVICE_PORT = "port",
  /// Default port
  DEFAULT_LOG_SERVICE_PORT = "33000"
}

/// Provide init log system
final class LogServiceInitManager
{
  public:
    /// A constructor for the $(D LogServiceInitManager)
    this(ConfigService service = config())
    {
      service.subscribe(LOG_SERVICE_CONFIG_TYPE, toDelegate(&initLogService));
    }
    
  private:
    /** Init LogService from configuration
    * Params:
    *		configs = All configuration data for LogServise
    */
    void initLogService(Composite[] configs)
    {   
      foreach(Composite loggerConfig; configs)
      {
        auto groupAttribute = loggerConfig.get!Attribute(LOG_SERVICE_GROUP);
        string group =  groupAttribute is null ? DEFAULT_LOG_SERVICE_GROUP : groupAttribute.getValue().get!string();
        bigLog().trace("LogServiceInitManager: parse config group `" ~ group ~ "'");

        auto nameAttribute = loggerConfig.get!Attribute(LOG_SERVICE_NAME);
        string name =  nameAttribute is null ? DEFAULT_LOG_SERVICE_NAME : nameAttribute.getValue().get!string();
        bigLog().trace("LogServiceInitManager: parse config name `" ~ name ~ "'");

        auto typeAttribute = loggerConfig.get!Attribute(LOG_SERVICE_TYPE);
        immutable string type =  typeAttribute is null ? DEFAULT_LOG_SERVICE_TYPE : typeAttribute.getValue().get!string();
        bigLog().trace("LogServiceInitManager: parse config type `" ~ type ~ "'");
        
        auto levelAttribute = loggerConfig.get!Attribute(LOG_SERVICE_LEVEL);
        immutable string level =  levelAttribute is null ? DEFAULT_LOG_SERVICE_LEVEL : levelAttribute.getValue().get!string();
        bigLog().trace("LogServiceInitManager: parse config log level `" ~ level ~ "'");
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
          bigLog().trace("LogServiceInitManager: create LogService `" ~ group ~ "'");
          auto logService = new LogService();
          app().register(logService, group);
        }
     
        Logger logger = null;
        
        switch(type)
        {
          default:
            bigLog().warning("LogServiceInitManager: can't create logger of type `" ~ type ~ "'");
            break;
          case "color":
            logger = new ColorConsoleLogger(logLevel);
            break;
          case "console":
            logger = new ConsoleLogger(logLevel);
            break;
          case "udp":
            auto hostAttribute = loggerConfig.get!Attribute(LOG_SERVICE_HOST);
            immutable string host =  hostAttribute is null ? DEFAULT_LOG_SERVICE_HOST : hostAttribute.getValue().get!string();
            bigLog().trace("LogServiceInitManager: parse config host `" ~ host ~ "'");

            auto portAttribute = loggerConfig.get!Attribute(LOG_SERVICE_PORT);
            immutable ushort port =  portAttribute is null ? to!ushort(DEFAULT_LOG_SERVICE_PORT) : portAttribute.getValue().get!ushort();
            bigLog().trace("LogServiceInitManager: parse config port `" ~ to!string(port) ~ "'");

            logger = new UDPLogger(host, port, logLevel);
            break;
          case "tcp":
            auto hostAttribute = loggerConfig.get!Attribute(LOG_SERVICE_HOST);
            immutable string host =  hostAttribute is null ? DEFAULT_LOG_SERVICE_HOST : hostAttribute.getValue().get!string();
            bigLog().trace("LogServiceInitManager: parse config host `" ~ host ~ "'");

            auto portAttribute = loggerConfig.get!Attribute(LOG_SERVICE_PORT);
            immutable ushort port =  portAttribute is null ? to!ushort(DEFAULT_LOG_SERVICE_PORT) : portAttribute.getValue().get!ushort();
            bigLog().trace("LogServiceInitManager: parse config port `" ~ to!string(port) ~ "'");

            logger = new TCPLogger(host, port, logLevel);
            break;
        }
        
        if(logger)
        {
          app().get!LogService(group).insertLogger(name, logger);
          bigLog().trace("LogServiceInitManager: create " ~ to!string(logger));
        }
      }
    }    
}