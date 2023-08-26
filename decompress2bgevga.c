#define WAIT_FOR_CHARACTER 0
#define WAIT_FOR_LEN 1

#define Next(n) state = n

void decompressor_handler (Message msg) {
  state state = WAIT_FOR_CHARACTER;
  static int Len;
  c = (int)msg.datum;
  switch (state) {
  case WAIT_FOR_CHARACTER:
    if (c == 0xFF) {
      Len = c;
      Next(WAIT_FOR_LEN);
    } else if (c == EOF) {
    } else if (c != 0xFF && c != EOF) {
      Send ("out", c);
    }
    break;
  case WAIT_FOR_LEN:
    for (; Len > 0; Len -= 1) {
      Send ("out", c);
    }
    Next(WAIT_FOR_CHARACTER);
    break;
  }
}
