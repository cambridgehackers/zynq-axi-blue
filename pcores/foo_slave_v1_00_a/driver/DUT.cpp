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
//fix Adapter.bsv to unreverse these
unsigned int b;
unsigned int a;

int channelNumber;
} request;
struct Response {
//fix Adapter.bsv to unreverse these
int response;
int responseChannel;
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
//fix Adapter.bsv to unreverse these
unsigned int y;
unsigned int x;

int channelNumber;
} request;
struct Response {
//fix Adapter.bsv to unreverse these
int response;
int responseChannel;
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

struct DUTresultIorShiftMSG : public UshwMessage
{
struct Request {
//fix Adapter.bsv to unreverse these

int channelNumber;
} request;
struct Response {
//fix Adapter.bsv to unreverse these
unsigned int response;
int responseChannel;
} response;
};

unsigned int DUT::resultIorShift (  )
{
    DUTresultIorShiftMSG msg;
    msg.argsize = sizeof(msg.request);
    msg.resultsize = sizeof(msg.response);
    msg.request.channelNumber = baseChannelNumber + 2;

    p->sendMessage(&msg);
    return msg.response.response;
};

struct DUTresultMSG : public UshwMessage
{
struct Request {
//fix Adapter.bsv to unreverse these

int channelNumber;
} request;
struct Response {
//fix Adapter.bsv to unreverse these
unsigned int response;
int responseChannel;
} response;
};

unsigned int DUT::result (  )
{
    DUTresultMSG msg;
    msg.argsize = sizeof(msg.request);
    msg.resultsize = sizeof(msg.response);
    msg.request.channelNumber = baseChannelNumber + 3;

    p->sendMessage(&msg);
    return msg.response.response;
};
