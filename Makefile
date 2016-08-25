ifeq ($(platform),)
platform = unix
ifeq ($(shell uname -a),)
   platform = win
else ifneq ($(findstring MINGW,$(shell uname -a)),)
   platform = win
else ifneq ($(findstring Darwin,$(shell uname -a)),)
   platform = osx
else ifneq ($(findstring win,$(shell uname -a)),)
   platform = win
endif
endif

ifeq ($(platform), unix)
   CC = gcc
   CXX = g++
   TARGET := 3doh
   fpic := -fPIC
   CFLAGS += -m32
   SHARED := -m32 -shared -Wl,--no-undefined
else ifeq ($(platform), osx)
   TARGET := libretro.dylib
   fpic := -fPIC
   SHARED := -dynamiclib
else ifeq ($(platform), android) 
   TARGET := 3doh
   CC = arm-linux-androideabi-gcc
   CXX = arm-linux-androideabi-g++ 
   AR = @arm-linux-androideabi-ar
   LD = @arm-linux-androideabi-g++ 
   SHARED :=  -llog -fPIC -shared -Wl
#-Wl,--fix-cortex-a8
   CFLAGS += -march=armv7-a -mfloat-abi=softfp -DRETRO_AND
else
   CC = gcc
   TARGET := retro-3doh.dll
   SHARED := -shared -static-libgcc -static-libstdc++ -s -Wl,--no-undefined
endif

ifeq ($(DEBUG), 1)
   CFLAGS += -O0 -g
else
   CFLAGS += -O3
endif

OBJECTS := freedo/arm.o \
freedo/DiagPort.o\
freedo/quarz.o\
freedo/Clio.o \
freedo/frame.o \
freedo/Madam.o \
freedo/vdlp.o \
freedo/_3do_sys.o \
freedo/bitop.o \
freedo/DSP.o \
freedo/Iso.o \
freedo/SPORT.o \
freedo/XBUS.o \
freedo/filters/hq2x.o \
freedo/filters/hq3x.o \
freedo/filters/hq4x.o \
freedo/filters/hqx_init.o \
video.o \
sound.o \
cdrom.o \
input.o \
config.o \
main.o

CFLAGS += -DLSB_FIRST -DALIGN_DWORD -DFAST_MEM $(fpic)  \
	-std=gnu99  -O3 -finline-functions -funroll-loops  -fsigned-char  \
	-Wno-strict-prototypes -ffast-math -fomit-frame-pointer -fno-strength-reduce  -fno-builtin -finline-functions -s

CXXFLAGS += $(CFLAGS) -std=gnu++0x
CPPFLAGS += $(CFLAGS)

all: $(TARGET)

$(TARGET): $(OBJECTS)
	$(CXX) $(fpic) $(SHARED) $(INCLUDES) -o $@ $(OBJECTS) -lm  

%.o: %.c
	$(CXX) $(CFLAGS) $(HINCLUDES) -c -o $@ $<

%.o: %.cpp
	$(CXX) $(CXXFLAGS) $(HINCLUDES) -c -o $@ $<
clean:
	rm -f $(OBJECTS) $(TARGET)

.PHONY: clean

