/**
	Copyright: © 2016 LLC CERERIS
	Authors: Peter Kozhevnikov <kozhevnikov@myriad-corp.com>
	License: Subject to the terms of the MIT license, as written in the included LICENSE.txt file.
*/

module big.console.style.styleinterface;

interface StyleInterface
{
public:
    void title(string message);
    void section(string message);
    void listing(string[] elements);
    void text(string message);
    void success(string message);
    void error(string message);
    void warning(string message);
    void note(string message);
    void caution(string message);
    void table(string[] headers, string[] rows);
    void ask(string question, string defaultValue = null, string validator = null);
    void askHidden(string question, string validator = null);
    void confirm(string question, bool defaultValue = true);
    void choice(string question, string[] choices, string defaultValue = null);
    void newLine(uint count = 1);
    void progressStart(uint max = 0);
    void progressAdvance(uint step = 1);
    void progressFinish();
}
