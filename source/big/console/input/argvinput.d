/**
	Copyright: © 2016 LLC CERERIS
	Authors: Peter Kozhevnikov <kozhevnikov@myriad-corp.com>
	License: Subject to the terms of the MIT license, as written in the included LICENSE.txt file.
*/

module big.console.input.argvinput;

import std.string;
import std.stdio;

import big.console.input;

class ArgvInput : Input
{
public:
    this(string[] argv = null, InputDefinition definition = null)
    {
        if (!(argv is null) && argv.length > 0)
        {
            argv = argv[1 .. $];
        }

        _tokens = argv;
        writeln("ARGV", _tokens);
        super(definition);
    }

    bool hasParameterOption(string[] values, bool onlyParams = false)
    {
        //                $values = (array) $values;
        foreach (token; _tokens)
        {
            if (onlyParams && token == "--")
            {
                return false;
            }
            foreach (value; values)
            {
                if (token == value || token.indexOf(value ~ "=") == 0)
                {
                    return true;
                }
            }
        }
        return false;
    }

    string getFirstArgument()
    {
        writeln("*/*/*/", _tokens);
        foreach (token; _tokens)
        {
            if (token.length > 0 && token[0 .. 1] == "-")
            {
                continue;
            }
            return token;
        }
        return null;
    }

protected:
    void setTokens(string[] tokens)
    {
        _tokens = tokens;
    }

    void parse()
    {
        auto parseOptions = true;
        _parsed = _tokens;

        //       while (null !== $token = array_shift($this->parsed)) {
        //            if ($parseOptions && '' == $token) {
        //                $this->parseArgument($token);
        //            } elseif ($parseOptions && '--' == $token) {
        //                $parseOptions = false;
        //            } elseif ($parseOptions && 0 === strpos($token, '--')) {
        //                $this->parseLongOption($token);
        //            } elseif ($parseOptions && '-' === $token[0] && '-' !== $token) {
        //                $this->parseShortOption($token);
        //            } else {
        //                $this->parseArgument($token);
        //            }
        //        }
    }

private:
    string[] _tokens;
    string[] _parsed;
}
