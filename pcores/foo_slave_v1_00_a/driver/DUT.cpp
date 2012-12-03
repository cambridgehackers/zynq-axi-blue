#include "ushw.h"
#include "DUT.h"

DUT *DUT::createDUT(const char *instanceName)
{
    UshwInstance *p = ushwOpen(instanceName);
    DUT *instance = new DUT(p);
    return instance;
}

DUT::DUT(UshwInstance *p, int baseChannelNumber)
 : p(p), baseChannelNumber(baseChannelNumber)
{
  p->messageHandlers = new UshwInstance::MessageHandler [DUT::DUTNumChannels]();
}
DUT::~DUT()
{
    p->close();
}


struct DUTiorMSG : public UshwMessage
{
struct Request {
//fix Adapter.bsv to unreverse these
unsigned int b;
unsigned int a;

} request;
int channelNumber;
};

void DUT::ior ( unsigned int a, unsigned int b )
{
    DUTiorMSG msg;
    msg.size = sizeof(msg.request) + sizeof(msg.channelNumber);
    msg.channelNumber = baseChannelNumber + 0;
msg.request.a = a;
msg.request.b = b;

    p->sendMessage(&msg);
};

struct DUTiorShiftMSG : public UshwMessage
{
struct Request {
//fix Adapter.bsv to unreverse these
unsigned int y;
unsigned int x;

} request;
int channelNumber;
};

void DUT::iorShift ( unsigned int x, unsigned int y )
{
    DUTiorShiftMSG msg;
    msg.size = sizeof(msg.request) + sizeof(msg.channelNumber);
    msg.channelNumber = baseChannelNumber + 1;
msg.request.x = x;
msg.request.y = y;

    p->sendMessage(&msg);
};
