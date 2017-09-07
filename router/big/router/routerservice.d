/**
* Copyright: 2017 © LLC CERERIS
* License: MIT
* Authors: LLC CERERIS
*/

module big.router.routerservice;

import big.utils.composite;
import big.log.logservice: bigLog, LogService;
import std.conv;
import std.algorithm: canFind;
import big.core.application: app;
import std.regex: matchFirst;

struct Middleware
{
  string middlewareName;
  Composite delegate(Composite) middlewareHandler;
}

struct Target
{
  string targetName;
  void delegate(Composite) targetHandler;
}

struct Rout
{
  string source;
  string type;
  string target;
  string middleware;
}

class RouterService
{
  public:
    this()
    {
    
    }
    
    void routing(Composite data)
    {
      auto sourceAttribute = data.get!Attribute("source");
      string source;
      if(sourceAttribute is null)
      {
        bigLog.warning("Data without source can't be routed!");
        return;
      }
      else
      {
        source = sourceAttribute.getValue().get!string();
      }
      
      foreach(Rout rout; _routs)
      {
//        auto  = matchFirst("a = 42;", regex(`(?P<var>\w+)\s*=\s*(?P<value>\d+);`));
      }
    }

    void addMiddleware(string middlewareName, Composite delegate(Composite) middlewareHandler)
    {
      Middleware newMiddleware;
      newMiddleware.middlewareName = middlewareName;
      newMiddleware.middlewareHandler = middlewareHandler;
      _middlewares ~= newMiddleware;
    }
   
    void addTarget(string targetName, void delegate(Composite) targetHandler)
    {
      Target newTarget;
      newTarget.targetName = targetName;
      newTarget.targetHandler = targetHandler;
      _targets ~= newTarget;
    }
    
    void insertRout(Rout newRout)
    {
      if(canFind(_routs, newRout))
      {
        bigLog.warning("Several equivalent routs were found in the configuration files!" ~
          "Routs duplicates will be ignored!");
      }
      else
      {
        _routs ~= newRout;
      }
    }
    
  private:
    Rout[] _routs;
    Target[] _targets;
    Middleware[] _middlewares;
}

/** Return RouterService instance for big.d (syntactic sugar).
* See_Also:
*   `big.core.application.app`
*/
static RouterService routerService()
{
  return app().get!RouterService();
}

/// Register default RouterService
static this()
{
  auto routerService = new RouterService();
  app().register(routerService);
}