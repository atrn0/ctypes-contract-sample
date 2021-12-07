module C = Bindings.C(Generated.Cstubs_gen)

exception IP_addr_error

(* foreign "ip_addr_pton" (string @-> Cbuf.output 4 ocaml_bytes @-> returning int) *)
let ip_addr_pton = fun v1 ->
  let n = Bytes.create 4 in
  let ret = C.IP.ip_addr_pton v1 {buffer=Ctypes.ocaml_bytes_start n; size=0} in
  if ret <> 0 then raise IP_addr_error else n
