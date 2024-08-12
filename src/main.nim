import std/os
import std/enumerate
import std/enumutils
import std/sequtils
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
      let wsp = anchor.child("a:graphic").child("a:graphicData").child("wp:wsp")
      if wsp.child("wp:spPr").child("a:prstGeom").attr("prst") == "rect":
        let txbx = wsp.child("wp:txbx")
        if txbx != nil:
          var textbox: TextBox

          textbox.vert = Vert.horz
          let bodyPr = wsp.child("wp:bodyPr")
          let bodyPr_vert = bodyPr.attr("vert")
          if bodyPr_vert != "":
            for item in Vert.toSeq:
              if bodyPr_vert == item.symbolName:
                textbox.vert = item
                break

          let x = anchor.child("wp:positionH").child("wp:posOffset").innerText
          let y = anchor.child("wp:positionV").child("wp:posOffset").innerText
          let w = anchor.child("wp:extent").attr("cx")
          let h = anchor.child("wp:extent").attr("cy")

          textbox.x = emu2mm($x)
          textbox.y = emu2mm($y)
          textbox.w = emu2mm($w)
          textbox.h = emu2mm($h)

          let txbxContent = txbx.child("wne:txbxContent")
          for p in txbxContent:
            for r in p:
              let t = r.child("w:t")
              if t != nil:
                textbox.text &= t.innerText

          textboxes.add(textbox)

let pgMar = body.child("w:sectPr").child("w:pgMar")
let marginleft = pgMar.attr("w:right")
let margintop = pgMar.attr("w:top")

echo render(marginleft, margintop, textboxes)