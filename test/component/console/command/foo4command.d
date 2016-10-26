/**
	Copyright: © 2016 LLC CERERIS
	Authors: Peter Kozhevnikov <kozhevnikov@myriad-corp.com>
	License: Subject to the terms of the MIT license, as written in the included LICENSE.txt file.
*/

module test.component.console.command.foo4command;

import big.component.console.command.command;

class Foo4Command: Command{
	protected:
		override void configure(){
			this.setName("foo3:bar:toh");
		}
}