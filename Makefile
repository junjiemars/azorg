## java compiler and compiler flags
JFLAGS = 
JCC = javac
JAVA = java
JAVAH = javah
## c/c++ compiler and compiler flags
CC = cc
INCLUDES = -I/System/Library/Frameworks/JavaVM.framework/Headers \
		   -I/Library/Java/JavaVirtualMachines/jdk1.8.0.jdk/Contents/Home/include/darwin
CFLAGS = -v -Wall 
LIB_FLAGS = -dynamiclib
LD_JVM= -L/Library/Java/JavaVirtualMachines/jdk1.8.0_25.jdk/Contents/Home/jre/lib/server \
		-ljvm

.SUFFIXES: .java .class
.java.class:
	$(JCC) $(JFLAGS) $*.java

JSRC = \
	   src/Java2c.java

LIB_SRC = \
		  src/java2c.c

BIN_SRC = \
		  src/c2java.c

classes: $(JSRC:.java=.class)

jniheaders: classes
	$(JAVAH) -o src/java2c.h -cp src/ Java2c

libjava2c: jniheaders
	$(CC) $(CFLAGS) $(LIB_FLAGS) $(INCLUDES) -o src/libjava2c.dylib $(LIB_SRC)

java2c: libjava2c
	$(JAVA) -cp src/ -Djava.library.path=src/ Java2c

c2java: 
	$(CC) $(CFLAGS) $(INCLUDES) $(LD_JVM) -o src/c2java.out $(BIN_SRC)

default: classes

clean:
	$(RM) src/*.class
	$(RM) src/*.dylib
	$(RM) src/*.out
	$(RM) src/java2c.h
