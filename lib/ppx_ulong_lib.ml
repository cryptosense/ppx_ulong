let out_of_range_msg =
  "Integer literal exceeds the range of representable integers of type Unsigned.ULong.t"

let strip_underscores = Str.global_replace (Str.regexp "_") ""

(* We'll need a little extra work to support the entire ULong range *)
let max_ulong = Unsigned.ULong.(to_int64 max_int)
let max_ulong_32bit = compare max_ulong Int64.zero > 0
let max = if max_ulong_32bit then max_ulong else Int64.max_int

let max_dec = Printf.sprintf "%Ld" max
let max_hex = Printf.sprintf "0x%Lx" max
let max_oct = Printf.sprintf "0o%Lo" max
let max_bin = Printf.sprintf "0b%s" (String.make (if max_ulong_32bit then 32 else 63) '1')

let compare_repr s s' =
  let compared_length = compare (String.length s) (String.length s') in
  if compared_length = 0 then String.compare s s' else compared_length

let too_large s =
  let s = String.lowercase s [@warning "-3"] in
  if String.length s < 2 then false
  else
    match String.sub s 0 2 with
      | "0x" -> compare_repr s max_hex > 0
      | "0o" -> compare_repr s max_oct > 0
      | "0b" -> compare_repr s max_bin > 0
      | _ -> compare_repr s max_dec > 0

let ulong_lit_string_of_string s =
  let s = strip_underscores s in
  if s.[0] = '-' || too_large s then Result.Error out_of_range_msg
  else Result.Ok s
