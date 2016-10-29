/**
	Copyright: © 2016 LLC CERERIS
	Authors: Peter Kozhevnikov <kozhevnikov@myriad-corp.com>
	License: Subject to the terms of the MIT license, as written in the included LICENSE.txt file.
*/

module big.console.input.input;

import std.format;

import big.console.input;
import big.console.exception;

abstract class Input : InputInterface
{
public:
    this(InputDefinition definition = null)
    {
        if (definition is null)
        {
            _definition = new InputDefinition;
        }
        else
        {
            //            $this->bind($definition);
            //            $this->validate();
        }
    }

    override void setInteractive(bool interactive)
    {
        this.interactive = interactive;
    }

    void validate()
    {
        //        $definition = $this->definition;
        //        $givenArguments = $this->arguments;
        //        $missingArguments = array_filter(array_keys($definition->getArguments()), function ($argument) use ($definition, $givenArguments) {
        //            return !array_key_exists($argument, $givenArguments) && $definition->getArgument($argument)->isRequired();
        //        });
        //        if (count($missingArguments) > 0) {
        //            throw new RuntimeException(sprintf('Not enough arguments (missing: "%s").', implode(', ', $missingArguments)));
        //        }
    }

    string getArgument(string name)
    {
        if (!_definition.hasArgument(name))
        {
            throw new InvalidArgumentException(format("The '%s' argument does not exist.",
                name));
        }

        return (name in _arguments) ? _arguments[name] : _definition.getArgument(name).getDefault();
    }

private:
    bool interactive = true;
    string[string] _arguments;
    InputDefinition _definition;
}
