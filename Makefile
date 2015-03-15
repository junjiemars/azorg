## java compiler and compiler flags
JFLAGS = 
JCC = javac
JAVA = java
JAVAH = javah
## c/c++ compiler and compiler flags
INCLUDES = -I/System/Library/Frameworks/JavaVM.framework/Headers
CFLAGS = -v -Wall -dynamiclib
CC = cc

.SUFFIXES: .java .class
.java.class:
	$(JCC) $(JFLAGS) $*.java

JSRC = \
	   src/Java2c.java

CSRC = \
	   src/java2c.c

classes: $(JSRC:.java=.class)

jniheaders: classes
	$(JAVAH) -o src/java2c.h -cp src/ Java2c

libjava2c: jniheaders
	$(CC) $(CFLAGS) $(INCLUDES) -o src/libjava2c.dylib $(CSRC)

run: libjava2c
	$(JAVA) -cp src/ -Djava.library.path=src/ Java2c

default: classes

clean:
	$(RM) src/*.class
	$(RM) src/java2c.h
