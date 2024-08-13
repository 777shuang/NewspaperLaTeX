import std/os
import std/enumerate
import std/[xmltree, xmlparser]
import zippy/ziparchives
import nimja/parser
import types, reader, global, utils

proc render(rectangles: seq[Rectangle], texts: seq[Text]): string =
  compileTemplateFile(getScriptDir() / "template.nimja")

let zip = openZipArchive("test.docx")
let xmlnode = parseXml(zip.extractFile("word/document.xml"))
zip.close()
writeFile("document.xml", $xmlnode)

var texts: seq[Text]
var rectangles: seq[Rectangle]

let body = xmlnode.child("w:body")
for paragraph in body:
  for (i, run) in enumerate(paragraph):
    let drawing = run.child("w:drawing")
    if drawing != nil:
      textbox(drawing, rectangles, texts)

let sectPr = body.child("w:sectPr")
let pgSz = sectPr.child("w:pgSz")
paperWidth = pt2emu(pgSz.attr("w:w"))
paperHeight = pt2emu(pgSz.attr("w:h"))
let pgMar = sectPr.child("w:pgMar")
leftMargin = pt2emu(pgMar.attr("w:left"))
rightMargin = pt2emu(pgMar.attr("w:right"))
topMargin = pt2emu(pgMar.attr("w:top"))
bottomMargin = pt2emu(pgMar.attr("w:bottom"))

echo render(rectangles, texts)