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
}
DUT::~DUT()
{
    p->close();
}


struct DUTiorMSG : public UshwMessage
{
struct Request {
int channelNumber;
unsigned int a;
unsigned int b;

} request;
struct Response {
int responseChannel;
int response;
} response;
};

int DUT::ior ( unsigned int a, unsigned int b )
{
    DUTiorMSG msg;
    msg.argsize = sizeof(msg.request);
    msg.resultsize = sizeof(msg.response);
    msg.request.channelNumber = baseChannelNumber + 0;
msg.request.a = a;
msg.request.b = b;

    p->sendMessage(&msg);
    return msg.response.response;
};

struct DUTiorShiftMSG : public UshwMessage
{
struct Request {
int channelNumber;
unsigned int x;
unsigned int y;

} request;
struct Response {
int responseChannel;
int response;
} response;
};

int DUT::iorShift ( unsigned int x, unsigned int y )
{
    DUTiorShiftMSG msg;
    msg.argsize = sizeof(msg.request);
    msg.resultsize = sizeof(msg.response);
    msg.request.channelNumber = baseChannelNumber + 1;
msg.request.x = x;
msg.request.y = y;

    p->sendMessage(&msg);
    return msg.response.response;
};

struct DUTresultMSG : public UshwMessage
{
struct Request {
int channelNumber;

} request;
struct Response {
int responseChannel;
unsigned int response;
} response;
};

unsigned int DUT::result (  )
{
    DUTresultMSG msg;
    msg.argsize = sizeof(msg.request);
    msg.resultsize = sizeof(msg.response);
    msg.request.channelNumber = baseChannelNumber + 2;

    p->sendMessage(&msg);
    return msg.response.response;
};
