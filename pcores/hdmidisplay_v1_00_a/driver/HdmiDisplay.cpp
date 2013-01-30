#include "ushw.h"
#include "HdmiDisplay.h"

HdmiDisplay *HdmiDisplay::createHdmiDisplay(const char *instanceName)
{
    PortalInstance *p = portalOpen(instanceName);
    HdmiDisplay *instance = new HdmiDisplay(p);
    return instance;
}

HdmiDisplay::HdmiDisplay(PortalInstance *p, int baseChannelNumber)
 : p(p), baseChannelNumber(baseChannelNumber)
{
  p->messageHandlers = new PortalInstance::MessageHandler [HdmiDisplay::HdmiDisplayNumChannels]();
}
HdmiDisplay::~HdmiDisplay()
{
    p->close();
}


struct HdmiDisplaysetPatternRegMSG : public PortalMessage
{
struct Request {
//fix Adapter.bsv to unreverse these
unsigned int yuv422;

} request;
int channelNumber;
};

void HdmiDisplay::setPatternReg ( unsigned int yuv422 )
{
    HdmiDisplaysetPatternRegMSG msg;
    msg.size = sizeof(msg.request) + sizeof(msg.channelNumber);
    msg.channelNumber = baseChannelNumber + 0;
msg.request.yuv422 = yuv422;

    p->sendMessage(&msg);
};

struct HdmiDisplaystartFrameBufferMSG : public PortalMessage
{
struct Request {
//fix Adapter.bsv to unreverse these
unsigned int base;

} request;
int channelNumber;
};

void HdmiDisplay::startFrameBuffer ( unsigned int base )
{
    HdmiDisplaystartFrameBufferMSG msg;
    msg.size = sizeof(msg.request) + sizeof(msg.channelNumber);
    msg.channelNumber = baseChannelNumber + 1;
msg.request.base = base;

    p->sendMessage(&msg);
};

struct HdmiDisplaywaitForVsyncMSG : public PortalMessage
{
struct Request {
//fix Adapter.bsv to unreverse these
unsigned int unused;

} request;
int channelNumber;
};

void HdmiDisplay::waitForVsync ( unsigned int unused )
{
    HdmiDisplaywaitForVsyncMSG msg;
    msg.size = sizeof(msg.request) + sizeof(msg.channelNumber);
    msg.channelNumber = baseChannelNumber + 2;
msg.request.unused = unused;

    p->sendMessage(&msg);
};

struct HdmiDisplayhdmiLinesPixelsMSG : public PortalMessage
{
struct Request {
//fix Adapter.bsv to unreverse these
unsigned int value;

} request;
int channelNumber;
};

void HdmiDisplay::hdmiLinesPixels ( unsigned int value )
{
    HdmiDisplayhdmiLinesPixelsMSG msg;
    msg.size = sizeof(msg.request) + sizeof(msg.channelNumber);
    msg.channelNumber = baseChannelNumber + 3;
msg.request.value = value;

    p->sendMessage(&msg);
};

struct HdmiDisplayhdmiBlankLinesPixelsMSG : public PortalMessage
{
struct Request {
//fix Adapter.bsv to unreverse these
unsigned int value;

} request;
int channelNumber;
};

void HdmiDisplay::hdmiBlankLinesPixels ( unsigned int value )
{
    HdmiDisplayhdmiBlankLinesPixelsMSG msg;
    msg.size = sizeof(msg.request) + sizeof(msg.channelNumber);
    msg.channelNumber = baseChannelNumber + 4;
msg.request.value = value;

    p->sendMessage(&msg);
};

struct HdmiDisplayhdmiStrideBytesMSG : public PortalMessage
{
struct Request {
//fix Adapter.bsv to unreverse these
unsigned int strideBytes;

} request;
int channelNumber;
};

void HdmiDisplay::hdmiStrideBytes ( unsigned int strideBytes )
{
    HdmiDisplayhdmiStrideBytesMSG msg;
    msg.size = sizeof(msg.request) + sizeof(msg.channelNumber);
    msg.channelNumber = baseChannelNumber + 5;
msg.request.strideBytes = strideBytes;

    p->sendMessage(&msg);
};

struct HdmiDisplayhdmiLineCountMinMaxMSG : public PortalMessage
{
struct Request {
//fix Adapter.bsv to unreverse these
unsigned int value;

} request;
int channelNumber;
};

void HdmiDisplay::hdmiLineCountMinMax ( unsigned int value )
{
    HdmiDisplayhdmiLineCountMinMaxMSG msg;
    msg.size = sizeof(msg.request) + sizeof(msg.channelNumber);
    msg.channelNumber = baseChannelNumber + 6;
msg.request.value = value;

    p->sendMessage(&msg);
};

struct HdmiDisplayhdmiPixelCountMinMaxMSG : public PortalMessage
{
struct Request {
//fix Adapter.bsv to unreverse these
unsigned int value;

} request;
int channelNumber;
};

void HdmiDisplay::hdmiPixelCountMinMax ( unsigned int value )
{
    HdmiDisplayhdmiPixelCountMinMaxMSG msg;
    msg.size = sizeof(msg.request) + sizeof(msg.channelNumber);
    msg.channelNumber = baseChannelNumber + 7;
msg.request.value = value;

    p->sendMessage(&msg);
};

struct HdmiDisplayhdmiSyncWidthsMSG : public PortalMessage
{
struct Request {
//fix Adapter.bsv to unreverse these
unsigned int value;

} request;
int channelNumber;
};

void HdmiDisplay::hdmiSyncWidths ( unsigned int value )
{
    HdmiDisplayhdmiSyncWidthsMSG msg;
    msg.size = sizeof(msg.request) + sizeof(msg.channelNumber);
    msg.channelNumber = baseChannelNumber + 8;
msg.request.value = value;

    p->sendMessage(&msg);
};

struct HdmiDisplaybeginTranslationTableMSG : public PortalMessage
{
struct Request {
//fix Adapter.bsv to unreverse these
unsigned int index:8;

} request;
int channelNumber;
};

void HdmiDisplay::beginTranslationTable ( unsigned int index )
{
    HdmiDisplaybeginTranslationTableMSG msg;
    msg.size = sizeof(msg.request) + sizeof(msg.channelNumber);
    msg.channelNumber = baseChannelNumber + 9;
msg.request.index = index;

    p->sendMessage(&msg);
};

struct HdmiDisplayaddTranslationEntryMSG : public PortalMessage
{
struct Request {
//fix Adapter.bsv to unreverse these
unsigned int length:12;
unsigned int address:20;

} request;
int channelNumber;
};

void HdmiDisplay::addTranslationEntry ( unsigned int address, unsigned int length )
{
    HdmiDisplayaddTranslationEntryMSG msg;
    msg.size = sizeof(msg.request) + sizeof(msg.channelNumber);
    msg.channelNumber = baseChannelNumber + 10;
msg.request.address = address;
msg.request.length = length;

    p->sendMessage(&msg);
};
