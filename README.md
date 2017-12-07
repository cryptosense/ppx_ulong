[![Build Status](https://travis-ci.org/cryptosense/ppx_ulong.svg?branch=master)](https://travis-ci.org/cryptosense/ppx_ulong)

# ppx_ulong

A ppx rewriter for integers' Unsigned.ULong literals

## Syntax

`ppx_ulong` transforms literals with the `u` suffix to an `Unsigned.ULong.t` value.

It turns:

```ocaml
10u
```

into:

```ocaml
Unsigned.ULong.of_int64 10L
```

`0x`, `0o` and `0b` notations are supported as well as `_`. If the literal isn't a
representable ulong value, it won't wrap it but will raise an ocaml.error.
