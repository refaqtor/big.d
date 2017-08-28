# TCP logger example

Example logger for TCP protocol.
``` d
// TCP logger for localhost (IP 127.0.0.1) and port 35000
auto logger = new TCPLogger("localhost", 35000);
 
// Run task for logging in loop
runTask({
  // Infinity loop
  while(true)
  {
    // Log message to TCP with critical log level
    logger.critical("Info message\n");
    // Sleep 1000 msecs for low load CPU
    sleep(1000.msecs);
  }
});

// Run vibe.d application
return runApplication();

```

### Run
First, you need to start the TCP server on port 35000. For example:
``` bash
socat TCP-LISTEN:35000 STDOUT
```

Then run the example:

``` bash
dub
```

Output for socat:
``` bash
2017-08-28T02:17:42.305 [critical] Info message
2017-08-28T02:17:43.307 [critical] Info message
2017-08-28T02:17:44.308 [critical] Info message
2017-08-28T02:17:45.309 [critical] Info message
2017-08-28T02:17:46.311 [critical] Info message
2017-08-28T02:17:47.312 [critical] Info message
2017-08-28T02:17:48.313 [critical] Info message
2017-08-28T02:17:49.315 [critical] Info message

```

### Dependencies
* [vibe-d:core] - Basic I/O and concurrency primitives, as well as low level utility functions
* [big-d:log] - Logging system for big.d


  [vibe-d:core]: <http://vibed.org/>
  [big-d:log]: <http://vibed.org/>

### Documentation
The documentation is generated automatically (ddox) and is accessible by reference [documentation API](https://llc-cereris.github.io/big.d/big/log/tcplogger/TCPLogger.html)

### License
MIT
