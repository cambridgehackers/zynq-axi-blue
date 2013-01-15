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
long numEntries[2];

long newColor[4] = {
    0x000000ff,
    0x0000ff00,
    0x00ff0000,
    0xffffffff
};
unsigned long line = 0;
unsigned long nlines = 1080;
unsigned long npixels = 1920;
unsigned short stridebytes = (4*npixels + 31) & ~31;

int updateFrequency(long frequency)
{
    int fd = open(si570path, O_RDWR);
    fprintf(stderr, "updateFrequency fd=%d freq=%ld\n", fd, frequency);
    if (fd < 0)
        return errno;
    char freqstring[32];
    snprintf(freqstring, sizeof(freqstring), "%ld", frequency);
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
        if (1) {
            unsigned short vsyncwidth = 5;
            unsigned short lmin = 40;
            unsigned short lmax = lmin + nlines;
            unsigned short pmin = 192;
            unsigned short pmax = pmin + npixels;
            dut->hdmiLinesPixels((pmin + npixels) << 16 | (lmin + vsyncwidth + nlines));
            dut->hdmiStrideBytes(stridebytes);
            dut->hdmiLineCountMinMax(lmax << 16 | lmin);
            dut->hdmiPixelCountMinMax(pmax << 16 | pmin);
            updateFrequency(60l * (long)(pmin + npixels) * (long)(lmin + vsyncwidth + nlines));
            //dut->hdmiSyncWidths(hsyncWidth << 16 | vsyncWidth);
            dut->startFrameBuffer(bases[0]);
        }
    }

    //dut->startFrameBuffer(bases[idleCalls & 1]);
    if (line < nlines/2) {
        for (int j = 0; j < 1920; j++) {
            fbs[0][line*1920+j] = newColor[(line >> 6) & 3];
        }
        line++;
    }
}

void handleVsyncMessage(PortalMessage *msg)
{
    long *lmsg = (long *)msg;
    fprintf(stderr, "vsync %d\n", lmsg[1]);
}

void handleNextEntMessage(PortalMessage *msg)
{
    long *lmsg = (long *)msg;
    long w2=lmsg[2];
    if (0) fprintf(stderr, "size=%d w1=%lx w2=%lx\n", msg->size, lmsg[1], w2);
    if (w2 == 0xffffff) {
        int base = bases[idleCalls++ & 1];
        //fprintf(stderr, "starting frame buffer base=%x\n", base);
        //dut->startFrameBuffer(base);
    }
    dut->waitForVsync(0);
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
                stridebytes = (npixels*4+31) & ~31L;
                break;
            }
        }
    }
    fprintf(stderr, "%s:%d\n", __FUNCTION__, __LINE__);
    dut = DUT::createDUT(devname);
    fprintf(stderr, "%s:%d dut=%p nlines=%d npixels=%d stridebytes=%d\n",
            __FUNCTION__, __LINE__, dut, nlines, npixels, stridebytes);

    unsigned long fbsize = nlines*stridebytes;
    int fd = 0;
    PortalAlloc portalAlloc;
    memset(&portalAlloc, 0, sizeof(portalAlloc));
    portal.alloc(fbsize, &fd, &portalAlloc);
    fprintf(stderr, "fbsize=%ld fd=%d base=%lx length=%lx numEntries=%d\n", fbsize, fd,
            portalAlloc.entries[0].dma_address, portalAlloc.entries[0].length, portalAlloc.numEntries);
    if (!fd)
        return -errno;
    bases[0] = 0x10000;
    numEntries[0] = portalAlloc.numEntries;

    dut->beginTranslationTable(0);
    for (int i = 0; i < portalAlloc.numEntries; i++) {
        unsigned long entry = ((portalAlloc.entries[i].dma_address&0xFFFFF000)
                               | ((portalAlloc.entries[i].length >> 12)&0x00000FFF));
        dut->addTranslationEntry(portalAlloc.entries[i].dma_address >> 12,
                                 portalAlloc.entries[i].length >> 12);
    }

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
        for (unsigned long line = 0; line < nlines; line++) {
            for (unsigned long pixel = 0; pixel < npixels; pixel++) {
                unsigned char blue = 255 * line / nlines;
                unsigned char green = 0; //255 * line / nlines;
                unsigned char red = 255 * pixel / npixels;
                int color = (red << 16) | (green << 8) | blue;
                longp[line * stridebytes/4 + pixel] = color;
            }
        }
    }
    if (0) {
        unsigned long fbsize = nlines*stridebytes;
        int fd = 0;
        PortalAlloc portalAlloc;
        portal.alloc(fbsize, &fd, &portalAlloc);
        if (fd) {
            fprintf(stderr, "Allocated second fb fd=%d numEntries=%d\n", fd, portalAlloc.numEntries);
            dut->beginTranslationTable(numEntries[0]);
            for (int i = 0; i < portalAlloc.numEntries; i++) {
                dut->addTranslationEntry(portalAlloc.entries[i].dma_address >> 12, 
                                         portalAlloc.entries[i].length >> 12);
            }

            bases[1] = numEntries[0];
            numEntries[1] = portalAlloc.numEntries;

            void *fb2 = mmap(0, fbsize, PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);
            long *longp = (long *)fb2;
            fbs[1] = longp;
            for (unsigned long i = 0; i < fbsize/4; i++) {
                longp[i] = 0x00FF0000;
            }
        }
    }
    fprintf(stderr, "%s:%d\n", __FUNCTION__, __LINE__);
    dut->connectHandler(DUT::FbReadingResponseChannel, handleNextEntMessage);
    dut->connectHandler(DUT::VsyncReceivedResponseChannel, handleVsyncMessage);
    portal.exec(idleFunc);
    return 0;
}
