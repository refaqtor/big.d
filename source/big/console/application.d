/**
	An Application is the container for a collection of commands.
	It is the main entry point of a Console application.
	This class is optimized for a standard CLI environment.
	
	Usage:
		auto app = new Application("MyApplication", "2.1 (stable)");
		app.add(new SimpleCommand);
		app.run();
	
	Copyright: © 2016 LLC CERERIS
	Authors: Peter Kozhevnikov <kozhevnikov@myriad-corp.com>
	License: Subject to the terms of the MIT license, as written in the included LICENSE.txt file.
*/

module big.console.application;

import std.array : empty;
import std.format : format;
import std.string;
import std.stdio;
import std.array;
import std.algorithm.sorting : sort;
import std.algorithm.iteration : uniq, filter;
import std.regex;
import std.algorithm.searching : canFind;
import std.algorithm.comparison : levenshteinDistance;
import std.process;
import std.conv;
import core.stdc.stdlib;

import big.console.command;
import big.console.exception;
import big.console.input;
import big.console.output;
import big.console.terminal;
import big.eventdispatcher;

alias Command[string] CommandMap;

class Application
{
public:
    this(string applicationName = "UNKNOWN", string applicationVersion = "UNKNOWN")
    {
        setName(applicationName);
        setVersion(applicationVersion);
        _terminal = new Terminal;
        _defaultCommand = "list";
        //        $this->helperSet = $this->getDefaultHelperSet();
        //        $this->definition = $this->getDefaultInputDefinition();

        foreach (command; getDefaultCommands())
        {
            add(command);
        }
    }

    Command add(Command command)
    {
        command.setApplication(this);

        if (!command.isEnabled())
        {
            command.setApplication();
            return null;
        }

        //			if (null === $command->getDefinition()) {
        //            throw new LogicException(sprintf('Command class "%s" is not correctly initialized. You probably forgot to call the parent constructor.', get_class($command)));
        //        }
        _commandMap[command.getName()] = command;

        foreach (commandAlias; command.getAliases())
        {
            _commandMap[commandAlias] = command;
        }

        return command;
    }

    void addCommands(Command[] commands)
    {
        foreach (command; commands)
        {
            add(command);
        }
    }

    void setName(string applicationName)
    {
        _applicationName = applicationName;
    }

    string getName()
    {
        return _applicationName;
    }

    void setVersion(string applicationVersion)
    {
        _applicationVersion = applicationVersion;
    }

    string getVersion()
    {
        return _applicationVersion;
    }

    string getHelp()
    {
        return getLongVersion();
    }

    CommandMap all(string namespace = "")
    {
        if (namespace == "")
        {
            return _commandMap;
        }

        CommandMap commandMap;
        foreach (name, command; _commandMap)
        {
            if (namespace == extractNamespace(name, count(namespace, ":")))
            {
                commandMap[name] = command;
            }
        }

        return commandMap;
    }

    Command register(string name)
    {
        return add(new Command(name));
    }

    string getLongVersion()
    {
        if (getName() != "UNKNOWN")
        {
            if (getVersion() != "UNKNOWN")
            {
                return format("%s <info>%s</info>", getName(), getVersion());
            }
            return getName();
        }

        return "Console Tool";
    }

    bool has(string name)
    {
        if (name in _commandMap)
        {
            return true;
        }

        return false;
    }

    Command get(string name)
    {
        if (!(name in _commandMap))
        {
            throw new CommandNotFoundException(format("The command '%s' does not exist.",
                name));
        }

        auto command = _commandMap[name];
        if (_wantHelps)
        {
            _wantHelps = false;
            auto helpCommand = cast(HelpCommand) get("help");
            helpCommand.setCommand(command);
            return helpCommand;
        }

        return command;
    }

    void setAutoExit(bool state)
    {
        _autoExit = state;
    }

    void setCatchExceptions(bool state)
    {
        _catchExceptions = state;
    }

    string[] getNamespaces()
    {
        string[] namespaces;

        foreach (command; all().values())
        {
            namespaces ~= extractAllNamespaces(command.getName());
            foreach (commandAlias; command.getAliases())
            {
                namespaces ~= extractAllNamespaces(commandAlias);
            }
        }

        namespaces = uniq(sort(namespaces)).array;
        return namespaces;
    }

    string findNamespace(string namespace)
    {
        auto allNamespaces = getNamespaces();
        auto namespaseRegex = replaceAll!(delegate(Captures!(string) m) {
            return m.hit ~ "[^:]*";
        })(namespace, regex("([^:]+|)"));
        string[] namespaces;
        foreach (name; allNamespaces)
        {
            namespaces ~= matchFirst(name, "^" ~ namespaseRegex).array;
        }

        if (namespaces.empty)
        {
            auto message = format("There are no commands defined in the '%s' namespace.",
                namespace);
            auto alternatives = findAlternatives(namespace, allNamespaces);

            if (!alternatives.empty)
            {
                if (alternatives.length == 1)
                {
                    message ~= "\n\nDid you mean this?\n    ";
                }
                else
                {
                    message ~= "\n\nDid you mean one of these?\n    ";
                }

                message ~= join(alternatives, "\n    ");
            }

            throw new CommandNotFoundException(message, alternatives);
        }

        auto exact = canFind(namespaces, namespace);
        if (namespaces.length > 1 && !exact)
        {
            throw new CommandNotFoundException(
                format("The namespace %s is ambiguous (%s).", namespace, namespaces.join(",")));
        }

        if (exact)
        {
            return namespace;
        }
        else
        {
            if (namespaces.empty)
            {
                return "";
            }
            else
            {
                return namespaces[0];
            }
        }
    }

    Command find(string name)
    {
        string[] allCommands = _commandMap.keys();
        string[] commands, commandsEnd;
        string[] exprArray;
        replaceAll!(delegate(Captures!(string) m) {
            exprArray = exprArray ~ (m[1] ~ "[^:]*");
            return m[1];
        })(name, regex("([^:]+)"));

        string expr = exprArray.join(".*");

        foreach (commandName; allCommands)
        {
            commands ~= matchFirst(commandName, "^" ~ expr).array;
        }

        foreach (commandName; allCommands)
        {
            commandsEnd ~= matchFirst(commandName, "^" ~ expr ~ "$").array;
        }

        if (commands.empty || commandsEnd.empty)
        {
            auto pos = name.indexOf(":");
            if (pos > -1)
            {
                findNamespace(name[0 .. pos]);
            }

            string message = format("Command '%s' is not defined.", name);
            auto alternatives = findAlternatives(name, allCommands);

            if (!alternatives.empty)
            {
                if (alternatives.length == 1)
                {
                    message ~= "\n\nDid you mean this?\n    ";
                }
                else
                {
                    message ~= "\n\nDid you mean one of these?\n    ";
                }
                message ~= alternatives.join("\n    ");
            }

            throw new CommandNotFoundException(message, alternatives);
        }

        if (commands.length > 1)
        {
            bool findCommand(string nameOrAlias)
            {
                if (nameOrAlias in _commandMap)
                {
                    string commandName = _commandMap[nameOrAlias].getName();
                    return commandName == nameOrAlias || !canFind(commands, commandName);
                }
                return false;
            }

            commands = commands.filter!(findCommand).array;
        }

        auto exact = canFind(commands, name);
        if (commands.length > 1 && !exact)
        {
            throw new CommandNotFoundException(format("Command '%s' is ambiguous (%s).",
                name, commands.join(",")));
        }

        if (exact)
        {
            return get(name);
        }
        else
        {
            if (commands.empty)
            {
                return null;
            }
            else
            {
                return this.get(commands[0]);
            }
        }
    }

    bool areExceptionsCaught()
    {
        return _catchExceptions;
    }

    int run(InputInterface input = null, OutputInterface output = null)
    {
        int exitCode;

        environment["LINES"] = to!string(_terminal.getHeight());
        environment["COLUMNS"] = to!string(_terminal.getWidth());

        if (input is null)
        {
            input = new ArgvInput;
        }
        if (output is null)
        {
            output = new ConsoleOutput;
        }

        this.configureIO(input, output);

        try
        {
            exitCode = doRun(input, output);
        }
        catch (Exception e)
        {
            if (!_catchExceptions)
            {
                throw e;
            }
            //            if ($output instanceof ConsoleOutputInterface) {
            //                $this->renderException($e, $output->getErrorOutput());
            //            } else {
            //                $this->renderException($e, $output);
            //            }
            //            $exitCode = $e->getCode();
            //            if (is_numeric($exitCode)) {
            //                $exitCode = (int) $exitCode;
            //                if (0 === $exitCode) {
            //                    $exitCode = 1;
            //                }
            //            } else {
            //                $exitCode = 1;
            //            }
        }

        if (_autoExit)
        {
            if (exitCode > 255)
            {
                exitCode = 255;
            }
            exit(exitCode);
        }

        return exitCode;
    }

    int doRun(InputInterface input, OutputInterface output)
    {
        if (input.hasParameterOption(["--version", "-V"], true))
        {
            output.writeln(this.getLongVersion());
            return 0;
        }

        auto name = getCommandName(input);
        if (input.hasParameterOption(["--help", "-h"], true))
        {
            if (!name)
            {
                name = "help";
                input = new ArrayInput(["command_name" : _defaultCommand]);
            }
            else
            {
                _wantHelps = true;
            }
        }

        if (!name)
        {
            name = _defaultCommand;
            input = new ArrayInput(["command" : _defaultCommand]);
        }

        auto command = find(name);
        _runningCommand = command;
        int exitCode = doRunCommand(command, input, output);
        _runningCommand = null;
        return exitCode;
    }

protected:
    string getCommandName(InputInterface input)
    {
        return _singleCommand ? _defaultCommand : input.getFirstArgument();
    }

    int doRunCommand(Command command, InputInterface input, OutputInterface output)
    {
        //        foreach ($command->getHelperSet() as $helper) {
        //            if ($helper instanceof InputAwareInterface) {
        //                $helper->setInput($input);
        //            }
        //        }
        if (_dispatcher is null)
        {
            return command.run(input, output);
        }
        //        // bind before the console.command event, so the listeners have access to input options/arguments
        //        try {
        //            $command->mergeApplicationDefinition();
        //            $input->bind($command->getDefinition());
        //        } catch (ExceptionInterface $e) {
        //            // ignore invalid options/arguments for now, to allow the event listeners to customize the InputDefinition
        //        }
        //        $event = new ConsoleCommandEvent($command, $input, $output);
        //        $this->dispatcher->dispatch(ConsoleEvents::COMMAND, $event);
        //        if ($event->commandShouldRun()) {
        //            try {
        //                $e = null;
        //                $exitCode = $command->run($input, $output);
        //            } catch (\Exception $x) {
        //                $e = $x;
        //            } catch (\Throwable $x) {
        //                $e = new FatalThrowableError($x);
        //            }
        //            if (null !== $e) {
        //                $event = new ConsoleExceptionEvent($command, $input, $output, $e, $e->getCode());
        //                $this->dispatcher->dispatch(ConsoleEvents::EXCEPTION, $event);
        //                if ($e !== $event->getException()) {
        //                    $x = $e = $event->getException();
        //                }
        //                $event = new ConsoleTerminateEvent($command, $input, $output, $e->getCode());
        //                $this->dispatcher->dispatch(ConsoleEvents::TERMINATE, $event);
        //                throw $x;
        //            }
        //        } else {
        //            $exitCode = ConsoleCommandEvent::RETURN_CODE_DISABLED;
        //        }
        //        auto event = new ConsoleTerminateEvent(command, input, output, exitCode);
        //        _dispatcher.dispatch(ConsoleEvents.TERMINATE, event);
        //        return event.getExitCode();
        return 0;
    }

private:
    void configureIO(InputInterface input, OutputInterface output)
    {
        //        if (true === $input->hasParameterOption(array('--ansi'), true)) {
        //            $output->setDecorated(true);
        //        } elseif (true === $input->hasParameterOption(array('--no-ansi'), true)) {
        //            $output->setDecorated(false);
        //        }
        //        if (true === $input->hasParameterOption(array('--no-interaction', '-n'), true)) {
        //            $input->setInteractive(false);
        //        } elseif (function_exists('posix_isatty')) {
        //            $inputStream = null;
        //            if ($input instanceof StreamableInputInterface) {
        //                $inputStream = $input->getStream();
        //            }
        //            // This check ensures that calling QuestionHelper::setInputStream() works
        //            // To be removed in 4.0 (in the same time as QuestionHelper::setInputStream)
        //            if (!$inputStream && $this->getHelperSet()->has('question')) {
        //                $inputStream = $this->getHelperSet()->get('question')->getInputStream(false);
        //            }
        //            if (!@posix_isatty($inputStream) && false === getenv('SHELL_INTERACTIVE')) {
        //                $input->setInteractive(false);
        //            }
        //        }
        //        if (true === $input->hasParameterOption(array('--quiet', '-q'), true)) {
        //            $output->setVerbosity(OutputInterface::VERBOSITY_QUIET);
        //            $input->setInteractive(false);
        //        } else {
        //            if ($input->hasParameterOption('-vvv', true) || $input->hasParameterOption('--verbose=3', true) || $input->getParameterOption('--verbose', false, true) === 3) {
        //                $output->setVerbosity(OutputInterface::VERBOSITY_DEBUG);
        //            } elseif ($input->hasParameterOption('-vv', true) || $input->hasParameterOption('--verbose=2', true) || $input->getParameterOption('--verbose', false, true) === 2) {
        //                $output->setVerbosity(OutputInterface::VERBOSITY_VERY_VERBOSE);
        //            } elseif ($input->hasParameterOption('-v', true) || $input->hasParameterOption('--verbose=1', true) || $input->hasParameterOption('--verbose', true) || $input->getParameterOption('--verbose', false, true)) {
        //                $output->setVerbosity(OutputInterface::VERBOSITY_VERBOSE);
        //            }
        //        }
    }

    Command[] getDefaultCommands()
    {
        return [new HelpCommand, new ListCommand];
    }

    string extractNamespace(string name, ulong limit = 0)
    {
        auto chunks = name.split(":");
        if (chunks.length > 0)
        {
            chunks = chunks[0 .. $ - 1];
            if (limit)
            {
                chunks = chunks[0 .. limit];
            }
            return chunks.join(":");
        }
        return "";
    }

    string[] extractAllNamespaces(string name)
    {
        auto chunks = name.split(":");
        if (chunks.length > 0)
        {
            chunks = chunks[0 .. $ - 1];
        }

        string[] namespaces;

        foreach (chunk; chunks)
        {
            if (!namespaces.empty)
            {
                namespaces ~= ':' ~ chunk;
            }
            else
            {
                namespaces ~= chunk;
            }
        }
        return namespaces;
    }

    string[] findAlternatives(string name, string[] collection)
    {
        double threshold = 1e3;
        double[string] alternatives;
        string[][string] collectionParts;

        foreach (item; collection)
        {
            collectionParts[item] = split(item, ":");
        }

        foreach (i, subname; split(name, ":"))
        {
            foreach (collectionName, parts; collectionParts)
            {
                bool exists = (collectionName in alternatives) != null;

                if (i >= parts.length && exists)
                {
                    alternatives[collectionName] += threshold;
                    continue;
                }
                else if (i >= parts.length)
                {
                    continue;
                }

                ulong lev = levenshteinDistance(subname, parts[i]);
                if (lev <= subname.length / 3 || subname != "" && parts[i].indexOf(subname) >= 0)
                {
                    alternatives[collectionName] = exists ? alternatives[collectionName] + lev : lev;
                }
                else if (exists)
                {
                    alternatives[collectionName] += threshold;
                }
            }
        }

        foreach (item; collection)
        {
            ulong lev = levenshteinDistance(name, item);
            if (lev <= name.length / 3.0 || item.indexOf(name) >= 0)
            {
                alternatives[item] = (item in alternatives) != null ? alternatives[item] - lev : lev;
            }
        }

        sort(alternatives.keys());
        return alternatives.keys();
    }

private:
    string _applicationName;
    string _applicationVersion;
    string _defaultCommand;
    bool _wantHelps = false;
    bool _autoExit = true;
    bool _catchExceptions = true;
    bool _singleCommand;
    Command _runningCommand;
    CommandMap _commandMap;
    Terminal _terminal;
    EventDispatcherInterface _dispatcher;
}
