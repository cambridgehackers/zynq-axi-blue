#include "ushw.h"
#include "DUT.h"
#include <stdio.h>

struct ResultIorMsg : public UshwMessage
{
struct Response {
//fix Adapter.bsv to unreverse these
int value;
int responseChannel;
} response;
};

DUT *dut = 0;
void handleIorResponse(UshwMessage *msg)
{
    struct ResultIorMsg *responseMsg = (struct ResultIorMsg *)msg;
    fprintf(stderr, "Ior returned %08x\n", responseMsg->response.value);
    unsigned int args[2] = { 0x0f0d0000, 0x00047bed };
    if (dut)
      dut->iorShift(args[0], args[1]);
}

void handleIorShiftResponse(UshwMessage *msg)
{
    struct ResultIorMsg *responseMsg = (struct ResultIorMsg *)msg;
    fprintf(stderr, "IorShift returned %08x\n", responseMsg->response.value);
    unsigned int args[2] = { 0x0fad0000, 0x00093bad };
    if (dut)
      dut->ior(args[0], args[1]);
}

int main(int argc, const char **argv)
{
    fprintf(stderr, "%s:%d\n", __FUNCTION__, __LINE__);
    dut = DUT::createDUT("foobridge1");
    fprintf(stderr, "%s:%d dut=%p\n", __FUNCTION__, __LINE__, dut);
    
    dut->connectHandler(DUT::IorResponseChannel, handleIorResponse);
    fprintf(stderr, "%s:%d\n", __FUNCTION__, __LINE__);
    dut->connectHandler(DUT::IorShiftResponseChannel, handleIorShiftResponse);
    fprintf(stderr, "%s:%d\n", __FUNCTION__, __LINE__);

    unsigned int args[2] = { 0x0fad0000, 0x00093bad };
    dut->ior(args[0], args[1]);

    fprintf(stderr, "ior(%08x, %08x)\n", args[0], args[1]);

    fprintf(stderr, "%s:%d\n", __FUNCTION__, __LINE__);
    ushw.exec();
    fprintf(stderr, "%s:%d\n", __FUNCTION__, __LINE__);
    return 0;
}
