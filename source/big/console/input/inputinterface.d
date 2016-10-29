/**
	Copyright: © 2016 LLC CERERIS
	Authors: Peter Kozhevnikov <kozhevnikov@myriad-corp.com>
	License: Subject to the terms of the MIT license, as written in the included LICENSE.txt file.
*/

module big.console.input.inputinterface;

interface InputInterface
{
public:
    string getFirstArgument();

    void setInteractive(bool interactive);

    bool hasParameterOption(string[] values, bool onlyParams = false);

    void validate();

    string getArgument(string name);
}
