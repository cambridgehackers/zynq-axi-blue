LOCAL_PATH:= $(call my-dir)
include $(CLEAR_VARS)
LOCAL_SRC_FILES := DUT.cpp ushw.cpp testmaster.cpp
LOCAL_MODULE = test-master
LOCAL_MODULE_TAGS := optional
LOCAL_STATIC_LIBRARIES := libc

include $(BUILD_EXECUTABLE)

include $(CLEAR_VARS)
LOCAL_SRC_FILES := DUT.cpp ushw.cpp testhdmi.cpp
LOCAL_MODULE = test-hdmi
LOCAL_MODULE_TAGS := optional
LOCAL_STATIC_LIBRARIES := libc

include $(BUILD_EXECUTABLE)
