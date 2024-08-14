import std/xmltree
import std/strutils
import std/sequtils
import std/enumutils
import types, global

# 第1引数に<wp:anchor>要素のXmlNodeを渡して、長方形の座標と幅、大きさを算出する。
# 枠線の太さは算出しない。
proc getRectangle(anchor: XmlNode): Rectangle {.inline.} =
  var result: Rectangle

  # 幅・高さの算出
  let extent = anchor.child("wp:extent")
  result.w = extent.attr("cx").parseInt
  result.h = extent.attr("cy").parseInt

  # X座標の算出
  let positionH = anchor.child("wp:positionH")
  let posOffsetH = positionH.child("wp:posOffset")
  let relativeFromH = positionH.attr("relativeFrom")
  if posOffsetH != nil: # 固定値で設定されていた場合
    let x = posOffsetH.innerText.parseInt
    result.x = case relativeFromH
      of "margin", "leftMargin": leftMargin + x
      of "rightMargin": rightMargin + x
      of "page": x
      else: 0
  else:
    let wp_align = positionH.child("wp:align")
    if wp_align != nil:
      let alignH = wp_align.innerText
      case relativeFromH
      of "page":
        case alignH
        of "left": result.x = 0
        of "center": result.x = paperWidth div 2 - result.w div 2
        of "right": result.x = paperWidth - result.w
      of "leftMargin":
        case alignH
        of "left": result.x = 0
        of "center": result.x = leftMargin div 2 - result.w div 2
        of "right": result.x = leftMargin - result.w
      of "rightMargin":
        case alignH
        of "left": result.x = paperWidth - rightMargin
        of "center": result.x = paperWidth + rightMargin div 2 - result.w div 2
        of "right": result.x = paperWidth
      of "margin":
        case alignH
        of "left": result.x = leftMargin
        of "center": result.x = leftMargin + (paperWidth - leftMargin - rightMargin) div 2 - result.w div 2
        of "right": result.x = paperWidth - result.w

  # Y座標の算出
  let positionV = anchor.child("wp:positionV")
  let posOffsetV = positionV.child("wp:posOffset")
  let relativeFromV = positionV.attr("relativeFrom")
  if posOffsetV != nil: # 固定値で設定されていた場合
    let y = posOffsetV.innerText.parseInt
    result.y = case relativeFromV
      of "margin", "topMargin": topMargin + y
      of "bottomMargin": bottomMargin + y
      of "page": y
      else: 0
  else:
    let wp_align = positionV.child("wp:align")
    if wp_align != nil:
      let alignV = wp_align.innerText
      case "page"
      of "page":
        case alignV
        of "top": result.y = 0
        of "center": result.y = paperHeight div 2 - result.h div 2
        of "bottom": result.y = paperHeight - result.h
      of "topMargin":
        case alignV
        of "top": result.y = 0
        of "center": result.y = topMargin div 2 - result.h div 2
        of "bottom": result.y = topMargin - result.h
      of "bottomMargin":
        case alignV
        of "top": result.y = paperHeight - result.y
        of "center": result.y = paperHeight + bottomMargin div 2 - result.h div 2
        of "bottom": result.y = paperHeight - result.h
      of "margin":
        case alignV
        of "top": result.y = topMargin
        of "center": result.y = topMargin + (paperHeight - topMargin - bottomMargin) div 2 - result.h div 2
        of "bottom": result.y = paperHeight - result.h

  return result

# テキストボックスを長方形と文字列に分けて処理する
proc textbox*(drawing: XmlNode, rectangles: var seq[Rectangle], texts: var seq[Text]) {.inline.} =
  let anchor = drawing.child("wp:anchor")
  let wsp = anchor.child("a:graphic").child("a:graphicData").child("wp:wsp")
  if wsp != nil:
    let spPr = wsp.child("wp:spPr")
    if spPr.child("a:prstGeom").attr("prst") == "rect":
      var rectangle = getRectangle(anchor)
      let a_ln = spPr.child("a:ln")
      if a_ln != nil:
        rectangle.t = a_ln.attr("w").parseInt
        rectangles.add(rectangle) # 枠線に関する設定がなければLaTeXソースには出力しない

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