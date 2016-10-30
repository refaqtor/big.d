/**
	Copyright: © 2016 LLC CERERIS
	Authors: Peter Kozhevnikov <kozhevnikov@myriad-corp.com>
	License: Subject to the terms of the MIT license, as written in the included LICENSE.txt file.
*/

module big.console.style.outputstyle;

import std.ascii;

import big.console.style;
import big.console.output;

abstract class OutputStyle : OutputInterface, StyleInterface
{
public:
    this(OutputInterface output)
    {
        _output = output;
    }

    void newLine(uint count = 1)
    {
        string temp = "";
        foreach (i; 0 .. count)
        {
            temp ~= newline;
        }

        _output.write(temp);
    }

    //    void createProgressBar(uint max = 0)
    //    {
    //        return new ProgressBar($this -  > output, $max);
    //    }

private:
    OutputInterface _output;
}
