module big.console.consoleapplication;

import colorize : fg, color, cwriteln, cwrite;

import big.console.application;
import big.console.command.command;
import big.console.command.helpcommand;
import big.console.command.createcommand;
import big.console.command.commandcreator;

class ConsoleApplication: Application{
	public:
		this(){
			creator.addCommand(new HelpCommand);
			creator.addCommand(new CreateCommand);
		}
	
		int run(string[] arguments){
			Command command = creator.createFromArguments(arguments);
			if(command && arguments.length > 1){
				command.execute(arguments[1..$]);
			}
			else{
				cwriteln("Command is not available!".color(fg.light_red));
				cwriteln("Please enter help for details".color(fg.light_green));
			}
			return 0;
		}
		
	private:
		CommandCreator creator;
}