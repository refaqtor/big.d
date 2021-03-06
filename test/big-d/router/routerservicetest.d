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

unittest
{
  scenario!("RouterService should route data correctly", ["router"])
  ({
    given!"Configured router service"
    ({       
      RouterService router = new RouterService();
      
      Route route = Route(r"\bsource\d*\b", r"\btype\d*\b", r"\bcustomTarget\b");
      Route copyRoute = Route(r"\bsource\d*\b", r"\btype\d*\b", r"\bcustomTarget\b");
      router.addRoute(route);
      router.addRoute(copyRoute);
      
      int expectedCount = 0; //shows how many times the function was called
      void customTarget(Composite composite)
      {
        expectedCount++;
      }
      
      router.addTarget("customTarget", toDelegate(&(customTarget)));
      
      Route[] expected = [];
      expected ~= Route(r"\bsource\d*\b", r"\btype\d*\b", r"\bcustomTarget\b");
      router.getRoutes.shouldEqual(expected);
      
      when!"Some data is created and routed"
      ({
          Composite data1 = new Composite("source1");
          data1.add(new Attribute("source", "source1"));
          data1.add(new Attribute("type", "type1"));
          data1.add(new Attribute("target", "customTarget"));
          
          Composite data2 = new Composite("source2");
          data2.add(new Attribute("source", "source2"));
          data2.add(new Attribute("type", "type2"));
          data2.add(new Attribute("target", "customTarget"));
          
          Composite data3 = new Composite("source3");
          data3.add(new Attribute("type", "type2"));
          data3.add(new Attribute("target", "customTarget"));
          
          Composite data4 = new Composite("source4");
          data4.add(new Attribute("source", "source4"));
          data4.add(new Attribute("target", "customTarget"));
          
          Composite data5 = new Composite("source5");
          data5.add(new Attribute("source", "sourceName5"));
          data5.add(new Attribute("type", "type2"));
          data5.add(new Attribute("target", "customTarget"));
          
          Composite data6 = new Composite("source6");
          data6.add(new Attribute("source", "source6"));
          data6.add(new Attribute("type", "typeName6"));
          data6.add(new Attribute("target", "customTarget"));
          
          router.process(data1);
          router.process(data2);
          router.process(data3);
          router.process(data4);
          router.process(data5);
          router.process(data6);
          
        then!"!These data correctly routed"
        ({
            expectedCount.shouldEqual(2);
        });
      });
    });
  });
  
  scenario!("RouterService should route data correctly", ["router"])
  ({
    given!"Configured router service with route which have middleware"
    ({       
      RouterService router = new RouterService();
      
      Route route = Route(r"\bsource\d*\b", r"\bDATA\b|\bPOST\b", r"\bcustomTarget\b", r"\bmiddleware\d*\b");
      router.addRoute(route);
      
      int expectedCount = 0; //shows how many times the function was called
      void customTarget(Composite composite)
      {
        expectedCount++;
      }
      router.addTarget("customTarget", toDelegate(&(customTarget)));
      
      Route[] expected = [];
      expected ~= Route(r"\bsource\d*\b", r"\bDATA\b|\bPOST\b", r"\bcustomTarget\b", r"\bmiddleware\d*\b");
      router.getRoutes.shouldEqual(expected);
      
      void customMiddleware1(ref Composite composite)
      {
        if(composite.get!Attribute("type").getValue() != "DATA")
        {
          composite = null;
        }
      }
      router.addMiddleware("middleware1", toDelegate(&(customMiddleware1)));
      
      when!"Some data is created and routed"
      ({
          Composite data1 = new Composite("source1");
          data1.add(new Attribute("source", "source1"));
          data1.add(new Attribute("type", "DATA"));
          data1.add(new Attribute("target", "customTarget"));
          
          Composite data2 = new Composite("source2");
          data2.add(new Attribute("source", "source2"));
          data2.add(new Attribute("type", "POST"));
          data2.add(new Attribute("target", "customTarget"));
          
          router.process(data1);
          router.process(data2);
          
        then!"!These data correctly routed"
        ({
            expectedCount.shouldEqual(1);
        });
      });
    });
  });
}