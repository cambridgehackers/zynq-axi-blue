#include "ushw.h"
#include "DUT.h"
#include <stdio.h>

int main(int argc, const char **argv)
{
    DUT *dut = DUT::createDUT("foobridge1");
    unsigned int args[2] = { 0x0fad0000, 0x00093bad };
    int result = dut->ior(args[0], args[1]);
    fprintf(stderr, "ior(%08x, %08x) -> %08x\n", args[0], args[1], result);
    args[0] = 0x0f0d0000;
    args[1] = 0x00047bed;
    result = dut->iorShift(args[0], args[1]);
    fprintf(stderr, "iorShift() -> %08x\n", result);
    return 0;
}
