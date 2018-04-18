/**
   BinProlog to Java interface adaptor
*/
public class bpj {
  public static String callj(String arg) {
    //System.out.println("ask_java CALLED with:"+arg);
    return "the("+arg+")";
  }
}