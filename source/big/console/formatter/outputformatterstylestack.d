/**
	Copyright: © 2016 LLC CERERIS
	Authors: Peter Kozhevnikov <kozhevnikov@myriad-corp.com>
	License: Subject to the terms of the MIT license, as written in the included LICENSE.txt file.
*/

module big.console.formatter.outputformatterstylestack;

import std.array;
import std.algorithm : reverse;

import big.console.formatter;
import big.console.exception;

class OutputFormatterStyleStack
{
public:

    this(OutputFormatterStyleInterface emptyStyle = null)
    {
        _emptyStyle = emptyStyle is null ? emptyStyle : new OutputFormatterStyle;
        reset();
    }

    void reset()
    {
        _styles = [];
    }

    void push(OutputFormatterStyleInterface style)
    {
        _styles ~= style;
    }

    OutputFormatterStyleInterface pop(OutputFormatterStyleInterface style = null)
    {
        if (_styles.empty)
        {
            return _emptyStyle;
        }
        if (style is null)
        {
            auto value = _styles[$ - 1];
            _styles = _styles[0 .. $ - 1];
            return value;
        }

        auto reverseStyles = _styles.dup;
        reverse(reverseStyles);
        foreach (index, stackedStyle; reverseStyles)
        {
            if (style.apply("") == stackedStyle.apply(""))
            {
                _styles = _styles[0 .. $ - index];
                return stackedStyle;
            }
        }
        throw new InvalidArgumentException("Incorrectly nested style tag found.");
    }

    OutputFormatterStyleInterface getCurrent()
    {
        if (_styles.empty)
        {
            return _emptyStyle;
        }

        return _styles[$ - 1];
    }

    OutputFormatterStyleStack setEmptyStyle(OutputFormatterStyleInterface emptyStyle)
    {
        _emptyStyle = emptyStyle;
        return this;
    }

    OutputFormatterStyleInterface getEmptyStyle()
    {
        return _emptyStyle;
    }

private:
    OutputFormatterStyleInterface _emptyStyle;
    OutputFormatterStyleInterface[] _styles;
}
