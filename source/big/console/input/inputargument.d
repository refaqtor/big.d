/**
	Copyright: © 2016 LLC CERERIS
	Authors: Peter Kozhevnikov <kozhevnikov@myriad-corp.com>
	License: Subject to the terms of the MIT license, as written in the included LICENSE.txt file.
*/

module big.console.input.inputargument;

import big.console.input;

class InputArgument
{
public:
    string getDefault()
    {
        return _default;
    }

private:
    string _default;
}
