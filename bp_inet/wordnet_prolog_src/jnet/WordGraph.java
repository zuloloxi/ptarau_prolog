package jnet;

import prolog.core.*;
import prolog.kernel.*;
import prolog3d.*;

public class WordGraph extends RankedGraph {
  public WordGraph() {
    super();
    this.dict=new ObjectDict();
  }
  
  private ObjectDict dict;
  
  public void add(Fun ws) {
    Object prev=null;
    for(int i=0;i<ws.args.length;i++) {
      Object w=ws.args[i];
      addVertex(w,"true");
      if(null!=prev) {
        int k=1;
        Integer K=(Integer)edgeData(prev,w);
        if(null!=K) k=K.intValue()+1; 
        addEdge(prev,w,new Integer(k));
      }
      prev=w;
    }
  }
  
  public void associate(Fun qs,Fun as) {
    add(qs);
    dict.put(qs,as);
  }
  
  public int maxIndex(Fun ws) {
    Object prev=null;
    Object found=null;
    int l=ws.args.length;
    int i=0;
    for(;i<l;i++) {   
      Object w=ws.args[i];
      if(null==vertexData(w)) break;
      if(null!=prev) {
        found=edgeData(prev,w);
        if(null==found) break;
      }
      prev=w;
    }
    return i-1;
  }
  
  public void draw(int time) {
    int r=400;
    int w=400;
    int h=400;
    Jinni3D.pp(showInfo(this)+"\n");
    Jinni3D.pp("dict.size()="+dict.size());
    Jinni3D.drawGraph(this,time,r,w,h);
  }
  
  public static void test() {
    WordGraph WG=new WordGraph();
    Fun s1=new Fun("s","the","dog","walks","."); 
    Fun s2=new Fun("s","the","dog","barks","."); 
    Fun s3=new Fun("s","the","cat","walks","."); 
    Fun s4=new Fun("s","who","walks","barks","."); 
    WG.add(s1); WG.add(s2); WG.add(s3); WG.add(s4);
    JavaIO.println(WG.showInfo(WG)+"\n"+WG);
    Fun q=new Fun("s","who","walks","barks",".");
    int i=WG.maxIndex(q);
    Jinni3D.pp("index="+i);          
    WG.draw(20);
    
    JavaIO.halt(0);
  }
  
  public static void main(String[] args) {
    test();
  }
}
