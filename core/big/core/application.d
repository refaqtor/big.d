/**
* Copyright: 2017 © LLC CERERIS
* License: MIT
* Authors: LLC CERERIS
*/

module big.core.application;

import dich.container: Container;
import dich.provider: InstanceProvider;

/// Application instance (Singleton)
final class Application
{
  public:
    /** This method gives a Application instance.
    * Based on Singleton example.
    *
    * Returns:
    *   $(D Application) instance
    */
    static Application get()
    {
      if(!_isInstance)
      {
        synchronized(Application.classinfo)
        {
          if(!_instance)
          {
            _instance = new Application();
          }

          _isInstance = true;
        }
      }

      return _instance;
    }

    /** Register service for Dependency injection. 
    *
    * Params:
    *   instance = Instance of service.
    *   name = Name of registered service.
    *
    * Returns:
    *   $(D bool) result of registration. Return $(D false) if service alredy registered.
    */
    bool register(T)(T instance, string name = "")
    {
      bool status;

      try
      {
        auto provider = new InstanceProvider(instance);
        _container.register!(T)(provider, name);
        status = true;
      }
      catch(Exception e)
      {}

      return status;
    }

    /** Get service by type. 
    *
    * Params:
    *   T = Type of service.
    *
    * Returns:
    *   Result service by type.
    */
    T get(T)()
    {
      return _container.get!T();
    }

    /** Get service by type and name. 
    *
    * Params:
    *   T = Type of service.
    *   name = Name of service.
    *
    * Returns:
    *   Result service by type and name.
    */
    T get(T)(string name)
    {
      return _container.get!T(name);
    }

  private:
    this()
    {
      _container = new Container();
    }

    static bool _isInstance;
    __gshared Application _instance;
    __gshared Container _container;
}

/// Return Application instance (syntactic sugar).
static Application app()
{
  return Application.get();
}
