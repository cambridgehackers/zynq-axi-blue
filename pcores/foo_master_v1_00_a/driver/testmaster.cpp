#include "ushw.h"
#include "DUT.h"
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

struct ResultIorMsg : public UshwMessage
{
struct Response {
//fix Adapter.bsv to unreverse these
int value;
int responseChannel;
} response;
};

DUT *dut = 0;

int main(int argc, char **argv)
{
    const char *devname = "foomaster0";
    int config = 0;
    int doWrite = 1;
    int doRead = 1;
    int verbose = 0;
    int doTest = 0;
    if (argc > 1) {
        int opt;
        while ((opt = getopt(argc, argv, "c:d:r:t:vw:")) != -1) {
            switch (opt) {
            case 'c':
                config = atoi(optarg);
                break;
            case 'd':
                devname = optarg;
                break;
            case 'r':
                doRead = atoi(optarg);
                break;
            case 't':
                doTest = atoi(optarg);
                break;
            case 'w':
                doWrite = atoi(optarg);
                break;
            case 'v':
                verbose = 1;
                break;
            }
        }
    }
    fprintf(stderr, "%s:%d\n", __FUNCTION__, __LINE__);
    dut = DUT::createDUT(devname);
    fprintf(stderr, "%s:%d dut=%p\n", __FUNCTION__, __LINE__, dut);

    unsigned long base = ushw.alloc(4096);
    unsigned long bound = base + 4096;
    dut->setBase(base);
    dut->setBounds(bound);
    dut->setEnabled(1);
    if (config)
        dut->configure(config);
    if (doTest) {
        dut->runTest(doTest);
        if (verbose)
            for (int i = 0; i < 13; i++) {
                dut->readFifoStatus(i*4);
            }
        if (verbose)
            for (int i = 0; i < 13; i++) {
                dut->readFromFifoStatus(i*4);
            }
    } else {
        if (doWrite)
            for (int w = 0; w < 16; w++) {
                dut->enq(0x5ace0000 + w);
            }
        if (verbose)
            for (int i = 0; i < 13; i++) {
                dut->readFifoStatus(i*4);
            }
        if (doRead)
            dut->readRange(base);
        if (verbose)
            for (int i = 0; i < 13; i++) {
                dut->readFromFifoStatus(i*4);
            }
    }
    ushw.exec();
    fprintf(stderr, "%s:%d\n", __FUNCTION__, __LINE__);
    return 0;
}
