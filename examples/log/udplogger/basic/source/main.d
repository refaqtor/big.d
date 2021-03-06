/**
* Copyright: 2017 © LLC CERERIS
* License: MIT
* Authors: LLC CERERIS
*/

import big.log.udplogger: UDPLogger;
import vibe.core.core: runApplication, runTask, sleep;
import std.datetime: msecs;

// main function
int main()
{
  // UDP logger for localhost (IP 127.0.0.1) and port 35000
  auto logger = new UDPLogger("localhost", 35000);
 
  // Run task for logging in loop
  runTask({
    // Infinity loop
    while(true)
    {
      // Log message to UDP with critical log level
      logger.critical("Info message\n");
      // Sleep 1000 msecs for low load CPU
      sleep(1000.msecs);
    }
  });

  // Run vibe.d application
  return runApplication();
}
