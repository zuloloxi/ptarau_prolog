package jwn;

import com.touchgraph.graphlayout.*;
import com.touchgraph.graphlayout.interaction.*;
import com.touchgraph.graphlayout.graphelements.*;
import  java.awt.*;
import  java.awt.event.*;
import java.util.Hashtable;
import prolog.kernel.*;
import prolog.core.*;

class ViewPanel extends GLPanel {
  ViewPanel() {
  }
  
  public void randomGraph() { // do nothing!!
  }
  
  Node addNode(String label) throws TGException {
    Node n=tgPanel.addNode();
    n.setLabel(label);
    return n;
  }
  
  Edge addEdge(Node from,Node to) {
    return tgPanel.addEdge(from,to,Edge.DEFAULT_LENGTH);	
  }
  
  void stopThreads() {
    tgPanel.stopDamper();
    tgPanel.stopMotion();
    tgPanel.tgLayout.stop();
  }
}

public class TGAdaptor extends Frame {
  
  public TGAdaptor() {
    super("JinniGraphViewer");
    this.panel=new ViewPanel();
    this.addWindowListener(new WindowAdapter() {
      public void windowClosing(WindowEvent e) {
        clearAll();
      }
    });
  }
    
  private ViewPanel panel; 
  
  public Node addNode(String label) {
    return addNode(label,0);
  }
   
  /**
    Shapes:
      0=rectangle
      1=round rectangle
      2=ellipse - B
      3=circle -
   */ 
  
  static Color Black=new Color(0,0,0); 
  static Color Red=new Color(200,0,0);
  static Color Blue=new Color(0,0,200);
  static Color Green=new Color(0,200,0);
  
  static Color[] colors={Black,Blue,Green,Red};
   
  public Node addNode(String label,int shape) {
    try {
       Node n=panel.addNode(label);
       int i=Math.abs(shape % 4);
       n.setType(1+i);
       n.setBackColor(colors[i]);
       return n;
    }
    catch ( TGException tge ) {
      System.err.println(tge.getMessage());
    }
    return null;   
  }
  
  public Edge addEdge(Node from,Node to) {
    Edge e=panel.addEdge(from,to);
    return e;
  }
  
  public static void show(GraphSpec G) {
    TGAdaptor A=new TGAdaptor();
    Object[] vs=G.vertices();
    Hashtable Map=new Hashtable();
     
    for(int i=0; i<vs.length; i++) {
      Object V=vs[i];
      Node N=A.addNode(V.toString(),3);
      Map.put(V,N);
    }
     
    for(int i=0; i<vs.length; i++) {
      Object V=vs[i];
      Node from=(Node)Map.get(V);
      Object[] es=G.edges(V);
      for(int j=0;j<es.length;j++) {
        Node to=(Node)Map.get(es[j]);
        A.addEdge(from,to);
      }
    }
    
    A.showAll();
  }
  
  static int WITH_ROOT=0;
  static int GIANT_ONLY=1;
  
  public static void show(RankedGraph G) {
     show(G,GIANT_ONLY,15,20);
  }
  public static void show(RankedGraph G,int how,int max,int chop) {
    TGAdaptor A=new TGAdaptor();
    Hashtable Map=new Hashtable();
    
    Node Root=null;
    
    if(WITH_ROOT==how) Root=A.addNode("ROOT",0);
    
    double maxRank=0.0; int i=0;
  
    int giant=G.giantComponent();
    ObjectIterator vs=G.vertexIterator();
    int count=0;
    while(vs.hasNext()) {
      Object V=vs.next();
      if(how==GIANT_ONLY && giant!=G.getComponent(V)) continue;
      if(count++>max) break;
      if(0==i++) {
        maxRank=G.getRank(V);
      }
      double r=G.getRank(V);
      int x=(int)Math.round(r/maxRank*255);
      if(x<15) x=1;
      else if(x>255) x=255;
      Color C=new Color(x,255-x,0);
      Object D=G.vertexData(V);
      String ChoppedD=D.toString();
      if(chop>0 && chop<ChoppedD.length()) ChoppedD=ChoppedD.substring(0,chop);
      Node N=A.addNode(//x+
        "["+i+"]:"+V+"=>"+ChoppedD,1);
      N.setBackColor(C);
      Map.put(V,N);
    }
    
    vs=G.vertexIterator(); 
    count=0;
    while(vs.hasNext()) {
      Object V=vs.next();
      if(how==GIANT_ONLY && giant!=G.getComponent(V)) continue;
      if(count++>max) break;
      Node from=(Node)Map.get(V);
      if(WITH_ROOT==how) A.addEdge(Root,from);
      ObjectIterator es=G.outIterator(V);
      while(es.hasNext()) {
        Node to=(Node)Map.get(es.next());
        A.addEdge(from,to);
      }
    }
    A.showAll();
  }
  
  public void showAll() {
    panel.setVisible(true);
    //new GLEditUI(panel).activate();
    new GLNavigateUI(panel).activate();
    add("Center", panel);
    setSize(800,600);
    setVisible(true);
  }
  
  public void clearAll() {
    panel.stopThreads();
    remove(panel);
    removeAll();
    dispose();
    //System.exit(0);
  }
  
  public static void main( String[] args ) {

    TGAdaptor A = new TGAdaptor();
    
    Node root=A.addNode("ROOT",0);
    Node a=A.addNode("AAAAAAAAAAAAAA",1);
    Node b=A.addNode("BBBBBBBBBB",2);
    Node c=A.addNode("CCCC",3);
    A.addEdge(root,a);
    A.addEdge(root,b); 
    A.addEdge(root,c);
    A.showAll();
  }
}


interface GraphSpec {
  public Object[] vertices();
  public Object[] edges(Object V);
}


