/**
	Copyright: © 2016 LLC CERERIS
	Authors: Peter Kozhevnikov <kozhevnikov@myriad-corp.com>
	License: Subject to the terms of the MIT license, as written in the included LICENSE.txt file.
*/

module big.console.command.command;

import std.array;
import std.regex;
import std.string;
import std.conv;
import std.format : format;

import big.console.application;
import big.console.exception;
import big.console.input;
import big.console.output;
import big.console.helper;

class Command
{
public:
    this(string name = null)
    {
        _definition = new InputDefinition;

        if (!(name is null))
        {
            setName(name);
        }

        configure();

        if (getName().empty)
        {
            throw new LogicException(
                format("The command defined in %s cannot have an empty name.", typeid(this)));
        }
    }

    void ignoreValidationErrors()
    {
        _ignoreValidationErrors = true;
    }

    void setApplication(Application application = null)
    {
        _application = application;

        if (_application)
        {
            //            setHelperSet(_application.getHelperSet());
        }
        else
        {
            //            _helperSet = null;
        }
    }

    //    void setHelperSet(HelperSet helperSet)
    //    {
    //        _helperSet = helperSet;
    //    }
    //
    //    HelperSet getHelperSet()
    //    {
    //        return _helperSet;
    //    }

    Application getApplication()
    {
        return _application;
    }

    bool isEnabled()
    {
        return true;
    }

    string getName()
    {
        return _name;
    }

    Command setName(string name)
    {
        validateName(name);
        _name = name;
        return this;
    }

    string[] getAliases()
    {
        return _aliases;
    }

    Command setAliases(string[] aliases)
    {
        foreach (commandAlias; aliases)
        {
            validateName(commandAlias);
        }

        _aliases = aliases;
        return this;
    }

    int run(InputInterface input, OutputInterface output)
    {
        //        $this->getSynopsis(true);
        //        $this->getSynopsis(false);
        //        // add the application arguments and options
        //        $this->mergeApplicationDefinition();
        //        // bind the input against the command specific arguments/options
        //        try {
        //            $input->bind($this->definition);
        //        } catch (ExceptionInterface $e) {
        //            if (!$this->ignoreValidationErrors) {
        //                throw $e;
        //            }
        //        }
        //        $this->initialize($input, $output);
        //        if (null !== $this->processTitle) {
        //            if (function_exists('cli_set_process_title')) {
        //                cli_set_process_title($this->processTitle);
        //            } elseif (function_exists('setproctitle')) {
        //                setproctitle($this->processTitle);
        //            } elseif (OutputInterface::VERBOSITY_VERY_VERBOSE === $output->getVerbosity()) {
        //                $output->writeln('<comment>Install the proctitle PECL to be able to change the process title.</comment>');
        //            }
        //        }
        //        if ($input->isInteractive()) {
        //            $this->interact($input, $output);
        //        }
        //        // The command name argument is often omitted when a command is executed directly with its run() method.
        //        // It would fail the validation if we didn't make sure the command argument is present,
        //        // since it's required by the application.

        //        if (input.hasArgument("command") && input.getArgument("command") is null)
        //        {
        //            input.setArgument("command", getName());
        //        }

        input.validate();
        int statusCode = 0;

        if (_code)
        {
            statusCode = _code(input, output);
        }
        else
        {
            statusCode = execute(input, output);
        }
        return statusCode;
    }

    Command setCode(int delegate(InputInterface, OutputInterface) code)
    {
        _code = code;
        return this;
    }

    InputDefinition getDefinition()
    {
        return _definition;
    }

protected:
    void configure()
    {
    }

    protected int execute(InputInterface input, OutputInterface output)
    {
        throw new LogicException(
            "You must override the execute() method in the concrete command class.");
    }

    void interact(InputInterface input, OutputInterface output)
    {
    }

    void initialize(InputInterface input, OutputInterface output)
    {
    }

private:
    void validateName(string name)
    {
        //	        if (!preg_match('/^[^\:]++(\:[^\:]++)*$/', $name)) {
        //	            throw new InvalidArgumentException(sprintf('Command name "%s" is invalid.', $name));
        //	        }
    }

private:
    Application _application;
    bool _ignoreValidationErrors;
    string _name;
    string[] _aliases;
    InputDefinition _definition;
    //    HelperSet _helperSet;
    int delegate(InputInterface, OutputInterface) _code;
}
