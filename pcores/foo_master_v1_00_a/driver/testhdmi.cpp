#include "ushw.h"
#include "DUT.h"
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

struct ResultIorMsg : public PortalMessage
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
    int pattern = 0;
    if (argc > 1) {
        int opt;
        while ((opt = getopt(argc, argv, "p:")) != -1) {
            switch (opt) {
            case 'p':
              pattern = strtoul(optarg, NULL, 0);
                break;
            }
        }
    }
    fprintf(stderr, "%s:%d\n", __FUNCTION__, __LINE__);
    dut = DUT::createDUT(devname);
    fprintf(stderr, "%s:%d dut=%p\n", __FUNCTION__, __LINE__, dut);

    if (pattern) {
      fprintf(stderr, "%s:%d setting pattern=%lx\n", __FUNCTION__, __LINE__, pattern);
      dut->setPatternReg(pattern);
    }
    //portal.exec();
    fprintf(stderr, "%s:%d\n", __FUNCTION__, __LINE__);
    return 0;
}
