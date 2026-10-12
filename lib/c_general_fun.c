//Library of general use functions
//requires: stdio, stdlib, 


//#####################FUNCTION DECLARATIONS###################################
//string functions
unsigned long int strlen (char* str);
unsigned long int scat (char* s1, char* s2, char* s3, unsigned int len1, unsigned int len2);
unsigned int intofstr (char* buf);

//file functions
char randbuf (char* buf, unsigned int len);
void wgarbln (unsigned int nl, FILE* dest);
void cpwgarb (FILE** src, unsigned char nsrc, FILE* dest);
void cpnonl (FILE** src, unsigned char nsrc, FILE* dest);



//#####################FUNCTION DEFINITIONS####################################
//---------------------str functions-------------------------------------------
//returns the length of a null terminated str excluding nul terminator
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


//NULL TERMINATED string
unsigned int intofstr (char* buf){
	unsigned int r=0;
	while (*buf){
		r=r*10+*buf-48;
		buf++;
	}
	return r;
}


//--------------------file functions-------------------------------------------
//just a function to generate random commented chars in a buffer
//each block is enclosed in `# ... `
//rand needs to be seeded outside of this function
char randbuf (char* buf, unsigned int len){
	unsigned char c;
	if (len<4){
		return -1;
	}

	buf[0]=buf[len-2]='`';
	buf[1]='#';
	buf[len-1]=';';

	for (unsigned int i=2; i<len-3; i++){
		do {c=rand()%255+1;} while (c=='`' || c=='\n');
		buf[i]=c;
	}
	//last char cant be "\"
	do {c=rand()%255+1;} while (c=='\\' || c=='`' || c=='\n');
	buf[len-3]=c;

	return 0;
}


void wgarbln (unsigned int nl, FILE* dest){
	char buf[3000];
	for (int i=0; i<nl; i++){
		randbuf(buf, 3000);
		buf[2999]='\n';
		fwrite(buf,1,3000,dest);
	}
}


//copys contents of src files into dest with trash at the start of each line
void cpwgarb (FILE** src, unsigned char nsrc, FILE* dest){
	char buf[6000];
	unsigned int len;

	for (unsigned char i=0; i<nsrc; i++){
		while (fgets(buf+3000,3000,src[i]) != NULL){
			len=strlen(buf+3000);
			buf[len+3000]='\n';

			if (3000-len<4){
				fwrite(buf+3000, 1, len, dest);
			}else{
				randbuf(buf+len,3000-len);
				fwrite(buf+len, 1, 3000, dest);
			}
		}
	}
}


//copy no newline : copies the contents of (a) bash script(s) without newlines
//not rly useful :<
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
