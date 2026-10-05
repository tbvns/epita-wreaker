//Library of general use functions
//requires: stdio, stdlib, time


//#####################FUNCTION DECLARATIONS###################################
//string functions
unsigned long int strlen (char* str);
unsigned long int scat (char* s1, char* s2, char* s3, unsigned int len1, unsigned int len2);

//file functions
void prtrandgarb(unsigned long int len, unsigned int blocksz, FILE* dest);
void cpnonl (FILE** src, unsigned char nsrc, FILE* dest);



//#####################FUNCTION DEFINITIONS####################################
//---------------------str functions-------------------------------------------
//returns the length of a nul terminated str excluding nul terminator
unsigned long int strlen (char* str){
	unsigned long int r=0;
	while (str[r]){
		r++;
	}
	return r;
}

//concatenates strings s1 and s2 into s3
unsigned long int scat (char* s1, char* s2, char* s3, unsigned int len1, unsigned int len2){
	for (unsigned int i=0; i<len1; i++){
		s3[i]=s1[i];
	}
	for (unsigned int i=0; i<len2; i++){
		s3[i+len1]=s2[i];
	}
	return len1+len2;
}


//--------------------file functions-------------------------------------------
//just a function to generate random commented chars in a file (or stdout ig)
//each block is enclosed in `# ... `
//rand needs to be seeded outside of this function
void prtRandGarb(unsigned long int len, unsigned int blocksz, FILE* dest){
	char c;
	char buf[blocksz+3];
	unsigned int offset=len%blocksz;

	//sets up buffer so contents are not run in bash
	buf[0]=buf[offset+2]='`';
	buf[1]='#';

	for (unsigned int i=0; i<offset; i++){
		do {c=rand()%127;} while (c=='`' || c=='\n');
		buf[i+2]=c;
	}
	fwrite(buf, 1, offset+3, dest);

	len-=offset;
	buf[blocksz+2]='`';
	while (len>0){
		for (unsigned int i=0; i<blocksz; i++){
			do {c=rand()%127;} while (c=='`' || c=='\n');
			buf[i+2]=c;
		}
		fwrite(buf, 1, blocksz+3, dest);
		len-=blocksz;
	}
}


//copy no newline : copies the contents of (a) bash script(s) without newlines
void cpnonl (FILE** src, unsigned char nsrc, FILE* dest){
	char c;
	char tick=0;
	char com=0;

	for (unsigned char i=0; i<nsrc; i++){
		while( (c=fgetc(src[i])) != EOF){
			switch (c){
				case '#':
					if (!tick){fputc('`',dest);}
					com=tick=1;
					break;
				case '\n':
					if (!com){fputc('`',dest);}
					fputc('`',dest);
					c=';';
					break;
				case '`':
					if (tick && com){
						tick=com=0;
					} else if (!tick && !com){
						tick=1;
					}
			}
			fputc(c,dest);
		}
	}
}

