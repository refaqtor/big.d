/**
* Copyright: 2017 © LLC CERERIS
* License: MIT
* Authors: LLC CERERIS
*/

module big.log.logservicetype;

/** LogService basic types
* See_Also:
*   `big.log.logservice`
*/
enum LogServiceType: string
{
  /// Name of default $(D LogService)
  DEFAULT = "",
  /// Name of $(D LogService) for logging big.d
  BIG_D = "big.d"
}
