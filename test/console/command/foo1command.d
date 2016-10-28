/**
	Copyright: © 2016 LLC CERERIS
	Authors: Peter Kozhevnikov <kozhevnikov@myriad-corp.com>
	License: Subject to the terms of the MIT license, as written in the included LICENSE.txt file.
*/

module test.console.command.foo1command;

import big.console.command;

class Foo1Command: Command{
	protected:
		override void configure(){
			this.setName("foo:bar1");
//			this.setDescription("The foo:bar1 command");
            this.setAliases(["afoobar1"]);
		}
}