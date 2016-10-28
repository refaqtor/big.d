/**
	Copyright: © 2016 LLC CERERIS
	Authors: Peter Kozhevnikov <kozhevnikov@myriad-corp.com>
	License: Subject to the terms of the MIT license, as written in the included LICENSE.txt file.
*/

module test.console.command.barbuccommand;

import big.console.command;

class BarBucCommand: Command{
	protected:
		override void configure(){
			this.setName("bar:buc");
		}
}