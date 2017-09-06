/**
* Copyright: 2017 © LLC CERERIS
* License: MIT
* Authors: LLC CERERIS
*/

module big.config.yamlconfigreader;

import big.utils.bigdexception;
import big.utils.composite;
import dyaml;
import std.conv;
import std.datetime;
import std.file;

///Class is used to convert yaml files into an array of composite objects
class YamlConfigReader
{
  public:
    /// A constructor for the $(D YamlConfigReader).
    this()
    {
    
    }
    
    /** This method converts the configuration file into an array of composite objects for each service
    Params:
      filePath = The path to the file from which config data will be taken
      arrayOfServiceNames = An array of service names for which the configuration data will be searched
      
    Returns: $(D Composite[][string])
    */
    Composite[][string] readConfig(in string filePath, in string[] arrayOfServiceNames)
    {
      Composite[][string] result;
      
      auto loader = new Loader(filePath);
      Node root = loader.loadAll();
      
      Node.Pair[] pairNodeArray = getPairs(root);
      
      foreach(string nameOfService; arrayOfServiceNames)
      {
        foreach(pair; pairNodeArray)
        {
          if(nameOfService == pair.key.as!string.to!string)
          {
            Composite tempConfig = new Composite(nameOfService);
            parse(pair.value, tempConfig);
            result[nameOfService] ~= tempConfig;
          }
        }
      }
      
      return result;
    }
    
  private:
    // parse node...
    void parse(Node node, ref Composite config)
    {
      if(node.isScalar())
      {
        config.add(new Attribute(node.as!string.to!string, null));
      }
      if(node.isMapping())
      {
        parse(node.as!(Node.Pair[]), config);
      }
      if(node.isSequence())
      {
        parse(node.as!(Node[]), config);
      }
    }
    
    // parse array of pairs...
    void parse(Node.Pair[] pairs, ref Composite config)
    {
      foreach(Node.Pair pair; pairs)
      {
        if(pair.value.isScalar())
        {
          if(pair.value.isString)
          {
            config.add(new Attribute(pair.key.as!string.to!string, pair.value.as!string));
          }
          if(pair.value.isBool)
          {
            config.add(new Attribute(pair.key.as!string.to!string, pair.value.as!bool));  
          }
          if(pair.value.isFloat)
          {
            config.add(new Attribute(pair.key.as!string.to!string, pair.value.as!float));
          }
          if(pair.value.isInt)
          {
            config.add(new Attribute(pair.key.as!string.to!string, pair.value.as!int));
          }
          if(!pair.value.isString && !pair.value.isBool && !pair.value.isFloat && !pair.value.isInt)
          {
            throw new BigDException("In some configuration file an unknown type is used! " ~
              "Please use only the following types in the configuration files: int, float, bool or string");
          }
        }
        else
        {
          Composite subConfig = new Composite(pair.key.as!string.to!string);
          parse(pair.value, subConfig);
          config.add(subConfig);
        }
      }
    }
    
    // parse array of nodes...
    void parse(Node[] nodes, ref Composite config)
    {
      foreach(Node node; nodes)
      {
        parse(node, config);
      }
    }
  
    Node.Pair[] getPairs(Node node)
    {
      Node[] notSequenceNodeArray = [];
      if(node.isSequence())
      {
        parseNodeArray(node, notSequenceNodeArray);
      }
      
      Node.Pair[] pairNodeArray = [];
      
      foreach(notSequenceNode; notSequenceNodeArray)
      {
        foreach(pair; notSequenceNode.as!(Node.Pair[]))
        {
          pairNodeArray ~= pair;
        }
      }
      
      return pairNodeArray;
    }
    
    void parseNodeArray(Node node, ref Node[] notSequenceNodeArray)
    {
      foreach(Node _node; node)
      {
        if(_node.isSequence())
        {
          parseNodeArray(_node, notSequenceNodeArray);
        }
        else
        {
          notSequenceNodeArray ~= _node;
        }
      }
    }
}