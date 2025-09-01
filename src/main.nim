import std/os
import tinydialogs
import convert

let path = openFileDialog("Open word document", getCurrentDir() / "\0", ["*.docx"], "Word document")
convert_wrapper(path)