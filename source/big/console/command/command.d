module big.console.command.command;

class Command{
	public:
		this(string type){
			this.type = type;
		}
	
		abstract void execute(string[] arguments);
		
		string getType(){
			return this.type;
		}
		
	private:
		string type;
		string description;
}