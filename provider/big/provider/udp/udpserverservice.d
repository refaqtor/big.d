/**
* Copyright: 2017 © LLC CERERIS
* License: MIT
* Authors: LLC CERERIS
*/

module big.provider.udp.udpserverservice;

import big.core.application: app;
import big.provider.udp.udpserver: UDPServer;

/// For store UDPServer instance
struct UDPServerEntry
{
  /// The name of the $(D UDPServer)
  string name;
  /// The stored $(D UDPServer)
  UDPServer server; 
}

/// Provide working with UDPServer
class UDPServerService
{
  public:
     
    void insertUDPServer(in string name, UDPServer server)
    {
      _servers ~= UDPServerEntry(name, server);
    }
    
    UDPServer removeUDPServer(in char[] toRemove) @safe
    {
      import std.algorithm.mutation : copy;
      import std.range.primitives : back, popBack;
      
      for(size_t i = 0; i < _servers.length; ++i)
      {
        if(_servers[i].name == toRemove)
        {
          UDPServer ret = _servers[i].server;
          _servers[i] = _servers.back;
          _servers.popBack();

          return ret;
        }
      }

      return null;
    }
    
    UDPServer getFirstUDPServer(in char[] name) @safe
    {
      for(size_t i = 0; i < _servers.length; ++i)
      {
        if(_servers[i].name == name)
        {
          UDPServer ret = _servers[i].server;
          return ret;
        }
      }

      return null;
    }
    
  private:
    UDPServerEntry[] _servers;
}

/// Register default UDPServerService
static this()
{
  auto service = new UDPServerService();
  app().register(service);
}