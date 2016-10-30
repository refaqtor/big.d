/**
	Copyright: © 2016 LLC CERERIS
	Authors: Peter Kozhevnikov <kozhevnikov@myriad-corp.com>
	License: Subject to the terms of the MIT license, as written in the included LICENSE.txt file.
*/

module big.console.output.output;

import std.regex;

import big.console.output;
import big.console.formatter;

abstract class Output : OutputInterface
{
public:
    this(int verbosity = VERBOSITY_NORMAL, bool decorated = false,
        OutputFormatterInterface formatter = null)
    {
        _verbosity = verbosity;
        _formatter = formatter ? formatter : new OutputFormatter();
        _formatter.setDecorated(decorated);
    }

    void setFormatter(OutputFormatterInterface formatter)
    {
        _formatter = formatter;
    }

    OutputFormatterInterface getFormatter()
    {
        return _formatter;
    }

    void setDecorated(bool decorated)
    {
        _formatter.setDecorated(decorated);
    }

    bool isDecorated()
    {
        return _formatter.isDecorated();
    }

    void setVerbosity(int level)
    {
        _verbosity = level;
    }

    int getVerbosity()
    {
        return _verbosity;
    }

    bool isQuiet()
    {
        return _verbosity == VERBOSITY_QUIET;
    }

    bool isVerbose()
    {
        return _verbosity == VERBOSITY_VERBOSE;
    }

    bool isVeryVerbose()
    {
        return _verbosity == VERBOSITY_VERY_VERBOSE;
    }

    bool isDebug()
    {
        return _verbosity == VERBOSITY_DEBUG;
    }

    void writeln(string message, int options = OUTPUT_NORMAL)
    {
        write(message, true, options);
    }

    void write(string message, bool newline = false, int options = OUTPUT_NORMAL)
    {
        int types = OUTPUT_NORMAL | OUTPUT_RAW | OUTPUT_PLAIN;
        int type = (types & options) ? (types & options) : OUTPUT_NORMAL;
        int verbosities = VERBOSITY_QUIET | VERBOSITY_NORMAL | VERBOSITY_VERBOSE | VERBOSITY_VERY_VERBOSE | VERBOSITY_DEBUG;
        int verbosity = (verbosities & options) ? (verbosities & options) : VERBOSITY_NORMAL;
        if (verbosity > getVerbosity())
        {
            return;
        }

        switch (type)
        {
        case OutputInterface.OUTPUT_NORMAL:
            message = _formatter.format(message);
            break;
        case OutputInterface.OUTPUT_RAW:
            break;
        case OutputInterface.OUTPUT_PLAIN:
            message = replaceAll(_formatter.format(message),
                regex(r"<[^>]*>"), "");
            break;
        default:
            break;
        }
        doWrite(message, newline);
    }

protected:
    abstract void doWrite(string message, bool newline);

private:
    int _verbosity;
    OutputFormatterInterface _formatter;
}
