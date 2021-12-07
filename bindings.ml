module C(F: Cstubs.FOREIGN) = struct
  open F

  module Sample = struct
    let read (i: int) = i

    let write (i: int) = 
        assert(i > 0);
        i + 1
  
    let t = Ctypes.view Ctypes.int ~read ~write
  
    let f = foreign "f" (t @-> returning Ctypes.int)
  end

  module IP = struct
    let buffer = Ctypes.view Ctypes.ocaml_bytes 
      ~read:(fun b: Cbuf.output -> {size=4; buffer=b})
      ~write:(fun {buffer=b; _} -> b)

    let ip_addr_pton = 
      foreign "ip_addr_pton" (Ctypes.string @-> buffer @-> returning Ctypes.int)
  end
end

(* 
let view ?format_typ ?format ~read ~write ty =
  View { read; write; format_typ; format; ty }

('a, 'b) view = {
  read : 'b -> 'a;
  write : 'a -> 'b;
  format_typ: ((Format.formatter -> unit) -> Format.formatter -> unit) option;
  format: (Format.formatter -> 'a -> unit) option;
  ty: 'b typ;
}
 *)
