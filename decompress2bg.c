#define WAIT_FOR_CHARACTER 0
#define WAIT_FOR_LEN 1

#define Next(n) state = n

void decompressor_handler (Message msg) {
  state state = WAIT_FOR_CHARACTER;
  switch (state) {
  case WAIT_FOR_CHARACTER:
    if (...) {
      Next(WAIT_FOR_LEN);
    } else if (...) {
    } else if (...) {
    }
    break;
  case WAIT_FOR_LEN:
    Next(WAIT_FOR_CHARACTER);
    break;
  }
}
