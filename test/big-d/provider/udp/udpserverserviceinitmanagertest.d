/**
* Copyright: 2017 © LLC CERERIS
* License: MIT
* Authors: LLC CERERIS
*/

module test.provider.udp.udpserverserviceinitmanager;

import big.config.configservice: ConfigService, InitPriority;
import big.core.application: app;
import big.provider.udp;
import big.utils.composite: Attribute, Component, Composite;
import checkit.assertion;
import checkit.bdd;

class ConfigServiceMock: ConfigService
{
  public:
    override void subscribe(string name, ConfigHandler handler, InitPriority priority)
    { 
      _handler = handler;
      _name = name;
      _priority = priority;
    }
    
    ConfigHandler _handler;
    string _name;
    InitPriority _priority;
}

unittest
{
  scenario!("UDPServerServiceInitManager should init UDPService from ConfigService", ["udp", "provider"])
  ({
    given!"ConfigService instance"
    ({
      auto config = new ConfigServiceMock;

      when!"Create UDPServerServiceInitManager"
      ({
        auto initManager = new UDPServerServiceInitManager(config);

        then!"UDPServerServiceInitManager init to ConfigService"
        ({
          config._name.shouldEqual("UDP");
          config._handler.shouldNotBeNull();
          config._priority.shouldEqual(InitPriority.NORMAL);
        });
        
        then!"UDPServerServiceInitManager init UDPServer"
        ({
          auto data = new Composite("UDP");
          data.add(new Attribute("url", "test"));
          data.add(new Attribute("host", "127.0.0.1"));
          data.add(new Attribute("port", 12000));
          config._handler([data]);
          
          auto server = udp.server().getFirstUDPServer("test");
          server.shouldBeInstanceOf!UDPServer();
          server.getHost().shouldEqual("127.0.0.1");
          server.getPort().shouldEqual(12000);
        });
        
        then!"Can't create without url"
        ({
          auto data = new Composite("UDP");
          config._handler([data]);
          udp.server().getFirstUDPServer("").shouldBeNull();
        });
      });
    });
  });
}
