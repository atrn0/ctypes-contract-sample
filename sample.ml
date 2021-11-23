open Ctypes

module C = Bindings.C(Generated.Cstubs_gen)

let () = 
  let output = C.Sample.f 10 in
  print_endline (Int.to_string output)

let () =
  let n = Bytes.create 4 in
  let ret = C.IP.ip_addr_pton "192.168.0.1" (ocaml_bytes_start n) in
  print_endline (Int.to_string ret);
  Bytes.iter (
    fun c ->
      let i = Char.code c in
      print_int i;
      print_char '.';
    ) n;
