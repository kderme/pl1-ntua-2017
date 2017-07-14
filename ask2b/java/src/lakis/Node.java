package lakis;

import java.util.ArrayList;

public class Node {

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

