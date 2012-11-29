typedef struct Params {
    unsigned int x : 32;
    unsigned int y : 32;
} Params;
typedef enum Colors { Octarine, Red, Green, Blue } Colors;
class DUT {
public:
    static DUT *createDUT(const char *instanceName);
    void setParams ( unsigned int, unsigned int );
    void result (  );
private:
    DUT(UshwInstance *);
    ~DUT();
    UshwInstance *p;
};
class NestedDut {
public:
    static NestedDut *createNestedDut(const char *instanceName);
    class Foo {
    public:
        void bar ( unsigned int );
    private:
        Foo(UshwInstance *);
        ~Foo();
        UshwInstance *p;
        friend class NestedDut;
    } foo;
private:
    NestedDut(UshwInstance *);
    ~NestedDut();
    UshwInstance *p;
};
