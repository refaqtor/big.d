/**
* Copyright: 2017 © LLC CERERIS
* License: MIT
* Authors: LLC CERERIS
*/

module test.big.utils.compositetest;

import big.utils.composite;
import checkit.assertion;
import checkit.bdd;
import std.conv;
import std.variant: Variant;

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

          to!string(root).shouldEqual("Composite(name: 'root', children: " ~
            "[\"name\":Attribute(name: 'name', value: 'TestConfig'), \"version\"" ~ 
            ":Attribute(name: 'version', value: '5'), \"SubTestConfig\"" ~ 
            ":Composite(name: 'SubTestConfig', children: [\"value\":Attribute(name: " ~ 
            "'value', value: '2.33')]), \"address\":Attribute(name: 'address', value: " ~ 
            "'TestValue(\"\")')])");
          
          ("version" in root).shouldBeTrue();
          ("cereris" in root).shouldBeFalse();

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
  scenario!("Set component name and value", ["utils"])
  ({
    given!"Attribute object"
    ({
      auto root = new Attribute("name", "value");

      when!"Set some name and value for given object"
      ({
        root.setName("newName");
        root.setValue(to!Variant("newValue"));

        then!"Get correct object name and value"
        ({
          root.getName.shouldEqual("newName");
          root.getValue.shouldEqual("newValue");
        });
      });
    });
  });
  scenario!("Remove child component from composite object", ["utils"])
  ({
    given!"Composite object"
    ({
      auto root = new Composite("name");
      root.add(new Attribute("name", "value"));

      when!"Remove child attribute from composite object"
      ({
        root.remove("name");

        then!"After trying to get the child attribute from composite object get null value"
        ({
          root.get!Attribute("name").shouldBeNull();
        });
      });
    });
  });
}
