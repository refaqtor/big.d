/**
	Copyright: © 2016 LLC CERERIS
	Authors: Peter Kozhevnikov <kozhevnikov@myriad-corp.com>
	License: Subject to the terms of the MIT license, as written in the included LICENSE.txt file.
*/

module big.console.input.arrayinput;

import std.stdio;
import std.algorithm : canFind;

import big.console.input;

class ArrayInput : Input
{
public:
    this(string[string] parameters)
    {
        _parameters = parameters;
    }

    string getFirstArgument()
    {
        foreach (key, value; _parameters)
        {
            if (key.length > 0 && key[0 .. 1] == "-")
            {
                continue;
            }
            return value;
        }
        return null;
    }

    bool hasParameterOption(string[] values, bool onlyParams = false)
    {
        foreach (key, value; _parameters.dup)
        {
            //            if (!is_int($k))
            //            {
            //                $v = $k;
            //            }

            if (onlyParams && key == "--")
            {
                return false;
            }

            if (values.canFind(key))
            {
                return true;
            }
        }
        return false;
    }

private:
    string[string] _parameters;
}
