#include "sample.h"

#include <stdint.h>

int f(int n) { return n * 2; }

int ip_addr_pton(const char *p, ip_addr_t *n) {
  char *sp, *ep;
  long ret;

  sp = (char *)p;
  for (int idx = 0; idx < 4; idx++) {
    ret = strtol(sp, &ep, 10);  // 10進数
    if (ret < 0 || ret > 255) {
      return -1;
    }
    if (ep == sp) {
      return -1;
    }
    if ((idx == 3 && *ep != '\0') || (idx != 3 && *ep != '.')) {
      return -1;
    }
    ((uint8_t *)n)[idx] = ret;
    sp = ep + 1;
  }
  return 0;
}
