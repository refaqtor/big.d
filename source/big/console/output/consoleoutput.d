/**
	Copyright: © 2016 LLC CERERIS
	Authors: Peter Kozhevnikov <kozhevnikov@myriad-corp.com>
	License: Subject to the terms of the MIT license, as written in the included LICENSE.txt file.
*/

module big.console.output.consoleoutput;

import std.stdio;

import big.console.output;
import big.console.formatter;

class ConsoleOutput : StreamOutput, ConsoleOutputInterface
{
public:
    this(int verbosity = VERBOSITY_NORMAL, bool decorated = false,
        OutputFormatterInterface formatter = null)
    {
        super(this.openOutputStream(), verbosity, decorated, formatter);
        //	        actualDecorated = this.isDecorated();
        ////	        this->stderr = new StreamOutput($this->openErrorStream(), $verbosity, $decorated, $this->getFormatter());
        //	        if(decorated == null){
        ////	            this.setDecorated($actualDecorated && $this->stderr->isDecorated());
        //	        }
    }

    override void setDecorated(bool decorated)
    {
        super.setDecorated(decorated);
        _stderr.setDecorated(decorated);
    }

    override void setFormatter(OutputFormatterInterface formatter)
    {
        super.setFormatter(formatter);
        _stderr.setFormatter(formatter);
    }

    override void setVerbosity(int level)
    {
        super.setVerbosity(level);
        _stderr.setVerbosity(level);
    }

    OutputInterface getErrorOutput()
    {
        return _stderr;
    }

    void setErrorOutput(OutputInterface error)
    {
        _stderr = error;
    }
    //    /**
    //     * Returns true if current environment supports writing console output to
    //     * STDOUT.
    //     *
    //     * @return bool
    //     */
    //    protected function hasStdoutSupport()
    //    {
    //        return false === $this->isRunningOS400();
    //    }
    //    /**
    //     * Returns true if current environment supports writing console output to
    //     * STDERR.
    //     *
    //     * @return bool
    //     */
    //    protected function hasStderrSupport()
    //    {
    //        return false === $this->isRunningOS400();
    //    }
    //    /**
    //     * Checks if current executing environment is IBM iSeries (OS400), which
    //     * doesn't properly convert character-encodings between ASCII to EBCDIC.
    //     *
    //     * @return bool
    //     */
    //    private function isRunningOS400()
    //    {
    //        $checks = array(
    //            function_exists('php_uname') ? php_uname('s') : '',
    //            getenv('OSTYPE'),
    //            PHP_OS,
    //        );
    //        return false !== stripos(implode(';', $checks), 'OS400');
    //    }

private:
    File openOutputStream()
    {
        return stdout;
    }

    File openErrorStream()
    {
        return stderr;
    }

private:
    OutputInterface _stderr;
}
