/**
	Copyright: © 2016 LLC CERERIS
	Authors: Peter Kozhevnikov <kozhevnikov@myriad-corp.com>
	License: Subject to the terms of the MIT license, as written in the included LICENSE.txt file.
*/

module big.console.terminal;

import std.process;
import std.conv;
import std.stdio;
import std.regex;

class Terminal{
	public:
		int getWidth(){
			if(environment.get("COLUMNS") != null){
				return to!int(environment["COLUMNS"]);
			}
			
			if(this.width == int.init) {
	            this.initDimensions();
	        }

	        return this.width;
	    }
    
	    int getHeight(){
	        if(environment.get("LINES") != null){
	            return to!int(environment["LINES"]);
	        }
	        
	        if(this.height == int.init) {
	            this.initDimensions();
	        }

	        return this.height;
	    }
	    
	private:
	    static void initDimensions(){
	    	version(Windows){
//	    		if (preg_match('/^(\d+)x(\d+)(?: \((\d+)x(\d+)\))?$/', trim(getenv('ANSICON')), $matches)) {
//	                // extract [w, H] from "wxh (WxH)"
//	                // or [w, h] from "wxh"
//	                self::$width = (int) $matches[1];
//	                self::$height = isset($matches[4]) ? (int) $matches[4] : (int) $matches[2];
//	            } elseif (null !== $dimensions = self::getConsoleMode()) {
//	                // extract [w, h] from "wxh"
//	                self::$width = (int) $dimensions[0];
//	                self::$height = (int) $dimensions[1];
//	            }
	    	}
	    	else{
	    		string sttyString = getSttyColumns();
	    		if(sttyString.length > 0){
	    			auto matches = matchAll(sttyString, r"rows.(\d+);.columns.(\d+);");
	    			if(!matches.empty){
	    				width = to!int(matches.front[2]);
	    				height = to!int(matches.front[1]);
	    			}
	    			else{
//	    				if (preg_match('/;.(\d+).rows;.(\d+).columns/i', $sttyString, $matches)) {
//	                // extract [w, h] from "; h rows; w columns"
//	                self::$width = (int) $matches[2];
//	                self::$height = (int) $matches[1];
//	            }
	    			}
	    		}
	    	}
	    }
	    
	    static string getSttyColumns(){
	    	auto stty = executeShell("stty -a | grep columns");
			if(stty.status == 0)
				return stty.output;
				
			return "";
	    }
	    
	private:
		static int width;
	    static int height;
}