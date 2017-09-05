/**
* Copyright: 2017 © LLC CERERIS
* License: MIT
* Authors: LLC CERERIS
*/

module test.big.utils.compositetest;

import big.utils.composite;
import checkit.assertion;
import checkit.bdd;

struct TestValue
{
  string name;
}

unittest
{
  scenario!("Make composite with attributes", ["utils"])
  ({
    given!"Composite object"
    ({
      auto root = new Composite("root");

      when!"Add childs and attributes"
      ({
        root.add(new Attribute("name", "TestConfig"));
        root.add(new Attribute("version", 5));
        root.add(new Attribute("address", TestValue()));

        auto subRoot = new Composite("SubTestConfig");
        subRoot.add(new Attribute("value", 2.33));

        root.add(subRoot);

        then!"Composite object get all component"
        ({
          root.get!Attribute("name").getValue().shouldEqual("TestConfig");
          root.get!Attribute("version").getValue().shouldEqual(5);
          root.get!Attribute("address").getValue().shouldEqual(TestValue());
          root.get!Component("name").isComposite().shouldBeFalse();
          root.get!Component("SubTestConfig").isComposite().shouldBeTrue();

          auto leaf = root.get!Composite("SubTestConfig");
          leaf.get!Attribute("value").getValue().shouldBeBetween(2.2, 2.4);

          leaf.get!Attribute("null").shouldBeNull();

          leaf.get!Attribute("value").setValue(Variant(1));
          leaf.get!Attribute("value").setName("qwerty");
          leaf.get!Attribute("value").getValue().shouldEqual(1);
          leaf.get!Attribute("value").getName().shouldEqual("qwerty");
          root.remove("SubTestConfig");
          root.get!Attribute("SubTestConfig").shouldBeNull();
        });
      });
    });
  });
}
