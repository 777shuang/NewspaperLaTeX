type Object* = object of RootObj
    x*: float # x[mm]
    y*: float # y[mm]
    w*: float # width[mm]
    h*: float # height[mm]

type Rectangle* = object of Object
    t*: float # thickness[mm]

type
    Run* = object
        fontsize*: float
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