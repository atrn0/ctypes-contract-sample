module C = Bindings.C(Generated.Cstubs_gen)

(* let () = 
  let output = C.Sample.f 10 in
  print_endline (Int.to_string output) *)

let () =
  let open Cbuf_gen in
  let n = ip_addr_pton "192.168.0.1" in
  Bytes.iter (fun c -> let i = Char.code c in print_int i; print_char '.') n
