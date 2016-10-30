/**
	Copyright: © 2016 LLC CERERIS
	Authors: Peter Kozhevnikov <kozhevnikov@myriad-corp.com>
	License: Subject to the terms of the MIT license, as written in the included LICENSE.txt file.
*/

module big.console.formatter.outputformatterstyle;

import std.format;
import std.array;
import std.conv;
import std.algorithm.searching : canFind;

import big.console.formatter;
import big.console.exception;

class OutputFormatterStyle : OutputFormatterStyleInterface
{
public:
    static this()
    {
        _availableForegroundColors["black"] = ["set" : 30, "unset" : 39];
        _availableForegroundColors["red"] = ["set" : 31, "unset" : 39];
        _availableForegroundColors["green"] = ["set" : 32, "unset" : 39];
        _availableForegroundColors["yellow"] = ["set" : 33, "unset" : 39];
        _availableForegroundColors["blue"] = ["set" : 34, "unset" : 39];
        _availableForegroundColors["magenta"] = ["set" : 35, "unset" : 39];
        _availableForegroundColors["cyan"] = ["set" : 36, "unset" : 39];
        _availableForegroundColors["white"] = ["set" : 37, "unset" : 39];
        _availableForegroundColors["default"] = ["set" : 39, "unset" : 39];

        _availableBackgroundColors["black"] = ["set" : 40, "unset" : 40];
        _availableBackgroundColors["red"] = ["set" : 41, "unset" : 40];
        _availableBackgroundColors["green"] = ["set" : 42, "unset" : 40];
        _availableBackgroundColors["yellow"] = ["set" : 43, "unset" : 40];
        _availableBackgroundColors["blue"] = ["set" : 44, "unset" : 40];
        _availableBackgroundColors["magenta"] = ["set" : 45, "unset" : 40];
        _availableBackgroundColors["cyan"] = ["set" : 46, "unset" : 40];
        _availableBackgroundColors["white"] = ["set" : 47, "unset" : 40];
        _availableBackgroundColors["default"] = ["set" : 49, "unset" : 40];

        _availableOptions["bold"] = ["set" : 1, "unset" : 22];
        _availableOptions["underscore"] = ["set" : 4, "unset" : 24];
        _availableOptions["blink"] = ["set" : 5, "unset" : 25];
        _availableOptions["reverse"] = ["set" : 7, "unset" : 27];
        _availableOptions["conceal"] = ["set" : 8, "unset" : 28];
    }

    this(string foreground = null, string background = null, string[] options = [])
    {
        if (!(foreground is null))
        {
            setForeground(foreground);
        }

        if (!(background is null))
        {
            setBackground(background);
        }
        if (options.length > 0)
        {
            setOptions(options);
        }
    }

    void setForeground(string color = null)
    {
        if (color is null)
        {
            _foreground = null;
            return;
        }

        if (!(color in _availableForegroundColors))
        {
            throw new InvalidArgumentException(
                format("Invalid foreground color specified: '%s'. Expected one of (%s)",
                color, _availableForegroundColors.keys.join(", ")));
        }
        _foreground = _availableForegroundColors[color];
    }

    void setBackground(string color = null)
    {
        if (color is null)
        {
            _background = null;
            return;
        }
        if (!(color in _availableBackgroundColors))
        {
            throw new InvalidArgumentException(
                format("Invalid background color specified: '%s'. Expected one of (%s)",
                color, _availableBackgroundColors.keys.join(", ")));
        }

        _background = _availableBackgroundColors[color];
    }

    void setOption(string option)
    {
        if (!(option in _availableOptions))
        {
            throw new InvalidArgumentException(
                format("Invalid option specified: '%s'. Expected one of (%s)",
                option, _availableOptions.keys.join(", ")));
        }

        if (!canFind(_options, _availableOptions[option]))
        {
            _options ~= _availableOptions[option];
        }
    }

    void unsetOption(string option)
    {
        if (!(option in _availableOptions))
        {
            throw new InvalidArgumentException(
                format("Invalid option specified: '%s'. Expected one of (%s)",
                option, _availableOptions.keys.join(", ")));
        }

        ubyte[string][] temp;
        foreach (op; _options)
        {
            if (op == _availableOptions[option])
            {
                continue;
            }

            temp ~= op;
        }

        _options = temp;
    }

    void setOptions(string[] options)
    {
        _options = [];

        foreach (option; options)
        {
            setOption(option);
        }
    }

    string apply(string text)
    {
        string[] setCodes;
        string[] unsetCodes;

        if (!(_foreground is null))
        {
            setCodes ~= to!string(_foreground["set"]);
            unsetCodes ~= to!string(_foreground["unset"]);
        }

        if (!(_background is null))
        {
            setCodes ~= to!string(_background["set"]);
            unsetCodes ~= to!string(_background["unset"]);
        }
        if (_options.length > 0)
        {
            foreach (option; _options)
            {
                setCodes ~= to!string(option["set"]);
                unsetCodes ~= to!string(option["unset"]);
            }
        }
        if (setCodes.length == 0)
        {
            return text;
        }

        return format("\033[%sm%s\033[%sm", setCodes.join(";"), text, unsetCodes.join(";"));
    }

private:
    ubyte[string] _foreground;
    ubyte[string] _background;
    ubyte[string][] _options;

    static ubyte[string][string] _availableForegroundColors;
    static ubyte[string][string] _availableBackgroundColors;
    static ubyte[string][string] _availableOptions;
}
