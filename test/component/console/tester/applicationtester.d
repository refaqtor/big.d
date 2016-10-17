/**
	Copyright: © 2016 LLC CERERIS
	Authors: Peter Kozhevnikov <kozhevnikov@myriad-corp.com>
	License: Subject to the terms of the MIT license, as written in the included LICENSE.txt file.
*/

module test.component.console.tester.applicationtester;

import big.component.console.application;

class ApplicationTester{
	public:
		this(Application application){
			this.application = application;
		}
		
		int run(){
			
		}
//		    public function run(array $input, $options = array())
//    {
//        $this->input = new ArrayInput($input);
//        if (isset($options['interactive'])) {
//            $this->input->setInteractive($options['interactive']);
//        }
//        $this->captureStreamsIndependently = array_key_exists('capture_stderr_separately', $options) && $options['capture_stderr_separately'];
//        if (!$this->captureStreamsIndependently) {
//            $this->output = new StreamOutput(fopen('php://memory', 'w', false));
//            if (isset($options['decorated'])) {
//                $this->output->setDecorated($options['decorated']);
//            }
//            if (isset($options['verbosity'])) {
//                $this->output->setVerbosity($options['verbosity']);
//            }
//        } else {
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
//        }
//        return $this->statusCode = $this->application->run($this->input, $this->output);
//    }

		string getDisplay(bool normalize = false){
//        rewind($this->output->getStream());
//        $display = stream_get_contents($this->output->getStream());
	        if(normalize) {
//            $display = str_replace(PHP_EOL, "\n", $display);
	        }
//        return $display;
	    }
		
	private:
		Application application;	
}