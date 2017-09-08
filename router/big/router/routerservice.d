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
  void delegate(ref Composite) middlewareHandler;
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
    
    void process(Composite data)
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
      
      auto typeAttribute = data.get!Attribute("type");
      string type;
      if(typeAttribute is null)
      {
        bigLog.warning("Data without type can't be routed!");
        return;
      }
      else
      {
        type = typeAttribute.getValue().get!string();
      }
      
      foreach(Rout rout; _routs)
      {
        string sourceRegex = rout.source;
        auto sourceMatchFirstValue = matchFirst(source, sourceRegex);
        
        string typeRegex = rout.type;
        auto typeMatchFirstValue = matchFirst(type, typeRegex);
        
        if(sourceMatchFirstValue.length == 0 || typeMatchFirstValue.length == 0)
        {
          return;
        }
        
        string middlewareRegex = rout.middleware;
        Composite middlewareComposite = data;
        if(!(middlewareRegex is null))
        {
          foreach(Middleware middleware; _middlewares)
          {
            auto middlewareMatchFirstValue = matchFirst(middleware.middlewareName, middlewareRegex);
            if(middlewareMatchFirstValue.length != 0)
            {
              bigLog.trace("Sending data '" ~ middlewareComposite.toString ~ "' to middleware with name '" ~
                middleware.middlewareName ~ "'");
              middleware.middlewareHandler(middlewareComposite);
              if(middlewareComposite is null)
              {
                bigLog.warning("Data has not passed the middleware check with the name '" ~
                  middleware.middlewareName ~ "'! Data will not be sent to any targets");
                return;
              }
              bigLog.trace("Middleware check wiht name '" ~ middleware.middlewareName ~ "' it's ok!");
            }
          }
          bigLog.trace("All middleware checks were successful!");
        }
        
        string targetRegex = rout.target;
        foreach(Target target; _targets)
        {
          auto targetMatchFirstValue = matchFirst(target.targetName, targetRegex);
          if(targetMatchFirstValue.length != 0)
          {
            target.targetHandler(middlewareComposite);
          }
        }
      }
    }

    void addMiddleware(string middlewareName, void delegate(ref Composite) middlewareHandler)
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
    
    void addRout(Rout newRout)
    {
      if(canFind(_routs, newRout))
      {
        bigLog.warning("Attempt to insert a router with equivalent parameters was detected!." ~
          "Please, check your configuration files or code were you insert the routers. " ~
          "Routs duplicates will be ignored!");
      }
      else
      {
        _routs ~= newRout;
      }
    }
    
    Rout[] getRouts()
    {
      return _routs;
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