let () =
  let fmt = Format.formatter_of_out_channel (open_out "cstubs_gen.c") in
  Format.fprintf fmt "#include \"c/sample.h\"\n";
  Cstubs.write_c fmt ~prefix:"caml_" (module Bindings.C);

  let fmt = Format.formatter_of_out_channel (open_out "cstubs_gen.ml") in
  Cstubs.write_ml fmt ~prefix:"caml_" (module Bindings.C);

  let fmt = Format.formatter_of_out_channel (open_out "cbuf_gen.ml") in
  Cbuf.write_ml fmt (module Bindings.C) ~module_name:"C.IP";
