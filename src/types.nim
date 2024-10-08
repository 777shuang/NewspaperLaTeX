type Object* = object of RootObj
    x*: int # x[EMU]
    y*: int # y[EMU]
    w*: int # width[EMU]
    h*: int # height[EMU]

type Graphic* = object of Object
    path*: string # 画像ファイル名

type
    Frame* {.pure.} = enum
        solid
        dashed
        dotted
    Rectangle* = object of Object
        t*: int # thickness[EMU]
        frame*: Frame

type
    Jc* {.pure.} = enum # 文字揃え
        left # 左揃え
        center # 中央揃え
        right # 右揃え
    Run* = object
        fontsize*: float # [pt]
        text*: string
    Paragraph* = object
        runs*: seq[Run]
        jc*: Jc
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