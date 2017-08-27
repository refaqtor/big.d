/**
* Copyright: 2017 © LLC CERERIS
* License: MIT
* Authors: LLC CERERIS
*/

module big.log.udplogger;

import std.datetime: DateTime;
import std.experimental.logger: Logger, LogLevel;
import std.string: format;
import vibe.core.net: listenUDP, NetworkAddress, resolveHost, UDPConnection;

/// This $(D Logger) implementation writes log messages to the associated UDP connection.
class UDPLogger: Logger
{
  public:
    /** A constructor for the $(D UDPLogger) Logger.
    Params:
      host = The host address of the UDP server.
      port = The port of the UDP server.
      logLevel = The $(D LogLevel) for the $(D UDPLogger). By default - LogLevel.warning

    Example:
    -------------
    auto logger1 = new UDPLogger("logFile");
    auto logger2 = new UDPLogger("logFile", LogLevel.fatal);
    -------------
    */
    this(in string host, in ushort port, in LogLevel logLevel = LogLevel.warning) @safe
    {
      super(logLevel);
      _address = resolveHost(host);
      _address.port = port;
      _connection = listenUDP(0);
    }

    /** This methods overrides the base class method and delegates the
    $(D LogEntry) data to the actual implementation.
    */
    override void writeLogMsg(ref LogEntry payload) @trusted
    {
      const auto dateTime = cast(DateTime) payload.timestamp;
      string dateTimeISO = "%04d-%02d-%02dT%02d:%02d:%02d.%03d".format( dateTime.year,
                                                                          dateTime.month,
                                                                          dateTime.day,
                                                                          dateTime.hour,
                                                                          dateTime.minute,
                                                                          dateTime.second,
                                                                          payload.timestamp.fracSecs.total!"msecs");
      try
      {
        _connection.send(cast(ubyte[]) "%s [%s] %s".format(dateTimeISO, payload.logLevel, payload.msg), &_address);
      }
      catch(Exception e)
      {
      }
    }

  private:
    NetworkAddress _address;
    UDPConnection _connection;
}
