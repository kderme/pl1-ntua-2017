#include <stdlib.h>
#include <stdio.h>
#include <limits.h>

void debug();

typedef struct node_{
	int i;
	int j;
	char type;
	int pizza;

	int visited;
	int min;
	char move;
	struct node_ *prev;
}Node;

void update_Node(Node *n,int visited,int min, int move, Node * prev){
	if(n==NULL){
		printf("NULL Node at update_Node\n");
		exit(1);
	}
	n->visited=visited;
	n->min=min;
	n->move=move;
	n->prev=prev;
}

void new_Node(Node *n, int i,int j, char type, int pizza){
	n->i=i;
	n->j=j;
	n->type=type;
	n->pizza=pizza;

	update_Node(n,0,INT_MAX,' ',NULL);
}

typedef struct Array_{
	Node ** nodes;
	int length;
	int capacity;
	int initial_capacity;
}Array;

void insert(Array * arr,Node *nd){
	if(arr->length==arr->capacity){
		arr->nodes=realloc(arr->nodes,2*arr->capacity*sizeof(Node *));
	}
	arr->capacity=2*arr->capacity;
	arr->nodes[arr->length]=nd;
	arr->length++;
}

Node * removeNode(Array *arr){
	if(arr->length==0)
		return NULL;
	Node * nd = arr->nodes[arr->length-1];
	arr->length--;
	if (arr->length==0){
		arr->nodes=realloc(arr->nodes,arr->initial_capacity*sizeof(Node *));
		arr->capacity=arr->initial_capacity;
	}
	return nd;
}

Array * new_Array(int capacity){
	Array * arr=malloc(sizeof(Array));
	arr->length=0;
	arr->capacity=capacity;
	arr->initial_capacity=capacity;
	arr->nodes=malloc(capacity*sizeof(Node *));
	return arr;
}

int N,M,counter;
#define maxSize 1000
typedef enum{NOPIZZA=0, WARMHOLE, PIZZA, NUM_TYPES} Types;
Node nodes[2][maxSize][maxSize];
Node *start,*end;
Array *arr[3][NUM_TYPES];

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
			new_Node(&nodes[1][i][j],i,j,c,1);
			new_Node(&nodes[0][i][j],i,j,c,0);
			if(c=='S')
				start=&nodes[1][i][j];
			if(c=='E')
				end=&nodes[1][i][j];
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
			printf("%c",nodes[1][i][j].type);
		printf("\n");
	}
#endif
	fclose(f);
}

void init(){
	int i,j;
	for(i=0;i<3;i++){
		for(j=0; j<NUM_TYPES;j++){
			arr[i][j]=new_Array(N+M);
		}
	}

	start->visited=1;
	start->min=0;
	insert(arr[0][PIZZA],start);
	counter=0;

}

void rewind_arrays(){
	int i,j;
	Array *t[3];

	i=0;
	for(j=0; j<NUM_TYPES;j++)
		t[j]=arr[i][j];

	for(i=0;i<2;i++){
		for(j=0; j<NUM_TYPES;j++)
			arr[i][j]=arr[i+1][j];
	}
	i=2;
	for(j=0; j<NUM_TYPES;j++)
		arr[i][j]=t[j];

}

Node * valid_square(int i, int j, int pizza,int cost){
	int i_ok= (i>=0 && i<N);
	int j_ok= (j>=0 && j<M);
	if(!(i_ok && j_ok))
		return NULL;

	Node * temp = &nodes[pizza][i][j];
	if (temp->type=='X')
		return NULL;
	if(!(temp->visited))
		return temp;
	else
		return NULL;
}

void new_found(Node *temp, Node * nd,char m,int cost,Types type){
	insert(arr[cost][type],temp);
	if(temp->type=='W' && nd->type!='W')
		insert(arr[cost][WARMHOLE],temp);
	update_Node(temp,1,counter+cost,m,nd);
}

char * create_path(){
	char *path=malloc((counter+1)*sizeof(char));
	Node *nd;
	int i=0;
	for(nd=end;nd!=start; nd=nd->prev){
		path[i]=nd->move;
		i++;
	}
	path[i]='\0';

	int j,temp;
	for(j=0;j<i/2;j++){
		temp=path[j];
		path[j]=path[i-j-1];
		path[i-j-1]=temp;
	}
	return path;
}

void print(int i, int j){
	printf("(%d,%d)--{%d}--[",i,j,arr[i][j]->length);
	int k;
	Node *temp;
	for(k=0;k<arr[i][j]->length;k++){
		temp=arr[i][j]->nodes[k];
		printf("(%d,%d,%d,%d,%c)",temp->i,temp->j,temp->pizza,temp->min,temp->move);
		if(k+1<arr[i][j]->length)
			printf(",");
	}
	printf("]\n");
}

void debug(){
#if defined(DBG)
	printf("counter=%d\n",counter);
	int i,j;
	for(i=0;i<3;i++){
		for(j=0;j<NUM_TYPES;j++){
			print(i,j);
		}
	}
	printf("ok?");
	char c;
	while(!(c=getchar()));
#endif
}

void move_urld(Node * nd,int cost){
	Node * temp;
	Types type=NOPIZZA;
	if(nd->pizza)
		type=PIZZA;

	if((temp = valid_square(nd->i-1,nd->j,nd->pizza,cost))){
#if defined(DBG)
	printf("U%d",cost);	

#endif
		new_found(temp, nd,'U',cost,type);
	}
	if((temp =  valid_square(nd->i,nd->j+1,nd->pizza,cost))){
#if defined(DBG)
	printf("R%d",cost);
#endif
		new_found(temp, nd,'R',cost,type);
	}
	if((temp =  valid_square(nd->i,nd->j-1,nd->pizza,cost))){
#if defined(DBG)
	printf("L%d",cost);
#endif
		new_found(temp, nd,'L',cost,type);
	}
	if((temp =  valid_square(nd->i+1,nd->j,nd->pizza,cost))){
#if defined(DBG)
	printf("D%d",cost);
#endif
		new_found(temp, nd,'D',cost,type);
	}
}

void move_w(Node *nd){
	int cost=1;
	Types type=PIZZA;
	if(nd->pizza)
		type=NOPIZZA;
	Node *temp;
	if((temp = valid_square(nd->i,nd->j,1-nd->pizza,cost)))
		new_found(temp,nd,'W',cost,type);

}

char * search(){
	for(;;counter++){
		debug();
		Node *nd;
		while((nd = removeNode(arr[0][NOPIZZA])))
			move_urld(nd,1);
		while((nd = removeNode(arr[0][WARMHOLE])))
			move_w(nd);
		while((nd = removeNode(arr[0][PIZZA]))){
			if(nd->type=='E')
				return create_path();
			move_urld(nd,2);
		}
		rewind_arrays();
	}
}

int main(int argc, char *args[]){
	if (argc!=2){
		printf("Usage: %s file.txt\n", args[0]);
		exit(1);
	}

	read_file(args[1]);
	
	init();

	char * path=search();

	printf("%d %s\n",counter,path);
}


