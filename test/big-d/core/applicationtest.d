/**
* Copyright: 2017 © LLC CERERIS
* License: MIT
* Authors: LLC CERERIS
*/

module test.big.core.applicationtest;

import big.core.application: app; 

import checkit.assertion;
import checkit.bdd;

class TestService{}

unittest
{
  scenario!("Register service", ["core"])
  ({
    given!"Service instance"
    ({
      auto service = new TestService();

      when!"Register service instance without name"
      ({
        app().register(service).shouldBeTrue();

        then!"Success get Test instance"
        ({
          app().get!TestService().shouldBeInstanceOf!TestService();
        });
      });

      when!"Register service instance by name"
      ({
        app().register(service, "test").shouldBeTrue();

        then!"Success get Test instance"
        ({
          app().get!TestService("test").shouldBeInstanceOf!TestService();
        });
      });

      when!"Register duplicate service instance by name"
      ({
        app().register(service, "test1").shouldBeTrue();
        app().register(service, "test1").shouldBeFalse();

        then!"Success get Test instance"
        ({
          app().get!TestService("test1").shouldBeInstanceOf!TestService();
        });
      });
    });
  });
}
