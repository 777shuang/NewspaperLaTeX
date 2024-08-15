import std/os
import std/enumerate
import std/[xmltree, xmlparser]
import zippy/ziparchives
import nimja/parser
import types, reader, global, utils

proc render(rectangles: seq[Rectangle], texts: seq[Text]): string =
  compileTemplateFile(getScriptDir() / "template" / "main.nimja")

let zip = openZipArchive("test.docx")
let xmlnode = parseXml(zip.extractFile("word/document.xml"))
zip.close()
when not defined(release):
  writeFile("document.xml", $xmlnode)

let body = xmlnode.child("w:body")
let sectPr = body.child("w:sectPr")
let pgSz = sectPr.child("w:pgSz")
# 紙面サイズの算出
paperWidth = pt2emu(pgSz.attr("w:w"))
paperHeight = pt2emu(pgSz.attr("w:h"))
let pgMar = sectPr.child("w:pgMar")
# 余白の算出
leftMargin = pt2emu(pgMar.attr("w:left"))
rightMargin = pt2emu(pgMar.attr("w:right"))
topMargin = pt2emu(pgMar.attr("w:top"))
bottomMargin = pt2emu(pgMar.attr("w:bottom"))

var texts: seq[Text]
var rectangles: seq[Rectangle]

for paragraph in body:
  for (i, run) in enumerate(paragraph):
    let drawing = run.child("w:drawing")
    if drawing != nil:
      textbox(drawing, rectangles, texts)

writeFile("test.tex", render(rectangles, texts))
discard execShellCmd("latexindent -w test.tex")