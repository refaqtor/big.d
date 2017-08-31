/**
* Copyright: 2017 © LLC CERERIS
* License: MIT
* Authors: LLC CERERIS
*/

module big.utils.composite;

import std.variant: Variant;

class Component
{
  public:
    this(string name)
    {
      _name = name;
    }

    string getName()
    {
      return _name;
    }

    void setName(in string name)
    {
      _name = name;
    }

    abstract bool isComposite();

  private:
    string _name;
}

class Attribute: Component
{
  public:
    this(T)(string name, T value)
    {
      super(name);
      _value = value;
    }

    Variant getValue()
    {
      return _value;
    }

    void setValue(Variant value)
    {
      _value = value;
    }


    override bool isComposite()
    {
      return false;
    }

  private:
    Variant _value;
}

class Composite: Component
{
  public:
    this(string name)
    {
      super(name);
    }

    void add(Component component)
    {
      _childs[component.getName()] = component;
    }

    void remove(string name)
    {
      _childs.remove(name);
    }

    T get(T: Component)(string name)
    {
      if(name in _childs)
      {
        return cast(T) _childs[name];
      }

      return null;
    }

    override bool isComposite()
    {
      return true;
    }

  private:
    Component[string] _childs;
}
