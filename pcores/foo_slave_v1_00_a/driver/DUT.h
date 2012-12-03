
class DUT {
public:
    enum DUTResponseChannel {
        ResultIorShiftResponseChannel, ResultResponseChannel, DUTNumChannels
    };
    int connectHandler(DUTResponseChannel c, UshwInstance::MessageHandler h) {
        p->messageHandlers[c] = h;
        return 0;
    }

    static DUT *createDUT(const char *instanceName);
    void ior ( unsigned int, unsigned int );
    void iorShift ( unsigned int, unsigned int );
private:
    DUT(UshwInstance *, int baseChannelNumber=0);
    ~DUT();
    UshwInstance *p;
    int baseChannelNumber;
};
