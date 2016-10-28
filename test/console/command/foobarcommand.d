/**
	Copyright: © 2016 LLC CERERIS
	Authors: Peter Kozhevnikov <kozhevnikov@myriad-corp.com>
	License: Subject to the terms of the MIT license, as written in the included LICENSE.txt file.
*/

module test.console.command.foobarcommand;

import big.console.command;

class FoobarCommand: Command{
	
//	    public $input;
//    public $output;
	
	protected:
		override void configure(){
			this.setName("foobar:foo");
//			this.setDescription("The foobar:foo command");
		}
		
//		protected function execute(InputInterface $input, OutputInterface $output)
//    {
//        $this->input = $input;
//        $this->output = $output;
//    }
}