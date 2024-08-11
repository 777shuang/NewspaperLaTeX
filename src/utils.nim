import std/strutils

proc emu2mm*(emu: string): float =
  return emu.parseInt / 36000