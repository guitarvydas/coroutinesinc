#include <stdio.h>

void decompressor () {
  static int c, len;
  while (1) {
    c = getchar ();
    if (c == EOF)
      break;
    if (c == 0xFF) {
      len = getchar ();
      c = getchar ();
      while (len--)
	emit (c);
    } else
      emit (c);
  }
  emit (EOF);
}
