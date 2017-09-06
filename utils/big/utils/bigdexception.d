/**
  Copyright: 2017 © LLC CERERIS
  License: MIT
  Authors: LLC CERERIS
*/

module big.utils.bigdexception;

import std.exception;

/// Class is used to generate exceptions associated with the big.d framework
class BigDException : Exception
{
  /** Creates a new instance of Exception.
    
    Params:
      msg = big.d exception message  
  */
  this(string msg, string file = __FILE__, size_t line = __LINE__)
  {
    super(msg, file, line);
  }
}