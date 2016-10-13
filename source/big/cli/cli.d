import std.stdio;

import application;

string temp;

int main(string[] args)
{
	auto application = new Application;
	return application.run(args);
}