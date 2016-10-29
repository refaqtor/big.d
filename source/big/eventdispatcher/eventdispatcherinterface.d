module big.eventdispatcher.eventdispatcherinterface;

import big.eventdispatcher;

interface EventDispatcherInterface
{
public:
    void dispatch(string eventName, Event event = null);
}
