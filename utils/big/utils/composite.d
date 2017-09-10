/**
* Copyright: 2017 © LLC CERERIS
* License: MIT
* Authors: LLC CERERIS
*/

module big.utils.composite;

import std.conv;
import std.string: format;
import std.variant: Variant;

/// Base component for make composite object
class Component
{
  public:
    /** A constructor for the $(D Component).
    * Params:
    *  name = The name of component.
    */
  public:
    this(string name)
    {
      _name = name;
    }

    /** Get name of $(D Component)
    * Returns: The name of $(D Component)
    */
    string getName()
    {
      return _name;
    }

    /** Set name of $(D Component)
    * Params:
    *   name = The name of $(D Component)
    */
    void setName(in string name)
    {
      _name = name;
    }
    
    /// Return $(D true) if $(D Component) is $(D Composite) and $(D false) if $(D Attribute)
    abstract bool isComposite();
    
    /// Convert Object to a human readable string
    override string toString()
    {
      return "Component(name: '%s')".format(getName()); 
    }

  private:
    /// Name of component
    string _name;
}

/// Attribute is leaf of $(D Composite) object. Attribute has $(D string) name and value. Attribute has not children.
class Attribute: Component
{
  public:
    /** A constructor for the $(D Attribute).
    * Params:
    *  name = The name of $(D Component)
    *  value = The value of $(D Component)
    */
    this(T)(string name, T value)
    {
      super(name);
      _value = value;
    }

    /** Get value of $(D Attribute)
    * Returns: The value of $(D Attribute)
    */
    Variant getValue()
    {
      return _value;
    }

    /** Set value of $(D Attribute)
    * Params:
    *   value = The value of $(D Attribute)
    */
    void setValue(Variant value)
    {
      _value = value;
    }

    /// Return $(D false)
    override bool isComposite()
    {
      return false;
    }
    
    /// Convert Object to a human readable string
    override string toString()
    {
      return "Attribute(name: '%s', value: '%s')".format(getName(), _value); 
    }

  private:
    /// Value of $(D Attribute)
    Variant _value;
}

/// Composite contain array children of $(D Component).
class Composite: Component
{
  public:
    /** A constructor for the $(D Composite).
    * Params:
    *  name = The name of $(D Composite)
    */
    this(string name)
    {
      super(name);
    }

    /** Add $(D Component) into $(D Composite) object
    * Params:
    *   component = The $(D Component) which be add to $(D Composite)
    */
    void add(Component component)
    {
      _childs[component.getName()] = component;
    }

    /** Remove $(D Component) from $(D Composite) object
    * Params:
    *   name = The name of $(D Component) which be removed from $(D Composite)
    */
    void remove(string name)
    {
      _childs.remove(name);
    }

    /** Get $(D Component) from $(D Composite) object
    * Params:
    *   name = The name of $(D Component) which be get from $(D Composite)
    *
    * Returns: $(D Component) if $(D Composite) contain $(D Component) with this name or $(D null).
    */
    T get(T: Component)(string name)
    {
      if(name in _childs)
      {
        return cast(T) _childs[name];
      }

      return null;
    }
    
    /// Return result of find Component by name
    bool opBinaryRight(string op)(string rth) if(op == "in")
    {
      return (rth in _childs) !is null;
    }

    /// Return $(D true)
    override bool isComposite()
    {
      return true;
    }
    
    /// Convert Object to a human readable string
    override string toString()
    {
      return "Composite(name: '%s', children: %s)".format(getName(), to!string(_childs)); 
    }

  private:
    /// Associative array of children $(D Component)
    Component[string] _childs;
}
