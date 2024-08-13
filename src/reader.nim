import std/xmltree
import std/sequtils
import std/enumutils
import types
import utils

proc textbox*(drawing: XmlNode, rectangles: var seq[Rectangle], texts: var seq[Text]) {.inline.} =
  let anchor = drawing.child("wp:anchor")
  let wsp = anchor.child("a:graphic").child("a:graphicData").child("wp:wsp")
  let spPr = wsp.child("wp:spPr")
  if wsp != nil and spPr.child("a:prstGeom").attr("prst") == "rect":

    var rectangle: Rectangle
    rectangle.x = emu2mm(anchor.child("wp:positionH").child("wp:posOffset").innerText)
    rectangle.y = emu2mm(anchor.child("wp:positionV").child("wp:posOffset").innerText)
    rectangle.w = emu2mm(anchor.child("wp:extent").attr("cx"))
    rectangle.h = emu2mm(anchor.child("wp:extent").attr("cy"))
    let a_ln = spPr.child("a:ln")
    if a_ln != nil:
      rectangle.t = emu2mm(a_ln.attr("w"))
    rectangles.add(rectangle)

    let txbx = wsp.child("wp:txbx")
    if txbx != nil:
      let txbxContent = txbx.child("wne:txbxContent")
      var text: Text

      text.x = rectangle.x
      text.y = rectangle.y
      text.w = rectangle.w
      text.h = rectangle.h
      text.vert = Vert.horz
      let bodyPr = wsp.child("wp:bodyPr")
      let bodyPr_vert = bodyPr.attr("vert")
      if bodyPr_vert != "":
        for item in Vert.toSeq:
          if bodyPr_vert == item.symbolName:
            text.vert = item
            break

      for p in txbxContent:
        var paragraph: Paragraph
        for r in p:
          let t = r.child("w:t")
          if t != nil:
            var run: Run
            run.fontsize = 10.5
            run.text = t.innerText
            paragraph.runs.add(run)
        text.paragraphs.add(paragraph)
      texts.add(text)