/**
	Copyright: © 2016 LLC CERERIS
	Authors: Peter Kozhevnikov <kozhevnikov@myriad-corp.com>
	License: Subject to the terms of the MIT license, as written in the included LICENSE.txt file.
*/

module big.component.console.command.listcommand;

import big.component.console.command.command;

class ListCommand : Command{
	protected:
		override void configure(){
			this.setName("list");
//			$this
//            ->setDefinition($this->createDefinition())
//            ->setDescription('Lists commands')
//            ->setHelp(<<<'EOF'
//The <info>%command.name%</info> command lists all commands:
//  <info>php %command.full_name%</info>
//You can also display the commands for a specific namespace:
//  <info>php %command.full_name% test</info>
//You can also output the information in other formats by using the <comment>--format</comment> option:
//  <info>php %command.full_name% --format=xml</info>
//It's also possible to get raw list of commands (useful for embedding command runner):
//  <info>php %command.full_name% --raw</info>
//EOF
//            )
//        ;			
		}
}