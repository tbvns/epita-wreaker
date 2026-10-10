#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include "../lib/c_general_fun.c"


//takes as param:	n of lines before content
//					n of lines after content
//					destination
//					source(s)
int main(int argc, char** argv){
	srand(time(NULL));

	if (argc<5){
		puts("no input file given");
		return -1;
	}



	FILE* src[argc-4];
	FILE* dest;

	
	//fills src with source files
	for (int i=0; i<argc-4; i++){
		src[i]=fopen(argv[i+4],"r");
		if (src[i]==NULL){				//tests if fopen worked
			puts("input file not found");
			return -2;
		}
	}

	//creates the new dest
	dest=fopen(argv[3],"w");


	//writes to new .bashrc
	wgarbln(intofstr(argv[1]), dest);
	cpwgarb(src, argc-4, dest);
	wgarbln(intofstr(argv[1]), dest);


	//closes files
	fclose(dest);
	for (int i=0; i<argc-4; i++){
		fclose(src[i]);
	}

	return 0;
}
