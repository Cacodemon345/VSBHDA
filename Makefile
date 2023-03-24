
# create sbemu.exe
# to create a debug version, enter: make DEBUG=1
# note that for assembly jwasm v2.17+ is needed ( understands -djgpp option )

ifndef DEBUG
DEBUG=0
endif

ifeq ($(DEBUG),1)
OUTD=debug
C_DEBUG_FLAGS=-D_DEBUG
else
OUTD=build
C_DEBUG_FLAGS=
endif

vpath_src=mpxplay/au_cards mpxplay/newfunc mpxplay/au_mixer sbemu
vpath %.c $(vpath_src)
vpath %.cc $(vpath_src)
vpath %.cpp $(vpath_src)
vpath %.C $(vpath_src)
vpath %.asm $(vpath_src)
vpath_header=./sbemu ./mpxplay ./mpxplay/au_cards ./mpxplay/au_mixer ./mpxplay/newfunc
vpath %.h $(vpath_header)
vpath_obj=./$(OUTD)/
vpath %.o $(vpath_obj)

RHIDE_OS_:=DJGPP
RHIDE_OS=$(RHIDE_OS_)
INCLUDE_DIRS=./mpxplay ./sbemu
C_OPT_FLAGS=-Os -fno-asynchronous-unwind-tables
LIBS=
LD_EXTRA_FLAGS=-Map $(OUTD)/sbemu.map
C_EXTRA_FLAGS=-march=i386 -D__DOS__ -DSBEMU -DSBLSUPP
LOCAL_OPT=$(subst ___~~~___, ,$(subst $(notdir $<)___,,$(filter $(notdir\
	$<)___%,$(LOCAL_OPTIONS))))

OBJFILES=$(OUTD)/main.o $(OUTD)/hdpmipt.o $(OUTD)/qemm.o    $(OUTD)/sbemu.o\
	$(OUTD)/virq.o     $(OUTD)/dbopl.o    $(OUTD)/opl3emu.o $(OUTD)/pic.o\
	$(OUTD)/stackio.o  $(OUTD)/stackisr.o $(OUTD)/int31.o\
	$(OUTD)/dprintf.o  $(OUTD)/vioout.o\
	$(OUTD)/untrapio.o $(OUTD)/vdma.o     $(OUTD)/dpmi.o\
	$(OUTD)/au_cards.o $(OUTD)/ac97_def.o $(OUTD)/dmairq.o  $(OUTD)/string.o\
	$(OUTD)/memory.o   $(OUTD)/nf_dpmi.o  $(OUTD)/pcibios.o $(OUTD)/time.o\
	$(OUTD)/cv_bits.o  $(OUTD)/cv_chan.o  $(OUTD)/cv_freq.o\
	$(OUTD)/sc_e1371.o $(OUTD)/sc_ich.o   $(OUTD)/sc_sbliv.o\
	$(OUTD)/sc_inthd.o $(OUTD)/sc_via82.o $(OUTD)/sc_sbl24.o

LIBRARIES=$(OUTD)/sbemu.ar
SOURCE_NAME=$<
OUTFILE=$@
SPECIAL_CFLAGS=
SRC_DIRS=mpxplay/au_cards mpxplay/newfunc mpxplay/au_mixer sbemu
MAIN_TARGET=$(OUTD)/sbemu.exe
PROJECT_ITEMS=ac97_def.c au_cards.c cv_bits.c cv_chan.c cv_freq.c\
	dbopl.cpp dmairq.c dpmi.c hdpmipt.c\
	main.c sbemu.c memory.c nf_dpmi.c opl3emu.cpp pcibios.c pic.c qemm.c\
	sc_e1371.c sc_ich.c sc_inthd.c sc_via82.c sc_sbl24.c sc_sbliv.c\
	string.c time.c untrapio.c vdma.c virq.c
DEFAULT_MASK=*.[acfghimnops]*
CLEAN_FILES=$(MAIN_TARGET) $(OBJFILES)
RHIDE_AR=ar
RHIDE_ARFLAGS=rcs
RHIDE_AS=$(RHIDE_GCC)
RHIDE_COMPILE.cc.o=$(RHIDE_COMPILE_CC)
RHIDE_COMPILE.C.o=$(RHIDE_COMPILE.cc.o)
RHIDE_COMPILE.asm.o=$(RHIDE_COMPILE_JWASM)
RHIDE_COMPILE.c.o=$(RHIDE_COMPILE_C)
RHIDE_COMPILE.cpp.o=$(RHIDE_COMPILE.cc.o)
RHIDE_COMPILE_ARCHIVE=$(RHIDE_AR) $(RHIDE_ARFLAGS) $(OUTFILE) $(OBJFILES)

RHIDE_COMPILE_C=$(RHIDE_GCC) $(C_DEBUG_FLAGS) $(C_OPT_FLAGS) $(C_EXTRA_FLAGS)\
	$(CPPFLAGS) $(CFLAGS) $(LOCAL_OPT) $(RHIDE_INCLUDES) -c $(SOURCE_NAME) -o $(OUTFILE)
RHIDE_COMPILE_CC=$(RHIDE_GXX) $(C_DEBUG_FLAGS) $(C_OPT_FLAGS) \
	$(C_EXTRA_FLAGS) $(RHIDE_OS_CXXFLAGS)\
	$(CPPFLAGS) $(CXXFLAGS) $(LOCAL_OPT) $(RHIDE_INCLUDES) -c $(SOURCE_NAME) -o $(OUTFILE)
RHIDE_COMPILE_CC_FORCE=$(RHIDE_GXX) $(C_DEBUG_FLAGS) $(C_OPT_FLAGS)\
	$(C_EXTRA_FLAGS) $(RHIDE_OS_CXXFLAGS)\
	$(CPPFLAGS) $(CXXFLAGS) -x c++ $(LOCAL_OPT) $(RHIDE_INCLUDES) -c $(SOURCE_NAME) -o $(OUTFILE)
RHIDE_COMPILE_C_FORCE=$(RHIDE_GCC) $(C_DEBUG_FLAGS) $(C_OPT_FLAGS) $(C_EXTRA_FLAGS)\
	-x c $(CPPFLAGS) $(CFLAGS) $(LOCAL_OPT) $(RHIDE_INCLUDES) -c $(SOURCE_NAME) -o $(OUTFILE)

RHIDE_INCLUDES=$(SPECIAL_CFLAGS) $(addprefix -I,$(INCLUDE_DIRS))
RHIDE_COMPILE_JWASM=jwasm.exe -q -djgpp -Fo$(OUTFILE) $(SOURCE_NAME)
RHIDE_GCC=gcc
RHIDE_GXX=$(RHIDE_GCC)
RHIDE_LD=$(RHIDE_GCC)
RHIDE_LDFLAGS=$(addprefix -Xlinker ,$(LD_EXTRA_FLAGS))
RHIDE_LIBS=$(addprefix -l,$(LIBS) $(RHIDE_TYPED_LIBS))
RHIDE_PATH_SEPARATOR=$(RHIDE_PATH_SEPARATOR_$(RHIDE_OS))
RHIDE_PATH_SEPARATOR_$(RHIDE_OS)=:
RHIDE_PATH_SEPARATOR_DJGPP=;
RHIDE_SHARED_LDFLAGS=$(RHIDE_SHARED_LDFLAGS_$(RHIDE_OS))
RHIDE_SHARED_LDFLAGS_$(RHIDE_OS)=
RHIDE_SHARED_LDFLAGS_DJGPP=
RHIDE_TYPED_LIBS=$(foreach suff,$(RHIDE_TYPED_LIBS_SUFFIXES),$(RHIDE_TYPED_LIBS$(suff)))
RHIDE_TYPED_LIBS.C=$(RHIDE_TYPED_LIBS.cc)
RHIDE_TYPED_LIBS.cc=$(RHIDE_TYPED_LIBS_$(RHIDE_OS).cc)
RHIDE_TYPED_LIBS.cpp=$(RHIDE_TYPED_LIBS.cc)
RHIDE_TYPED_LIBS.cxx=$(RHIDE_TYPED_LIBS.cc)
RHIDE_TYPED_LIBS.l=fl
RHIDE_TYPED_LIBS_DJGPP.cc=stdcxx m
RHIDE_TYPED_LIBS_DJGPP.cpp=stdcxx m
RHIDE_TYPED_LIBS_DJGPP.cxx=stdcxx m
RHIDE_TYPED_LIBS_SUFFIXES=$(sort $(foreach item,$(PROJECT_ITEMS),$(suffix $(item))))

%.o: %.c
	$(RHIDE_COMPILE.c.o)
%.o: %.cpp
	$(RHIDE_COMPILE.cpp.o)
%.o: %.C
	$(RHIDE_COMPILE.C.o)
%.o: %.asm
	$(RHIDE_COMPILE.asm.o)

all::

clean::
	del $(OUTD)\*.o

DEPS_0= $(OUTD)/main.o   $(OUTD)/hdpmipt.o	$(OUTD)/qemm.o	$(OUTD)/opl3emu.o	$(OUTD)/dbopl.o\
	$(OUTD)/dpmi.o		$(OUTD)/pic.o	$(OUTD)/sbemu.o\
	$(OUTD)/untrapio.o	$(OUTD)/vdma.o		$(OUTD)/virq.o\
	$(OUTD)/time.o\
	$(OUTD)/stackio.o	$(OUTD)/stackisr.o	$(OUTD)/int31.o\
	$(OUTD)/ac97_def.o	$(OUTD)/au_cards.o	$(OUTD)/cv_bits.o	$(OUTD)/cv_chan.o	$(OUTD)/cv_freq.o\
	$(OUTD)/sc_e1371.o	$(OUTD)/sc_ich.o		$(OUTD)/sc_inthd.o	$(OUTD)/sc_via82.o	$(OUTD)/sc_sbliv.o	$(OUTD)/sc_sbl24.o\
	$(OUTD)/string.o\
	$(OUTD)/dmairq.o	$(OUTD)/pcibios.o	$(OUTD)/memory.o		$(OUTD)/nf_dpmi.o\
	$(OUTD)/dprintf.o	$(OUTD)/vioout.o

$(OUTD)/sbemu.exe:: $(OUTD)/sbemu.ar
	$(RHIDE_LD) $(C_EXTRA_FLAGS) -o $(OUTFILE) $(OUTD)/main.o $(LIBRARIES) $(LDFLAGS) $(RHIDE_LDFLAGS) $(RHIDE_LIBS)
	strip -s $(OUTFILE)
	exe2coff $(OUTFILE)
	copy /b res\stub.bin + $(OUTD)\sbemu $(OUTD)\sbemu.exe

$(OUTD)/sbemu.ar:: $(DEPS_0)
	ar --target=coff-go32 r $(OUTD)/sbemu.ar $(DEPS_0)

DEPS_7=dbopl.cpp   dbopl.h
DEPS_9=dpmi.c      dpmi_.h platform.h
DEPS_13=hdpmipt.c  hdpmipt.h qemm.h dpmi_.h platform.h untrapio.h sbemucfg.h
DEPS_14=main.c     hdpmipt.h qemm.h dpmi_.h opl3emu.h pic.h platform.h sbemu.h sbemucfg.h untrapio.h vdma.h virq.h\
	in_file.h mpxplay.h au_cards.h au_mixer.h mix_func.h newfunc.h
DEPS_17=opl3emu.cpp dbopl.h opl3emu.h
DEPS_19=pic.c      pic.h platform.h untrapio.h
DEPS_20=qemm.c     qemm.h dpmi_.h platform.h untrapio.h sbemucfg.h
DEPS_21=sbemu.c    dpmi_.h platform.h sbemu.h sbemucfg.h
DEPS_31=untrapio.c untrapio.h
DEPS_32=vdma.c     dpmi_.h platform.h untrapio.h vdma.h sbemucfg.h
DEPS_33=virq.c     dpmi_.h pic.h platform.h untrapio.h virq.h sbemucfg.h
DEPS_1=ac97_def.c  ac97_def.h au_cards.h au_mixer.h in_file.h mpxplay.h newfunc.h
DEPS_2=au_cards.c  au_cards.h dmairq.h au_mixer.h in_file.h mpxplay.h newfunc.h sbemucfg.h
DEPS_3=cv_bits.c   au_cards.h au_mixer.h in_file.h mpxplay.h newfunc.h
DEPS_4=cv_chan.c   au_cards.h au_mixer.h in_file.h mpxplay.h newfunc.h
DEPS_5=cv_freq.c   au_cards.h au_mixer.h in_file.h mpxplay.h newfunc.h
DEPS_8=dmairq.c    au_cards.h dmairq.h au_mixer.h in_file.h mpxplay.h newfunc.h
DEPS_15=memory.c   au_cards.h in_file.h mpxplay.h au_mixer.h newfunc.h
DEPS_16=nf_dpmi.c  newfunc.h
DEPS_18=pcibios.c  pcibios.h newfunc.h
DEPS_22=sc_e1371.c ac97_def.h in_file.h mpxplay.h au_cards.h dmairq.h pcibios.h au_mixer.h newfunc.h
DEPS_23=sc_ich.c   ac97_def.h in_file.h mpxplay.h au_cards.h dmairq.h pcibios.h au_mixer.h newfunc.h
DEPS_24=sc_inthd.c au_cards.h in_file.h mpxplay.h dmairq.h pcibios.h sc_inthd.h au_mixer.h newfunc.h
DEPS_25=sc_via82.c ac97_def.h in_file.h mpxplay.h au_cards.h dmairq.h pcibios.h au_mixer.h newfunc.h
DEPS_26=string.c   au_cards.h in_file.h mpxplay.h au_mixer.h newfunc.h
DEPS_29=time.c     au_cards.h au_mixer.h in_file.h mpxplay.h newfunc.h
DEPS_34=sc_sbliv.c ac97_def.h in_file.h mpxplay.h sc_sbliv.h emu10k1.h au_cards.h dmairq.h pcibios.h au_mixer.h newfunc.h
DEPS_35=sc_sbl24.c ac97_def.h in_file.h mpxplay.h sc_sbl24.h emu10k1.h au_cards.h dmairq.h pcibios.h au_mixer.h newfunc.h

$(OUTD)/ac97_def.o:: $(DEPS_1)
	$(RHIDE_COMPILE.c.o)
$(OUTD)/au_cards.o:: $(DEPS_2)
	$(RHIDE_COMPILE.c.o)
$(OUTD)/cv_bits.o:: $(DEPS_3)
	$(RHIDE_COMPILE.c.o)
$(OUTD)/cv_chan.o:: $(DEPS_4)
	$(RHIDE_COMPILE.c.o)
$(OUTD)/cv_freq.o:: $(DEPS_5)
	$(RHIDE_COMPILE.c.o)
$(OUTD)/dbopl.o:: $(DEPS_7)
	$(RHIDE_COMPILE.cpp.o)
$(OUTD)/dmairq.o:: $(DEPS_8)
	$(RHIDE_COMPILE.c.o)
$(OUTD)/dpmi.o:: $(DEPS_9)
	$(RHIDE_COMPILE.c.o)
$(OUTD)/hdpmipt.o:: $(DEPS_13)
	$(RHIDE_COMPILE.c.o)
$(OUTD)/main.o:: $(DEPS_14)
	$(RHIDE_COMPILE.c.o)
$(OUTD)/memory.o:: $(DEPS_15)
	$(RHIDE_COMPILE.c.o)
$(OUTD)/nf_dpmi.o:: $(DEPS_16)
	$(RHIDE_COMPILE.c.o)
$(OUTD)/opl3emu.o:: $(DEPS_17)
	$(RHIDE_COMPILE.cpp.o)
$(OUTD)/pcibios.o:: $(DEPS_18)
	$(RHIDE_COMPILE.c.o)
$(OUTD)/pic.o:: $(DEPS_19)
	$(RHIDE_COMPILE.c.o)
$(OUTD)/qemm.o:: $(DEPS_20)
	$(RHIDE_COMPILE.c.o)
$(OUTD)/sbemu.o:: $(DEPS_21)
	$(RHIDE_COMPILE.c.o)
$(OUTD)/sc_e1371.o:: $(DEPS_22)
	$(RHIDE_COMPILE.c.o)
$(OUTD)/sc_ich.o:: $(DEPS_23)
	$(RHIDE_COMPILE.c.o)
$(OUTD)/sc_inthd.o:: $(DEPS_24)
	$(RHIDE_COMPILE.c.o)
$(OUTD)/sc_via82.o:: $(DEPS_25)
	$(RHIDE_COMPILE.c.o)
$(OUTD)/string.o:: $(DEPS_26)
	$(RHIDE_COMPILE.c.o)
$(OUTD)/time.o:: $(DEPS_29)
	$(RHIDE_COMPILE.c.o)
$(OUTD)/untrapio.o:: $(DEPS_31)
	$(RHIDE_COMPILE.c.o)
$(OUTD)/vdma.o:: $(DEPS_32)
	$(RHIDE_COMPILE.c.o)
$(OUTD)/virq.o:: $(DEPS_33)
	$(RHIDE_COMPILE.c.o)
$(OUTD)/sc_sbliv.o:: $(DEPS_34)
	$(RHIDE_COMPILE.c.o)
$(OUTD)/sc_sbl24.o:: $(DEPS_35)
	$(RHIDE_COMPILE.c.o)
$(OUTD)/stackio.o:: stackio.asm
	$(RHIDE_COMPILE.asm.o)
$(OUTD)/stackisr.o:: stackisr.asm
	$(RHIDE_COMPILE.asm.o)
$(OUTD)/int31.o:: int31.asm
	$(RHIDE_COMPILE.asm.o)
$(OUTD)/dprintf.o:: dprintf.asm
	$(RHIDE_COMPILE.asm.o)
$(OUTD)/vioout.o:: vioout.asm
	$(RHIDE_COMPILE.asm.o)

all:: $(OUTD)/sbemu.exe

