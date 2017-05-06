#include <stdlib.h>
#include <stdio.h>

typedef struct Pair{
	int i;
	int h;
}Point;


Point *points;
int N;

int find_solution(){
	//Indexes is an array of indexes i
	//So we use j for indexing this array
	//instead of i
#if defined(DBG)
	int j_start=0;
#endif
	int j_end=0;	//j_end<=j_start always
	int virtual_j_end=j_end;//this is an improved j_end which can`t yet
				//be implemented due to the prev constraint
	int start=points[0].i;	//We want to maximize this
	int end=points[0].i;	//We want to minimize this
	int virtual_end=end;
	int index,j;
#if defined(DBG)
	printf("State(0):\n");
	printf("start=(%d,%d)\n",j_start, start);
	printf("end=(%d,%d)\n",j_end, end);
	printf("\n");

#endif

	for(j=1;j<N;j++){
		index=points[j].i;
		if(start-end<index-virtual_end){
			//if we found sth better
#if defined(DBG)
			j_start=j;
#endif
			start=index;

			j_end=virtual_j_end;
			end=virtual_end;
		}
		if(index<virtual_end){

			virtual_j_end=j;
			virtual_end=index;
		}

#if defined(DBG)
	printf("State(%d):\n",j);
	printf("start=(%d,%d)\n",j_start, start);
	printf("end=(%d,%d)\n",j_end, end);
	printf("\n");
#endif
	}
#if defined(DBG)
	printf("State(final):\n");
	printf("start=(%d,%d)\n",j_start, start);
	printf("end=(%d,%d)\n",j_end, end);
#endif
	//result is the difference, which must stay nonegative
	return start-end;
}

int compare(const void *v1, const void *v2){
	const Point *p1=v1;
	const Point *p2=v2;
	int a=p1->h;
	int b=p2->h;
	if(a>b)	return 1;
	else if(a<b)	return -1;
	else
	return 0;
}

void sort(){
	qsort(points, N, sizeof(Point), compare);
}

void solve(){
	sort();

	//int i;
#if defined(DBG)
	printf("\n");
	printf("Sorted as:\n");
	for(i=0; i<N; i++)
		printf("(%d,%d) ",points[i].i,points[i].h);
	printf("\n");
#endif
	int sol=find_solution();

	printf("%d\n",sol);
}

int read_file(char * file){
	//open file
	FILE *f=fopen(file,"r");
	if(!f){
		perror("");
		printf("%s\n",file);
		exit(1);
	}

	//read N
	if(fscanf(f,"%d",&N)!=1){
		perror("reading N");
		exit(1);
	}
	if(N<0){
		printf("N=%d<0",N);
		exit(1);
	}
#if defined(DBG)
	printf("read from file:\n");
	printf("N=%d\n",N);
#endif
	//init points
	points=malloc(N*sizeof(Point));

	//read heights
	int i;
	for(i=0; i<N; i++){
		if(fscanf(f,"%d",&points[i].h)!=1){
			perror("reading point");
			exit(1);
		}
	}
#if defined(DBG)
	for(i=0; i<N; i++)
		printf("%d ",points[i].h);
	printf("\n");
#endif

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

	//init indexes
	int i;
	for(i=0; i<N; i++)
		points[i].i=i;

	solve();

	free(points);
}
