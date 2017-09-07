/**
* Copyright: 2017 © LLC CERERIS
* License: MIT
* Authors: LLC CERERIS
*/

module big.config.configservice;

import big.core.application: app;
import big.config.yamlconfigreader;
import big.utils.bigdexception;
import big.utils.composite;
import std.file;

/** 
* Service used to convert configuration files to an array of composite 
* objects and call the service initialization function
*/
class ConfigService
{
  public:
    alias ConfigHandler = void delegate(Composite[]);
  
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
    void subscribe(string name, void delegate(Composite[]) handler)
    { 
      _handlersMap[name] ~= handler;
      _configDataMap[name] = [];
    }
    
    /** This method reads all the configs for all services in the specified directory
    Params:
      path = Directory to find configs
    */
    void load(in string path)
    {
      string[] arrayOfServiceNames;
      
      foreach(key, value; _handlersMap)
      {
        arrayOfServiceNames ~= key;
      }
      
      foreach (string yamlConfigPath; dirEntries(path, "*.yaml",SpanMode.depth))
      {
        Composite[][string] configFromOneFile;
        configFromOneFile = _yamlConfigReader.readConfig(yamlConfigPath, arrayOfServiceNames);
        
        foreach(key, value; configFromOneFile)
        {
          if(key in _handlersMap)
          {
             _configDataMap[key] ~= value;
          }
        }
      }
      
      /// TODO: Here you can implement config readers for other formats, for example json...
      
      foreach(key, value; _handlersMap)
      {
        foreach(handler; value)
        {
          handler(_configDataMap[key]);
        }
      }
      
      _configDataMap.clear();
    }
  
  private:
    /// Associative array of array config handlers
    ConfigHandler[][string] _handlersMap;
    /// Associative array of array Composite for invoke config handler
    Composite[][string] _configDataMap;
    /// Provide YAML config reader
    YamlConfigReader _yamlConfigReader;
}

/// Return ConfigService instance (syntactic sugar).
static ConfigService config()
{
  return app().get!ConfigService();
}

/// Register ConfigService
static this()
{
  auto configService = new ConfigService();
  app().register(configService);
}