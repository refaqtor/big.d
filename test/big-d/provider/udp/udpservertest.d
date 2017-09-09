/**
* Copyright: 2017 © LLC CERERIS
* License: MIT
* Authors: LLC CERERIS
*/

module test.big.provider.udpservertest;

import std.datetime: msecs;
import big.provider.udp;
import checkit.assertion;
import checkit.bdd;
import std.functional: toDelegate;
import vibe.core.net: NetworkAddress, listenUDP, resolveHost;
import vibe.core.core: runEventLoop, exitEventLoop, runTask, sleep;

unittest
{
  scenario!("Handle UDP packet", ["provider", "udp"])
  ({
    given!"UDPServer"
    ({
      ubyte[] data;
      NetworkAddress address;
      
      void handle(ubyte[] data_, NetworkAddress address_)
      {
        data = data_;
        address = address_;
      }
        
      auto server = new UDPServer("127.0.0.1", 29000, toDelegate(&handle));
      server.start();

      when!"Send data"
      ({
        auto client = listenUDP(0);
        auto address = resolveHost("127.0.0.1");
        address.port = 29000;
        client.send(cast(ubyte[]) "TestPacket", &address);
        
        runTask({
          sleep(100.msecs);
          exitEventLoop();
          
          then!"UDPServer succes get by name"
          ({
            data.shouldEqual("TestPacket");
            address.port.shouldEqual(29000);
            address.toAddressString.shouldEqual("127.0.0.1");
          });
        });

        runEventLoop();
      });
    });
  });
}
