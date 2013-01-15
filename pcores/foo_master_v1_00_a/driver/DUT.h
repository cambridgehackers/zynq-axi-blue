
class DUT {
public:
    enum DUTResponseChannel {
        FifoStatusResponseChannel, AxiResponseResponseChannel, FromFifoStatusResponseChannel, AxirResponseResponseChannel, ReadValueResponseChannel, TestCompletedResponseChannel, WriteQueuedResponseChannel, WriteCompletedResponseChannel, FirstReadResponseChannel, ReadCompletedResponseChannel, Test2CompletedResponseChannel, VsyncReceivedResponseChannel, TranslationTableEntryResponseChannel, FbReadingResponseChannel, DUTNumChannels
    };
    int connectHandler(DUTResponseChannel c, PortalInstance::MessageHandler h) {
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
    void runTest2 ( unsigned int );
    void setPatternReg ( unsigned int );
    void startFrameBuffer ( unsigned int );
    void waitForVsync ( unsigned int );
    void hdmiLinesPixels ( unsigned int );
    void hdmiBlankLinesPixels ( unsigned int );
    void hdmiStrideBytes ( unsigned int );
    void hdmiLineCountMinMax ( unsigned int );
    void hdmiPixelCountMinMax ( unsigned int );
    void hdmiSyncWidths ( unsigned int );
    void beginTranslationTable ( unsigned int );
    void addTranslationEntry ( unsigned int, unsigned int );
private:
    DUT(PortalInstance *, int baseChannelNumber=0);
    ~DUT();
    PortalInstance *p;
    int baseChannelNumber;
};
