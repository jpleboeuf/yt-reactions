import macros
from os import removeFile
import unittest
import fizzbuzz_classic
import fizzbuzz

macro stdoutFileName: string =
  var stdoutStr = ""
  when defined(Windows):
    stdoutStr = "CONOUT$"
  elif defined(DOS) or defined(OS2):
    stdoutStr = "CON"
  else:
    stdoutStr = "/dev/stdout"
  result = quote do:
    `stdoutStr`

template procOutToString(p: untyped): string =
  # indirection needed, or:
  #  > Error: type mismatch: got <File, macro (): string{.noSideEffect, gcsafe, locks: <unknown>.}, FileMode>
  const stdoutFileName0: string = stdoutFileName  
  const tmpFileName: string = "tmp.out"
  var stdoutReopenRet: bool
  stdoutReopenRet = reopen(stdout, tmpFileName, fmWrite)
  p
  stdoutReopenRet = reopen(stdout, stdoutFileName0, fmWrite)
  let tmpFileStr = readFile(tmpFileName)
  removeFile(tmpFileName)
  tmpFileStr

suite "FizzBuzz":
  test "FizzBuzz 100":
    var
      fizzbuzzClassicOutput = procOutToString(fizzbuzz_classic(100))
      fizzbuzzOutput = procOutToString(fizzbuzz(100))
    check fizzbuzzClassicOutput == fizzbuzzOutput
