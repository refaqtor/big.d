/**
	Copyright: © 2016 LLC CERERIS
	Authors: Peter Kozhevnikov <kozhevnikov@myriad-corp.com>
	License: Subject to the terms of the MIT license, as written in the included LICENSE.txt file.
*/

module big.console.exception.runtimeexception;

import std.exception;

class RuntimeException : Exception
{
    this(string s)
    {
        super(s);
    }
}
