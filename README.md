# Azorg
demostrates the jni programming

## How to call c/c++ code from java code

## How to call java code from c/c++ code

## Note
The OS X will notifing that you need to install Java Runtime 6 after you run
```shell
make c2java
```
The fix is easy: just to create the following directories
```shell
sudo mkdir /System/Library/Java/JavaVirtualMachines/1.6.0.jdk/
sudo mkdir /System/Library/Java/Support/Deploy.bundle/
```

## Resources
* [Java programming with JNI](http://www.cs.swarthmore.edu/~newhall/unixhelp/javamakefiles.html)
* [Java makefile](http://www.cs.swarthmore.edu/~newhall/unixhelp/javamakefiles.html)
* [A tutorial for porting to autoconf & automake](http://mij.oltrelinux.com/devel/autoconf-automake/) 
* [Java Programming Tutorial - JNI](https://www3.ntu.edu.sg/home/ehchua/programming/java/JavaNativeInterface.html)

