/**
* Copyright: 2017 © LLC CERERIS
* License: MIT
* Authors: LLC CERERIS
*/

module test.big.router.routerservicetest;

import big.config.configservice: ConfigService;
import big.router.routerserviceinitmanager;
import big.router.routerservice;
import big.utils.composite;
import std.functional;
import checkit;

//// If you want use custom middleware for router service,
//// you should create and register it in router service.
//
//// Examples of custom middlewares...
//void customMiddlewareHandler(ref Composite)
//{
//
//}

void everySourceAndTypeHandler(Composite composite)
{
  import std.stdio;
  writeln(composite.get!Attribute("source").getValue());
}

unittest
{
  scenario!("RouterService should rout data correctly", ["router"])
  ({
    given!"Configured router service"
    ({       
      RouterService router = new RouterService();
      
      Rout rout = Rout(r"\bsource\d*\b", r"\btype\d*\b", r"everySourceAndTypeTarget");
      router.addRout(rout);
      
      router.addTarget("everySourceAndTypeTarget", toDelegate(&(everySourceAndTypeHandler)));
      
      when!"Create RouterServiceInitManager"
      ({
        then!"!!!!!!!!!!"
        ({
            Rout[] expected = [];
            expected ~= Rout(r"\bsource\d*\b", r"\btype\d*\b", r"everySourceAndTypeTarget");
            
            router.getRouts.shouldEqual(expected);
            
            Composite data1 = new Composite("source11");
            data1.add(new Attribute("source", "source1"));
            data1.add(new Attribute("type", "type1"));
            data1.add(new Attribute("target", "everySourceAndTypeTarget"));
            
            Composite data2 = new Composite("source22");
            data2.add(new Attribute("source", "source2"));
            data2.add(new Attribute("type", "type2"));
            data2.add(new Attribute("target", "everySourceAndTypeTarget"));
            
            router.process(data1);
            router.process(data2);
        });
      });
    });
  });
}