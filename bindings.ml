open Ctypes

module C(F: Cstubs.FOREIGN) = struct
  open F
  let f = foreign "f" (int @-> returning int)
end
