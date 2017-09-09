/**
* Copyright: 2017 © LLC CERERIS
* License: MIT
* Authors: LLC CERERIS
*/

module big.router.routerservice;

import big.core.application: app;
import big.log.logservice: bigLog, LogService;
import big.utils.composite;
import std.algorithm: canFind;
import std.conv;
import std.regex: matchFirst;

///Pair from the name and middleware handler of data
struct Middleware
{
  ///Middleware name
  string middlewareName;
  ///Middleware handler
  void delegate(ref Composite) middlewareHandler;
}

///Pair from the name and target handler of data
struct Target
{
  ///Target name
  string targetName;
  ///Target handler
  void delegate(Composite) targetHandler;
}

///The structure of the route whose array is used for data routing
struct Route
{
  ///Source name (regex)
  string source;
  ///Type of request (regex)
  string type;
  ///Target name (regex)
  string target;
  ///Middleware name (regex)
  string middleware;
}

/** This service allows you to routing data by using $(D Route) structures.
* You should add targets and middlewares if you want working route service
* correctly.
*/
final class RouterService
{
  public:
    /** Main function of router service which coordinates
    * data and targets by using routes and middlewares
    */
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
      
      foreach(Route route; _routes)
      {
        string sourceRegex = route.source;
        const auto sourceMatchFirstValue = matchFirst(source, sourceRegex);
        
        string typeRegex = route.type;
        const auto typeMatchFirstValue = matchFirst(type, typeRegex);
        
        if(sourceMatchFirstValue.length == 0 || typeMatchFirstValue.length == 0)
        {
          continue;
        }
        
        string middlewareRegex = route.middleware;
        Composite middlewareComposite = data;
        if(!(middlewareRegex is null))
        {
          foreach(Middleware middleware; _middlewares)
          {
            const auto middlewareMatchFirstValue = matchFirst(middleware.middlewareName, middlewareRegex);
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
        
        string targetRegex = route.target;
        foreach(Target target; _targets)
        {
          const auto targetMatchFirstValue = matchFirst(target.targetName, targetRegex);
          if(targetMatchFirstValue.length != 0)
          {
            target.targetHandler(middlewareComposite);
          }
        }
      }
    }
    
    ///You can add middleware by using this function
    void addMiddleware(string middlewareName, void delegate(ref Composite) middlewareHandler)
    {
      Middleware newMiddleware;
      newMiddleware.middlewareName = middlewareName;
      newMiddleware.middlewareHandler = middlewareHandler;
      _middlewares ~= newMiddleware;
    }
   
    ///You can add target by using this function
    void addTarget(string targetName, void delegate(Composite) targetHandler)
    {
      Target newTarget;
      newTarget.targetName = targetName;
      newTarget.targetHandler = targetHandler;
      _targets ~= newTarget;
    }
    
    ///You can add route by using this function
    void addRoute(Route newRoute)
    {
      if(canFind(_routes, newRoute))
      {
        bigLog.warning("Attempt to insert a router with equivalent parameters was detected!." ~
          "Please, check your configuration files or code were you insert the routers. " ~
          "Routes duplicates will be ignored!");
      }
      else
      {
        _routes ~= newRoute;
      }
    }
    
    ///You can get routes by using this function
    Route[] getRoutes()
    {
      return _routes;
    }
    
  private:
    Route[] _routes;
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