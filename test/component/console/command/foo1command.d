/**
	Copyright: © 2016 LLC CERERIS
	Authors: Peter Kozhevnikov <kozhevnikov@myriad-corp.com>
	License: Subject to the terms of the MIT license, as written in the included LICENSE.txt file.
*/

module test.component.console.command.foo1command;

import big.component.console.command.command;

class Foo1Command: Command{
	protected:
		override void configure(){
			this.setName("foo:bar1");
//			this.setDescription("The foo:bar command");
//            this.setAliases(["afoobar"]);
		}
}