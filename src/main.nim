import std/os
import std/enumerate
import std/[xmltree, xmlparser]
import zippy/ziparchives
import nimja/parser
import types, utils

proc render(marginleft, margintop:string, textboxes: seq[TextBox]): string =
  compileTemplateFile(getScriptDir() / "template.nimja")

let reader = openZipArchive("test.docx")
let xmlnode = parseXml(reader.extractFile("word/document.xml"))
writeFile("document.xml", $xmlnode)
reader.close()

var textboxes: seq[TextBox] = @[]

let body = xmlnode.child("w:body")
for paragraph in body:
  for (i, run) in enumerate(paragraph):
    let drawing = run.child("w:drawing")
    if drawing != nil:

      let anchor = drawing.child("wp:anchor")
      if anchor != nil:
        let x = anchor.child("wp:positionH").child("wp:posOffset").innerText
        let y = anchor.child("wp:positionV").child("wp:posOffset").innerText
        let w = anchor.child("wp:extent").attr("cx")
        let h = anchor.child("wp:extent").attr("cy")

        var textbox: TextBox
        textbox.x = emu2mm($x)
        textbox.y = emu2mm($y)
        textbox.w = emu2mm($w)
        textbox.h = emu2mm($h)
        textbox.text = "みかん"
        textboxes.add(textbox)

let pgMar = body.child("w:sectPr").child("w:pgMar")
let marginleft = pgMar.attr("w:right")
let margintop = pgMar.attr("w:header")

echo render(marginleft, margintop, textboxes)