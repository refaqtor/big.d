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

module big.component.console;

class Application{
	public:
		this(string applicationName, string applicationVersion){
			this.applicationName = applicationName;
			this.applicationVersion = applicationVersion;
		}
		
	private:
		string applicationName;
		string applicationVersion;	
}