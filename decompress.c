//#include <stdio.h>
int getchar();
#include "coroutines.h"

int decompressor () {
  static int c, len;
  crBegin;
  while (1) {
    c = getchar ();
    if (c == EOF)
      break;
    if (c == 0xFF) {
      len = getchar ();
      c = getchar ();
      while (len--)
	crReturn(c);
    } else
      crReturn(c);
  }
  crFinish;
}
