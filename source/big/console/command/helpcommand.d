module big.console.command.helpcommand;

import colorize : fg, color, cwriteln, cwritefln;

import big.console.command.command;

class HelpCommand: Command{
	public:
		this(){
			logo = 			"\t\t╔══╗─╔══╗╔═══╗──╔══╗\n"
							"\t\t║╔╗║─╚╗╔╝║╔══╝──║╔╗╚╗\n"
							"\t\t║╚╝╚╗─║║─║║╔═╗──║║╚╗║\n"
							"\t\t║╔═╗║─║║─║║╚╗║──║║─║║\n"
							"\t\t║╚═╝║╔╝╚╗║╚═╝║╔╗║╚═╝║\n"
							"\t\t╚═══╝╚══╝╚═══╝╚╝╚═══╝";
			
			copyright = 	"\t\t LLC CERERIS © 2016";
			description = 	"Command line interface for big.d MVC web framework (D)\n"
						    "------------------------------------------------------";
		}
	
		void execute(){
			cwriteln(logo.color(fg.light_green));
			cwriteln(copyright.color(fg.init));
			cwriteln(description.color(fg.init));
			cwriteln("Available commands:".color(fg.light_yellow));
		}
		
	private:
		string logo;
		string copyright;	
		string description;
}