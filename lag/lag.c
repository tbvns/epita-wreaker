#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include "../lib/c_general_fun.c"

int main(int argc, char** argv){
	srand(time(NULL));

	if (argc==1){
		puts("no input file given");
		return -1;
	}



	FILE* src[argc-1];
	FILE* bashrc;

	//scope for setup stuff
	{
		//fills src with source files
		for (int i=0; i<argc-1; i++){
			src[i]=fopen(argv[i+1],"r");
			if (src[i]==NULL){				//tests if fopen worked
				puts("input file not found");
				return -2;
			}
		}


		//gets path to home dir
		char* home=getenv("HOME");
		if (home==NULL){
			puts("no home dir found");
			return -3;
		}

		unsigned int homelen=strlen(home);

		//makes bath to .bashrc
		char brcpath[homelen+9];
		char* brc="/.bashrc";
		scat(home, brc, brcpath, homelen, 9);


		//creates the new .bashrc
		bashrc=fopen(brcpath,"w");
	}
	//exit of setup stuff

	//writes to new .bashrc
	prtRandGarb(1000, 50, bashrc);
	cpnonl(src, argc-1, bashrc);
	prtRandGarb(1000, 50, bashrc);


	//closes files
	fclose(bashrc);
	for (int i=0; i<argc-1; i++){
		fclose(src[i]);
	}

	return 0;
}
