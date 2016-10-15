/**
	An Application is the container for a collection of commands.
	It is the main entry point of a Console application.
	This class is optimized for a standard CLI environment.
	
	Usage:
		auto app = new Application("MyApplication", "2.1 (stable)");
		app.add(new SimpleCommand);
		app.run();
	
	Copyright: © 2016 LLC CERERIS
	Authors: Peter Kozhevnikov <kozhevnikov@myriad-corp.com>
	License: Subject to the terms of the MIT license, as written in the included LICENSE.txt file.
*/

module big.component.console.application;

import std.array: empty;
import std.format: format;
import std.string;
import std.stdio;
import std.array;

import big.component.console.command.command;
import big.component.console.command.helpcommand;
import big.component.console.command.listcommand;

alias Command[string] CommandMap;

class Application{
	public:
		this(string applicationName = "UNKNOWN", string applicationVersion = "UNKNOWN"){
			this.setName(applicationName);
			this.setVersion(applicationVersion);
			
			foreach (command; this.getDefaultCommands()) {
				this.add(command);
			}
		}
		
		Command add(Command command){
			command.setApplication(this);
			
			if(!command.isEnabled()){
	            command.setApplication();
	            return null;
	        }
			
//			if (null === $command->getDefinition()) {
//            throw new LogicException(sprintf('Command class "%s" is not correctly initialized. You probably forgot to call the parent constructor.', get_class($command)));
//        }
	        this.commandMap[command.getName()] = command;
//        foreach ($command->getAliases() as $alias) {
//            $this->commands[$alias] = $command;
//        }
	        return command;
		}
		
		void addCommands(Command[] commands){
	        foreach (command; commands){
	            this.add(command);
	        }
	    }
		
		void setName(string applicationName){
			this.applicationName = applicationName;
		}
		
		string getName(){
			return this.applicationName;
		}
		
		void setVersion(string applicationVersion){
			this.applicationVersion = applicationVersion;
		}
		
		string getVersion(){
			return this.applicationVersion;
		}
		
		string getHelp(){
			return this.getLongVersion();
		}
		
		CommandMap all(string namespace = ""){
			if(namespace == ""){
				return this.commandMap;
			}
			
			CommandMap commandMap;
			foreach (name, command; this.commandMap){
				if(namespace == this.extractNamespace(name, count(namespace, ":"))){
					commandMap[name] = command;
				}
			}
			
			return commandMap;
		}
		
		Command register(string name){
	        return this.add(new Command(name));
	    }
		
		string getLongVersion(){
	        if(this.getName() != "UNKNOWN"){
	            if(this.getVersion() != "UNKNOWN"){
	                return format("%s <info>%s</info>", this.getName(), this.getVersion());
	            }
	            return this.getName();
	        }
	        
	        return "Console Tool";
	    }
		
		bool has(string name){
			if(name in this.commandMap){
				return true;
			}
			
			return false;
	    }
	
	private:
		Command[] getDefaultCommands(){
	        return [new HelpCommand, new ListCommand];
		}
		
		string extractNamespace(string name, ulong limit = 0){
			auto chunks = name.split(":");
			if(chunks.length > 0){
				chunks = chunks[0..$-1];
				if(limit){
					chunks = chunks[0..limit];	
				}
				return chunks.join(":");
			}
			return "";
	    }
			
	private:
		string applicationName;
		string applicationVersion;
		CommandMap commandMap;
}