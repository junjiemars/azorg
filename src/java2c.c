#include "java2c.h"
#include <stdio.h>

JNIEXPORT jint JNICALL Java_Java2c_c_1square
  (JNIEnv *env, jobject obj, jint n) {
      printf("Oh, Gandalf\n");
      int v = n * n;
      return (v);
  }

