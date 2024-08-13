type Object* = object of RootObj
    x*: int # x[EMU]
    y*: int # y[EMU]
    w*: int # width[EMU]
    h*: int # height[EMU]

type Rectangle* = object of Object
    t*: int # thickness[EMU]

type
    Run* = object
        fontsize*: float # [pt]
        text*: string
    Paragraph* = object
        runs*: seq[Run]
    Vert* {.pure.} = enum
        horz
        eaVert
        vert
        vert270
    Text* = object of Object
        paragraphs*: seq[Paragraph]
        vert*: Vert