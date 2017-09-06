/**
* Copyright: 2017 © LLC CERERIS
* License: MIT
* Authors: LLC CERERIS
*/

module big.router.routerservice;

import big.utils.composite;
import big.log.logservice: bigLog, LogService;

struct Target
{
  string targetName;
  void delegate(Composite) targetHandler;
}

struct Rout
{
  string source;
  string type;
  Target target;
  Middleware middleware;
}

class RouterService
{
  public:
    this()
    {
    
    }
    
    void routing(Composite data)
    {
      Component sourceComponent = data.get!Component("sourceName");
      string source;
      
      // obtaining a source name...
      if(sourceComponent is null)
      {
        bigLog.warning("You can't route data for which no source is specified");
      }
      else
      {
        if(sourceComponent.isComposite())
        {
          bigLog.warning("You can't route data with composite source");
          return;
        }
        else
        {
          try
          {
            source = (cast(Attribute) sourceComponent).getValue();
          }
          catch(Exception e)
          {
            bigLog.warning(e.msg);
          }
          return;
        }
      }
      
      foreach(Rout rout; _routs)
      {
        
      }
    }
    
  private:
    Rout[] _routs;  
}