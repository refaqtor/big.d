/**
	Copyright: © 2016 LLC CERERIS
	Authors: Peter Kozhevnikov <kozhevnikov@myriad-corp.com>
	License: Subject to the terms of the MIT license, as written in the included LICENSE.txt file.
*/

module test.console.command.foo4command;

import big.console.command;

class Foo4Command: Command{
	protected:
		override void configure(){
			this.setName("foo3:bar:toh");
		}
}