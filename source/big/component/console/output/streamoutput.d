/**
	Copyright: © 2016 LLC CERERIS
	Authors: Peter Kozhevnikov <kozhevnikov@myriad-corp.com>
	License: Subject to the terms of the MIT license, as written in the included LICENSE.txt file.
*/

module big.component.console.output.streamoutput;

import std.stdio;

import big.component.console.output.output;

class StreamOutput: Output{
	public:
		this(File stream){
			this.stream = stream;
		}
	
		File getStream(){
	        return this.stream;
	    }
	private:
		File stream;
}