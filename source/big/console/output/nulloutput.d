/**
	Copyright: © 2016 LLC CERERIS
	Authors: Peter Kozhevnikov <kozhevnikov@myriad-corp.com>
	License: Subject to the terms of the MIT license, as written in the included LICENSE.txt file.
*/

module big.console.output.nulloutput;

import big.console.output;
import big.console.formatter;

class NullOutput : OutputInterface
{
public:
    void setFormatter(OutputFormatterInterface formatter)
    {
    }

    OutputFormatterInterface getFormatter()
    {
        return new OutputFormatter();
    }

    void setDecorated(bool decorated)
    {
    }

    bool isDecorated()
    {
        return false;
    }

    void setVerbosity(int level)
    {
    }

    int getVerbosity()
    {
        return VERBOSITY_QUIET;
    }

    bool isQuiet()
    {
        return true;
    }

    bool isVerbose()
    {
        return false;
    }

    bool isVeryVerbose()
    {
        return false;
    }

    bool isDebug()
    {
        return false;
    }

    void writeln(string messages, int options = OUTPUT_NORMAL)
    {
    }

    void write(string message, bool newline = false, int options = OUTPUT_NORMAL)
    {
    }
}
