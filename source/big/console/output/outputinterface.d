/**
	Copyright: © 2016 LLC CERERIS
	Authors: Peter Kozhevnikov <kozhevnikov@myriad-corp.com>
	License: Subject to the terms of the MIT license, as written in the included LICENSE.txt file.
*/

module big.console.output.outputinterface;

import big.console.formatter;

interface OutputInterface
{
public:
    static immutable VERBOSITY_QUIET = 16;
    static immutable VERBOSITY_NORMAL = 32;
    static immutable VERBOSITY_VERBOSE = 64;
    static immutable VERBOSITY_VERY_VERBOSE = 128;
    static immutable VERBOSITY_DEBUG = 256;

    static immutable OUTPUT_NORMAL = 1;
    static immutable OUTPUT_RAW = 2;
    static immutable OUTPUT_PLAIN = 4;

public:
    void write(string message, bool newline = false, int options = 0);
    void writeln(string message, int options = 0);
    void setVerbosity(int level);
    int getVerbosity();
    bool isQuiet();
    bool isVerbose();
    bool isVeryVerbose();
    bool isDebug();
    void setDecorated(bool decorated);
    bool isDecorated();
    void setFormatter(OutputFormatterInterface formatter);
    OutputFormatterInterface getFormatter();
}
