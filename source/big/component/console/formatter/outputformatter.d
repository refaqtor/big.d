/**
	Copyright: © 2016 LLC CERERIS
	Authors: Peter Kozhevnikov <kozhevnikov@myriad-corp.com>
	License: Subject to the terms of the MIT license, as written in the included LICENSE.txt file.
*/

module big.component.console.formatter.outputformatter;

import big.component.console.formatter.outputformatterinterface;

class OutputFormatter: OutputFormatterInterface{
	public:
		void setDecorated(bool decorated){
	        this.decorated = decorated;
	    }
	
	private:
		bool decorated;	
}