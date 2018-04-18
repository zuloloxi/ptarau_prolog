package jwn;

import java.io.*;
import javax.swing.text.html.*;
import javax.swing.text.html.parser.*;
import javax.swing.text.*;
import java.net.*;

public class DeTagger extends HTMLEditorKit.ParserCallback {
  public static boolean trace=false;
  
  StringBuffer s;
  private boolean skip;
  private int count;
  private int max;
  
  public DeTagger(int max) {
    this.skip=false;
    this.count=0;
    this.max=max;
  }

  public void parse(Reader in) throws IOException {
    this.s = new StringBuffer();
    ParserDelegator delegator = new ParserDelegator();
    delegator.parse(in, this, true);
  }

  //public void handleError(String errorMsg, int pos) {}
   
  public void handleStartTag(HTML.Tag t,MutableAttributeSet a,int pos) {
    if("script".equals(t.toString())) skip=true;
  }
  
  public void handleEndTag(HTML.Tag t, int pos) {
    if("script".equals(t.toString())) 
      skip=false;
  }
  
  public void handleText(char[] cs, int pos) {
    if(max>0 && count>max) return;
    if(skip || !cleanChars(cs)) return;
    s.append(cs);
    s.append(" ");
    count+=1+cs.length;
  }
  
  public String toString() {
    return s.toString();
  }
         
  public static BufferedReader toReader(String fileOrUrl)  {
    BufferedReader in=null;
    try {  
      if(fileOrUrl.startsWith("http://")) {
        URL url=new URL(fileOrUrl);
        in = new BufferedReader(
          new InputStreamReader(
          url.openStream()));
      }
      else {
        in=new BufferedReader(new FileReader(fileOrUrl));
      }
    }    
    catch (Exception e) {
      if(trace) e.printStackTrace();
    }  
    return in;
   }
   
  public static String detagString(String s) {
     return detagString(0,s);
  }
    
  public static String detagString(int max,String s) {
    Reader in=new StringReader(s);
    return detagStream(max,in);
  } 
  
  public static String detag(String fileOrUrl) {
    return detag(0,fileOrUrl);
  } 
  
  public static String detag(int max,String fileOrUrl) {
    return detagStream(max,toReader(fileOrUrl));
  } 
   
   boolean cleanChars(char[] cs) {
     for(int i=0;i<cs.length;i++) {
       char c=cs[i];
       if(Character.isLetterOrDigit(c) || Character.isWhitespace(c)) continue;
       if(c>31 && c<127) continue;
       return false;
     }
     return true;
   }
   
   public static String detagStream(int max,Reader in) {  
   if(null==in) return null;
    try {
      DeTagger parser = new DeTagger(max);
      parser.parse(in);
      in.close();
      return parser.toString();
    }
    catch (Exception e) {
      if(trace) e.printStackTrace();
      return null;
    }
  }
}
