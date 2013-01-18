
class DUT {
public:
    enum DUTResponseChannel {
        VsyncReceivedResponseChannel, TranslationTableEntryResponseChannel, FbReadingResponseChannel, DUTNumChannels
    };
    int connectHandler(DUTResponseChannel c, PortalInstance::MessageHandler h) {
        p->messageHandlers[c] = h;
        return 0;
    }

    static DUT *createDUT(const char *instanceName);
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
