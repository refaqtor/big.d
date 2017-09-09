/**
* Copyright: 2017 © LLC CERERIS
* License: MIT
* Authors: LLC CERERIS
* See_Also: 
*   `big.provider.udp.udpserver`
*   `big.provider.udp.udpserverservice`
*   `big.provider.udp.udpserverserviceinitmanager`
*/

module big.provider.udp;

import big.core.application: app;

public import big.provider.udp.udpserver;
public import big.provider.udp.udpserverservice;
public import big.provider.udp.udpserverserviceinitmanager;

/// Provide work with udp components
static struct udp
{
  /** Return UDPServerService instance (syntactic sugar).
  * See_Also:
  *   `big.core.application.app`
  */
  static UDPServerService server(in string name = "")
  {
    return app().get!UDPServerService(name);
  }  
}