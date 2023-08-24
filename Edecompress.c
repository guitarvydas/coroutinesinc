# 0 "decompress.c"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "/usr/include/stdc-predef.h" 1 3 4
# 0 "<command-line>" 2
# 1 "decompress.c"

int getchar();
# 1 "coroutines.h" 1
# 4 "decompress.c" 2

int decompressor () {
  static int c, len;
  static int state=0;
  switch (state) { 
  case 0:;
    while (1) {
      c = getchar ();
      if (c == EOF)
	break;
      if (c == 0xFF) {
	len = getchar ();
	c = getchar ();
	while (len--)
	  do {
	    state = 16;
	    return c;
	    case 16:;
	  } while (0);
      } else
	do {
	  state = 18; 
	  return c; 
	  case 18:; 
	} 
	while (0);
    }
  };
}
