open Ctypes

module C(F: Cstubs.FOREIGN) = struct
  open F

  module Sample = struct
    let read (i: int) = i

    let write (i: int) = 
        assert(i > 0);
        i + 1
  
    let t = view int ~read ~write
  
    let f = foreign "f" (t @-> returning int)
  end
end
