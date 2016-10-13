/**
	Argument parser for command line interface.
	Copyright: © 2016 LLC CERERIS
	License: Subject to the terms of the MIT license, as written in the included LICENSE.txt file.
	Authors: Peter Kozhevnikov
*/

import std.stdio;
import std.array;
import std.algorithm;

struct ArgumentParser{
	public:
		bool parse(string[] args){
			while(!args.empty){
				args = proceed(args);
			}
			
			auto attributeNames = priorityMap.keys.sort!((a,b){return priorityMap[a] > priorityMap[b];});
			foreach(name; attributeNames){
				if(name in valueMap)
				{
					if(name in attributeMap){
						attributeMap[name](valueMap[name]);
					}
					if(name in actionMap){
						actionMap[name]();
					}
				}
			}

			return !valueMap.keys.empty;
		}
		
		bool addArgument(string argumentName, void delegate(string) fun, string description = "", string paramName = "", uint priority = 0){
			if(argumentName in attributeMap){
				return false;	
			}
			
			attributeMap[argumentName] = fun;
			priorityMap[argumentName] = priority;
			descriptionMap[argumentName] = description;
			paramMap[argumentName] = paramName;
			return true;
		};
		
		bool addAction(string actionName, void delegate() fun, string description = "", uint priority = 0){
			if(actionName in actionMap){
				return false;	
			}
			
			actionMap[actionName] = fun;
			priorityMap[actionName] = priority;
			descriptionMap[actionName] = description;
			return true;
		};
		
		string get(string name){
			if(name in valueMap){
				return valueMap[name];
			}
			
			return "";
		}
		
		void printHelp(){
			foreach(name; attributeMap.keys){
				writeln("\t" ~ name ~ "\t<" ~ paramMap[name] ~ ">" ~ "\t - " ~ descriptionMap[name]);
			}
			
			foreach(name; actionMap.keys){
				writeln("\t" ~ name ~ "\t - " ~ descriptionMap[name]);
			}
		}
		
	private:
		string[] proceed(string[] args){
			if(args[0] in attributeMap && args.length > 1){
				valueMap[args[0]] = args[1];
			}
			
			if(args[0] in actionMap){
				valueMap[args[0]] = "true";
			}
			
			return args[1..$];
		}
		
	private:
		void delegate(string)[string] attributeMap;
		void delegate()[string] actionMap;
		uint[string] priorityMap;
		string[string] valueMap;
		string[string] descriptionMap;
		string[string] paramMap;
}