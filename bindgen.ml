let () =
  let fmt = Format.formatter_of_out_channel (open_out "gen/sample_stubs.c") in
  Format.fprintf fmt "#include \"sample.h\"\n";
  Cstubs.write_c fmt ~prefix:"caml_" (module Bindings.C);

  let fmt = Format.formatter_of_out_channel (open_out "gen/sample_generated.ml") in
  Cstubs.write_ml fmt ~prefix:"caml_" (module Bindings.C)
