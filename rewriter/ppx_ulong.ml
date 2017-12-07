open Migrate_parsetree

open Ast_405.Ast_mapper
open Ast_405.Parsetree

let ocaml_version = Versions.ocaml_405

let expr mapper = function
  | { pexp_desc = Pexp_constant (Pconst_integer (s, Some 'u'))
    ; pexp_loc
    ; pexp_attributes
    }
    ->
      (
        match Ppx_ulong_lib.ulong_lit_string_of_string s with
          | Ok s ->
              let int64_lit =
                { pexp_desc = Pexp_constant (Pconst_integer (s, Some 'L'))
                ; pexp_loc
                ; pexp_attributes = []
                }
              in
              let expr = [%expr Unsigned.ULong.of_int64 [%e int64_lit]] [@metaloc pexp_loc] in
              {expr with pexp_attributes}
          | Error msg ->
              let error = Location.error ~loc:pexp_loc msg in
              { pexp_desc = Pexp_extension (extension_of_error error)
              ; pexp_loc
              ; pexp_attributes
              }
      )
  | expr
    -> default_mapper.expr mapper expr

let mapper _ _ = {default_mapper with expr}

let () = Driver.register ~name:"ppx_ulong" ocaml_version mapper
