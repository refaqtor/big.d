/**
	Copyright: © 2016 LLC CERERIS
	Authors: Peter Kozhevnikov <kozhevnikov@myriad-corp.com>
	License: Subject to the terms of the MIT license, as written in the included LICENSE.txt file.
*/

import std.stdio;

import big.component.console.application;
import big.component.console.command.helpcommand;
import test.component.console.command.barbuccommand;
import test.component.console.command.foocommand;
import test.component.console.command.foo1command;
import test.component.console.command.foo2command;
import test.component.console.command.foo5command;
import test.component.console.tester.applicationtester;

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
    
    auto foo = new FooCommand;
    application.add(foo);
	assert(application.has("afoobar"), ".has() returns true if an alias is registered");
	assert(application.get("foo:bar") == foo, "get() returns a command by name");
	assert(application.get("afoobar") == foo, "get() returns a command by alias");
}

/// silent help test
unittest{
	auto application = new Application;
	application.setAutoExit(false);
	application.setCatchExceptions(false);
	
	auto tester = new ApplicationTester(application);
	tester.run(["h": "true", "-q": "true"], ["decorated": "false"]);
    assert(tester.getDisplay(true) == "");
}

/// get invalid command test
unittest{
	auto application = new Application;
	bool check = false;	
    
    try{
		application.get("foofoo");
	}
	catch (Exception e) {
		check = true;
	}
	
	assert(check, "this() get invalid command throw exception");
}

/// get namespaces test
unittest{
	auto application = new Application;
	application.add(new FooCommand);
	application.add(new Foo1Command);
	assert(application.getNamespaces() == ["foo"], ".getNamespaces() returns an array of unique used namespaces");
}

/// find namespace test
unittest{
	auto application = new Application;
	application.add(new FooCommand);
	assert(application.findNamespace("foo") == "foo", ".findNamespace() returns the given namespace if it exists");
	assert(application.findNamespace("f") == "foo", ".findNamespace() finds a namespace given an abbreviation");
    
    application.add(new Foo2Command);
    assert(application.findNamespace("foo") == "foo", ".findNamespace() returns the given namespace if it exists");
}

/// find namespace with subnamespaces
unittest{
	auto application = new Application;
	application.add(new FooCommand);
	application.add(new Foo2Command);
	assert(application.findNamespace("foo") == "foo", ".findNamespace() returns commands even if the commands are only contained in subnamespaces");
}

/// find ambiguous namespace
unittest{
	auto application = new Application;
	bool check = false;
	
	application.add(new BarBucCommand);
	application.add(new FooCommand);
	application.add(new Foo2Command);
    
    try{
		application.findNamespace("f");
	}
	catch (Exception e) {
		check = true;
	}
	
	assert(check, ".add the namespace 'f' is ambiguous (foo, foo1).");
}

/// find invalid namespace test
unittest{
	auto application = new Application;
	application.findNamespace("bar");
}