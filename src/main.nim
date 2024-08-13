import std/os
import std/enumerate
import std/[xmltree, xmlparser]
import zippy/ziparchives
import nimja/parser
import types, reader

proc render(marginleft, margintop:string, rectangles: seq[Rectangle], texts: seq[Text]): string =
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

let pgMar = body.child("w:sectPr").child("w:pgMar")
let marginleft = pgMar.attr("w:right")
let margintop = pgMar.attr("w:top")

echo render(marginleft, margintop, rectangles, texts)