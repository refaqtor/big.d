module big.console.command.createcommand;

import big.console.command.command;

class CreateCommand: Command{
	public:
		this(){
			super(CREATE_COMMAND_TYPE);
		}
	
		override void execute(string[] arguments){
			
		}
			
	public:
		static string CREATE_COMMAND_TYPE = "create";	
}

//import colorize : fg, color, cwriteln, cwrite;
//
//import big.console.command.command;
//
//class CreateHelpCommand: Command{
//	public:
//		this(){
//			super(HELP_COMMAND_TYPE);
//			
//			logo = 			"\t\t╔══╗─╔══╗╔═══╗──╔══╗\n"
//							"\t\t║╔╗║─╚╗╔╝║╔══╝──║╔╗╚╗\n"
//							"\t\t║╚╝╚╗─║║─║║╔═╗──║║╚╗║\n"
//							"\t\t║╔═╗║─║║─║║╚╗║──║║─║║\n"
//							"\t\t║╚═╝║╔╝╚╗║╚═╝║╔╗║╚═╝║\n"
//							"\t\t╚═══╝╚══╝╚═══╝╚╝╚═══╝";
//			
//			copyright = 	"\t\t LLC CERERIS © 2016";
//			description = 	"Command line interface for big.d MVC web framework (D)";
//			separator =     "------------------------------------------------------";
//			commandMap = [	"create": "Create new big.d project",
//							"help": "Show this help message"];
//		}
//	
//		override void execute(){
//			cwriteln(logo.color(fg.light_green));
//			cwriteln(copyright.color(fg.init));
//			cwriteln(description.color(fg.init));
//			cwriteln(separator.color(fg.init));
//			cwriteln("Available commands:".color(fg.light_yellow));
//			foreach(command; commandMap.keys){
//				cwrite(("\t" ~ command).color(fg.light_green));
//				cwriteln(("\t - " ~ commandMap[command]).color(fg.init));	
//			}
//			cwriteln("Enter <command> help for more information about command".color(fg.light_yellow));
//		}
//		
//	public:
//		static string CREATE_HELP_COMMAND_TYPE = "create help";
//		
//	private:
//		string logo;
//		string copyright;	
//		string description;
//		string separator;
//		string[string] commandMap;
//}