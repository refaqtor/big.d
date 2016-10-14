module big.console.command.helpcommand;

import colorize : fg, color, cwriteln, cwrite;
import std.array;
import std.stdio;

import big.console.command.command;

class HelpCommand: Command{
	public:
		this(){
			super(HELP_COMMAND_TYPE);
			
			logo = 			"\t\t╔══╗─╔══╗╔═══╗──╔══╗\n"
							"\t\t║╔╗║─╚╗╔╝║╔══╝──║╔╗╚╗\n"
							"\t\t║╚╝╚╗─║║─║║╔═╗──║║╚╗║\n"
							"\t\t║╔═╗║─║║─║║╚╗║──║║─║║\n"
							"\t\t║╚═╝║╔╝╚╗║╚═╝║╔╗║╚═╝║\n"
							"\t\t╚═══╝╚══╝╚═══╝╚╝╚═══╝";
			
			copyright = 	"\t\t LLC CERERIS © 2016";
			description = 	"Command line interface for big.d MVC web framework (D)";
			separator =     "------------------------------------------------------";
			commandMap = [	"create": "Create new big.d project",
							"help": "Show this help message"];
		}
	
		override void execute(string[] arguments){
			if(arguments.length == 1){
				cwriteln(logo.color(fg.light_green));
				cwriteln(copyright.color(fg.init));
				cwriteln(description.color(fg.init));
				cwriteln(separator.color(fg.init));
				cwriteln("Available commands:".color(fg.light_yellow));
				foreach(command; commandMap.keys){
					cwrite(("\t" ~ command).color(fg.light_green));
					cwriteln(("\t - " ~ commandMap[command]).color(fg.init));	
				}
				cwriteln("Enter help <command> for more information about command".color(fg.light_yellow));
			}
			else{
				cwriteln("Command is not available!".color(fg.light_red));
				cwriteln("Please enter help for details".color(fg.light_green));
			}
		}
		
	public:
		static string HELP_COMMAND_TYPE = "help";
		
	private:
		string logo;
		string copyright;	
		string description;
		string separator;
		string[string] commandMap;
}