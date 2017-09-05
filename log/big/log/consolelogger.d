/**
* Copyright: 2017 © LLC CERERIS
* License: MIT
* Authors: LLC CERERIS
*/

module big.log.consolelogger;

import std.datetime: DateTime;
import std.experimental.logger: Logger, LogLevel;
import std.format: formattedWrite;
import std.stdio: File, stdout;
import std.string: format;

/// This $(D Logger) implementation writes log messages to standart STDOUT
class ConsoleLogger: Logger
{
  public:
    /** A constructor for the $(D ConsoleLogger) Logger.
    * Params:
    *   logLevel = The $(D LogLevel) for the $(D ConsoleLogger). By default - LogLevel.warning
    *   outFile = The $(D File) output for write log messages
    *
    * Example:
    * -------------
    * auto logger1 = new ConsoleLogger();
    * auto logger2 = new ConsoleLogger(LogLevel.fatal);
    * -------------
    */
    this(in LogLevel logLevel = LogLevel.warning, File outFile = stdout) @safe
    {
      super(logLevel);
      _out = outFile;
    }

    /** This methods overrides the base class method and delegates the
    * $(D LogEntry) data to the actual implementation.
    */
    override void writeLogMsg(ref LogEntry payload) @trusted
    {
      {
        const auto dateTime = cast(DateTime) payload.timestamp;
        string dateTimeISO = "%04d-%02d-%02dT%02d:%02d:%02d.%03d".format( dateTime.year,
                                                                          dateTime.month,
                                                                          dateTime.day,
                                                                          dateTime.hour,
                                                                          dateTime.minute,
                                                                          dateTime.second,
                                                                          payload.timestamp.fracSecs.total!"msecs");
        auto writer = _out.lockingTextWriter();
        formattedWrite(writer, "%s [%s] %s\n", dateTimeISO, payload.logLevel, payload.msg);
        _out.flush();
      }
    }

  private:
    /// $(D File) output for write log messages
    File _out;
}
