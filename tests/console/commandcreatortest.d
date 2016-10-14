import big.console.command.command;
import big.console.command.commandcreator;

unittest{
	class Test1Command: Command{
		public:
			this(){
				super("1");
			}
			
			override void execute(){}
	}
	
	class Test2Command: Command{
		public:
			this(){
				super("2");
			}
			
			override void execute(){}
	}
	
	auto command1 = new Test1Command;
	auto command2 = new Test2Command;
	
	auto creator = new CommandCreator;
	creator.addCommand(command1);
	creator.addCommand(command2);
	
	assert(typeid(creator.createFromArguments(["execute path", "1"])) == typeid(Test1Command));
	assert(typeid(creator.createFromArguments(["execute path", "2"])) == typeid(Test2Command));
	assert(creator.createFromArguments(["execute path", "0"]) is null);
}