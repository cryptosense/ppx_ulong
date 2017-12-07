let out_of_range_msg =
  "Integer literal exceeds the range of representable integers of type Unsigned.ULong.t"

let strip_underscores = Str.global_replace (Str.regexp "_") ""

let ulong_lit_string_of_string s =
  let s = strip_underscores s in
  if s.[0] = '-' then Error out_of_range_msg
  else Ok s
