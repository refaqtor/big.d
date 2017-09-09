/**
* Copyright: 2017 © LLC CERERIS
* License: MIT
* Authors: LLC CERERIS
*/

module test.big.provider.udpserverservicetest;

import big.core.application: app;
import big.provider.udp;
import checkit.assertion;
import checkit.bdd;
import std.functional: toDelegate;
import vibe.core.net: NetworkAddress;

class TestUDPServer: UDPServer
{
  public:
    this(in string host, in ushort port)
    {
      super(host, port, toDelegate(&handle));
    }
    
  private:
    void handle(ubyte[] data, NetworkAddress address)
    {}
}

unittest
{
  scenario!("Insert server by name", ["provider", "udp"])
  ({
    given!"Empty UDPServerService"
    ({
      auto service = new UDPServerService();

      when!"Add many udp servers"
      ({
        auto firstUDPServer = new TestUDPServer("1", 3);
        auto secondUDPServer = new TestUDPServer("2", 4);
        service.insertUDPServer("FirstUDPServer", firstUDPServer);
        service.insertUDPServer("SecondUDPServer", secondUDPServer);

        then!"UDPServer succes get by name"
        ({
          service.getFirstUDPServer("FirstUDPServer").shouldBeInstanceOf!TestUDPServer();
          service.getFirstUDPServer("FirstUDPServer").getHost().shouldEqual("1");
          service.getFirstUDPServer("FirstUDPServer").getPort().shouldEqual(3);
          service.getFirstUDPServer("SecondUDPServer").shouldBeInstanceOf!TestUDPServer();
          service.getFirstUDPServer("SecondUDPServer").getHost().shouldEqual("2");
          service.getFirstUDPServer("SecondUDPServer").getPort().shouldEqual(4);
        });
      });
    });
  });

  scenario!("Get a nonexistent udp server by name", ["provider", "udp"])
  ({
    given!"Empty UDPServerService"
    ({
      auto service = new UDPServerService();

      when!"Try get nonexistent udp server"
      ({
        then!"Get null value"
        ({
          service.getFirstUDPServer("nonexistent").shouldBeNull();
        });
      });
    });
  });
  
  scenario!("Remove udp server by name", ["provider", "udp"])
  ({
    given!"Not empty UDPServerService"
    ({
      auto service = new UDPServerService();
      auto server = new TestUDPServer("test", 11, );
      service.insertUDPServer("Server", server);

      when!"Remove udp server"
      ({
        service.removeUDPServer("Server").shouldNotBeNull();
          
        then!"After get null value"
        ({
          service.getFirstUDPServer("Server").shouldBeNull();
        });
      });
      
      when!"Remove exist udp server"
      ({
        then!"Get null value"
        ({
          service.removeUDPServer("Server1111").shouldBeNull();
        });
      });
    });
  });

  scenario!("Use syntactic sugar", ["provider", "udp"])
  ({
    given!"Default UDPServerService"
    ({
      auto service = new UDPServerService();

      when!"Register UDPServerService"
      ({
        app().register(service);

        then!"Get default UDPServerService with syntactic sugar"
        ({
          udp.server().shouldBeInstanceOf!UDPServerService();
        });
      });
    });
  });
}
