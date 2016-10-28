/**
	Copyright: © 2016 LLC CERERIS
	Authors: Peter Kozhevnikov <kozhevnikov@myriad-corp.com>
	License: Subject to the terms of the MIT license, as written in the included LICENSE.txt file.
*/

import std.stdio;
import std.string;

import big.console.application;
import big.console.command;
import big.console.exception;
import test.console.tester;
import test.console.command;

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
	bool check = false;
	
	try{
		application.findNamespace("bar");
	}
	catch (Exception e) {
		check = true;
	}
	
	assert(check, "Exception There are no commands defined in the 'bar' namespace.");
}

/// find unique name but namespace name test
unittest{
	auto application = new Application;
	application.add(new FooCommand);
	application.add(new Foo1Command);
	application.add(new Foo2Command);
	
	bool check = false;
	
	try{
		application.find("foo1");
	}
	catch (Exception e) {
		check = true;
	}
	
	assert(check, "Exception There are no commands defined in the 'bar1' namespace.");
}

/// find test
unittest{
	auto application = new Application;
	application.add(new FooCommand);
	
	assert(typeid(application.find("foo:bar")) == typeid(FooCommand), "find() returns a command if its name exists");
	assert(typeid(application.find("h")) == typeid(HelpCommand), "find() returns a command if its name exists");
	assert(typeid(application.find("f:bar")) == typeid(FooCommand), "find() returns a command if its name exists");
	assert(typeid(application.find("f:b")) == typeid(FooCommand), "find() returns a command if its name exists");
	assert(typeid(application.find("a")) == typeid(FooCommand), "find() returns a command if its name exists");
}

/// find with ambiguous abbreviations test
unittest{
    auto application = new Application;
    application.add(new FooCommand);
    application.add(new Foo1Command);
    application.add(new Foo2Command);
    
    bool checkF, checkA, checkB = false;
    
    try{
    	application.find("f");
    }
    catch(Exception e){
    	checkF = true;
    	assert(e.msg.indexOf("Command 'f' is not defined.") > -1);
    }
    
    try{
    	application.find("a");
    }
    catch(Exception e){
    	checkA = true;
    	assert(e.msg == "Command 'a' is ambiguous (afoobar2,afoobar,afoobar1).");
    }
    
    try{
    	application.find("foo:b");
    }
    catch(Exception e){
    	checkB = true;
    	assert(e.msg == "Command 'foo:b' is ambiguous (foo1:bar,foo:bar1,foo:bar).");
    }
    
    assert(checkF && checkA && checkB);
}

/// find command equal namespace test
unittest{
	auto application = new Application;
    application.add(new Foo3Command);
    application.add(new Foo4Command);
    
    assert(typeid(Foo3Command) == typeid(application.find("foo3:bar")), "find() returns the good command even if a namespace has same name");
    assert(typeid(Foo4Command) == typeid(application.find("foo3:bar:toh")), "find() returns a command even if its namespace equals another command name");
}

/// find command with ambiguous namespaces but unique name test
unittest{
	auto application = new Application;
    application.add(new FooCommand);
    application.add(new FoobarCommand);
    
    assert(typeid(FoobarCommand) == typeid(application.find("f:f")));
}

/// find command with missing namespace
unittest{
	auto application = new Application;
    application.add(new Foo4Command);
    assert(typeid(Foo4Command) == typeid(application.find("f:t")));
}

/// find alternative exception message single test
unittest{
	auto application = new Application;
    application.add(new Foo3Command);
    
    bool checkA, checkB = false;
    
    try{
    	application.find("foo3:baR");
    }
    catch(Exception e){
    	checkA = true;
    	assert(e.msg.indexOf("Did you mean this?") > -1);
    }
    
    try{
    	application.find("foO3:bar");
    }
    catch(Exception e){
    	checkB = true;
    	assert(e.msg.indexOf("Did you mean this?") > -1);
    }
    
    assert(checkA && checkB);
}

/// find alternative exception message multiple test
unittest{
	auto application = new Application;
    application.add(new FooCommand);
    application.add(new Foo1Command);
    application.add(new Foo2Command);
    
    // Command + plural
	try {
	    application.find("foo:baR");
	    assert(false, "find() throws a CommandNotFoundException if command does not exist, with alternatives");
	}
	catch(Exception e){
		assert(typeid(e) == typeid(CommandNotFoundException), "find() throws a CommandNotFoundException if command does not exist, with alternatives");
		assert(e.msg.indexOf("Did you mean one of these") > -1, "find() throws a CommandNotFoundException if command does not exist, with alternatives");
		assert(e.msg.indexOf("foo1:bar") > -1);
		assert(e.msg.indexOf("foo:bar") > -1);
	}
	
	// Namespace + plural
    try {
	    application.find("foo2:bar");
        assert(false, "find() throws a CommandNotFoundException if command does not exist, with alternatives");
    }
    catch(Exception e){
    	assert(typeid(e) == typeid(CommandNotFoundException), "find() throws a CommandNotFoundException if command does not exist, with alternatives");
		assert(e.msg.indexOf("Did you mean one of these") > -1, "find() throws a CommandNotFoundException if command does not exist, with alternatives");
		assert(e.msg.indexOf("foo1") > -1);
    }
    
    application.add(new Foo3Command);
    application.add(new Foo4Command);
    
    // Subnamespace + plural
    try {
		application.find("foo3:");
	    assert(false, "find() should throw an CommandNotFoundException if a command is ambiguous because of a subnamespace, with alternatives");
        }
	catch(Exception e){
        assert(typeid(e) == typeid(CommandNotFoundException), "find() throws a CommandNotFoundException if command does not exist, with alternatives");
        assert(e.msg.indexOf("foo3:bar") > -1);
        assert(e.msg.indexOf("foo3:bar:toh") > -1);
    }
}

/// find alternative commands
unittest{
	auto application = new Application;
	application.add(new FooCommand);
	application.add(new Foo1Command);
	application.add(new Foo2Command);

	auto commandName = "Unknown command";

    try {
		application.find(commandName);
        assert(false, "find() throws a CommandNotFoundException if command does not exist");
    }
    catch(CommandNotFoundException e){
    	assert(e.getAlternatives().empty);
    	assert(e.msg.indexOf(format("Command '%s' is not defined.", commandName)) > -1, "find() throws a CommandNotFoundException if command does not exist, without alternatives");
    }
    
    commandName = "bar1";
     
    try{
	    application.find(commandName);
        assert(false, "find() throws a CommandNotFoundException if command does not exist");
    }
    catch(CommandNotFoundException e){
        assert(e.getAlternatives() == ["foo:bar1", "afoobar1"]);
        assert(e.msg.indexOf(format("Command '%s' is not defined.", commandName)) > -1, "find() throws a CommandNotFoundException if command does not exist, without alternatives");
        assert(e.msg.indexOf("afoobar1") > -1, "find() throws a CommandNotFoundException if command does not exist, with alternative : 'afoobar1'");
        assert(e.msg.indexOf("foo:bar1") > -1, "find() throws a CommandNotFoundException if command does not exist, with alternative : 'foo:bar1'");
        assert(e.msg.indexOf("foo:bar2") == -1, "find() throws a CommandNotFoundException if command does not exist, with alternative : 'foo:bar'");
    }
}

/// find alternative commands with an alias test
unittest{
	auto fooCommand = new FooCommand;
    fooCommand.setAliases(["foo2"]);
    
    auto application = new Application;
    application.add(fooCommand);
    auto result = application.find("foo");
    assert(fooCommand == result);
}

/// find alternative namespace test
unittest{
	auto application = new Application;
	application.add(new FooCommand);
	application.add(new Foo1Command);
	application.add(new Foo2Command);
	application.add(new Foo3Command);
    
    try{
	    application.find("Unknown-namespace:Unknown-command");
        assert(false, "find() throws a CommandNotFoundException if namespace does not exist");
    }
    catch(CommandNotFoundException e){
	    assert(e.getAlternatives() == []);
        assert(e.msg == "There are no commands defined in the 'Unknown-namespace' namespace.", "find() throws a CommandNotFoundException if namespace does not exist, without alternatives");
    }
    
    try{
	    application.find("foo2:command");
	    assert(false, "find() throws a CommandNotFoundException if namespace does not exist");
    }
    catch(CommandNotFoundException e) {
    	assert(e.getAlternatives == ["foo", "foo1", "foo3"]);
    	assert(e.msg.indexOf("There are no commands defined in the 'foo2' namespace.") > -1, "find() throws a CommandNotFoundException if namespace does not exist, with alternative");
    	assert(e.msg.indexOf("foo") > -1, "find() throws a CommandNotFoundException if namespace does not exist, with alternative : 'foo'");
    	assert(e.msg.indexOf("foo1") > -1, "find() throws a CommandNotFoundException if namespace does not exist, with alternative : 'foo1'");
    	assert(e.msg.indexOf("foo3") > -1, "find() throws a CommandNotFoundException if namespace does not exist, with alternative : 'foo3'");
    }
}