/**
	Copyright: © 2016 LLC CERERIS
	Authors: Peter Kozhevnikov <kozhevnikov@myriad-corp.com>
	License: Subject to the terms of the MIT license, as written in the included LICENSE.txt file.
*/

module big.console.output.output;

import big.console.output;
import big.console.formatter;

abstract class Output: OutputInterface{
	public:
		this(int verbosity = VERBOSITY_NORMAL, bool decorated = false, OutputFormatterInterface formatter = null){
	        this.verbosity = verbosity;
	        this.formatter = formatter? formatter: new OutputFormatter();
	        this.formatter.setDecorated(decorated);
		}
	
		void setVerbosity(int level){
			this.verbosity = level;
		}
		
		void setDecorated(bool decorated){
			this.formatter.setDecorated(decorated);
		}
	
	private:
		int verbosity;
		OutputFormatterInterface formatter;
}