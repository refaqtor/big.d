/**
	Copyright: © 2016 LLC CERERIS
	Authors: Peter Kozhevnikov <kozhevnikov@myriad-corp.com>
	License: Subject to the terms of the MIT license, as written in the included LICENSE.txt file.
*/

import std.stdio;

import big.component.console.application;
import big.component.console.command.helpcommand;
import test.component.console.command.foocommand;
import test.component.console.command.foo1command;
import test.component.console.command.foo5command;

/// Constructor test
unittest{
	auto application = new Application("foo", "bar");
	assert(application.getName() == "foo", "this() takes the application name as its first argument");
	assert(application.getVersion() == "bar", "this() takes the application version as its second argument");
	assert(application.all().keys() == ["help", "list"], "this() registered the help and list commands by default");
}

/// getName and setName test
unittest{
	auto application = new Application;
	application.setName("foo");
	assert(application.getName() == "foo", ".setName() sets the name of the application");
}

/// getVersion and setVersion test
unittest{
	auto application = new Application;
	application.setVersion("bar");
	assert(application.getVersion() == "bar", ".setVersion() sets the version of the application");
}

/// getLongVersion test
unittest{
	auto application = new Application("foo", "bar");
	assert(application.getLongVersion() == "foo <info>bar</info>", ".getLongVersion() returns the long version of the application");
}

/// help test
unittest{
	auto application = new Application;
	assert(application.getHelp() == "Console Tool", ".getHelp() returns a help message");
}

/// all test
unittest{
	auto application = new Application;
	auto commandMap = application.all();
	
	assert(typeid(commandMap["help"]) == typeid(HelpCommand), ".all() returns the registered commands");
	application.add(new FooCommand);
	CommandMap commands = application.all("foo");
	assert(commands.keys().length == 1, ".all() takes a namespace as its first argument");
}

/// register test
unittest{
	auto application = new Application;
	auto command = application.register("foo");
	assert(command.getName() == "foo", ".register() registers a new command");
}

/// add test
unittest{
	auto application = new Application;
	auto foo = new FooCommand;
	application.add(foo);
	assert(application.all()["foo:bar"] == foo, ".add() registers a command");
	
	application = new Application;
	foo = new FooCommand;
	auto foo1 = new Foo1Command;
    application.addCommands([foo, foo1]);
    auto commands = application.all();
    assert([commands["foo:bar"], commands["foo:bar1"]] == [foo, foo1], ".addCommands() registers an array of commands");
}

/// add command with empty constructor test
unittest{
	bool check = false;
	auto application = new Application;
	
	try{
		application.add(new Foo5Command);
	}
	catch (Exception e) {
		check = true;
	}
	assert(check, "this() no exception");
}

/// has test
unittest{
	auto application = new Application;
	assert(application.has("list"), ".has() returns true if a named command is registered"); 
    assert(!application.has("afoobar"), ".has() returns false if a named command is not registered");
    
    application.add(new FooCommand);
	assert(application.has("afoobar"), ".has() returns true if an alias is registered");
	assert(application.get("foo:bar") == foo, "get() returns a command by name");
	assert(application.get("afoobar") == foo, "get() returns a command by alias");
	
	application = new Application;
	application.add(new FooCommand);

//        $r = new \ReflectionObject($application);
//        $p = $r->getProperty('wantHelps');
//        $p->setAccessible(true);
//        $p->setValue($application, true);
//        $command = $application->get('foo:bar');
//        $this->assertInstanceOf('Symfony\Component\Console\Command\HelpCommand', $command, '->get() returns the help command if --help is provided as the input');
}