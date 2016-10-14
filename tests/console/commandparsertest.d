//import std.stdio;
//import argumentParser;
//
//unittest{
//	auto testArgs = ["executablePath", "test", "true", "test2", "false"];
//	auto parser = new ArgumentParser;
//	
//	auto check1 = false;
//	auto check2 = false;
//	auto check3 = false;
//	
//	string[] sequence = [];
//	
//	assert(parser.addArgument("test", delegate(value){
//			assert(parser.get("test") == "true");
//			assert(value == "true");
//			check1 = true;
//			sequence ~= "test";
//		}
//	));
//	
//	assert(parser.addArgument("test2", delegate(value){
//			assert(parser.get("test2") == "false");
//			assert(value == "false");
//			check2 = true;
//			sequence ~= "test2";
//		},
//		"",
//		"",
//		1
//	));
//	
//	assert(parser.addAction("help", delegate(){
//			assert(parser.get("help"));
//			check3 = true;
//			sequence ~= "test3";
//			writeln("asdasdasasa!!!!!!!!!!!!");
//		},
//		"",
//		1000
//	));
//	
//	parser.parse(testArgs);
////	assert(check1 && check2 && check3);
////	assert(sequence == ["test3", "test2", "test"]);
//}