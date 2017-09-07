/**
* Copyright: 2017 © LLC CERERIS
* License: MIT
* Authors: LLC CERERIS
*/

module big.applicationmain;

import big.config.configservice: config;
import big.core.application: app, Application;
import big.log.logservice: bigLog, LogService;
import big.log.logserviceinitmanager: LogServiceInitManager;
import big.log.logservicetype: LogServiceType;
import vibe.core.core: lowerPrivileges, runEventLoop;

version (BigCustomMain)
{
  /// main function exist
}
else
{
  static this()
  {
    /// LogService for logging big.d messages
    auto innerLogService = new LogService();
    app().register(innerLogService, LogServiceType.BIG_D);
    
    /// Init LogServiceInitManager
    auto logServiceInitManager = new LogServiceInitManager;
  }

  /// main function for run big.d framework
  int main(string[] args)
  {
    bigLog().info("Run big.d application");
    int exitStatus;

    bigLog().trace("Lower privileges for user and group (vibe.d)");
    lowerPrivileges();

    try
    {
      /// Load config files
      config().load("./config");
      
      bigLog().trace("Run vibe.d event loop");
      exitStatus = runEventLoop();
    }
    catch(Exception e)
    {
      bigLog().critical("Vibe.d event loop exception: " ~ e.msg);
    }

    bigLog().info("Stop big.d application");
    return exitStatus;
  }
}
