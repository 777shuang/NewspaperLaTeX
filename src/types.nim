type Vert* {.pure.} = enum
    horz
    eaVert
    vert
    vert270

type Object* = object of RootObj
    x*: float # x[mm]
    y*: float # y[mm]
    w*: float # width[mm]
    h*: float # height[mm]

type Rectangle* = object of Object
    t*: float # thickness[mm]

type Text* = object of Object
    text*: seq[tuple[fontsize: float, content: string]]
    vert*: Vert