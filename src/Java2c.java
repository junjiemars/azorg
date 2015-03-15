public class Java2c {
    public native int int_func_int(int n);

    public static void main(String[] args) {
        System.out.println("Ho, Azorg!");
        System.loadLibrary("java2c");

        final Java2c j2c = new Java2c();
        System.out.println(String.format("int_func_int(%d)=%d",
                    3, j2c.int_func_int(3)));
    }
}
