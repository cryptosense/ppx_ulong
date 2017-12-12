val out_of_range_msg : string

(** Return a string stripped from '_' characters *)
val strip_underscores : string -> string

(** Return true if the literal is too large to be converted, ie if it represents
    an integer greater than [Int64.max_int] *)
val too_large : string -> bool

(** Return a string sanitized for Unsigned.ULong.of_string or [Error msg] if the given
    string doesn't represent a valid ulong *)
val ulong_lit_string_of_string : string -> (string, string) Result.result
