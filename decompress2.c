//#include <stdio.h>
int getchar();

#define WAIT_FOR_CHARACTER 0
#define WAIT_FOR_LEN 1
#define WAIT_FOR_RUN_CHAR 2

#define Next(n) state = n

void decompressor_handler (Message msg) {
  static int c, len;
  state state = WAIT_FOR_CHARACTER;
  c = (int)msg.datum;
  switch (state) {
  case WAIT_FOR_CHARACTER:
    break;
  case WAIT_FOR_LEN:
    break;
  case WAIT_FOR_RUN_CHAR:
    break;
  }
}
