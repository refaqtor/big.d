/**
* Copyright: 2017 © LLC CERERIS
* License: MIT
* Authors: LLC CERERIS
*/

module big.provider.aqmp.aqmpclientservice;

import big.core.application: app;
import big.provider.aqmp.aqmpclient: AQMPClient;

/// For store AQMPClient instance
struct AQMPClientEntry
{
  /// The name of the $(D AQMPClient)
  string name;
  /// The stored $(D AQMPClient)
  AQMPClient client; 
}

/// Provide working with AQMPClient
class AQMPClientService
{
  public:
   
    void insertAQMPClient(in string name, AQMPClient client)
    {
      _clients ~= AQMPClientEntry(name, client);
    }
    
//    UDPServer removeUDPServer(in char[] toRemove) @safe
//    {
//      import std.algorithm.mutation : copy;
//      import std.range.primitives : back, popBack;
//      
//      for(size_t i = 0; i < _servers.length; ++i)
//      {
//        if(_servers[i].name == toRemove)
//        {
//          UDPServer ret = _servers[i].server;
//          _servers[i] = _servers.back;
//          _servers.popBack();
//
//          return ret;
//        }
//      }
//
//      return null;
//    }
//    
//    UDPServer getFirstUDPServer(in char[] name) @safe
//    {
//      for(size_t i = 0; i < _servers.length; ++i)
//      {
//        if(_servers[i].name == name)
//        {
//          UDPServer ret = _servers[i].server;
//          return ret;
//        }
//      }
//
//      return null;
//    }
    
  private:
    AQMPClientEntry[] _clients;
}

/// Register default AQMPClientService
static this()
{
  auto service = new AQMPClientService();
  app().register(service);
}