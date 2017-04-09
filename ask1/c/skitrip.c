#include <stdlib.h>
#include <stdio.h>

int *Indexes;
int N;

int find_solution(){
	//Indexes is an array of indexes i
	//So we use j for indexing this array
	//instead of i
	
	int j_start=0, j_end=0;	//j_end<=j_start always
	int virtual_j_end=j_end;//this is an improved j_end which can`t yet
				//be implemented due to the prev constraint
	int start=Indexes[0];	//We want to maximize this
	int end=Indexes[0];	//We want to minimize this
	int virtual_end=end;
	int index,j;

	for(j=1;j<N;j++){
		index=Indexes[j];
		if(index>start){
			j_start=j;
			start=index;

			j_end=virtual_j_end;
			end=virtual_end;
		}
		if(index<end){
			virtual_j_end=j;
			virtual_end=index;
		}
	}

	//result is the difference, which must stay nonegative
	return start-end;
	
}

int *Heights;

void sort(){
	//TODO
	//sort Heights (increasing order) but also swap Indexes
	
}

void solve(){
	sort();

	int sol=find_solution();

	printf("%d\n",sol);
}

int read_file(char * file){
	//open file
	FILE *f=fopen(file,"r");
	if(!f){
		perror("file not found\n");
		exit(1);
	}

	//read N
	int N=fscanf(f,"%d",&N);
	if(N<0){
		printf("N=%d<0",N);
		exit(1);
	}

	//read Heights
	Heights=malloc(N*sizeof(int));
	int i;
	for(i=0; i<N; i++)
		fscanf(f,"%d",&Heights[i]);

	//close file
	fclose(f);

	return N;
}


int main(int argc, char *args[]){
	if (argc!=2){
		printf("Usage: %s file.txt\n", args[0]);
		exit(1);
	}

	N=read_file(args[1]);
	
	Indexes=malloc(N*sizeof(int));
	int i;
	for(i=0; i<N; i++)
		Indexes[i]=i;
	
	free(Heights);

	solve();
		
	free(Indexes);
}


