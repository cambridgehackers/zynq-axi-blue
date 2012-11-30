class DUT {
public:
    static DUT *createDUT(const char *instanceName);
    int ior ( unsigned int, unsigned int );
    int iorShift ( unsigned int, unsigned int );
    unsigned int result (  );
private:
    DUT(UshwInstance *, int baseChannelNumber=0);
    ~DUT();
    UshwInstance *p;
    int baseChannelNumber;
};
