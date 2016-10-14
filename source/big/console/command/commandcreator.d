module big.console.command.commandcreator;

import big.console.command.command;
import big.console.command.helpcommand;

struct CommandCreator{
	public:
		void addCommand(Command command){
			commandMap[command.getType()] = command;
		}
	
		Command createFromArguments(string[] arguments){
			if(arguments.length > 1){
				arguments = arguments[1..$];	
				if(arguments[0] in commandMap){
					return commandMap[arguments[0]];
				}
			}
			
			return null;
		}
		
	private:
		Command[string] commandMap;
}