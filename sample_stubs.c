#include "sample.h"
#include "ctypes_cstubs_internals.h"
value caml__1_f(value x1)
{
   int x2 = Long_val(x1);
   int x5 = f(x2);
   return Val_long(x5);
}
