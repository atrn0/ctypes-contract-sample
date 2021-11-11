(* open Ctypes *)

module C = Bindings.C(Generated.Sample_generated)

let () = print_endline (Int.to_string (C.f 100))
