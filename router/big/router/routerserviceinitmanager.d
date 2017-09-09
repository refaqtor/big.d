/**
* Copyright: 2017 © LLC CERERIS
* License: MIT
* Authors: LLC CERERIS
*/

module big.router.routerserviceinitmanager;

import big.config.configservice: config, ConfigService;
import big.log.logservice: bigLog;
import big.router.routerservice: Route, routerService;
import big.utils.composite;
import std.functional: toDelegate;

enum
{
  /// String name for load from config file
  ROUTE_CONFIG_TYPE = "Rout",
  /// String name of source defenition
  ROUTE_SOURCE = "source",
  /// String name of type defenition
  ROUTE_TYPE = "type",
  /// String name of target defenition
  ROUTE_TARGET = "target",
  /// String name of middleware defenition
  ROUTE_MIDDLEWARE = "middleware"
}

/// Provide init router system
final class RouterServiceInitManager
{
  public:
    /// A constructor for the $(D RouterServiceInitManager)
    this(ConfigService service = config())
    {
      service.subscribe(ROUTE_CONFIG_TYPE, toDelegate(&initRouterService));
    }
    
  private:
    /** Init RouterServise from configuration
    * Params:
    *		configs = All configuration data for RouterServise
    */
    void initRouterService(Composite[] configs)
    {      
      foreach(Composite routerConfig; configs)
      {
        auto sourceAttribute = routerConfig.get!Attribute(ROUTE_SOURCE);
        string source;
        if(sourceAttribute is null)
        {
          bigLog.warning("Route without 'source' will be ignored! Check your config!");
          continue;
        }
        else
        {
          source = sourceAttribute.getValue().get!string();
        }
        
        auto typeAttribute = routerConfig.get!Attribute(ROUTE_TYPE);
        string type;
        if(typeAttribute is null)
        {
          bigLog.warning("Route without 'type' will be ignored! Check your config!");
          continue;
        }
        else
        {
          type = typeAttribute.getValue().get!string();
        }
        
        auto targetAttribute = routerConfig.get!Attribute(ROUTE_TARGET);
        string target;
        if(targetAttribute is null)
        {
          bigLog.warning("Route without 'target' will be ignored! Check your config!");
          continue;
        }
        else
        {
          target = targetAttribute.getValue().get!string();
        }
        
        auto middlewareAttribute = routerConfig.get!Attribute(ROUTE_MIDDLEWARE);
        string middleware = null;
        if(!(middlewareAttribute is null))
        {
          middleware = middlewareAttribute.getValue().get!string();
        }
        
        Route newRoute;
        newRoute.source = source;
        newRoute.type = type;
        newRoute.target = target;
        newRoute.middleware = middleware;
        
        routerService.addRoute(newRoute);
      }
    }    
}