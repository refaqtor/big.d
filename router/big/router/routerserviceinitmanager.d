/**
* Copyright: 2017 © LLC CERERIS
* License: MIT
* Authors: LLC CERERIS
*/

module big.router.routerserviceinitmanager;

import big.config.configservice: config, ConfigService;
import std.functional: toDelegate;
import big.utils.composite;
import big.router.routerservice: routerService, Rout;
import big.log.logservice: bigLog;

enum
{
  /// String name for load from config file
  ROUT_CONFIG_TYPE = "Rout",
  ROUT_SOURCE = "source",
  ROUT_TYPE = "type",
  ROUT_TARGET = "target",
  ROUT_MIDDLEWARE = "middleware"
}

/// Provide init router system
final class RouterServiceInitManager
{
  public:
    /// A constructor for the $(D RouterServiceInitManager)
    this(ConfigService service = config())
    {
      service.subscribe(ROUT_CONFIG_TYPE, toDelegate(&init));
    }
    
  private:
    /** Init RouterServise from configuration
    * Params:
    *		configs = All configuration data for RouterServise
    */
    void init(Composite[] configs)
    {      
      foreach(Composite routerConfig; configs)
      {
        auto sourceAttribute = routerConfig.get!Attribute(ROUT_SOURCE);
        string source;
        if(sourceAttribute is null)
        {
          bigLog.warning("Rout without 'source' will be ignored! Check your config!");
          continue;
        }
        else
        {
          source = sourceAttribute.getValue().get!string();
        }
        
        auto typeAttribute = routerConfig.get!Attribute(ROUT_TYPE);
        string type;
        if(typeAttribute is null)
        {
          bigLog.warning("Rout without 'type' will be ignored! Check your config!");
          continue;
        }
        else
        {
          type = typeAttribute.getValue().get!string();
        }
        
        auto targetAttribute = routerConfig.get!Attribute(ROUT_TARGET);
        string target;
        if(targetAttribute is null)
        {
          bigLog.warning("Rout without 'target' will be ignored! Check your config!");
          continue;
        }
        else
        {
          target = targetAttribute.getValue().get!string();
        }
        
        auto middlewareAttribute = routerConfig.get!Attribute(ROUT_MIDDLEWARE);
        string middleware = null;
        if(!(middlewareAttribute is null))
        {
          middleware = middlewareAttribute.getValue().get!string();
        }
        
        Rout newRout;
        newRout.source = source;
        newRout.type = type;
        newRout.target = target;
        newRout.middleware = middleware;
        
        routerService.insertRout(newRout);
      }
    }    
}