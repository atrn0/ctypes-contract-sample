module type FOREIGN = Ctypes.FOREIGN

module type FOREIGN' = FOREIGN with type 'a result = unit

module type BINDINGS = functor (F : FOREIGN') -> sig end

let write_ml (fmt: Format.formatter) (module B : BINDINGS): unit =
  let foreign: (module FOREIGN') = (
    module struct
      type 'a fn = 'a Ctypes.fn
      type 'a return = 'a
      let (@->) = Ctypes.(@->)
      let returning = Ctypes.returning
      type 'a result = unit
      let foreign cname _ = print_endline ("executing foreign. cname: " ^ cname)
      let foreign_value cname _ = print_endline ("executing foreign_value. cname: " ^ cname)
    end) in
  let module _ = B((val foreign)) in
  Format.fprintf fmt "open Ctypes@.";
  print_endline "Cbuf.write_ml generated ml."
