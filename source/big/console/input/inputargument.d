/**
	Copyright: © 2016 LLC CERERIS
	Authors: Peter Kozhevnikov <kozhevnikov@myriad-corp.com>
	License: Subject to the terms of the MIT license, as written in the included LICENSE.txt file.
*/

module big.console.input.inputargument;

import big.console.input;

class InputArgument
{
public:
    static immutable int REQUIRED = 1;
    static immutable int OPTIONAL = 2;
    static immutable int IS_ARRAY = 4;

public:
    this(string name, int mode = 0, string description = "", int defaultValue = 0)
    {
        //		        if (null === $mode) {
        //            $mode = self::OPTIONAL;
        //        } elseif (!is_int($mode) || $mode > 7 || $mode < 1) {
        //            throw new InvalidArgumentException(sprintf('Argument mode "%s" is not valid.', $mode));
        //        }
        //        $this->name = $name;
        //        $this->mode = $mode;
        //        $this->description = $description;
        //        $this->setDefault($default);
    }

    string getDefault()
    {
        return _default;
    }

private:
    string _default;
}
