/**
	Copyright: © 2016 LLC CERERIS
	Authors: Peter Kozhevnikov <kozhevnikov@myriad-corp.com>
	License: Subject to the terms of the MIT license, as written in the included LICENSE.txt file.
*/

module big.console.formatter.outputformatterinterface;

import big.console.formatter;

interface OutputFormatterInterface
{
public:
    void setDecorated(bool decorated);
    bool isDecorated();
    void setStyle(string name, OutputFormatterStyleInterface style);
    bool hasStyle(string name);
    OutputFormatterStyleInterface getStyle(string name);
    string format(string message);
}
