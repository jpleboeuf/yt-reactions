import macros
import strformat

template echoCode(str: string): string =
  # see https://nim-lang.org/docs/strformat.html#limitations
  block:
    let str0 {.inject.} = str
    &"echo \"{str0}\"\n"

template `%%`(a: int64, b: int64): bool =
  (a mod b == 0)

template `!^$`(s: string): bool =
  (s != "")

macro fizzbuzz*(nN) =
  if nN.kind != nnkIntLit:
    error("argument must be an int literal")
  var src = ""
  for i in 1 .. nN.intVal:
    let fizz = (if i %% 3: "Fizz" else: "")
    let buzz = (if i %% 5: "Buzz" else: "")
    if !^$fizz or !^$buzz:
      src &= echoCode(&"{fizz}{buzz}")
    else:
      src &= echoCode($i)
  parseStmt(src)

when isMainModule:
  fizzbuzz(100)
