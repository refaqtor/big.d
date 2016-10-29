/**
	Copyright: © 2016 LLC CERERIS
	Authors: Peter Kozhevnikov <kozhevnikov@myriad-corp.com>
	License: Subject to the terms of the MIT license, as written in the included LICENSE.txt file.
*/

module big.console.input.inputdefinition;

import std.format;

import big.console.input;
import big.console.exception;

class InputDefinition
{
public:
    bool hasArgument(string name)
    {
        return !((name in _arguments) is null);
    }

    InputArgument getArgument(string name)
    {
        if (!hasArgument(name))
        {
            throw new InvalidArgumentException(format("The '%s' argument does not exist.",
                name));
        }

        return _arguments[name];
    }

private:
    InputArgument[string] _arguments;
}
