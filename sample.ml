open Ctypes

module C = Bindings.C(Generated.Cstubs_gen)

let () = 
  let output = C.Sample.f 10 in
  print_endline (Int.to_string output)

exception IP_addr_error
let ip_addr_pton (p: string): bytes =
  let n = Bytes.create 4 in
  let ret = C.IP.ip_addr_pton p (ocaml_bytes_start n) in
  if ret <> 0 then raise IP_addr_error else n

let () =
  let n = ip_addr_pton "192.168.0.255" in
  Bytes.iter (fun c -> let i = Char.code c in print_int i; print_char '.') n;
