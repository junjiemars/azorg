OUTDIR=build
SRCDIR=src
MKDIR=mkdir -p

.PHONY: all

all: dir java2c c2java
dir: ${OUTDIR}
$(OUTDIR):
	${MKDIR} ${OUTDIR}

## java compiler/flags
JFLAGS = 
JCC = javac
JAVA = java
JAVAH = javah

.SUFFIXES: .java .class
.java.class:
	$(JCC) $(JFLAGS) -d $(OUTDIR) $*.java

## c compiler/flags
CC = cc
ifeq ($(OS), Windows_NT)
	CFLAGS += -D WIN32
else 
	OS := $(shell uname -s)

	ifeq ($(OS), Linux) 
		CFLAGS += -I$(JAVA_HOME)include \
					-I$(JAVA_HOME)include/linux  \
					-Wall -g -O3
		LDFLAGS += -fPIC -shared
		LD_JVM = -L/usr/lib \
				 -L$(JAVA_HOME)jre/lib/i386/server/ \
				 -ljvm
		LIBJAVA2C = libjava2c.so
	endif

	ifeq ($(OS), Darwin)
		CFLAGS += -I$(JAVA_HOME)/include \
					-I$(JAVA_HOME)/include/darwin \
					-v -Wall -g -O3
		LDFLAGS += -dynamiclib
		LD_PATH = $(JAVA_HOME)/jre/lib/server/
		LD_JVM += -L$(LD_PATH) -ljvm \
				  -rpath $(LD_PATH) \
				  -rpath src
		LIBJAVA2C = libjava2c.dylib
	endif
endif


JSRC = \
	   $(SRCDIR)/Java2c.java \
	   $(SRCDIR)/C2Java.java

JAVA2C_SRC = \
			 $(SRCDIR)/java2c.c

C2JAVA_SRC = \
		  $(SRCDIR)/c2java.c

classes: $(JSRC:.java=.class)

jniheaders: classes
	$(JAVAH) -o $(SRCDIR)/java2c.h -classpath $(OUTDIR) Java2c

$(LIBJAVA2C): jniheaders $(JAVA2C_SRC)
	$(CC) $(CFLAGS) $(LDFLAGS) -o $(OUTDIR)/$(LIBJAVA2C) $(JAVA2C_SRC)

java2c: $(LIBJAVA2C)
	$(JAVA) -cp $(OUTDIR) -Djava.library.path=$(OUTDIR) Java2c

c2java: classes
	$(CC) $(CFLAGS) -o $(OUTDIR)/c2java.out $(C2JAVA_SRC) $(LD_JVM)
	$(${OUTDIR}/c2java.out)

default: classes

clean:
	$(RM) -r $(OUTDIR)/*
