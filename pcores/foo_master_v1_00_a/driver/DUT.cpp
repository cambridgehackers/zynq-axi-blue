#include "ushw.h"
#include "DUT.h"

DUT *DUT::createDUT(const char *instanceName)
{
    PortalInstance *p = portalOpen(instanceName);
    DUT *instance = new DUT(p);
    return instance;
}

DUT::DUT(PortalInstance *p, int baseChannelNumber)
 : p(p), baseChannelNumber(baseChannelNumber)
{
  p->messageHandlers = new PortalInstance::MessageHandler [DUT::DUTNumChannels]();
}
DUT::~DUT()
{
    p->close();
}


struct DUTsetPatternRegMSG : public PortalMessage
{
struct Request {
//fix Adapter.bsv to unreverse these
unsigned int yuv422;

} request;
int channelNumber;
};

void DUT::setPatternReg ( unsigned int yuv422 )
{
    DUTsetPatternRegMSG msg;
    msg.size = sizeof(msg.request) + sizeof(msg.channelNumber);
    msg.channelNumber = baseChannelNumber + 0;
msg.request.yuv422 = yuv422;

    p->sendMessage(&msg);
};

struct DUTstartFrameBufferMSG : public PortalMessage
{
struct Request {
//fix Adapter.bsv to unreverse these
unsigned int base;

} request;
int channelNumber;
};

void DUT::startFrameBuffer ( unsigned int base )
{
    DUTstartFrameBufferMSG msg;
    msg.size = sizeof(msg.request) + sizeof(msg.channelNumber);
    msg.channelNumber = baseChannelNumber + 1;
msg.request.base = base;

    p->sendMessage(&msg);
};

struct DUTwaitForVsyncMSG : public PortalMessage
{
struct Request {
//fix Adapter.bsv to unreverse these
unsigned int unused;

} request;
int channelNumber;
};

void DUT::waitForVsync ( unsigned int unused )
{
    DUTwaitForVsyncMSG msg;
    msg.size = sizeof(msg.request) + sizeof(msg.channelNumber);
    msg.channelNumber = baseChannelNumber + 2;
msg.request.unused = unused;

    p->sendMessage(&msg);
};

struct DUThdmiLinesPixelsMSG : public PortalMessage
{
struct Request {
//fix Adapter.bsv to unreverse these
unsigned int value;

} request;
int channelNumber;
};

void DUT::hdmiLinesPixels ( unsigned int value )
{
    DUThdmiLinesPixelsMSG msg;
    msg.size = sizeof(msg.request) + sizeof(msg.channelNumber);
    msg.channelNumber = baseChannelNumber + 3;
msg.request.value = value;

    p->sendMessage(&msg);
};

struct DUThdmiBlankLinesPixelsMSG : public PortalMessage
{
struct Request {
//fix Adapter.bsv to unreverse these
unsigned int value;

} request;
int channelNumber;
};

void DUT::hdmiBlankLinesPixels ( unsigned int value )
{
    DUThdmiBlankLinesPixelsMSG msg;
    msg.size = sizeof(msg.request) + sizeof(msg.channelNumber);
    msg.channelNumber = baseChannelNumber + 4;
msg.request.value = value;

    p->sendMessage(&msg);
};

struct DUThdmiStrideBytesMSG : public PortalMessage
{
struct Request {
//fix Adapter.bsv to unreverse these
unsigned int strideBytes;

} request;
int channelNumber;
};

void DUT::hdmiStrideBytes ( unsigned int strideBytes )
{
    DUThdmiStrideBytesMSG msg;
    msg.size = sizeof(msg.request) + sizeof(msg.channelNumber);
    msg.channelNumber = baseChannelNumber + 5;
msg.request.strideBytes = strideBytes;

    p->sendMessage(&msg);
};

struct DUThdmiLineCountMinMaxMSG : public PortalMessage
{
struct Request {
//fix Adapter.bsv to unreverse these
unsigned int value;

} request;
int channelNumber;
};

void DUT::hdmiLineCountMinMax ( unsigned int value )
{
    DUThdmiLineCountMinMaxMSG msg;
    msg.size = sizeof(msg.request) + sizeof(msg.channelNumber);
    msg.channelNumber = baseChannelNumber + 6;
msg.request.value = value;

    p->sendMessage(&msg);
};

struct DUThdmiPixelCountMinMaxMSG : public PortalMessage
{
struct Request {
//fix Adapter.bsv to unreverse these
unsigned int value;

} request;
int channelNumber;
};

void DUT::hdmiPixelCountMinMax ( unsigned int value )
{
    DUThdmiPixelCountMinMaxMSG msg;
    msg.size = sizeof(msg.request) + sizeof(msg.channelNumber);
    msg.channelNumber = baseChannelNumber + 7;
msg.request.value = value;

    p->sendMessage(&msg);
};

struct DUThdmiSyncWidthsMSG : public PortalMessage
{
struct Request {
//fix Adapter.bsv to unreverse these
unsigned int value;

} request;
int channelNumber;
};

void DUT::hdmiSyncWidths ( unsigned int value )
{
    DUThdmiSyncWidthsMSG msg;
    msg.size = sizeof(msg.request) + sizeof(msg.channelNumber);
    msg.channelNumber = baseChannelNumber + 8;
msg.request.value = value;

    p->sendMessage(&msg);
};

struct DUTbeginTranslationTableMSG : public PortalMessage
{
struct Request {
//fix Adapter.bsv to unreverse these
unsigned int index:6;

} request;
int channelNumber;
};

void DUT::beginTranslationTable ( unsigned int index )
{
    DUTbeginTranslationTableMSG msg;
    msg.size = sizeof(msg.request) + sizeof(msg.channelNumber);
    msg.channelNumber = baseChannelNumber + 9;
msg.request.index = index;

    p->sendMessage(&msg);
};

struct DUTaddTranslationEntryMSG : public PortalMessage
{
struct Request {
//fix Adapter.bsv to unreverse these
unsigned int length:12;
unsigned int address:20;

} request;
int channelNumber;
};

void DUT::addTranslationEntry ( unsigned int address, unsigned int length )
{
    DUTaddTranslationEntryMSG msg;
    msg.size = sizeof(msg.request) + sizeof(msg.channelNumber);
    msg.channelNumber = baseChannelNumber + 10;
msg.request.address = address;
msg.request.length = length;

    p->sendMessage(&msg);
};
