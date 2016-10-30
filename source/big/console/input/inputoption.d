/**
	Copyright: © 2016 LLC CERERIS
	Authors: Peter Kozhevnikov <kozhevnikov@myriad-corp.com>
	License: Subject to the terms of the MIT license, as written in the included LICENSE.txt file.
*/

module big.console.input.inputoption;

import big.console.input;

class InputOption
{
public:
    static immutable int VALUE_NONE = 1;
    static immutable int VALUE_REQUIRED = 2;
    static immutable int VALUE_OPTIONAL = 4;
    static immutable int VALUE_IS_ARRAY = 8;
}
