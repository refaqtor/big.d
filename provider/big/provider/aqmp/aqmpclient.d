/**
* Copyright: 2017 © LLC CERERIS
* License: MIT
* Authors: LLC CERERIS
*/

module big.provider.aqmp.aqmpclient;

import core.time : msecs;
import big.log.logservice: bigLog;
import vibe.core.core: runTask, sleep;
import vibe.core.net: connectTCP, NetworkAddress, resolveHost, TCPConnection;
import std.string: format;

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
    bool connect(ushort timeout)
    {
      bigLog().trace("AQMPClient: try connect to TCP `" ~ _address.toString() ~ "'");
      
      try
      {
        if(!_connection || !_connection.connected())
        {  
          _connection = connectTCP(_address);
          bigLog().trace("AQMPClient: success TCP connect to `" ~ _address.toString() ~ "'");
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
    /// $(D TCPConnection) of TCP communication between $(D AQMPClient) and AQMP broker
    TCPConnection _connection;
    /// $(D NetworkAddress) of remote AQMP broker
    NetworkAddress _address;
    /// Handle data from AQMP broker
    AQMPClientHandler _handler;
}