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

  module IP = struct
    let output: 'a typ -> 'a typ = fun t -> t

    let ip_addr_pton = 
      foreign "ip_addr_pton" (string @-> output ocaml_bytes @-> returning int)
  end
end
