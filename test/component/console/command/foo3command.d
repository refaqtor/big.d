/**
	Copyright: © 2016 LLC CERERIS
	Authors: Peter Kozhevnikov <kozhevnikov@myriad-corp.com>
	License: Subject to the terms of the MIT license, as written in the included LICENSE.txt file.
*/

module test.component.console.command.foo3command;

import big.component.console.command.command;

class Foo3Command: Command{
	protected:
		override void configure(){
			this.setName("foo3:bar");
//			this.setDescription("The foo3:bar command");
		}
		
//		protected function execute(InputInterface $input, OutputInterface $output)
//    {
//        try {
//            try {
//                throw new \Exception('First exception <p>this is html</p>');
//            } catch (\Exception $e) {
//                throw new \Exception('Second exception <comment>comment</comment>', 0, $e);
//            }
//        } catch (\Exception $e) {
//            throw new \Exception('Third exception <fg=blue;bg=red>comment</>', 404, $e);
//        }
//    }
}