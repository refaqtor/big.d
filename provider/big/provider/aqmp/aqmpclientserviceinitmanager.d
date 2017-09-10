/**
* Copyright: 2017 © LLC CERERIS
* License: MIT
* Authors: LLC CERERIS
*/

module big.provider.aqmp.aqmpclientserviceinitmanager;
//
import big.config.configservice: config, ConfigService;
import big.core.application: app;
import big.log.logservice: bigLog;
import big.provider.aqmp.aqmpclient: AQMPClient;
import big.provider.aqmp.aqmpclientservice: AQMPClientService;
import big.utils.composite: Attribute, Composite;
import std.conv: to;
import std.functional: toDelegate;
import vibe.core.net: NetworkAddress;

enum
{
  /// String name for load from config file
  AQMP_CLIENT_SERVICE_CONFIG_TYPE = "AQMP",
  /// String name of url defenition
  AQMP_CLIENT_SERVICE_URL = "url",
  /// String name of host defenition
  AQMP_CLIENT_SERVICE_HOST = "host",
  /// Default host
  DEFAULT_AQMP_CLIENT_SERVICE_HOST = "0.0.0.0",
  /// String name of level defenition
  AQMP_CLIENT_SERVICE_PORT = "port",
  /// String name of user defenition
  AQMP_CLIENT_SERVICE_USER = "user",
  /// Default user name
  DEFAULT_AQMP_CLIENT_SERVICE_USER = "quest",
  /// String name of password defenition
  AQMP_CLIENT_SERVICE_PASSWORD = "password",
  /// Default password
  DEFAULT_AQMP_CLIENT_SERVICE_PASSWORD = "quest",
  /// String name of connect timeout defenition
  AQMP_CLIENT_SERVICE_CONNECT_TIMEOUT = "connect-timeout"
}

enum: ushort
{
  /// Default port
  DEFAULT_AQMP_CLIENT_SERVICE_PORT = 5672,
  /// Default connect timeout
  DEFAULT_AQMP_CLIENT_SERVICE_CONNECT_TIMEOUT = 5000
}

/// Provide init udp server
final class AQMPClientServiceInitManager
{
  public:
    /// A constructor for the $(D AQMPClientServiceInitManager)
    this(ConfigService service = config())
    {
      service.subscribe(AQMP_CLIENT_SERVICE_CONFIG_TYPE, toDelegate(&initAQMPClientService));
    }
    
  private:
    /** Init AQMPClientService from configuration
    * Params:
    *		configs = All configuration data for AQMPClientService
    */
    void initAQMPClientService(Composite[] configs)
    {        
      foreach(Composite aqmpClientConfig; configs)
      {                
        auto urlAttribute = aqmpClientConfig.get!Attribute(AQMP_CLIENT_SERVICE_URL);
        if(urlAttribute is null)
        {
          bigLog().warning("AQMPClientServiceInitManager: url is not defined. Cancel creation!");
          continue;
        }
        
        string url = urlAttribute.getValue().get!string();
        bigLog().trace("AQMPClientServiceInitManager: parse url `" ~ url ~ "'");
        
        auto hostAttribute = aqmpClientConfig.get!Attribute(AQMP_CLIENT_SERVICE_HOST);
        immutable string host =  hostAttribute is null ? DEFAULT_AQMP_CLIENT_SERVICE_HOST : hostAttribute.getValue().get!string();
        bigLog().trace("AQMPClientServiceInitManager: parse config host `" ~ host ~ "'");
        
        auto portAttribute = aqmpClientConfig.get!Attribute(AQMP_CLIENT_SERVICE_PORT);
        immutable ushort port =  portAttribute is null ? DEFAULT_AQMP_CLIENT_SERVICE_PORT : to!ushort(portAttribute.getValue().get!int());
        bigLog().trace("AQMPClientServiceInitManager: parse config port `" ~ to!string(port) ~ "'");
        
        auto userAttribute = aqmpClientConfig.get!Attribute(AQMP_CLIENT_SERVICE_USER);
        immutable string user =  userAttribute is null ? DEFAULT_AQMP_CLIENT_SERVICE_USER : userAttribute.getValue().get!string();
        bigLog().trace("AQMPClientServiceInitManager: parse config user `" ~ user ~ "'");
        
        auto passwordAttribute = aqmpClientConfig.get!Attribute(AQMP_CLIENT_SERVICE_PASSWORD);
        immutable string password =  passwordAttribute is null ? DEFAULT_AQMP_CLIENT_SERVICE_PASSWORD : passwordAttribute.getValue().get!string();
        bigLog().trace("AQMPClientServiceInitManager: parse config password `" ~ password ~ "'");
        
        auto connectTimeoutAttribute = aqmpClientConfig.get!Attribute(AQMP_CLIENT_SERVICE_CONNECT_TIMEOUT);
        immutable ushort connectTimeout =  connectTimeoutAttribute is null ? DEFAULT_AQMP_CLIENT_SERVICE_CONNECT_TIMEOUT : to!ushort(connectTimeoutAttribute.getValue().get!int());
        bigLog().trace("AQMPClientServiceInitManager: parse config connect timeout `" ~ to!string(connectTimeout) ~ "'");
              
        auto client = new AQMPClient(host, port, toDelegate(&_handle));
        client.connect(connectTimeout);
        
        app().get!AQMPClientService().insertAQMPClient(url, client);
        bigLog().info("AQMPClientServiceInitManager: create " ~ to!string(client));
      }
    }    
    
  private:
    void _handle(ubyte[] data, NetworkAddress address)
    {
      /// TODO: to route
    }
}