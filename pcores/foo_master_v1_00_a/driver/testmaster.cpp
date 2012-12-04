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
    dut->enq(0x5af33d);
    
    ushw.exec();
    fprintf(stderr, "%s:%d\n", __FUNCTION__, __LINE__);
    return 0;
}
