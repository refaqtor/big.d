/**
	Copyright: © 2016 LLC CERERIS
	Authors: Peter Kozhevnikov <kozhevnikov@myriad-corp.com>
	License: Subject to the terms of the MIT license, as written in the included LICENSE.txt file.
*/

module big.component.console.output.outputinterface;

interface OutputInterface{
	
	static immutable VERBOSITY_QUIET = 16;
	static immutable VERBOSITY_NORMAL = 32;
	static immutable VERBOSITY_VERBOSE = 64;
	static immutable VERBOSITY_VERY_VERBOSE = 128;
	static immutable VERBOSITY_DEBUG = 256;
	
	static immutable OUTPUT_NORMAL = 1;
    static immutable OUTPUT_RAW = 2;
    static immutable OUTPUT_PLAIN = 4;
	
	public:
		void setVerbosity(int level);
		
		void setDecorated(bool decorated);
}