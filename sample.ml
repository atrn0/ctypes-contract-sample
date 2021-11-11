(* open Ctypes *)

module C = Bindings.C(Generated.Sample_generated)

let () = 
  let output = C.f 10 in
  print_endline (Int.to_string output)
