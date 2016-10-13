import std.stdio;
import std.array;
import std.algorithm;

class ArgumentParser{
	public:
		void parse(string[] args){
			while(!args.empty){
				args = proceed(args);
			}
			
			auto attributeNames = priorityMap.keys.sort!((a,b){return priorityMap[a] > priorityMap[b];});
			foreach(name; attributeNames){
				if(name in valueMap){
					attributeMap[name](valueMap[name]);
				}
			}
		}
		
		bool addArgument(string argumentName, void delegate(string) fun, uint priority = 0){
			if(argumentName in attributeMap){
				return false;	
			}
			
			attributeMap[argumentName] = fun;
			priorityMap[argumentName] = priority;
			return true;
		};
		
		string get(string name){
			if(name in valueMap){
				return valueMap[name];
			}
			
			return "";
		}
		
	private:
		string[] proceed(string[] args){
			if(args[0] in attributeMap && args.length > 1){
				valueMap[args[0]] = args[1];
			}
			
			return args[1..$];
		}
		
	private:
		void delegate(string)[string] attributeMap;
		uint[string] priorityMap;
		string[string] valueMap;
}