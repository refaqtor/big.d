/**
* Copyright: 2017 © LLC CERERIS
* License: MIT
* Authors: LLC CERERIS
*/

module big.log.logservice;

import big.core.application: app;
import big.log.logservicetype: LogServiceType;
import std.experimental.logger : Logger, LogLevel, MultiLogger;

/** This $(D MultiLogger) implementation allows you to get a logger by name
* See_Also: 
*   `std.experimental.logger`
*/
class LogService : MultiLogger
{
  public:
    /** A constructor for the $(D LogService) MultiLogger.
    * Params:
    *   logLevel = The $(D LogLevel) for the $(D LogService). By default - LogLevel.warning
    */
    this(in LogLevel logLevel = LogLevel.warning)
    {
      super(logLevel);
    }
    
    /** This method gives a Logger from the $(D LogService).
    * Params:
    *   name = The name of the $(D Logger) will be given. If the $(D Logger)
    *   is not found $(D null) will be returned. Only the first occurrence of
    *   a $(D Logger) with the given name will be given.
    * Returns: $(D Logger) with the given name.
    */
    Logger getLogger(in char[] name) @safe
    {
      for (size_t i = 0; i < this.logger.length; ++i)
      {
        if (this.logger[i].name == name)
        {
          Logger ret = this.logger[i].logger;
          return ret;
        }
      }

      return null;
    }
}

/** Return LogService instance (syntactic sugar).
* See_Also: 
*   `big.core.application.app`
*/
static LogService log(in string logName = "")
{
  return app().get!LogService(logName);
}

/** Return LogService instance for big.d (syntactic sugar).
* See_Also: 
*   `big.core.application.app`
*/
static LogService bigLog()
{
  return app().get!LogService(LogServiceType.BIG_D);
}

/// Register LogService
static this()
{
  auto logService = new LogService();
  app().register(logService, LogServiceType.DEFAULT);
}
