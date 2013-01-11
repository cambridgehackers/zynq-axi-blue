#include "ushw.h"
#include "DUT.h"
#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <sys/types.h>
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
const char *si570path = "/sys/devices/amba.0/e0004000.i2c/i2c-0/i2c-1/1-005d/frequency";


int idleCalls = 0;

long bases[2];
long *fbs[2];

long newColor[4] = {
    0x000000ff,
    0x0000ff00,
    0x00ff0000,
    0xffffffff
};
unsigned long line = 0;
unsigned long nlines = 1080;
unsigned long npixels = 1920;

int updateFrequency(long frequency)
{
    int fd = open(si570path, O_RDWR);
    fprintf(stderr, "updateFrequency fd=%d freq=%d\n", fd, frequency);
    if (fd < 0)
        return errno;
    char freqstring[32];
    snprintf(freqstring, sizeof(freqstring), "%d", frequency);
    int rc = write(fd, freqstring, strlen(freqstring));
    if (rc < 0)
        return errno;
    close(fd);
    return 0;
}

void idleFunc(void)
{
    if (idleCalls++ == 0) {
        //dut->readRange(0x8000);
        if (nlines != 1080 || npixels != 1920) {
            unsigned short vsyncwidth = 5;
            unsigned short lmin = 40;
            unsigned short lmax = lmin + nlines;
            unsigned short pmin = 192;
            unsigned short pmax = pmin + npixels;
            dut->hdmiLinesPixels((pmin + npixels) << 16 | (lmin + vsyncwidth + nlines));
            dut->hdmiLineCountMinMax(lmax << 16 | lmin);
            dut->hdmiPixelCountMinMax(pmax << 16 | pmin);
            updateFrequency(60l * (long)(pmin + npixels) * (long)(lmin + vsyncwidth + nlines));
            //dut->hdmiSyncWidths(hsyncWidth << 16 | vsyncWidth);
        }
        dut->startFrameBuffer(bases[0]);
        dut->startFrameBuffer(bases[0]); // there was a bug that we had to start it twice
    }

    //dut->startFrameBuffer(bases[idleCalls & 1]);
    if (line < nlines/2) {
        for (int j = 0; j < 1920; j++) {
            fbs[0][line*1920+j] = newColor[(line >> 6) & 3];
        }
        line++;
    }
}

int main(int argc, char **argv)
{
    const char *devname = "foomaster0";
    void *fb0 = 0;
    void *fb = 0;
    if (argc > 1) {
        int opt;
        while ((opt = getopt(argc, argv, "f:l:p:")) != -1) {
            switch (opt) {
            case 'f':
                fb0 = (void*)strtoul(optarg, NULL, 0);
              break;
            case 'l':
              nlines = strtoul(optarg, NULL, 0);
              break;
            case 'p':
              npixels = strtoul(optarg, NULL, 0);
              break;
            }
        }
    }
    fprintf(stderr, "%s:%d\n", __FUNCTION__, __LINE__);
    dut = DUT::createDUT(devname);
    fprintf(stderr, "%s:%d dut=%p\n", __FUNCTION__, __LINE__, dut);

    unsigned long fbsize = npixels*nlines*2;
    int fd = 0;
    unsigned long base = 0;
    portal.alloc(fbsize, &fd, &base);
    fprintf(stderr, "fbsize=%ld fd=%d base=%lx\n", fbsize, fd, base);
    if (!fd)
        return -errno;
    bases[0] = base;

    fb = mmap(0, fbsize, PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);
    fprintf(stderr, "%s:%d fd=%d fbptr=%p\n", __FUNCTION__, __LINE__, fd, fb);
    if (fb != MAP_FAILED)
        memset(fb, 0, fbsize);
    else
        fprintf(stderr, "mmap failed errno=%d:%s\n", errno, strerror(errno));

    if (fb != MAP_FAILED) {
      fprintf(stderr, "%s:%d starting frame buffer=%p\n", __FUNCTION__, __LINE__, fb);

      long *longp = (long *)fb;
      fbs[0] = longp;
      fbs[1] = longp;
      fprintf(stderr, "%s:%d\n", __FUNCTION__, __LINE__);
      for (int i = 0; i < fbsize/4; i++) {
        longp[i] = 0x0000ff00;
      }
    }
    {
      unsigned long fbsize = 1920*1080*4;
      int fd = 0;
      unsigned long base = 0;
      portal.alloc(fbsize, &fd, &base);
      if (fd) {
          bases[1] = base;
          void *fb2 = mmap(0, fbsize, PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);
          long *longp = (long *)fb2;
          fbs[1] = longp;
          for (int i = 0; i < fbsize/4; i++) {
              longp[i] = 0x00FF0000;
          }
      }
    }
    fprintf(stderr, "%s:%d\n", __FUNCTION__, __LINE__);
    portal.exec(idleFunc);
    return 0;
}
