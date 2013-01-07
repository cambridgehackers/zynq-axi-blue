#include "ushw.h"
#include "DUT.h"
#include <sys/mman.h>
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
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

int idleCalls = 0;

long bases[2];

void idleFunc(void)
{
  if (idleCalls++ == 30) {
    //dut->readRange(0x8000);
  }
    dut->startFrameBuffer(bases[idleCalls & 1]);
}

int main(int argc, char **argv)
{
    const char *devname = "foomaster0";
    void *fb0 = 0;
    void *fb = 0;
    int pattern = 0;
    if (argc > 1) {
        int opt;
        while ((opt = getopt(argc, argv, "f:p:")) != -1) {
            switch (opt) {
            case 'f':
                fb0 = (void*)strtoul(optarg, NULL, 0);
              break;
            case 'p':
              pattern = strtoul(optarg, NULL, 0);
              break;
            }
        }
    }
    fprintf(stderr, "%s:%d\n", __FUNCTION__, __LINE__);
    dut = DUT::createDUT(devname);
    fprintf(stderr, "%s:%d dut=%p\n", __FUNCTION__, __LINE__, dut);

    unsigned long fbsize = 1920*1080*2;
    int fd = 0;
    unsigned long base = 0;
    portal.alloc(fbsize, &fd, &base);
    fprintf(stderr, "fbsize=%ld fd=%d base=%lx\n", fbsize, fd, base);
    bases[0] = base;

    if (pattern) {
      fprintf(stderr, "%s:%d setting pattern=%lx\n", __FUNCTION__, __LINE__, pattern);
      dut->setPatternReg(pattern);
    }
    fb = mmap(0, fbsize, PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);
    fprintf(stderr, "%s:%d fbptr=%p\n", __FUNCTION__, __LINE__, fb);
    if (fb != MAP_FAILED)
        memset(fb, 0, fbsize);
    else
        fprintf(stderr, "mmap failed errno=%d:%s\n", errno, strerror(errno));

    dut->readRange((long)fb0);
    if (fb != MAP_FAILED) {
      fprintf(stderr, "%s:%d starting frame buffer=%p\n", __FUNCTION__, __LINE__, fb);
      dut->startFrameBuffer(base);

      long *longp = (long *)fb;
      fprintf(stderr, "%s:%d\n", __FUNCTION__, __LINE__);
      for (int i = 0; i < fbsize/4; i++) {
        longp[i] = 0xff1d6b1d;
      }
      for (int i = 0; i < fbsize/4; i++) {
        longp[i] = 0x2c961596;
      }
    }
    {
      unsigned long fbsize = 1920*1080*2;
      int fd = 0;
      unsigned long base = 0;
      portal.alloc(fbsize, &fd, &base);
      bases[1] = base;
      void *fb2 = mmap(0, fbsize, PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);
      long *longp = (long *)fb2;
      for (int i = 0; i < fbsize/4; i++) {
        longp[i] = 0xff1d6b1d;
      }
    }
    fprintf(stderr, "%s:%d\n", __FUNCTION__, __LINE__);
    dut->readRange((long)base);
    portal.exec(idleFunc);
    return 0;
}
