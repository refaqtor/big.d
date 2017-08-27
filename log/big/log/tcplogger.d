/**
* Copyright: 2017 © LLC CERERIS
* License: MIT
* Authors: LLC CERERIS
*/

module big.log.tcplogger;

import std.datetime: DateTime;
import std.experimental.logger: Logger, LogLevel;
import std.string: format;
import vibe.core.net: connectTCP, NetworkAddress, resolveHost, TCPConnection;

/// This $(D Logger) implementation writes log messages to the associated TCP connection.
class TCPLogger: Logger
{
  public:
    /** A constructor for the $(D TCPLogger) Logger.
    Params:
      host = The host address of the TCP server.
      port = The port of the TCP server.
      logLevel = The $(D LogLevel) for the $(D TCPLogger). By default - LogLevel.warning

    Example:
    -------------
    auto logger1 = new TCPLogger("logFile");
    auto logger2 = new TCPLogger("logFile", LogLevel.fatal);
    -------------
    */
    this(in string host, in ushort port, in LogLevel logLevel = LogLevel.warning) @safe
    {
      super(logLevel);
      _address = resolveHost(host);
      _address.port = port;
    }

    /** This methods overrides the base class method and delegates the
    $(D LogEntry) data to the actual implementation.
    */
    override void writeLogMsg(ref LogEntry payload) @trusted
    {
      if(tryConnectToTCP())
      {
        const auto dateTime = cast(DateTime) payload.timestamp;
        string dateTimeISO = "%04d-%02d-%02dT%02d:%02d:%02d.%03d".format( dateTime.year,
                                                                          dateTime.month,
                                                                          dateTime.day,
                                                                          dateTime.hour,
                                                                          dateTime.minute,
                                                                          dateTime.second,
                                                                          payload.timestamp.fracSecs.total!"msecs");
        _connection.write("%s [%s] %s".format(dateTimeISO, payload.logLevel, payload.msg));
      }
    }

  private:
    bool tryConnectToTCP()
    {
      try
      {
        if(!_connection || !_connection.connected())
        {  
          _connection = connectTCP(_address);
        }
      }
      catch(Exception e)
      {
        return false;
      }

      return _connection.connected();
    }

    NetworkAddress _address;
    TCPConnection _connection;
}
