/**
* Copyright: 2017 © LLC CERERIS
* License: MIT
* Authors: LLC CERERIS
*/

module big.provider.aqmp;

import big.core.application: app;

public import big.provider.aqmp.aqmpclient;
public import big.provider.aqmp.aqmpclientservice;
public import big.provider.aqmp.aqmpclientserviceinitmanager;

/// Provide work aqmp components
//static struct udp
//{
//  /** Return UDPServerService instance (syntactic sugar).
//  * See_Also:
//  *   `big.core.application.app`
//  */
//  static UDPServerService server(in string name = "")
//  {
//    return app().get!UDPServerService(name);
//  }  
//}