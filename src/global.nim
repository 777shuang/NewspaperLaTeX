import std/xmltree
import zippy/ziparchives

var zipArchiveReader*: ZipArchiveReader
var document_rels*: XmlNode

var leftMargin*, rightMargin*: int # EMU
var topMargin*, bottomMargin*: int # EMU
var paperWidth*, paperHeight*: int # EMU