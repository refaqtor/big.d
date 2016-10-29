/**
	Copyright: © 2016 LLC CERERIS
	Authors: Peter Kozhevnikov <kozhevnikov@myriad-corp.com>
	License: Subject to the terms of the MIT license, as written in the included LICENSE.txt file.
*/

module big.console.output.consoleoutput;

import std.stdio;

import big.console.output;
import big.console.formatter;

class ConsoleOutput: StreamOutput, ConsoleOutputInterface{
	public:
		this(int verbosity = VERBOSITY_NORMAL, bool decorated = false, OutputFormatterInterface formatter = null){
			super(this.openOutputStream(), verbosity, decorated, formatter);
//	        actualDecorated = this.isDecorated();
////	        this->stderr = new StreamOutput($this->openErrorStream(), $verbosity, $decorated, $this->getFormatter());
//	        if(decorated == null){
////	            this.setDecorated($actualDecorated && $this->stderr->isDecorated());
//	        }
		}
		
	private:
		File openOutputStream(){
	        return stdout;
	    }
}