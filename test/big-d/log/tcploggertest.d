/**
* Copyright: 2017 © LLC CERERIS
* License: MIT
* Authors: LLC CERERIS
*/

module test.big.log.tcploggertest;

import big.log.tcplogger;
import checkit.assertion;
import checkit.bdd;
import std.datetime: DateTime, msecs;
import std.algorithm.searching: canFind;
import vibe.core.net: listenTCP;
import vibe.core.core: runEventLoop, exitEventLoop, runTask, sleep;

import std.stdio;

unittest
{
  scenario!("Success logging to TCP server", ["log"])
  ({
    given!"TCP server and TCPLogger"
    ({
      string data;

      auto server = listenTCP(32000, 
          (connection)
          { 
            try
            {
              while(!connection.empty)
              {
			          if(connection.waitForData())
                {
                  ubyte[] buffer = new ubyte[connection.leastSize];
                  connection.read(buffer);
                  data = cast(string) buffer;
			          }
              }
		        } 
            catch (Exception e)
            {}
          }, "127.0.0.1");

      TCPLogger logger = new TCPLogger("localhost", 32000);

      when!"Logging custom message"
      ({
        string expectedMessage = "Test message for logging";

        runTask({
          sleep(1.msecs);
          logger.warning(expectedMessage);
          sleep(10.msecs);
          server.stopListening();
          exitEventLoop();
        });

        runEventLoop();

        then!"TCP server receive custom message"
        ({
          (canFind(data, "[warning]")).shouldBeTrue();
          (canFind(data, expectedMessage)).shouldBeTrue();
        });
      });
    });
  });
}

unittest
{
  scenario!("Logging to reconnect TCP server", ["log"])
  ({
    given!"TCP server and TCPLogger"
    ({
      string data;
      ubyte messageCount;

      auto server = listenTCP(32002, 
          (connection)
          { 
            try
            {
              while(!connection.empty)
              {
			          if(connection.waitForData())
                {
                  ubyte[] buffer = new ubyte[connection.leastSize];
                  connection.read(buffer);
                  data = cast(string) buffer;
                  messageCount += 1;
                  connection.close();
			          }
              }
		        } 
            catch (Exception e)
            {}
          }, "127.0.0.1");

      TCPLogger logger = new TCPLogger("localhost", 32002);

      when!"Logging custom message"
      ({
        string expectedMessage = "Test message for logging";

        runTask({
          sleep(1.msecs);
          logger.warning(expectedMessage);
          sleep(10.msecs);
          logger.warning(expectedMessage);
          sleep(10.msecs);
          server.stopListening();
          exitEventLoop();
        });

        runEventLoop();

        then!"TCP server receive custom message"
        ({
          messageCount.shouldEqual(2);
          (canFind(data, "[warning]")).shouldBeTrue();
          (canFind(data, expectedMessage)).shouldBeTrue();
        });
      });
    });
  });
}

unittest
{
  scenario!("Fail logging to disable TCP server", ["log"])
  ({
    given!"TCPLogger"
    ({
      TCPLogger logger = new TCPLogger("localhost", 32001);

      when!"Logging custom message"
      ({
        string expectedMessage = "Test message for logging";

        runTask({

          then!"TCP logger not throw exception"
          ({
            logger.warning(expectedMessage).shouldNotThrow();
          });

          sleep(10.msecs);
          exitEventLoop();
        });

        runEventLoop();
      });
    });
  });
}
