OUTDIR=build
SRCDIR=src
MKDIR=mkdir -p

## java compiler/flags
JFLAGS = 
JCC = javac
JAVA = java
JAVAH = javah

.PHONY: classes

all: ${OUTDIR} JvmArch classes
$(OUTDIR):
	${MKDIR} ${OUTDIR}
JvmArch: 
	$(JCC) $(JFLAGS) -d $(OUTDIR) $(SRCDIR)/JvmArch.java

.SUFFIXES: .java .class
.java.class:
	$(JCC) $(JFLAGS) -d $(OUTDIR) $*.java

JAVA_SRC = \
		   $(SRCDIR)/Java2c.java \
		   $(SRCDIR)/C2Java.java

classes: $(JAVA_SRC:.java=.class)

## cc compiler/flags
CC=cc

ifeq ($(OS), Windows_NT)
	CCFLAGS += -D WIN32
else 
	OS := $(shell uname -s)
	##JVM_ARCH := $(shell uname -m)
	JVM_ARCH_CLASS = ${OUTDIR}/JvmArch.class
	ifneq ($(wildcard $(JVM_ARCH_CLASS)),)
		JVM_ARCH := $(shell java -classpath ${OUTDIR} JvmArch)
	endif

	ifeq ($(OS), Linux) 
		ifndef (JAVA_HOME)
			JAVA_HOME := $(shell readlink -f `which java`|sed 's/\/bin\/java//g')
			JAVAH = ${JAVA_HOME}/bin/javah
		endif
		CCFLAGS += -I$(JAVA_HOME)/include \
					-I$(JAVA_HOME)/include/linux  \
					-Wall -g -O0 ${CCFLAGS}\
					-D_GNU_SOURCE
		LDFLAGS += -fPIC -shared
		LD_PATH = ${JAVA_HOME}/jre/lib/${JVM_ARCH}/server
		LD_JVM = -L$(LD_PATH) \
				 -ljvm
		LIBJAVA2C = libjava2c.so
		LD_RUN = LD_LIBRARY_PATH=${LD_PATH}:${LD_LIBRARY_PATH}
	endif

	ifeq ($(OS), Darwin)
		CCFLAGS += -I$(JAVA_HOME)/include \
					-I$(JAVA_HOME)/include/darwin \
					-Wall -g -O3 ${CFLAGS}
		LDFLAGS += -dynamiclib
		LD_PATH = $(JAVA_HOME)/jre/lib/server/
		LD_JVM += -L$(LD_PATH) -ljvm \
				  -rpath $(LD_PATH) \
				  -rpath src
		LIBJAVA2C = libjava2c.dylib
	endif
endif

JAVA2C_SRC = \
			 $(SRCDIR)/java2c.c

C2JAVA_SRC = \
		  $(SRCDIR)/c2java.c

jniheaders: classes
	$(JAVAH) -o $(SRCDIR)/java2c.h -classpath $(OUTDIR) Java2c

$(LIBJAVA2C): jniheaders $(JAVA2C_SRC)
	$(CC) $(CCFLAGS) $(LDFLAGS) -o $(OUTDIR)/$(LIBJAVA2C) $(JAVA2C_SRC)

java2c: $(LIBJAVA2C)
	$(JAVA) -cp $(OUTDIR) -Djava.library.path=$(OUTDIR) Java2c

c2java: classes
	$(CC) $(CCFLAGS) -o $(OUTDIR)/c2java.out $(C2JAVA_SRC) $(LD_JVM)
	$(LD_RUN) ${OUTDIR}/c2java.out ${OUTDIR}


clean:
	$(RM) -r $(OUTDIR)/*
