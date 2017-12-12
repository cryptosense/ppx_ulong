open OUnit2

let (>:=) s test = s >:: test s

let equal_string s s' = String.compare s s' = 0

let show_string = Printf.sprintf "%S"

let equal_string_res s s' =
  let open Result in
  match s, s' with
    | Ok s, Ok s' -> equal_string s s'
    | Error s, Error s' -> equal_string s s'
    | Ok _, Error _
    | Error _, Ok _
      -> false

let show_string_res = function
  | Result.Ok s -> Printf.sprintf "Ok %s" @@ show_string s
  | Result.Error s -> Printf.sprintf "Error %s" @@ show_string s

let test_strip_underscores =
  let test expected s ctxt =
    let actual = Ppx_ulong_lib.strip_underscores s in
    assert_equal ~ctxt ~cmp:equal_string ~printer:show_string expected actual
  in
  "strip_underscores" >:::
  [ "Empty" >:: test "" ""
  ; "10" >:= test "10"
  ;  "1_0" >:= test "10"
  ]

let test_ulong_lit_string_of_string =
  let test expected s ctxt =
    let actual = Ppx_ulong_lib.ulong_lit_string_of_string s in
    assert_equal ~ctxt ~cmp:equal_string_res ~printer:show_string_res expected actual
  in
  let open Result in
  "ulong_lit_string_of_string" >:::
  [ "1" >:= test (Ok "1")
  ; "1_000" >:= test (Ok "1000")
  ; "-1" >:= test (Error Ppx_ulong_lib.out_of_range_msg)
  ]

let suite =
  "Ppx_ulong_lib" >:::
  [ test_strip_underscores
  ; test_ulong_lit_string_of_string
  ]

let _ = run_test_tt_main suite
