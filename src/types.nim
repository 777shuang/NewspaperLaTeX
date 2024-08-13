type Object* = object of RootObj
    x*: float # x[pt]
    y*: float # y[pt]
    w*: float # width[pt]
    h*: float # height[pt]

type Rectangle* = object of Object
    t*: float # thickness[pt]

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