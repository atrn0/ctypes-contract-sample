module type FOREIGN = Ctypes.FOREIGN

module type BINDINGS = functor (F : FOREIGN with type 'a result = unit) -> sig end

val write_ml : Format.formatter -> (module BINDINGS) -> unit

type output = {size: int; buffer: bytes Ctypes.ocaml}
