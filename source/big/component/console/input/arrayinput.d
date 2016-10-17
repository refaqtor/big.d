/**
	Copyright: © 2016 LLC CERERIS
	Authors: Peter Kozhevnikov <kozhevnikov@myriad-corp.com>
	License: Subject to the terms of the MIT license, as written in the included LICENSE.txt file.
*/

module big.component.console.input.arrayinput;

import big.component.console.input.input;

class ArrayInput: Input{
	public:
		this(string[string] parameters){
			this.parameters = parameters;
		}
		
		void setInteractive(bool interactive){
			this.interactive = interactive;
		}
	
	private:
		string[string] parameters;	
		bool interactive;
}