/**
* Copyright: 2017 © LLC CERERIS
* License: MIT
* Authors: LLC CERERIS
*/

module test.big.log.udploggertest;

import big.log.udplogger;
import checkit.assertion;
import checkit.bdd;
import std.datetime: DateTime, msecs;
import std.algorithm.searching: canFind;
import vibe.core.net: listenUDP;
import vibe.core.core: runEventLoop, exitEventLoop, runTask, sleep;

import std.stdio;

unittest
{
  scenario!("Success logging to UDP server", ["log"])
  ({
    given!"UDP server and UDPLogger"
    ({
      string data;

      auto server = listenUDP(31000);
      runTask({
        while(true)
        {
			    data = cast(string) server.recv();
		    }
      });

      UDPLogger logger = new UDPLogger("127.0.0.1", 31000);

      when!"Logging custom message"
      ({
        string expectedMessage = "Test message for logging";

        runTask({
          sleep(10.msecs);
          logger.warning(expectedMessage);
          sleep(100.msecs);
          exitEventLoop();
          
          then!"UDP server receive custom message"
          ({
            (canFind(data, "[warning]")).shouldBeTrue();
            (canFind(data, expectedMessage)).shouldBeTrue();
          });
        });

        runEventLoop();
      });
    });
  });
}

unittest
{
  scenario!("Logging to reconnect UDP server", ["log"])
  ({
    given!"UDP server and UDPLogger"
    ({
      string data;
      ubyte messageCount;

      runTask({
        sleep(1.msecs);
        auto server = listenUDP(31001);
        while(true)
        {
			    data = cast(string) server.recv();
          messageCount += 1;
		    }
      });

      UDPLogger logger = new UDPLogger("127.0.0.1", 31001);

      when!"Logging custom message"
      ({
        string expectedMessage = "Test message for logging";

        runTask({
          logger.warning(expectedMessage);
          sleep(100.msecs);
          logger.warning(expectedMessage);
          sleep(100.msecs);
          exitEventLoop();

          then!"UDP server receive custom message"
          ({
            messageCount.shouldEqual(1);
            (canFind(data, "[warning]")).shouldBeTrue();
            (canFind(data, expectedMessage)).shouldBeTrue();
          });
        });

        runEventLoop();
      });
    });
  });
}

unittest
{
  scenario!("Fail logging to disable UDP server", ["log"])
  ({
    given!"UDPLogger"
    ({
      UDPLogger logger = new UDPLogger("127.0.0.1", 31055);

      when!"Logging custom message"
      ({
        string expectedMessage = "Test message for logging";

        runTask({
          then!"UDP logger not throw exception"
          ({
            logger.warning(expectedMessage).shouldNotThrow();
          });

          sleep(100.msecs);
          exitEventLoop();
        });

        runEventLoop();
      });
    });
  });
}
