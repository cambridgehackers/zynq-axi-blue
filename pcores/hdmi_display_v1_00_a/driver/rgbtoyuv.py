
def rgbToYuv(R, G, B):
    Y = 0.299 * R + 0.587 * G + 0.114 * B + 0
    Cb = -0.169 * R - 0.331 * G + 0.499 * B + 128
    Cr = 0.499 * R - 0.418 * G - 0.0813 * B + 128 
    return Y, Cb, Cr

def rgbToYuvInt(R, G, B):
    Y = (77 * R + 150 * G + 29 * B) >> 8 + 0
    Cb = (-43 * R - 85 * G + 128 * B + 128*256) >> 8 + 0
    Cr = (128 * R - 107 * G - 21 * B + 128*256) >> 8
    return Y, Cb, Cr


def packYuv(yuv):
    y, u, v = yuv
    return "%02x%02x%02x%02x" % (int(round(y)), int(round(u)), int(round(y)), int(round(v)))

print rgbToYuv(255,255,255)
print rgbToYuv(255,0,0)
print rgbToYuv(0,255,0)
print rgbToYuv(0,0,255)

print rgbToYuvInt(255,255,255)
print rgbToYuvInt(255,0,0)
print rgbToYuvInt(0,255,0)
print rgbToYuvInt(0,0,255)

print packYuv(rgbToYuv(255,255,255))
print packYuv(rgbToYuv(255,0,0))
print packYuv(rgbToYuv(0,255,0))
print packYuv(rgbToYuv(0,0,255))
