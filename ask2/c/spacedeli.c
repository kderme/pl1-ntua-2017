#include <stdlib.h>
#include <stdio.h>
#include <limits.h>


typedef struct node_{
	int x,y;
	char type;
	int min;
	int pizza;
	int visited;
	int closed;
	char move;
	struct node_ *prev;
}Node;

int new_Node(Node *n, int x,int y, char type, int pizza,int min, int visited,int closed){
	n->x=x;
	n->y=y;
	n->type=type;
	n->pizza=pizza;
	n->min=min;
	n->visited=visited;
	n->closed=closed;
	n->move=' ';
	n->prev=NULL;
}

typedef struct ListNode_{
	struct ListNode_ *next;
	Node * node;
}ListNode;

typedef struct List_{
	ListNode *head;
	ListNode *tail;
	int length;
}List;

ListNode * new_ListNode(Node *nd){
	ListNode *lnd=malloc(sizeof(ListNode));
	lnd->next=NULL;
	lnd->node=nd;
	return lnd;
}

List * new_List(){
	List * ls=malloc(sizeof(List));
	ls->length=0;
	ls->head=NULL;
	ls->tail=NULL;
	return ls;
}

void add_existing_node_to_list(List * ls,ListNode *nd){
	nd->next=NULL;
	if (ls->length==0)
		ls->head=nd;
	else
		ls->tail->next=nd;
	ls->tail=nd;
	ls->length++;
}

void add_new_node_to_list(List * ls,Node *nd){
	ListNode * lnd = new_ListNode(nd);
	add_existing_node_to_list(ls,lnd);
}

int N,M,counter;
#define maxSize 1000
	Node nodes[maxSize][maxSize];
	Node nodes0[maxSize][maxSize];
Node *start,*end;
List *ls0;
List *ls1;
List *ls2;
List *ls3;

void read_file(char * file){
	//open file
	FILE *f=fopen(file,"r");
	if(!f){
		perror("");
		exit(1);
	}

	int i=0;
	int j=0;
	int c;
	while(1){
		while((c=fgetc(f))!=EOF && c!='\n'){
//int new_Node(Node *n, int x,int y, char type, int pizza,int min, int visited,closed){
			new_Node(&nodes[i][j],i,j,c,1,INT_MAX,0,0);
			new_Node(&nodes0[i][j],i,j,c,0,INT_MAX,0,0);
			if(c=='S')
				start=&nodes[i][j];
			if(c=='E')
				end=&nodes[i][j];
			j++;
		}
		if(c==EOF){
			if(j==0)
				N=i;
			else
				N=i+1;
			break;
		}
		else if(c=='\n'){
			if(i==0)
				M=j;
			i++;
			j=0;
		}
	}

#if defined(DBG)
	printf("read from file:\n");
	printf("N=%d\n",N);
	printf("M=%d\n",M);
	for(i=0; i<N; i++){
		for(j=0;j<M;j++)
			printf("%c",nodes[i][j].type);
		printf("\n");
	}
#endif
	fclose(f);
}

void init(){
	ls0=new_List();
	ls1=new_List();
	ls2=new_List();
	ls3=new_List();

	start->visited=1;
	add_new_node_to_list(ls0,start);
	counter=0;

}

void rewind_lists(){
	ls0=ls1;
	ls1=ls2;
	ls2=ls3;
	ls3=NULL;
}

Node * goes_up(Node * nd){

}

Node * goes_right(Node * nd){

}

Node * goes_left(Node * nd){

}

Node * goes_down(Node * nd){

}

Node * goes_w(Node *nd){

}

void new_found(Node *next, Node * nd, int cost,char m){

}

char * create_path(){
	char *path=malloc(counter*sizeof(char));
	Node *nd;
	int i=counter-1;
	for(nd=end;nd!=start; nd=nd->prev){
		path[i]=nd->move;
	}
	return path;
}

char * find_path(){
	for(;;counter++){
		Node *nd;
		ListNode *lnd;
		for(lnd=ls0->head; lnd!=NULL; lnd=lnd->next){
			nd=lnd->node;
			Node * temp;
			if(temp=goes_up(nd)){
				int cost=2;
				if(nd->pizza==0)
					cost=1;
				new_found(temp, nd,cost,'U');
			}
			if(temp=goes_right(nd)){
				int cost=2;
				if(nd->pizza==0)
					cost=1;
				new_found(temp, nd,cost,'R');
			}
			if(temp=goes_left(nd)){
				int cost=2;
				if(nd->pizza==0)
					cost=1;
				new_found(temp, nd,cost,'L');
			}
			if(temp=goes_down(nd)){
				int cost=2;
				if(nd->pizza==0)
					cost=1;
				new_found(temp, nd,cost,'D');
			}
			if(nd->type=='W'){
				if(temp=goes_w(nd)){
					int cost=1;
					new_found(temp,nd, cost,'W');
				}
			}
			if(nd->type=='E'){
				return create_path();
			}
		}
	}
}

int main(int argc, char *args[]){
	if (argc!=2){
		printf("Usage: %s file.txt\n", args[0]);
		exit(1);
	}

	read_file(args[1]);
	
	init();

	char * path=find_path();

	printf("%d %s\n",counter,path);
}


