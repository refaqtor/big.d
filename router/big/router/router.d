/**
* Copyright: 2017 © LLC CERERIS
* License: MIT
* Authors: LLC CERERIS
*/

module big.router.router;

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
  string[] targets;
  Middleware middleware;
}

class Router
{
  public:
    this()
    {
    
    }
    
    void routing(Composite data)
    {
      string source;
      if((source = getSourceNameFromData(data.get!Component("sourceName"))) is null)
      {
        return;
      }
      
      foreach(Rout rout; _routs)
      {
        if(rout.source == source)
        {
          //middleware...
          foreach(string targetName; rout.targets)
          {
            if(targetName == "*") //send data for all targets...
            {
              foreach(Target target; _targets)
              {
                target.targetHandler(data);
              }
            }
            else //send data for the specified targets...
            {
              foreach(Target target; _targets)
              {
                if(targetName == target.name)
                {
                  target.targetHandler(data);
                }
              }
            }
          }
        }
      }
    }
    
    void addTarget(string targetName, void delegate(Composite) targetHandler)
    {
      Target newTarget;
      newTarget.name = targetName;
      newTarget.targetHandler = targetHandler;
      _targets ~= newTarget;
    }
    
    void addRout(string sourceName, string[] targets, Middleware middleware)
    {
      Rout newRout;
      newRout.name = sourceName;
      newRout.targets = targets;
      newRout.middleware = middleware;
      _routs ~= newRout;
    }
    
  private:
    Rout[] _routs;
    Target[] _targets;
    
    string getSourceNameFromData(Component data)
    {
      string result = null;
      if(data is null)
      {
        bigLog.warning("You can't route data for which no source is specified");
        return result;
      }
      else
      {
        if(data.isComposite())
        {
          bigLog.warning("You can't route data with composite source");
          return result;
        }
        else
        {
          try
          {
            result = (to!Attribute(sourceComponent)).getValue();
          }
          catch(Exception e)
          {
            bigLog.warning(e.msg);
          }
          return result;
        }
      }
    }
}