module C = Bindings.C(Generated.Cstubs_gen)

let () = 
  let output = C.Sample.f 10 in
  print_endline (Int.to_string output)
