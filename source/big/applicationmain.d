/**
* Copyright: 2017 © LLC CERERIS
* License: MIT
* Authors: LLC CERERIS
*/

module big.applicationmain;

import big.core.application: app, Application;
import big.log.logservice: bigLog, LogService;
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
    auto logService = new LogService();
    app().register(logService, LogServiceType.BIG_D);
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
      bigLog().trace("Run vibe.d event loop");
      exitStatus = runEventLoop();
    }
    catch(Exception e)
    {
      bigLog().critical("Vibe.d event loop exception: " ~ e.msg);
    }

    bigLog().critical("Stop big.d application");
    return exitStatus;
  }
}
