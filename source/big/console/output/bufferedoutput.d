/**
	Copyright: © 2016 LLC CERERIS
	Authors: Peter Kozhevnikov <kozhevnikov@myriad-corp.com>
	License: Subject to the terms of the MIT license, as written in the included LICENSE.txt file.
*/

module big.console.output.bufferedoutput;

import std.ascii;

import big.console.output;

class BufferedOutput : Output
{
public:
    string fetch()
    {
        string content = _buffer.dup;
        _buffer = "";
        return content;
    }

protected:
    override void doWrite(string message, bool newline)
    {
        _buffer ~= message;
        if (newline)
        {
            _buffer ~= newline;
        }
    }

private:
    string _buffer = "";
}
