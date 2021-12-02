module type FOREIGN = Ctypes.FOREIGN

module type FOREIGN' = FOREIGN with type 'a result = unit

module type BINDINGS = functor (F : FOREIGN') -> sig end

(* exception Unimplemented *)

(* (cname, name, fn) *)
type bind = Bind : string * string * ('a -> 'b) Ctypes.fn -> bind

(* let write_args fmt fn =
  let rec write_args2 : type a. Format.formatter -> a Ctypes.fn -> int -> unit = fun fmt fn counter -> 
    match fn with 
    | Function (_, f) -> 
      Format.fprintf fmt "@[(v%d: %s) @]" counter "(CI.View {CI.ty = CI.Pointer _})";
      write_args2 fmt f (counter + 1)
    | _ -> ()
  in
  write_args2 fmt fn 1 *)

let write_foreign fmt (bindings: bind list) =
  Format.fprintf fmt "@[\
module C = Bindings.C(Generated.Cstubs_gen)

exception IP_addr_error@.";
  let write_buf_wrapper = fun (Bind (stub_name, _, _)) ->
    Format.fprintf fmt "let %s: string -> bytes =@." stub_name;
    Format.fprintf fmt "  fun v1 ->@.";
    Format.fprintf fmt "  let n = Bytes.create 4 in
  let ret = C.IP.ip_addr_pton v1 (Ctypes.ocaml_bytes_start n) in
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

let output _ t  = t
