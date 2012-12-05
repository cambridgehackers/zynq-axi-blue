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


struct DUTsetBaseMSG : public UshwMessage
{
struct Request {
//fix Adapter.bsv to unreverse these
unsigned int base;

} request;
int channelNumber;
};

void DUT::setBase ( unsigned int base )
{
    DUTsetBaseMSG msg;
    msg.size = sizeof(msg.request) + sizeof(msg.channelNumber);
    msg.channelNumber = baseChannelNumber + 0;
msg.request.base = base;

    p->sendMessage(&msg);
};

struct DUTsetBoundsMSG : public UshwMessage
{
struct Request {
//fix Adapter.bsv to unreverse these
unsigned int bounds;

} request;
int channelNumber;
};

void DUT::setBounds ( unsigned int bounds )
{
    DUTsetBoundsMSG msg;
    msg.size = sizeof(msg.request) + sizeof(msg.channelNumber);
    msg.channelNumber = baseChannelNumber + 1;
msg.request.bounds = bounds;

    p->sendMessage(&msg);
};

struct DUTsetThresholdMSG : public UshwMessage
{
struct Request {
//fix Adapter.bsv to unreverse these
unsigned int threshold;

} request;
int channelNumber;
};

void DUT::setThreshold ( unsigned int threshold )
{
    DUTsetThresholdMSG msg;
    msg.size = sizeof(msg.request) + sizeof(msg.channelNumber);
    msg.channelNumber = baseChannelNumber + 2;
msg.request.threshold = threshold;

    p->sendMessage(&msg);
};

struct DUTsetEnabledMSG : public UshwMessage
{
struct Request {
//fix Adapter.bsv to unreverse these
unsigned int v;

} request;
int channelNumber;
};

void DUT::setEnabled ( unsigned int v )
{
    DUTsetEnabledMSG msg;
    msg.size = sizeof(msg.request) + sizeof(msg.channelNumber);
    msg.channelNumber = baseChannelNumber + 3;
msg.request.v = v;

    p->sendMessage(&msg);
};

struct DUTenqMSG : public UshwMessage
{
struct Request {
//fix Adapter.bsv to unreverse these
unsigned int v;

} request;
int channelNumber;
};

void DUT::enq ( unsigned int v )
{
    DUTenqMSG msg;
    msg.size = sizeof(msg.request) + sizeof(msg.channelNumber);
    msg.channelNumber = baseChannelNumber + 4;
msg.request.v = v;

    p->sendMessage(&msg);
};

struct DUTreadFifoStatusMSG : public UshwMessage
{
struct Request {
//fix Adapter.bsv to unreverse these
unsigned int addr;

} request;
int channelNumber;
};

void DUT::readFifoStatus ( unsigned int addr )
{
    DUTreadFifoStatusMSG msg;
    msg.size = sizeof(msg.request) + sizeof(msg.channelNumber);
    msg.channelNumber = baseChannelNumber + 5;
msg.request.addr = addr;

    p->sendMessage(&msg);
};

struct DUTreadRangeMSG : public UshwMessage
{
struct Request {
//fix Adapter.bsv to unreverse these
unsigned int addr;

} request;
int channelNumber;
};

void DUT::readRange ( unsigned int addr )
{
    DUTreadRangeMSG msg;
    msg.size = sizeof(msg.request) + sizeof(msg.channelNumber);
    msg.channelNumber = baseChannelNumber + 6;
msg.request.addr = addr;

    p->sendMessage(&msg);
};

struct DUTreadFromFifoStatusMSG : public UshwMessage
{
struct Request {
//fix Adapter.bsv to unreverse these
unsigned int addr;

} request;
int channelNumber;
};

void DUT::readFromFifoStatus ( unsigned int addr )
{
    DUTreadFromFifoStatusMSG msg;
    msg.size = sizeof(msg.request) + sizeof(msg.channelNumber);
    msg.channelNumber = baseChannelNumber + 7;
msg.request.addr = addr;

    p->sendMessage(&msg);
};
