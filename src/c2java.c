#include <jni.h>
#include <stdio.h>
#include <stdlib.h>

#ifdef _WIN32
#define PATH_SEPARATOR ';'
#else
#define PATH_SEPARATOR ':'
#endif

int main(int argc, char *argv[]) {
    if (argc < 2) {
        printf("<c>%s need classpath option!\n", argv[0]);
        return (0);
    }
    JavaVMOption options[1];
    JNIEnv *env;
    JavaVM *jvm;
    JavaVMInitArgs vm_args = {0};
    long status;
    jclass clazz;
    jmethodID mid;
    jint square;

    //options[0].optionString = "-Djava.class.path=.";
    if (0 >= asprintf(&options[0].optionString, "-Djava.class.path=%s", argv[1])) {
        return (0);
    }
    vm_args.version = JNI_VERSION_1_6;
    vm_args.nOptions = 1;
    vm_args.options = options;
    status = JNI_CreateJavaVM(&jvm, (void**)&env, &vm_args);

    if (status != JNI_ERR) {
        clazz = (*env)->FindClass(env, "C2Java");
        if (clazz) {
            mid = (*env)->GetStaticMethodID(env, clazz, "square", "(I)I");
            if (mid) {
                square = (*env)->CallStaticIntMethod(env, clazz, mid, 5);
                printf("<c>:square(%d)=%d\n", 5, square);
            }
        }

        (*jvm)->DestroyJavaVM(jvm);
    }

    free(options[0].optionString);
    return (0);
}
