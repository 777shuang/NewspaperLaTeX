# Package

version       = "0.1.0"
author        = "777shuang"
description   = "A new awesome nimble package"
license       = "Proprietary"
srcDir        = "src"
bin           = @["main"]


# Tasks

import std/os
import std/strutils
task countlines, "プログラムの総行数を算出":
  var lines = 0
  for file in walkDirRec(getCurrentDir(), skipSpecial=true):
    let (dir, _, ext) = splitFile($file)
    if not dir.contains(".git"):
      case ext
      of ".nim", ".nimja":
        lines += readFile($file).count('\n')
  echo lines

# Dependencies

requires "nim >= 2.0.0"
requires "tinyfiledialogs"
requires "zippy"
requires "nimja == 0.8.7"