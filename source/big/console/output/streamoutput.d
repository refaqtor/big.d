/**
	Copyright: © 2016 LLC CERERIS
	Authors: Peter Kozhevnikov <kozhevnikov@myriad-corp.com>
	License: Subject to the terms of the MIT license, as written in the included LICENSE.txt file.
*/

module big.console.output.streamoutput;

import std.stdio;

import big.console.output;
import big.console.formatter;

class StreamOutput : Output
{
public:
    this(File stream, int verbosity = VERBOSITY_NORMAL, bool decorated = false,
        OutputFormatterInterface formatter = null)
    {
        this.stream = stream;
    }

    File getStream()
    {
        return this.stream;
    }

private:
    File stream;
}
