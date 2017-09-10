/**
* Copyright: 2017 © LLC CERERIS
* License: MIT
* Authors: LLC CERERIS
*/

module big.provider.udp.udpserver;

import vibe.core.core: runTask;
import vibe.core.net: listenUDP, NetworkAddress, resolveHost, UDPConnection;
import std.string: format;

/// UDP server for handle udp connection
class UDPServer
{
  public:
    alias UDPServerHandler = void delegate(ubyte[] data, NetworkAddress address, string url);
  
    /** A constructor for the $(D UDPServer).
    * Params:
    *   host = The host address of the UDP server.
    *   port = The port of the UDP server.
    */
    this(in string host, in ushort port, in string url, UDPServerHandler handler)
    {
      _host = host;
      _port = port;
      _url = url;
      _handler = handler;
    }
    
    /// Return host of udp server
    string getHost()
    {
      return _host;
    }
    
    /// Return port of udp server
    ushort getPort()
    {
      return _port;
    }
    
    /// Start udp server
    void start()
    {
      _isStart = true;
      _connection = listenUDP(_port, _host);
        
      runTask({     
        NetworkAddress peerAddress;
            
        while(_isStart)
        {
  			  auto data = _connection.recv(null, &peerAddress);
  			  _handler(data, peerAddress, _url);
  		  }
      });                                
    }
    
    /// Convert Object to a human readable string
    override string toString()
    {
      return "UDPServer(host: '%s', host: '%d')".format(_host, _port); 
    }
  
  private:
    /// Host name of UDP server
    string _host;
    /// UDP port of UDP server
    ushort _port;
    /// url of UDP server
    string _url;
    /// $(D UDPConnection) for communication between UDP clients and server
    UDPConnection _connection;
    /// Status of running. If UDPServer is start = true.
    bool _isStart;
    /// Handle data from UDPServer
    UDPServerHandler _handler;
}