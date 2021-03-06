/**
* Copyright: 2017 © LLC CERERIS
* License: MIT
* Authors: LLC CERERIS
*/

module test.big.log.configservicetest;

import big.config.configservice;
import big.utils.composite;
import checkit;
import std.functional;

class CustomService
{
  public:
    this()
    {
      field1 = "default string";
      field2 = 0;
      field3 = false;
    }
    
    void init(Composite[] config)
    {     
      foreach(Composite composite; config)
      {
        if(composite.get!Attribute("field1").getValue == "Some string")
        {
          field1 = "Some string";
        }
        if(composite.get!Attribute("field2").getValue == 2)
        {
          field2 = 2;
        }
        if(composite.get!Attribute("field3").getValue == true)
        {
          field3 = true;
        }
      }
    }
    
    string field1;
    int field2;
    bool field3;
}

unittest
{
  scenario!("Get config", ["config"])
  ({
      given!"Config service with registered custom service, custom service and config path"
      ({
          auto configService = new ConfigService();
          CustomService customService = new CustomService;
          configService.subscribe("CustomService", toDelegate(&(customService.init)));
          string configPath = "test/big-d/config/testConfigDirectory2";

          when!"Called a function 'load'"
          ({
              configService.load(configPath);

              then!"Get the correct initialized service"
              ({
                  customService.field1.shouldEqual("Some string");
                  customService.field2.shouldEqual(2);
                  customService.field3.shouldBeFalse();
              });
          });
          
          when!"Get default ConfigService"
          ({
              then!"Get the correct initialized service"
              ({
                  config().shouldNotBeNull();
                  config().shouldBeInstanceOf!ConfigService();
              });
          });
      });
  }); 
}