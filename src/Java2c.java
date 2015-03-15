public class Java2c {
    public native int c_square(int n);

    public static int square(int n) {
        int v = n * n;
        System.out.println(String.format("<java>:square(%d)=%d", n, v));
        return (v);
    }

    public static void main(String[] args) {
        System.out.println("Ho, Azorg!");
        System.loadLibrary("java2c");

        final Java2c j2c = new Java2c();
        System.out.println(String.format("c_square(%d)=%d",
                    3, j2c.c_square(3)));
    }
}
