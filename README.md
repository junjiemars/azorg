# Azorg
demostrates the jni programming

## How to play
Just use make to play around, 

### How to call c/c++ code from java code
```shell
make java2c
```

### How to call java code from c/c++ code
```shell
make c2java
```

## Known issues
### To install Java Runtime 6 on Max OS X 
when the other JRE version had been installed, your Mac remind you to install JRE 6
to fix: 
```shell
sudo mkdir /System/Library/Java/JavaVirtualMachines/1.6.0.jdk/
sudo mkdir /System/Library/Java/Support/Deploy.bundle/
```

## Resources
* [Java programming with JNI](http://www.cs.swarthmore.edu/~newhall/unixhelp/javamakefiles.html)
* [Java makefile](http://www.cs.swarthmore.edu/~newhall/unixhelp/javamakefiles.html)
* [A tutorial for porting to autoconf & automake](http://mij.oltrelinux.com/devel/autoconf-automake/) 
* [Java Programming Tutorial - JNI](https://www3.ntu.edu.sg/home/ehchua/programming/java/JavaNativeInterface.html)

