LOCAL_PATH:= $(call my-dir)
include $(CLEAR_VARS)
LOCAL_SRC_FILES := DUT.cpp ushw.cpp testmaster.cpp
LOCAL_MODULE = test-master
LOCAL_MODULE_TAGS := optional
LOCAL_STATIC_LIBRARIES := libc

$(LOCAL_PATH)/DUT.cpp: $(LOCAL_PATH)/../hdl/verilog/DUT.cpp
	cp $(LOCAL_PATH)/../hdl/verilog/DUT.cpp $(LOCAL_PATH)/
$(LOCAL_PATH)/DUT.h: $(LOCAL_PATH)/../hdl/verilog/DUT.h
	cp $(LOCAL_PATH)/../hdl/verilog/DUT.h $(LOCAL_PATH)/
$(LOCAL_PATH)/ushw.cpp: /home/jamey/bluespec/klaatu-language/cpp/ushw.cpp
	cp -v /home/jamey/bluespec/klaatu-language/cpp/ushw.cpp $(LOCAL_PATH)
$(LOCAL_PATH)/ushw.h: /home/jamey/bluespec/klaatu-language/cpp/ushw.h
	cp -v /home/jamey/bluespec/klaatu-language/cpp/ushw.h $(LOCAL_PATH)

include $(BUILD_EXECUTABLE)

include $(CLEAR_VARS)
LOCAL_SRC_FILES := DUT.cpp ushw.cpp testhdmi.cpp
LOCAL_MODULE = test-hdmi
LOCAL_MODULE_TAGS := optional
LOCAL_STATIC_LIBRARIES := libc

include $(BUILD_EXECUTABLE)
