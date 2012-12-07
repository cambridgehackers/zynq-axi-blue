
class DUT {
public:
    enum DUTResponseChannel {
        FifoStatusResponseChannel, AxiResponseResponseChannel, FromFifoStatusResponseChannel, AxirResponseResponseChannel, ReadValueResponseChannel, TestCompletedResponseChannel, WriteQueuedResponseChannel, WriteCompletedResponseChannel, FirstReadResponseChannel, ReadCompletedResponseChannel, DUTNumChannels
    };
    int connectHandler(DUTResponseChannel c, UshwInstance::MessageHandler h) {
        p->messageHandlers[c] = h;
        return 0;
    }

    static DUT *createDUT(const char *instanceName);
    void setBase ( unsigned int );
    void setBounds ( unsigned int );
    void setThreshold ( unsigned int );
    void setEnabled ( unsigned int );
    void enq ( unsigned int );
    void readFifoStatus ( unsigned int );
    void configure ( unsigned int );
    void readRange ( unsigned int );
    void readFromFifoStatus ( unsigned int );
    void runTest ( unsigned int );
private:
    DUT(UshwInstance *, int baseChannelNumber=0);
    ~DUT();
    UshwInstance *p;
    int baseChannelNumber;
};
