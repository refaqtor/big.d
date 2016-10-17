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
import std.algorithm.sorting: sort;
import std.algorithm.iteration: uniq;
import std.regex;
import std.algorithm.searching: canFind;

import big.component.console.command.command;
import big.component.console.command.helpcommand;
import big.component.console.command.listcommand;
import big.component.console.exception.commandnotfoundexception;
import big.component.console.input.inputinterface;
import big.component.console.output.outputinterface;

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
	        
	        foreach(commandAlias; command.getAliases()) {
				this.commandMap[commandAlias] = command;
			}
	        
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
		
		Command get(string name){
			if(!(name in this.commandMap)){
				throw new CommandNotFoundException(format("The command %s does not exist.", name));
			}
			
			auto command = this.commandMap[name];
			if(this.wantHelps){
				this.wantHelps = false;
				auto helpCommand = cast(HelpCommand)this.get("help");
				helpCommand.setCommand(command);
				return helpCommand;
			}
			
			return command;
		}
		
		void setAutoExit(bool state){
	        this.autoExit = state;
	    }
		
		void setCatchExceptions(bool state){
	        this.catchExceptions = state;
	    }
		
		string[] getNamespaces(){
	        string[] namespaces;
	        
	        foreach(command; this.all().values()) {
	            namespaces ~= this.extractAllNamespaces(command.getName());
	            foreach(commandAlias ; command.getAliases()){
	                namespaces ~= this.extractAllNamespaces(commandAlias);
	            }
	        }
	        
	        namespaces = uniq(sort(namespaces)).array;
	        return namespaces;
	    }
		
		string findNamespace(string namespace){
	        auto allNamespaces = this.getNamespaces();
			auto namespaseRegex = replaceAll!(delegate(Captures!(string) m){return m.hit ~ "[^:]*";})(namespace, regex("([^:]+|)"));
			string[] namespaces;
			foreach(name; allNamespaces){
				namespaces ~= matchFirst(name, namespaseRegex).array;	
			}
			
	        if(namespace.empty){
	            auto message = format("There are no commands defined in the %s namespace.", namespace);
	            auto alternatives = this.findAlternatives(namespace, allNamespaces);
	            
	            if(alternatives){
	                if (1 == count($alternatives)) {
	                    $message .= "\n\nDid you mean this?\n    ";
	                } else {
	                    $message .= "\n\nDid you mean one of these?\n    ";
	                }
	                
	                message ~= implode("\n    ", $alternatives);
	            }

	            throw new CommandNotFoundException(message, alternatives);
			}
	        
	        auto exact = canFind(namespaces, namespace);
	        if(namespaces.length > 1 && !exact) {
	            throw new CommandNotFoundException(format("The namespace %s is ambiguous (%s).", namespace, namespaces.join(",")));
	        }
	        
	        if(exact){
	        	return namespace;
	        }
	        else{
	        	if(namespaces.empty){
	        		return "";
	        	}
	        	else{
	        		return namespaces[0];
	        	}
	        }
	    }
		
		int run(InputInterface input = null, OutputInterface output = null){
			int exitCode;
			
			//        putenv('LINES='.$this->terminal->getHeight());
//        putenv('COLUMNS='.$this->terminal->getWidth());
//        if (null === $input) {
//            $input = new ArgvInput();
//        }
//        if (null === $output) {
//            $output = new ConsoleOutput();
//        }
//        $this->configureIO($input, $output);
//        try {
//            $exitCode = $this->doRun($input, $output);
//        } catch (\Exception $e) {
//            if (!$this->catchExceptions) {
//                throw $e;
//            }
//            if ($output instanceof ConsoleOutputInterface) {
//                $this->renderException($e, $output->getErrorOutput());
//            } else {
//                $this->renderException($e, $output);
//            }
//            $exitCode = $e->getCode();
//            if (is_numeric($exitCode)) {
//                $exitCode = (int) $exitCode;
//                if (0 === $exitCode) {
//                    $exitCode = 1;
//                }
//            } else {
//                $exitCode = 1;
//            }
//        }
//        if ($this->autoExit) {
//            if ($exitCode > 255) {
//                $exitCode = 255;
//            }
//            exit($exitCode);
//        }
//        return $exitCode;
//    }
			
			return exitCode;
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
		
		string[] extractAllNamespaces(string name){
	        auto chunks = name.split(":");
	        if(chunks.length > 0){
	        	chunks = chunks[0..$-1];
	        }
	        
	        string[] namespaces;
	        
	        foreach(chunk; chunks){
	            if(!namespaces.empty) {
	                namespaces ~= ':'~ chunk;
	            } else {
		            namespaces ~= chunk;
	            }
	        }
	        return namespaces;
	    }		
			
	private:
		string applicationName;
		string applicationVersion;
		bool wantHelps = false;
		bool autoExit = true;
		bool catchExceptions = true;
		CommandMap commandMap;
}