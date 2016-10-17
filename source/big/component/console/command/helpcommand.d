/**
	Copyright: © 2016 LLC CERERIS
	Authors: Peter Kozhevnikov <kozhevnikov@myriad-corp.com>
	License: Subject to the terms of the MIT license, as written in the included LICENSE.txt file.
*/

module big.component.console.command.helpcommand;

import big.component.console.command.command;

class HelpCommand: Command{
	public:
		void setCommand(Command command){
	        this.command = command;
	    }
		
	protected:
		override void configure(){
			//			$this->ignoreValidationErrors();
	        this.setName("help");
			//            ->setDefinition(array(
			//                new InputArgument('command_name', InputArgument::OPTIONAL, 'The command name', 'help'),
			//                new InputOption('format', null, InputOption::VALUE_REQUIRED, 'The output format (txt, xml, json, or md)', 'txt'),
			//                new InputOption('raw', null, InputOption::VALUE_NONE, 'To output raw command help'),
			//            ))
			//            ->setDescription('Displays help for a command')
			//            ->setHelp(<<<'EOF'
			//The <info>%command.name%</info> command displays help for a given command:
			//  <info>php %command.full_name% list</info>
			//You can also output the help in other formats by using the <comment>--format</comment> option:
			//  <info>php %command.full_name% --format=xml list</info>
			//To display the list of available commands, please use the <info>list</info> command.
			//EOF
			//            )
			//        ;
		}
		
	private:
		Command command;	
}