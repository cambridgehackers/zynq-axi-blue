#include "ushw.h"
#include "dut.h"

DUT *DUT::createDUT(const char *instanceName)
{
    UshwInstance *p = ushwOpen(instanceName);
    DUT *instance = new DUT(p);
    return instance;
}


DUT::DUT(UshwInstance *p)
{
    this->p = p;
}
DUT::~DUT()
{
    p->close();
}


struct DUTsetParamsMSG : public UshwMessage
{
unsigned int a;
unsigned int b;

};

void DUT::setParams ( unsigned int a, unsigned int b )
{
    DUTsetParamsMSG msg;
    msg.argsize = sizeof(msg)-sizeof(UshwMessage);
    msg.resultsize = 0;
msg.a = a;
msg.b = b;

    p->sendMessage(&msg);
};

struct DUTresultMSG : public UshwMessage
{

};

void DUT::result (  )
{
    DUTresultMSG msg;
    msg.argsize = sizeof(msg)-sizeof(UshwMessage);
    msg.resultsize = 0;

    p->sendMessage(&msg);
};

NestedDut *NestedDut::createNestedDut(const char *instanceName)
{
    UshwInstance *p = ushwOpen(instanceName);
    NestedDut *instance = new NestedDut(p);
    return instance;
}


NestedDut::NestedDut(UshwInstance *p)
: foo(p)
{
    this->p = p;
}
NestedDut::~NestedDut()
{
    p->close();
}


NestedDut::Foo::Foo(UshwInstance *p)
{
    this->p = p;
}
NestedDut::Foo::~Foo()
{
    p->close();
}


struct FoobarMSG : public UshwMessage
{
unsigned int a;

};

void NestedDut::Foo::bar ( unsigned int a )
{
    FoobarMSG msg;
    msg.argsize = sizeof(msg)-sizeof(UshwMessage);
    msg.resultsize = 0;
msg.a = a;

    p->sendMessage(&msg);
};
