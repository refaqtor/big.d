# TCP logger example for logstash

Example TCP logger for logstash tcp input.
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
First, you need to start logshash. For example:
``` bash
logstash -f logstash.conf
```

Then run the example:

``` bash
dub
```

Output:
``` json
{"@timestamp":"2017-08-28T01:10:58.813Z","level":"critical","@version":"1","host":"127.0.0.1","time":"2017-08-28T04:10:58.811","message":"Info message\n","type":"bigd"}
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
