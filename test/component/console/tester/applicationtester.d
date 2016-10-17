/**
	Copyright: © 2016 LLC CERERIS
	Authors: Peter Kozhevnikov <kozhevnikov@myriad-corp.com>
	License: Subject to the terms of the MIT license, as written in the included LICENSE.txt file.
*/

module test.component.console.tester.applicationtester;

import std.stdio;
import std.array;
import std.conv;

import big.component.console.application;
import big.component.console.input.inputinterface;
import big.component.console.input.arrayinput;
import big.component.console.output.outputinterface;
import big.component.console.output.streamoutput;

class ApplicationTester{
	public:
		this(Application application){
			this.application = application;
		}
		
		int run(string[string] input, string[string] options = null){
			this.input = new ArrayInput(input);
			
			if("interactive" in options){
				this.input.setInteractive(options["interactive"] == "true" ? true : false);
			}
			
			this.captureStreamsIndependently = !(("capture_stderr_separately" in options) is null) && options["capture_stderr_separately"] == "true";
			
			if (!this.captureStreamsIndependently) {
	            this.output = new StreamOutput(File.tmpfile());
	            
	            if("decorated" in options){
	                this.output.setDecorated(options["decorated"] == "true");
	            }
	            
	            if("verbosity" in options){
	                this.output.setVerbosity(to!int(options["verbosity"]));
	            }
	        } 
			else {
//            $this->output = new ConsoleOutput(
//                isset($options['verbosity']) ? $options['verbosity'] : ConsoleOutput::VERBOSITY_NORMAL,
//                isset($options['decorated']) ? $options['decorated'] : null
//            );
//            $errorOutput = new StreamOutput(fopen('php://memory', 'w', false));
//            $errorOutput->setFormatter($this->output->getFormatter());
//            $errorOutput->setVerbosity($this->output->getVerbosity());
//            $errorOutput->setDecorated($this->output->isDecorated());
//            $reflectedOutput = new \ReflectionObject($this->output);
//            $strErrProperty = $reflectedOutput->getProperty('stderr');
//            $strErrProperty->setAccessible(true);
//            $strErrProperty->setValue($this->output, $errorOutput);
//            $reflectedParent = $reflectedOutput->getParentClass();
//            $streamProperty = $reflectedParent->getProperty('stream');
//            $streamProperty->setAccessible(true);
//            $streamProperty->setValue($this->output, fopen('php://memory', 'w', false));
	        }	
			
			this.statusCode = this.application.run(this.input, this.output);
			return this.statusCode;
		}

		string getDisplay(bool normalize = false){
			(cast(StreamOutput) this.output).getStream().rewind();
			StreamOutput streamOutput = cast(StreamOutput) this.output;
			
			string display;
			foreach(line; streamOutput.getStream.byLine()){
				display ~= line;
			}
			
		    if(normalize) {
//            $display = str_replace(PHP_EOL, "\n", $display);
	        }
		    
	        return display;
	    }
		
	private:
		InputInterface input;
		OutputInterface output;
		Application application;
		int statusCode;	
		bool captureStreamsIndependently;
}