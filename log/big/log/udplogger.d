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

/** This $(D Logger) implementation writes log messages to the associated UDP connection.
* See_Also: 
*   `std.experimental.logger`
*/
class UDPLogger: Logger
{
  public:
    /** A constructor for the $(D UDPLogger) Logger.
    * Params:
    *   host = The host address of the UDP server.
    *   port = The port of the UDP server.
    *   logLevel = The $(D LogLevel) for the $(D UDPLogger). By default - LogLevel.warning
    */
    this(in string host, in ushort port, in LogLevel logLevel = LogLevel.warning) @safe
    {
      super(logLevel);
      _address = resolveHost(host);
      _address.port = port;
      _connection = listenUDP(0);
    }

    /** This methods overrides the base class method and delegates the
    * $(D LogEntry) data to the actual implementation.
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
        _connection.send(cast(ubyte[]) "%s [%s] %s\n\r".format(dateTimeISO, payload.logLevel, payload.msg), &_address);
      }
      catch(Exception e)
      {
      }
    }
    
    /// Convert Object to a human readable string
    override string toString()
    {
      return "UDPLogger(host: %s, port: %d, level: '%s')".format(_address.toAddressString(), _address.port, logLevel()); 
    }

  private:
    /// $(D NetworkAddress) of remote UDP server for logging
    NetworkAddress _address;
    /// $(D UDPConnection) of UDP communication between $(D UDPLogger) and UDP server
    UDPConnection _connection;
}
