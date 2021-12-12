module C(F: Cstubs.FOREIGN) = struct
  open F
  let read (i: int) = i

  let write (i: int) = 
      assert(i > 0);
      i + 1

  let t = Ctypes.view Ctypes.int ~read ~write

  module F = struct
    let f = foreign "f" (t @-> returning Ctypes.int)
  end

  let buffer = Ctypes.view Ctypes.ocaml_bytes 
    ~read:(fun b: Cbuf.cbuf_output -> {size=4; buffer=b})
    ~write:(fun {buffer=b; _} -> b)

  module IP = struct
    let ip_addr_pton = 
      foreign "ip_addr_pton" (Ctypes.string @-> buffer @-> returning Ctypes.int)
  end
  
  (* let buffer _ ty = ty
  let ip_addr_pton = 
    foreign "ip_addr_pton" (Ctypes.string @-> buffer 4 Ctypes.ocaml_bytes @-> returning Ctypes.int) *)
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
