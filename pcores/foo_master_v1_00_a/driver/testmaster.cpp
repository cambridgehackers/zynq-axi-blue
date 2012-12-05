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

int main(int argc, const char **argv)
{
    fprintf(stderr, "%s:%d\n", __FUNCTION__, __LINE__);
    dut = DUT::createDUT("foomaster0");
    fprintf(stderr, "%s:%d dut=%p\n", __FUNCTION__, __LINE__, dut);

    unsigned long base = ushw.alloc(4096);
    unsigned long bound = base + 4096;
    dut->setBase(base);
    dut->setBounds(bound);
    dut->setEnabled(1);
    if (1)
    for (int w = 0; w < 16; w++) {
      dut->enq(0x5ace0000 + w);
    }
    if (0)
    for (int i = 0; i < 13; i++) {
      dut->readFifoStatus(i*4);
    }
    if (1)
    dut->readRange(base);
    if (0)
    for (int i = 0; i < 13; i++) {
      dut->readFromFifoStatus(i*4);
    }

    ushw.exec();
    fprintf(stderr, "%s:%d\n", __FUNCTION__, __LINE__);
    return 0;
}
