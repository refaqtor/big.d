/**
	Copyright: © 2016 LLC CERERIS
	Authors: Peter Kozhevnikov <kozhevnikov@myriad-corp.com>
	License: Subject to the terms of the MIT license, as written in the included LICENSE.txt file.
*/

module big.console.output.streamoutput;

import std.stdio;
import std.ascii;

import big.console.output;
import big.console.formatter;

class StreamOutput : Output
{
public:
    this(File stream, int verbosity = VERBOSITY_NORMAL, bool decorated = false,
        OutputFormatterInterface formatter = null)
    {
        _stream = stream;
        super(verbosity, decorated, formatter);
    }

    File getStream()
    {
        return _stream;
    }

protected:
    override void doWrite(string message, bool newline)
    {
        _stream.write(message);
        if (newline)
        {
            _stream.write(newline);
        }

        _stream.flush();
    }

    bool hasColorSupport()
    {
        //        if (DIRECTORY_SEPARATOR === '\\') {
        //            return
        //                '10.0.10586' === PHP_WINDOWS_VERSION_MAJOR.'.'.PHP_WINDOWS_VERSION_MINOR.'.'.PHP_WINDOWS_VERSION_BUILD
        //                || false !== getenv('ANSICON')
        //                || 'ON' === getenv('ConEmuANSI')
        //                || 'xterm' === getenv('TERM');
        //        }
        //        return function_exists('posix_isatty') && @posix_isatty($this->stream);
        return true;
    }

private:
    File _stream;
}
