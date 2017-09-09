/**
* Copyright: 2017 © LLC CERERIS
* License: MIT
* Authors: LLC CERERIS
*/

module test.big.router.routerserviceinitmanagertest;

import big.config.configservice: ConfigService;
import big.router.routerservice;
import big.router.routerserviceinitmanager;
import checkit;

unittest
{
  scenario!("RouterServiceInitManager should init RouterService from ConfigService", ["router"])
  ({
    given!"ConfigService instance"
    ({
      auto config = new ConfigService;

      when!"Create RouterServiceInitManager"
      ({
        auto initManager = new RouterServiceInitManager(config);
        
        then!"RouterServiceInitManager init RouterService"
        ({
            config.load("test/big-d/router/testConfigDirectory1");          
            auto router = routerService();
            
            Route[] expected = [];
            expected ~= Route("sorceRegex", "typeRegex", "targetRegex", "middlewareRegex");
            expected ~= Route("sorceRegex2", "typeRegex", "targetRegex", "middlewareRegex");
            expected ~= Route("sorceRegex", "typeRegex", "targetRegex");
            
            router.getRoutes.shouldEqual(expected);
        });
      });
    });
  });
}