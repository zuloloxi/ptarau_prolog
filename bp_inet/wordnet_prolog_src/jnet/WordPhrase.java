package jnet;

import prolog.core.*;
import prolog.kernel.*;

public class WordPhrase {
  WordPhrase(String[] words) {
    this.words=words;
    int code=0;
    for(int i=0; i<words.length; i++) {
      code+=(code<<4)+words[i].hashCode();
    }
    this.hcode=Math.abs(code);
  }

  final private String[] words;
  final private int hcode;
  
  public int hashCode() {
    return this.hcode;
  }

  public String get(int i) {
    if(i<0 || i>=words.length) return null;
    return words[i];
  }
  
  public boolean equals(Object other) {
     if(!(other instanceof WordPhrase)) return false;
     WordPhrase wp=(WordPhrase)other;
     if(wp.hcode!=this.hcode || wp.words.length!=this.words.length) return false;
     for(int i=0; i<this.words.length; i++) {
       if(!this.words[i].equals(wp.words[i])) return false;
     }
     return true;
  }
}
