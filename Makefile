# ----------------------------------------------------------------------
# Makefile for comskip.exe
# ----------------------------------------------------------------------

CC=i686-w64-mingw32-gcc
WINDRES=i686-w64-mingw32-windres
OBJCOPY=i686-w64-mingw32-objcopy
DONATOR=-DDONATOR -DDONATORS
CFLAGS=-O3 -g
LDFLAGS=-static-libgcc -lcomdlg32 -lgdi32 -largtable2 -lavformat -lavcodec -lavutil -lx264 -lws2_32

OBJS=comskip.o mpeg2dec.o video_out_dx.o comskip.res
EXE=comskip.exe
SYM=comskip.debuginfo

all: $(EXE) $(SYM)
	
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
