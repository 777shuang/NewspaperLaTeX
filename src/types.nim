type Object* = object of RootObj
    x*: int # x[EMU]
    y*: int # y[EMU]
    w*: int # width[EMU]
    h*: int # height[EMU]

type
    Frame* {.pure.} = enum
        solid
        dashed
        dotted
    Rectangle* = object of Object
        t*: int # thickness[EMU]
        frame*: Frame

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
    Anchor* {.pure.} = enum
        b # 下合わせ
        ctr # 中央合わせ
        t # 上合わせ
    Text* = object of Object
        paragraphs*: seq[Paragraph]
        vert*: Vert
        anchor*: Anchor