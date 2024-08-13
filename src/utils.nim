import std/strutils

proc emu2pt*(emu: int): string =
  return $float(emu / 12700) & "pt"

proc pt2emu*(pt: string): int =
  return int(pt.replace("pt").parseFloat * 12700)