LOCAL_PATH:= $(call my-dir)
include $(CLEAR_VARS)
LOCAL_SRC_FILES := dut.cpp ushw.cpp testdut.cpp
LOCAL_MODULE = test-dut
LOCAL_MODULE_TAGS := optional
LOCAL_STATIC_LIBRARIES := libc
include $(BUILD_EXECUTABLE)
