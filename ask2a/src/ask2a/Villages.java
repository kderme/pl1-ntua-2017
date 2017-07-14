//package ask2a;

import java.util.*;
import java.lang.*;
import java.io.*;
 
public class Villages
{
	private static boolean DEBUG=false;
	private Integer N;
	private Integer M;
	
	public Integer sets;
 
	int parent [];

    Villages(int N,int M){
    	this.N=N;
    	this.M=M;
        this.sets=N;

        parent = new int[this.N];
 
        // Initialize all subsets as single element sets
        for (int i=0; i<this.N; ++i){
            parent[i]=-1;
        }
    }
 
    // A utility function to find the subset of an element i
    int find(int i){
	if (DEBUG)
	     	System.out.println(i);
    	while (parent[i] != -1){
    		parent[i]=parent[parent[i]];
    		i=parent[i];
        }
        return i;
    }
 
    // A utility function to do union of two subsets
    void Union(int x, int y){
    	int xset = find(x);
        int yset = find(y);
   		parent[xset] = yset;
   		
   		this.sets=this.sets-1;
    }
    
    public static void main(String [] args) throws IOException{
    	
    	BufferedReader in = new BufferedReader(new FileReader(args[0]));
    	
    	String line;
    	line = in.readLine();
    	String [] el=line.split(" ");
    	int N=new Integer (el[0]);
    	int M=new Integer (el[1]);
    	int K=new Integer (el[2]);
    	
    	Villages graph = new Villages(N, M);
    	
    	for(int i=0; i<M; i++){
    		line = in.readLine();
    		el=line.split(" ");
    		int x=new Integer (el[0]) -1;
    		int y=new Integer (el[1]) -1;
		if (DEBUG)
    			System.out.println(x+" "+y);
    	    graph.Union(x, y);
    	}
    	int result=graph.sets-K;
    	if(result<1)
    		result=1;
    	System.out.println(result);
    	in.close();
    }
}
