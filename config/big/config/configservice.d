/**
* Copyright: 2017 © LLC CERERIS
* License: MIT
* Authors: LLC CERERIS
*/

module big.config.configservice;

import big.config.yamlconfigreader;
import big.utils.bigdexception;
import big.utils.composite;
import std.file;

/// The structure representing the service
struct SubscribeStructure
{
  /// Array of composite elements witch used as parameter for init service function
  Composite[] config;
  
  /// Init service function
  void delegate(Composite[]) initService;
}

/** 
* Service used to convert configuration files to an array of composite 
* objects and call the service initialization function
*/
class ConfigService
{
  public:
    /// A constructor for the $(D ConfigService).
    this()
    {
      _yamlConfigReader = new YamlConfigReader;
    }
    
    /** This method allows services to subscribe to receive configs
    Params:
      name = The name of service (By this name configurations
             in configuration files will be searched)
    */
    void subscribe(string name, void delegate(Composite[]) initService)
    {
      foreach(key, value; _subscribes)
      {
        if(key == name)
        {
          throw new BigDException("All services must have unique names");
        }
      }
      
      SubscribeStructure newSubscribe;
      
      newSubscribe.config = [];
      newSubscribe.initService = initService;
      
      _subscribes[name] = newSubscribe;
    }
    
    /** This method reads all the configs for all services in the specified directory
    Params:
      path = Directory to find configs
    */
    void load(in string path)
    {
      string[] arrayOfServiceNames;
      foreach(key, value; _subscribes)
      {
        arrayOfServiceNames ~= key;
      }
      
      foreach (string yamlConfigPath; dirEntries(path, "*.yaml",SpanMode.depth))
      {
        Composite[][string] configFromOneFile;
        configFromOneFile = _yamlConfigReader.readConfig(yamlConfigPath, arrayOfServiceNames);
        foreach(key, value; configFromOneFile)
        {
          if(key in _subscribes)
          {
            _subscribes[key].config ~= value;
          }
        }
      }
      
      //Here you can implement config readers for other formats, for example json...
      
      foreach(SubscribeStructure subscribe; _subscribes)
      {
        subscribe.initService(subscribe.config);
      }
    }
  
  private:
    SubscribeStructure[string] _subscribes;
    YamlConfigReader _yamlConfigReader;
}