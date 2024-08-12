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

type TextBox* = object of Object
    text*: string
    vert*: Vert