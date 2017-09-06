/**
* Copyright: 2017 © LLC CERERIS
* License: MIT
* Authors: LLC CERERIS
*/

module test.big.log.yamlconfigreadertest;

import big.config.yamlconfigreader;
import big.utils.composite;
import checkit;

unittest
{
  scenario!("Get correct composite objects from yaml file", ["config"])
  ({
      given!"input yaml file, yaml config reader and array of service names"
      ({
          YamlConfigReader yamlConfigReader = new YamlConfigReader;
          string yamlFilePath = "test/big-d/config/testConfigDirectory1/input1.yaml";
          string[] arrayOfServiceNames = [
            "service1",
            "service2",
            "service3",
            "service4",
            "service5",
            "service6",
            "service7",
          ];

          when!"Called a function 'readConfig' for array of service names"
          ({
              Composite[][string] got = yamlConfigReader.readConfig(yamlFilePath, arrayOfServiceNames);

              then!"Get the correct configs for each service"
              ({
                  got["service1"].length.shouldEqual(1);
                  got["service2"].length.shouldEqual(1);
                  got["service3"].length.shouldEqual(1);
                  got["service4"].length.shouldEqual(1);
                  got["service5"].length.shouldEqual(1);
                  got["service6"].length.shouldEqual(1);
                  got["service7"].length.shouldEqual(2);
                  
                  got["service1"][0].getName.shouldEqual("service1");
                  got["service1"][0].get!Attribute("field1").getValue.shouldEqual(null);
                  
                  got["service2"][0].getName.shouldEqual("service2");
                  got["service2"][0].get!Attribute("field1").getValue.shouldEqual(1);
                  got["service2"][0].get!Attribute("field2").getValue.shouldEqual(2);
                  
                  got["service3"][0].getName.shouldEqual("service3");
                  got["service3"][0].get!Attribute("field1").getValue.shouldEqual(null);
                  
                  got["service4"][0].getName.shouldEqual("service4");
                  got["service4"][0].get!Attribute("field1").getValue.shouldEqual(null);
                  
                  got["service5"][0].getName.shouldEqual("service5");
                  got["service5"][0].get!Attribute("field1").getValue.shouldEqual(null);
                  got["service5"][0].get!Attribute("field2").getValue.shouldEqual(null);
                  got["service5"][0].get!Attribute("field3").getValue.shouldEqual(null);
                  got["service5"][0].get!Attribute("field4").getValue.shouldEqual(null);
                  
                  got["service6"][0].getName.shouldEqual("service6");
                  got["service6"][0].get!Attribute("field1").getValue.shouldEqual(1);
                  got["service6"][0].get!Component("field2").isComposite.shouldBeTrue;
                  got["service6"][0].get!Composite("field2").get!Attribute("subField1").getValue.shouldEqual(1);
                  got["service6"][0].get!Composite("field2").get!Attribute("subField2").getValue.shouldEqual(null);
                  
                  got["service7"][0].getName.shouldEqual("service7");
                  got["service7"][1].getName.shouldEqual("service7");
                  got["service7"][0].get!Attribute("field1").getValue.shouldEqual(1);
                  got["service7"][1].get!Attribute("field1").getValue.shouldEqual(2);
              });
          });
      });
  });
  
  scenario!("Get correct composite object from yaml file with values of different types", ["config"])
  ({
      given!"input yaml file, yaml config reader and name of service"
      ({
          YamlConfigReader yamlConfigReader = new YamlConfigReader;
          string yamlFilePath = "test/big-d/config/testConfigDirectory1/input2.yaml";
          string serviceName = "service8";

          when!"Called a function 'readConfig' for given service name"
          ({
              Composite[][string] got = yamlConfigReader.readConfig(yamlFilePath, [serviceName]);

              then!"Get the correct config with values of different types"
              ({
                  got["service8"][0].get!Attribute("long").getValue.shouldEqual(1);
                  got["service8"][0].get!Attribute("string").getValue.shouldEqual("two");
                  got["service8"][0].get!Attribute("bool").getValue.shouldEqual(true);
                  got["service8"][0].get!Attribute("real").getValue.shouldBeBetween(1, 2);
              });
          });
      });
  });
  
  scenario!("Parse incorrect yaml file", ["config"])
  ({
      given!"input incorrect yaml file, yaml config reader and name of service"
      ({
          YamlConfigReader yamlConfigReader = new YamlConfigReader;
          string yamlFilePath = "test/big-d/config/testConfigDirectory1/input3.yaml";
          string serviceName = "service1";

          when!"Called a function 'readConfig' for given service name"
          ({
              then!"Get exception"
              ({
                  (yamlConfigReader.readConfig(yamlFilePath, [serviceName])).shouldThrowWithMessage(
                      "In some configuration file an unknown type is used! Please use only the " ~
                      "following types in the configuration files: int, float, bool or string");
              });
          });
      });
  });  
}