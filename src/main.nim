import std/os
import std/enumerate
import std/[xmltree, xmlparser]
import zippy/ziparchives
import nimja/parser
import types, reader, global, utils

zipArchiveReader = openZipArchive("test.docx")
let xmlnode = parseXml(zipArchiveReader.extractFile("word/document.xml"))
document_rels = parseXml(zipArchiveReader.extractFile("word/_rels/document.xml.rels"))
when not defined(release):
  writeFile("document.xml", $xmlnode)
  writeFile("rels.xml", $document_rels)

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
var graphics: seq[Graphic]

for paragraph in body:
  for (i, run) in enumerate(paragraph):
    let drawing = run.child("w:drawing")
    if drawing != nil:
      textbox(drawing, rectangles, texts)
      graphic(drawing, graphics)

writeFile("test.tex", tmplf(getScriptDir() / "template" / "main.nimja"))
when not defined(release):
  discard execShellCmd("latexindent -w -s -l test.tex")
zipArchiveReader.close()