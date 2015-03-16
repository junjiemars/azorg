## java compiler and compiler flags
JFLAGS = 
JCC = javac
JAVA = java
JAVAH = javah

.SUFFIXES: .java .class
.java.class:
	$(JCC) $(JFLAGS) $*.java

CC = cc
ifeq ($(OS), Windows_NT)
	CCFLAGS += -D WIN32
else 
	OS := $(shell uname -s)

	ifeq ($(OS), Linux) 
		INCLUDES += -I$(JAVA_HOME)include \
					-I$(JAVA_HOME)include/linux 
		CCFLAGS += -Wall
		LIB_FLAGS += -fPIC -shared
		LIBJAVA2C = libjava2c.so
		LD_JVM = -L/usr/lib \
				 -L$(JAVA_HOME)jre/lib/i386/server/ \
				 -ljvm
	endif

	ifeq ($(OS), Darwin)
		INCLUDES += -I/System/Library/Frameworks/JavaVM.framework/Headers \
					-I/Library/Java/JavaVirtualMachines/jdk1.8.0.jdk/Contents/Home/include/darwin
		LIB_FLAGS += -dynamiclib
		LD_JVM += -L/Library/Java/JavaVirtualMachines/jdk1.8.0_25.jdk/Contents/Home/jre/lib/server \
				  -ljvm
		CCFLAGS += -v -Wall
		LIBJAVA2C = libjava2c.dylib
	endif
endif

JSRC = \
	   src/Java2c.java

LIB_SRC = \
		  src/java2c.c

BIN_SRC = \
		  src/c2java.c

classes: $(JSRC:.java=.class)

jniheaders: classes
	$(JAVAH) -o src/java2c.h -cp src/ Java2c

LIBJAVA2C: jniheaders
	$(CC) $(CCFLAGS) $(LIB_FLAGS) $(INCLUDES) -o src/$(LIBJAVA2C) $(LIB_SRC)

java2c: LIBJAVA2C
	$(JAVA) -cp src/ -Djava.library.path=src/ Java2c

c2java: classes
	$(CC) $(CCFLAGS) -o src/c2java.out $(BIN_SRC) $(INCLUDES) $(LD_JVM)
	$(src/c2java.out)

default: classes

clean:
	$(RM) src/*.class
	$(RM) src/*.dylib
	$(RM) src/*.so
	$(RM) src/*.out
	$(RM) src/java2c.h
