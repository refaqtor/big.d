import std.stdio;
import argumentParser;

unittest{
	auto testArgs = ["executablePath", "test", "true", "test2", "false"];
	auto parser = new ArgumentParser;
	
	auto check1 = false;
	auto check2 = false;
	
	string[] sequence = [];
	
	assert(parser.addArgument("test", delegate(value){
			assert(parser.get("test") == "true");
			check1 = true;
			sequence ~= "test";
		}
	));
	
	assert(parser.addArgument("test2", delegate(value){
			assert(parser.get("test2") == "false");
			check2 = true;
			sequence ~= "test2";
		},
		1
	));
	
	parser.parse(testArgs);
	assert(check1 && check2);
	assert(sequence == ["test2", "test"]);
}