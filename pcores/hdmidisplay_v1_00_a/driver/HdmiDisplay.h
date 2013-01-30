
class HdmiDisplay {
public:
    enum HdmiDisplayResponseChannel {
        VsyncReceivedResponseChannel, TranslationTableEntryResponseChannel, FbReadingResponseChannel, HdmiDisplayNumChannels
    };
    int connectHandler(HdmiDisplayResponseChannel c, PortalInstance::MessageHandler h) {
        p->messageHandlers[c] = h;
        return 0;
    }

    static HdmiDisplay *createHdmiDisplay(const char *instanceName);
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
    HdmiDisplay(PortalInstance *, int baseChannelNumber=0);
    ~HdmiDisplay();
    PortalInstance *p;
    int baseChannelNumber;
};
