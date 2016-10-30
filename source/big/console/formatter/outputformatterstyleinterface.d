/**
	Copyright: © 2016 LLC CERERIS
	Authors: Peter Kozhevnikov <kozhevnikov@myriad-corp.com>
	License: Subject to the terms of the MIT license, as written in the included LICENSE.txt file.
*/

module big.console.formatter.outputformatterstyleinterface;

interface OutputFormatterStyleInterface
{
public:
    void setForeground(string color = null);
    void setBackground(string color = null);
    void setOption(string option);
    void unsetOption(string option);
    void setOptions(string[] options);
    string apply(string text);
}
