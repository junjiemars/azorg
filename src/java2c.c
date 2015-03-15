#include "java2c.h"
#include <stdio.h>

jint JNICALL Java_Java2c_int_1func_1int
  (JNIEnv *env, jobject this, jint n) {
      printf("Oh, Gandalf\n");
      int v = n * n;
      return (v);
  }

