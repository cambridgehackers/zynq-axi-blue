#include "ushw.h"
#include "dut.h"

int main(int argc, const char **argv)
{
    DUT *dut = DUT::createDUT("foobridge1");
    dut->setParams(0x0fad0000, 0x00000bad);
    return 0;
}
