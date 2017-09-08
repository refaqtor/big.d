/**
* Copyright: 2017 © LLC CERERIS
* License: MIT
* Authors: LLC CERERIS
*/

module big.provider.udp.udpserverserviceinitmanager;

import big.config.configservice: config, ConfigService;
import big.core.application: app;
import big.log.logservice: bigLog;
import big.provider.udp.udpserver: UDPServer;
import big.provider.udp.udpserverservice: UDPServerService;
import big.utils.composite: Attribute, Composite;
import std.conv: to;
import std.functional: toDelegate;
import vibe.core.net: NetworkAddress;

enum
{
  /// String name for load from config file
  UDP_SERVER_SERVICE_CONFIG_TYPE = "UDP",
  /// String name of url defenition
  UDP_SERVER_SERVICE_URL = "url",
  /// String name of host defenition
  UDP_SERVER_SERVICE_HOST = "host",
  /// Default host
  DEFAULT_UDP_SERVER_SERVICE_HOST = "0.0.0.0",
  /// String name of level defenition
  UDP_SERVER_SERVICE_PORT = "port"
}

enum: ushort
{
  /// Default port
  DEFAULT_UDP_SERVER_SERVICE_PORT = 33000,
}

/// Provide init udp server
final class UDPServerServiceInitManager
{
  public:
    /// A constructor for the $(D LogServiceInitManager)
    this(ConfigService service = config())
    {
      service.subscribe(UDP_SERVER_SERVICE_CONFIG_TYPE, toDelegate(&initUDPServerService));
    }
    
  private:
    /** Init UDPServerService from configuration
    * Params:
    *		configs = All configuration data for UDPServerService
    */
    void initUDPServerService(Composite[] configs)
    {   
      foreach(Composite udpServerConfig; configs)
      {   
        auto urlAttribute = udpServerConfig.get!Attribute(UDP_SERVER_SERVICE_URL);
        if(urlAttribute is null)
        {
          bigLog().warning("UDPServerServiceInitManager: url is not defined. Cancel creation!");
          continue;
        }
        
        string url = urlAttribute.getValue().get!string();
        bigLog().trace("UDPServerServiceInitManager: parse url `" ~ url ~ "'");
        
        auto hostAttribute = udpServerConfig.get!Attribute(UDP_SERVER_SERVICE_HOST);
        immutable string host =  hostAttribute is null ? DEFAULT_UDP_SERVER_SERVICE_HOST : hostAttribute.getValue().get!string();
        bigLog().trace("LogServiceInitManager: parse config host `" ~ host ~ "'");
        
        auto portAttribute = udpServerConfig.get!Attribute(UDP_SERVER_SERVICE_PORT);
        immutable ushort port =  portAttribute is null ? DEFAULT_UDP_SERVER_SERVICE_PORT : to!ushort(portAttribute.getValue().get!int());
        bigLog().trace("LogServiceInitManager: parse config port `" ~ to!string(port) ~ "'");
           
        auto server = new UDPServer(host, port, toDelegate(&_handle));
        server.start();
        
        app().get!UDPServerService().insertUDPServer(url, server);
        bigLog().trace("UDPServerServiceInitManager: create " ~ to!string(server));
      }
    }    
    
  private:
    void _handle(ubyte[] data, NetworkAddress address)
    {
      /// TODO: to route
    }
}