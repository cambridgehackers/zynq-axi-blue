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


struct DUTsetBaseMSG : public PortalMessage
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

struct DUTsetBoundsMSG : public PortalMessage
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

struct DUTsetThresholdMSG : public PortalMessage
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

struct DUTsetEnabledMSG : public PortalMessage
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

struct DUTenqMSG : public PortalMessage
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

struct DUTreadFifoStatusMSG : public PortalMessage
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

struct DUTconfigureMSG : public PortalMessage
{
  struct Request {
    //fix Adapter.bsv to unreverse these
    unsigned int v;

  } request;
  int channelNumber;
};

void DUT::configure ( unsigned int v )
{
  DUTconfigureMSG msg;
  msg.size = sizeof(msg.request) + sizeof(msg.channelNumber);
  msg.channelNumber = baseChannelNumber + 6;
  msg.request.v = v;

  p->sendMessage(&msg);
};

struct DUTreadRangeMSG : public PortalMessage
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
  msg.channelNumber = baseChannelNumber + 7;
  msg.request.addr = addr;

  p->sendMessage(&msg);
};

struct DUTreadFromFifoStatusMSG : public PortalMessage
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
  msg.channelNumber = baseChannelNumber + 8;
  msg.request.addr = addr;

  p->sendMessage(&msg);
};

struct DUTrunTestMSG : public PortalMessage
{
  struct Request {
    //fix Adapter.bsv to unreverse these
    unsigned int numWords;

  } request;
  int channelNumber;
};

void DUT::runTest ( unsigned int numWords )
{
  DUTrunTestMSG msg;
  msg.size = sizeof(msg.request) + sizeof(msg.channelNumber);
  msg.channelNumber = baseChannelNumber + 9;
  msg.request.numWords = numWords;

  p->sendMessage(&msg);
};

struct DUTrunTest2MSG : public PortalMessage
{
  struct Request {
    //fix Adapter.bsv to unreverse these
    unsigned int base;

  } request;
  int channelNumber;
};

void DUT::runTest2 ( unsigned int base )
{
  DUTrunTest2MSG msg;
  msg.size = sizeof(msg.request) + sizeof(msg.channelNumber);
  msg.channelNumber = baseChannelNumber + 10;
  msg.request.base = base;

  p->sendMessage(&msg);
};

struct DUTsetPatternRegMSG : public PortalMessage
{
  struct Request {
    //fix Adapter.bsv to unreverse these
    unsigned int base;

  } request;
  int channelNumber;
};

void DUT::setPatternReg ( unsigned int base )
{
  DUTsetPatternRegMSG msg;
  msg.size = sizeof(msg.request) + sizeof(msg.channelNumber);
  msg.channelNumber = baseChannelNumber + 11;
  msg.request.base = base;

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
  msg.channelNumber = baseChannelNumber + 12;
  msg.request.base = base;

  p->sendMessage(&msg);
};

struct DUTwaitForVsyncMSG : public PortalMessage
{
  struct Request {
    //fix Adapter.bsv to unreverse these
    unsigned int base;

  } request;
  int channelNumber;
};

void DUT::waitForVsync ( unsigned int base )
{
  DUTwaitForVsyncMSG msg;
  msg.size = sizeof(msg.request) + sizeof(msg.channelNumber);
  msg.channelNumber = baseChannelNumber + 13;
  msg.request.base = base;

  p->sendMessage(&msg);
};
struct DUThdmiLinesPixelsMSG : public PortalMessage
{
  struct Request {
    //fix Adapter.bsv to unreverse these
    unsigned int base;

  } request;
  int channelNumber;
};

void DUT::hdmiLinesPixels ( unsigned int base )
{
  DUThdmiLinesPixelsMSG msg;
  msg.size = sizeof(msg.request) + sizeof(msg.channelNumber);
  msg.channelNumber = baseChannelNumber + 14;
  msg.request.base = base;

  p->sendMessage(&msg);
};
struct DUThdmiBlankLinesPixelsMSG : public PortalMessage
{
  struct Request {
    //fix Adapter.bsv to unreverse these
    unsigned int base;

  } request;
  int channelNumber;
};

void DUT::hdmiBlankLinesPixels ( unsigned int base )
{
  DUThdmiBlankLinesPixelsMSG msg;
  msg.size = sizeof(msg.request) + sizeof(msg.channelNumber);
  msg.channelNumber = baseChannelNumber + 15;
  msg.request.base = base;

  p->sendMessage(&msg);
};
struct DUThdmiLineCountMinMaxMSG : public PortalMessage
{
  struct Request {
    //fix Adapter.bsv to unreverse these
    unsigned int base;

  } request;
  int channelNumber;
};

void DUT::hdmiLineCountMinMax ( unsigned int base )
{
  DUThdmiLineCountMinMaxMSG msg;
  msg.size = sizeof(msg.request) + sizeof(msg.channelNumber);
  msg.channelNumber = baseChannelNumber + 16;
  msg.request.base = base;

  p->sendMessage(&msg);
};
struct DUThdmiPixelCountMinMaxMSG : public PortalMessage
{
  struct Request {
    //fix Adapter.bsv to unreverse these
    unsigned int base;

  } request;
  int channelNumber;
};

void DUT::hdmiPixelCountMinMax ( unsigned int base )
{
  DUThdmiPixelCountMinMaxMSG msg;
  msg.size = sizeof(msg.request) + sizeof(msg.channelNumber);
  msg.channelNumber = baseChannelNumber + 17;
  msg.request.base = base;

  p->sendMessage(&msg);
};
struct DUThdmiSyncWidthsMSG : public PortalMessage
{
  struct Request {
    //fix Adapter.bsv to unreverse these
    unsigned int base;

  } request;
  int channelNumber;
};

void DUT::hdmiSyncWidths ( unsigned int base )
{
  DUThdmiSyncWidthsMSG msg;
  msg.size = sizeof(msg.request) + sizeof(msg.channelNumber);
  msg.channelNumber = baseChannelNumber + 18;
  msg.request.base = base;

  p->sendMessage(&msg);
};
