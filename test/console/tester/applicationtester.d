/**
	Copyright: © 2016 LLC CERERIS
	Authors: Peter Kozhevnikov <kozhevnikov@myriad-corp.com>
	License: Subject to the terms of the MIT license, as written in the included LICENSE.txt file.
*/

module test.console.tester.applicationtester;

import std.stdio;
import std.array;
import std.conv;

import big.console.application;
import big.console.input;
import big.console.output;

class ApplicationTester
{
public:
    this(Application application)
    {
        _application = application;
    }

    int run(string[string] input, string[string] options = null)
    {
        _input = new ArrayInput(input);

        if ("interactive" in options)
        {
            _input.setInteractive(options["interactive"] == "true" ? true : false);
        }

        _captureStreamsIndependently = !(("capture_stderr_separately" in options) is null)
            && options["capture_stderr_separately"] == "true";

        if (!_captureStreamsIndependently)
        {
            _output = new StreamOutput(File.tmpfile());

            if ("decorated" in options)
            {
                _output.setDecorated(options["decorated"] == "true");
            }

            if ("verbosity" in options)
            {
                _output.setVerbosity(to!int(options["verbosity"]));
            }
        }
        else
        {
            //            $this->output = new ConsoleOutput(
            //                isset($options['verbosity']) ? $options['verbosity'] : ConsoleOutput::VERBOSITY_NORMAL,
            //                isset($options['decorated']) ? $options['decorated'] : null
            //            );
            //            $errorOutput = new StreamOutput(fopen('php://memory', 'w', false));
            //            $errorOutput->setFormatter($this->output->getFormatter());
            //            $errorOutput->setVerbosity($this->output->getVerbosity());
            //            $errorOutput->setDecorated($this->output->isDecorated());
            //            $reflectedOutput = new \ReflectionObject($this->output);
            //            $strErrProperty = $reflectedOutput->getProperty('stderr');
            //            $strErrProperty->setAccessible(true);
            //            $strErrProperty->setValue($this->output, $errorOutput);
            //            $reflectedParent = $reflectedOutput->getParentClass();
            //            $streamProperty = $reflectedParent->getProperty('stream');
            //            $streamProperty->setAccessible(true);
            //            $streamProperty->setValue($this->output, fopen('php://memory', 'w', false));
        }

        _statusCode = _application.run(_input, _output);
        return _statusCode;
    }

    string getDisplay(bool normalize = false)
    {
        (cast(StreamOutput) _output).getStream().rewind();
        StreamOutput streamOutput = cast(StreamOutput) _output;

        string display;
        foreach (line; streamOutput.getStream.byLine())
        {
            display ~= line;
        }

        if (normalize)
        {
            display = display.replace("\r\n", "\n");
            display = display.replace("\r", "\n");
        }

        return display;
    }

private:
    InputInterface _input;
    OutputInterface _output;
    Application _application;
    int _statusCode;
    bool _captureStreamsIndependently;
}
