#include "ushw.h"
#include "DUT.h"

int main(int argc, const char **argv)
{
    DUT *dut = DUT::createDUT("foobridge1");
    dut->ior(0x0fad0000, 0x00000bad);
    dut->iorShift(0x0fad0000, 0x00000bad);
    return 0;
}
