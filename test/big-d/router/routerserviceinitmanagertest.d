/**
* Copyright: 2017 © LLC CERERIS
* License: MIT
* Authors: LLC CERERIS
*/

module test.big.router.routerserviceinitmanagertest;

import big.config.configservice: ConfigService;
import big.router.routerserviceinitmanager;
import big.router.routerservice;
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
            
            Rout[] expected = [];
            expected ~= Rout("sorceRegex", "typeRegex", "targetRegex", "middlewareRegex");
            expected ~= Rout("sorceRegex2", "typeRegex", "targetRegex", "middlewareRegex");
            expected ~= Rout("sorceRegex", "typeRegex", "targetRegex");
            
            router.getRouts.shouldEqual(expected);
        });
      });
    });
  });
}