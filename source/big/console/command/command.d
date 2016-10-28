/**
	Copyright: © 2016 LLC CERERIS
	Authors: Peter Kozhevnikov <kozhevnikov@myriad-corp.com>
	License: Subject to the terms of the MIT license, as written in the included LICENSE.txt file.
*/

module big.console.command.command;

import std.array;
import std.regex;
import std.format: format;

import big.console.application;
import big.console.exception;

class Command{
	public:
		this(string name = ""){
			if(name != ""){
				this.setName(name);
			}
			
			this.configure();
			
	        if(this.getName() == "") {
	            throw new LogicException(format("The command defined in %s cannot have an empty name.", typeid(this)));
	        }
		}
	
		void setApplication(Application application = null){
	        this.application = application;
	        
	        if(application){
//	            $this->setHelperSet($application->getHelperSet());
	        }
	        else{
//	            $this->helperSet = null;
	        }
	    }
		
		bool isEnabled(){
	        return true;
	    }
		
		string getName(){
			return this.name;
		}
		
		Command setName(string name){
			this.validateName(name);
	        this.name = name;
	        return this;
		}
		
		string[] getAliases(){
	        return this.aliases;
	    }
		
		Command setAliases(string[] aliases){
	        foreach(commandAlias; aliases){
	            this.validateName(commandAlias);
	        }
	        
	        this.aliases = aliases;
	        return this;
	    }
	
	protected:
		void configure(){}
		
	private:
		void validateName(string name){
//	        if (!preg_match('/^[^\:]++(\:[^\:]++)*$/', $name)) {
//	            throw new InvalidArgumentException(sprintf('Command name "%s" is invalid.', $name));
//	        }
	    }	
	
	private:
		Application application;
		string name;	
		string[] aliases;
}