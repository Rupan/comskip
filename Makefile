# ----------------------------------------------------------------------
# Makefile for comskip.exe
# ----------------------------------------------------------------------

# use 'make BITS=64' for a 64-bit build
ifeq ($(BITS),64)
  ARCH=x86_64
else
  ARCH=i686
endif

CC=$(ARCH)-w64-mingw32-gcc
WINDRES=$(ARCH)-w64-mingw32-windres
OBJCOPY=$(ARCH)-w64-mingw32-objcopy
DONATOR=-DDONATOR -DDONATORS
CFLAGS=-O3 -g -Wno-deprecated-declarations
LDFLAGS=-static-libgcc -lcomdlg32 -lgdi32 -largtable2 -lavformat -lavcodec -lavutil -lws2_32

OBJS=comskip.o mpeg2dec.o video_out_dx.o comskip.res
EXE=comskip.exe
SYM=comskip.debuginfo

all: $(EXE)
	
$(EXE): $(OBJS)
	$(CC) $(CFLAGS) -o $(EXE) $(OBJS) $(LDFLAGS)

$(SYM): $(EXE)
	$(OBJCOPY) --only-keep-debug $(EXE) $(SYM)
	$(OBJCOPY) --strip-debug $(EXE)
	$(OBJCOPY) --add-gnu-debuglink=$(SYM) $(EXE)

%.o: %.c
	$(CC) $(CFLAGS) $(DONATOR) $(INCLUDES) -c $< -o $@

%.res: %.rc
	$(WINDRES) $< -O coff -o $@

clean:
	rm -f $(EXE) $(SYM) $(OBJS)
