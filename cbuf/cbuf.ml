module type FOREIGN = Ctypes.FOREIGN

module type FOREIGN' = FOREIGN with type 'a result = unit

module type BINDINGS = functor (F : FOREIGN') -> sig end

type bind = Bind : string * string * ('a -> 'b) Ctypes.fn -> bind

let write_foreign fmt (bindings: bind list) =
  Format.fprintf fmt "@[\
open Ctypes

module C = Bindings.C(Generated.Cstubs_gen)

exception IP_addr_error
@]";
  List.iter (fun (Bind (stub_name, _, _)) ->
    Format.fprintf fmt "@[\
let %s (p: string): bytes =
  let n = Bytes.create 4 in
  let ret = C.IP.ip_addr_pton p (ocaml_bytes_start n) in
  if ret <> 0 then raise IP_addr_error else n
@]@."
    stub_name
    ) bindings

let write_ml (fmt: Format.formatter) (module B : BINDINGS): unit =
  let bindings = ref []
  and counter = ref 0 in
  let var name = incr counter;
    Printf.sprintf "caml_%d_%s" !counter name in
  let foreign: (module FOREIGN') = (
    module struct
      type 'a fn = 'a Ctypes.fn
      type 'a return = 'a
      let (@->) = Ctypes.(@->)
      let returning = Ctypes.returning
      type 'a result = unit
      let foreign cname fn =
        let name = var cname in
        bindings := Bind (cname, name, fn) :: !bindings
      let foreign_value cname _ = print_endline ("executing foreign_value. cname: " ^ cname)
    end) in
  let module _ = B((val foreign)) in
  write_foreign fmt !bindings;
  print_endline "Cbuf.write_ml generated ml."
