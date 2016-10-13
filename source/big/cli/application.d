import std.stdio;
import argumentParser;
import projectCreator;


class Application{
	public:
		this(){
			parser.addArgument("create", delegate(value){
				if(creator.create(value)){
					writeln("Project" ~ value ~" was created success!");
				}
				else{
					writeln("Project can't created!");
				}
			}, "Create new Big.d project", "project name");
			
			parser.addAction("--help", delegate(){ this.printHelp();},"Print this help message");
			parser.addAction("-h", delegate(){ this.printHelp();},"Print this help message");
		}
	
		int run(string[] args){
			if(!parser.parse(args)){
				this.printHelp();
				return -1;
			}
			
			return 0;
		}
	
	private:
		void printHelp(){
			writeln("---------------------------");
			writeln("CLI for Big.d MVC framework");
			writeln("---------------------------");
			writeln("Enter -h or --help for print");
			writeln("this help message.");
			writeln("");
			writeln("Available commands:");
			parser.printHelp();
			writeln("");
		}
		
	private:
		ArgumentParser parser;
		ProjectCreator creator;
}