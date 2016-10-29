/**
	Copyright: © 2016 LLC CERERIS
	Authors: Peter Kozhevnikov <kozhevnikov@myriad-corp.com>
	License: Subject to the terms of the MIT license, as written in the included LICENSE.txt file.
*/

module big.console.exception.invalidargumentexception;

import std.exception;

class InvalidArgumentException : Exception
{
    this(string s)
    {
        super(s);
    }
}
