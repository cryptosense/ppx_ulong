open OUnit2

let (>:=) s test = s >:: test s

let test_strip_underscores =
  let test expected s ctxt =
    let actual = Ppx_ulong_lib.strip_underscores s in
    assert_equal ~ctxt ~cmp:[%eq: string] ~printer:[%show: string] expected actual
  in
  "strip_underscores" >:::
  [ "Empty" >:: test "" ""
  ; "10" >:= test "10"
  ;  "1_0" >:= test "10"
  ]

let test_ulong_lit_string_of_string =
  let test expected s ctxt =
    let actual = Ppx_ulong_lib.ulong_lit_string_of_string s in
    assert_equal ~ctxt
      ~cmp:[%eq: (string, string) result]
      ~printer:[%show: (string, string) result]
      expected
      actual
  in
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
