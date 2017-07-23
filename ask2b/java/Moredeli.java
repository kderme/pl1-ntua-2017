import java.io.File;
import java.io.FileNotFoundException;
import java.util.ArrayList;
import java.util.Scanner;

public class Moredeli {

  final boolean DEBUG=false;
  private int N;
  private int M;
  private Node start;
  private Node end;
  private Node[][] nodes;
  
  public String path=null;
  public int totalCost=-1;
  
  public Moredeli(String file){
	  
	  try {
		File fl=new File(file);
		Scanner sc=new Scanner(fl);
		int i=0;
		ArrayList<String> lines=new ArrayList<String>(10);
		while(sc.hasNext()){
			String line=sc.next();
			lines.add(line);
		}
		sc.close();
		if(lines.size()==0){
			System.out.println("file with 0 lines");
			System.exit(1);
	    }
		M=lines.get(0).length();
		N=lines.size();
		nodes=new Node[N][M];
		for(i=0;i<N;i++){
			char[] linesi=lines.get(i).toCharArray();
			for(int j=0;j<M;j++){
				nodes[i][j]=new Node(i,j,linesi[j]);
				if(DEBUG)
					nodes[i][j].print();
				if (nodes[i][j].type=='S')
					start=nodes[i][j];
				else if (nodes[i][j].type=='E')
					end=nodes[i][j];
			}
			if(DEBUG)
				System.out.println();
		}
	} catch (FileNotFoundException e) {
		e.printStackTrace();
	}
  }
  
  public void search(){
	  ArrayList<Node> ls1=new ArrayList<Node>(1);
	  ls1.add(start);
	  ArrayList<Node> ls2=new ArrayList<Node>(0);
	  ArrayList<Node> ls3=new ArrayList<Node>(0);
	  ArrayList<Node> ls4=new ArrayList<Node>(0);
	  Node nd;
	  
	  for(int counter=0;;counter++){
		  if(DEBUG)
			  Node.printAll(ls1,ls2,ls3,ls4,counter);
		  for(Node node:ls1){
			  if (node==null){
				  System.out.println("can this be?");
				  System.exit(1);
			  }
				  
			  if (node.type=='E'){
				  find_path(counter);
			      return;
			  }
			  if (node.visited)
				  continue;
			  
			  nd=moveR(counter,node);
			  if (nd!=null)
				  ls2.add(nd);
		  
			  nd=moveD(counter,node);
			  if (nd!=null)
				  ls2.add(nd);
		  }
		  for(Node node:ls1){
			  if (node.visited)
				  continue;
			  nd=moveL(counter,node);
			  if (nd!=null)
				  ls3.add(nd);
		  }
		  for(Node node:ls1){
			  if (node.visited)
				  continue;
			  nd=moveU(counter,node);
			  if (nd!=null)
				  ls4.add(nd);
		  }
		  for(Node node:ls1)
			  node.visited=true;

		  ls1=ls2;
		  ls2=ls3;
		  ls3=ls4;
		  ls4=new ArrayList<Node>(0);
	  }
  }
  
  private void find_path(int counter) {
   	ArrayList<Character> ls=new ArrayList<Character>(counter);
   	for(Node node=end;node!=start;node=node.prev)
   		ls.add(0,node.move);
	StringBuilder result = new StringBuilder(ls.size());
	for (Character c : ls) {
		  result.append(c);
	}
	path = result.toString();
//   	path=new String (ls);
   	totalCost=end.min;
  }

	private Node move
(int counter, Node[][] nodes,int i,int j,int cost,char move,Node prev)
     {
		if(i<0 || i>=N || j<0 || j>=M)
			return null;
		else{
			Node node=nodes[i][j];
			if(node.visited||node.type=='X')
				return null;
			else{
				if(node.prev!=null && cost+counter>=node.min)
					return null;
				else{
					node.min=cost+counter;
					node.move=move;
					node.prev=prev;
					return node;
				}
			}
		}
		
	}
    private Node moveR(int counter, Node node){
		int inew=node.i;
		int jnew=node.j+1;
		return move(counter,nodes,inew,jnew,1,'R',node);
	}
    
    private Node moveD(int counter, Node node){
		int inew=node.i+1;
		int jnew=node.j;
		return move(counter,nodes,inew,jnew,1,'D',node);
	}
    
    private Node moveL(int counter, Node node){
		int inew=node.i;
		int jnew=node.j-1;
		return move(counter,nodes,inew,jnew,2,'L',node);
	}
    
	private Node moveU(int counter, Node node){
		int inew=node.i-1;
		int jnew=node.j;
		return move(counter,nodes,inew,jnew,3,'U',node);
	}
  
  public static void main(String args[]){
	  if(args.length!=1){
		  System.out.println("Usage: java Moredeli file\n");
		  System.exit(1);
	  }
	  Moredeli more=new Moredeli(args[0]);
	  
	  more.search();
	  
	  System.out.println(more.totalCost+" "+more.path);
  }
}

class Node {

	public int i;
	public int j;
	public char type;
	public int min=Integer.MAX_VALUE;
	boolean visited=false;
	char move='Q';
	Node prev=null;
	
	public Node(int i, int j,char type){
		this.i=i;
		this.j=j;
		this.type=type;
	}
	
	public void print(){
		String prv="null";
		if (prev!=null)
			prv="("+prev.i+","+prev.j+")";
		System.out.println
("("+i+","+j+","+type+","+min+","+visited+","+move+","+prv+")");
	}
	
	public static void printArr(ArrayList<Node> ls,String header){
		System.out.println(header);
		for(Node node:ls){
			node.print();
		}
	}

	public static void printAll(ArrayList<Node> ls1, ArrayList<Node> ls2, ArrayList<Node> ls3, ArrayList<Node> ls4,
			int counter) {
		System.out.println("counter="+counter);
		printArr(ls1,ls1.size()+"");
		printArr(ls2,ls2.size()+"");
		printArr(ls3,ls3.size()+"");
		printArr(ls4,ls4.size()+"");
	}
}
