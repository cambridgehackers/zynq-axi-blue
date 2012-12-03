LOCAL_PATH:= $(call my-dir)
include $(CLEAR_VARS)
LOCAL_SRC_FILES := DUT.cpp ushw.cpp testdut.cpp
LOCAL_MODULE = test-dut
LOCAL_MODULE_TAGS := optional
LOCAL_STATIC_LIBRARIES := libc

$(LOCAL_PATH)/DUT.cpp: $(LOCAL_PATH)/../hdl/verilog/DUT.cpp
	cp $(LOCAL_PATH)/../hdl/verilog/DUT.cpp $(LOCAL_PATH)/
$(LOCAL_PATH)/DUT.h: $(LOCAL_PATH)/../hdl/verilog/DUT.h
	cp $(LOCAL_PATH)/../hdl/verilog/DUT.h $(LOCAL_PATH)/

include $(BUILD_EXECUTABLE)
