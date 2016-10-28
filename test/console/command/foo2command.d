/**
	Copyright: © 2016 LLC CERERIS
	Authors: Peter Kozhevnikov <kozhevnikov@myriad-corp.com>
	License: Subject to the terms of the MIT license, as written in the included LICENSE.txt file.
*/

module test.console.command.foo2command;

import big.console.command;

class Foo2Command: Command{
	protected:
		override void configure(){
			this.setName("foo1:bar");
//			this.setDescription("The foo:bar command");
            this.setAliases(["afoobar2"]);
		}
}