module type FOREIGN = Ctypes.FOREIGN

module type FOREIGN' = FOREIGN with type 'a result = unit

module type BINDINGS = functor (F : FOREIGN') -> sig end

module CI = Cstubs_internals

(* exception Unimplemented *)

type cbuf_output = {size: int; buffer: bytes Ctypes.ocaml}

(* (cname, name, fn) *)
type bind = Bind : string * string * ('a -> 'b) Ctypes.fn -> bind

let rec buffer_size_of_fn: type a. a Ctypes.fn -> int = function
  | Returns _ -> 0
  | Function (CI.View {CI.ty = CI.(OCaml Bytes); read = r; _}, _) -> 4
  | Function (_, f) -> buffer_size_of_fn f

(* write_forign writes the cbuf wrapper function *)
let write_foreign fmt (bindings: bind list) =
  Format.fprintf fmt "@[\
module C = Bindings.C(Generated.Cstubs_gen)@.@.exception IP_addr_error@.";
  let write_buf_wrapper = fun (Bind (stub_name, _, fn)) ->
    Format.fprintf fmt "@.let %s = " stub_name;
    Format.fprintf fmt "fun v1 ->@.";
    Format.fprintf fmt "  let n = Bytes.create %d in" (buffer_size_of_fn fn);
    Format.fprintf fmt "  let ret = C.IP.ip_addr_pton v1 {buffer=Ctypes.ocaml_bytes_start n; size=0} in
  if ret <> 0 then raise IP_addr_error else n@.@]" 
  in 
  List.iter write_buf_wrapper bindings

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

type output = cbuf_output
