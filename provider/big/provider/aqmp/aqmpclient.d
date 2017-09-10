/**
* Copyright: 2017 © LLC CERERIS
* License: MIT
* Authors: LLC CERERIS
*/

module big.provider.aqmp.aqmpclient;

import core.time : msecs;
import big.log.logservice: bigLog;
import big.utils.composite: Attribute, Composite;
import vibe.core.core: runTask, sleep;
import vibe.core.net: connectTCP, NetworkAddress, resolveHost, TCPConnection;
import std.conv: to;
import std.string: format;

enum AQMPVersion: string
{
  VERSION_0_9_1 = "AMQP" ~ 0 ~ 0 ~ 9 ~ 1
}

enum
{
  AQMP_TYPE_NAME = "type",
  AQMP_CHANNEL_NAME = "channel",
  AQMP_SIZE_NAME = "size"
}

enum AQMPType: ubyte
{
  METHOD = 1,
  HEADER = 2,
  BODY = 3,
  HEARTBEAT = 4
}

/// AQMP client for AQMP brokers (like RabbitMQ)
class AQMPClient
{
  public:
    alias AQMPClientHandler = void delegate(ubyte[] data, NetworkAddress address);
  
    /** A constructor for the $(D AQMPClient).
    * Params:
    *   host = The host address of the AQMP broker.
    *   port = The port of the AQMP broker.
    */
    this(in string host, in ushort port, AQMPClientHandler handler)
    {
      _address = resolveHost(host);
      _address.port = port;
      _handler = handler;
    }
    
    
    /// Connect to AQMP broker
    bool connect(ushort timeout, AQMPVersion aqmpVersion = AQMPVersion.VERSION_0_9_1)
    {
      bigLog().trace("AQMPClient: try connect to TCP `" ~ _address.toString() ~ "'");
      
      try
      {
        if(!_connection || !_connection.connected())
        {  
          _connection = connectTCP(_address);
          bigLog().trace("AQMPClient: success TCP connect to `" ~ _address.toString() ~ "'");
          startSession(aqmpVersion);    
          return true; 
        }
      }
      catch(Exception e)
      {
        bigLog().error("AQMPClient: can't connect to `" ~ _address.toString() ~ "'");
        
        if((!_connection || !_connection.connected()) && timeout)
        {
          runTask({
            sleep(msecs(timeout));
            connect(timeout);
          });
        }
      }  
      
      return false;          
    }
    
    /// Convert Object to a human readable string
    override string toString()
    {
      return "AQMPClient(address: '%s')".format(_address.toString()); 
    }
  
  private:
    void startSession(AQMPVersion protocolVersion)
    {
      if(_connection && _connection.connected())
      {
        _connection.write(cast(ubyte[]) protocolVersion);
        
        if(_connection.waitForData())
        {
          ubyte[] buffer = new ubyte[_connection.leastSize];
          _connection.read(buffer);
          bigLog().info(handle(buffer));
        }
      }
    }
    
    Composite handle(ubyte[] buffer)
    {
      if(buffer.length >= 7)
      {
        Composite packet = new Composite("Packet");
        packet.add(new Attribute(AQMP_TYPE_NAME, buffer[0]));
        packet.add(new Attribute(AQMP_CHANNEL_NAME, *cast(short*)buffer[1..2].ptr));
        packet.add(new Attribute(AQMP_SIZE_NAME, *cast(long*)buffer[3..6].ptr));
        return packet;
      }
      
      return null;
    }
  
    /// $(D TCPConnection) of TCP communication between $(D AQMPClient) and AQMP broker
    TCPConnection _connection;
    /// $(D NetworkAddress) of remote AQMP broker
    NetworkAddress _address;
    /// Handle data from AQMP broker
    AQMPClientHandler _handler;
}