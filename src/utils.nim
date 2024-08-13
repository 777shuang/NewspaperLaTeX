import std/strutils

proc emu2pt*(emu: string): float =
  return emu.parseInt / 12700