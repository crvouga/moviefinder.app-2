module [VerifyCodeErr, toStr]

VerifyCodeErr : [WrongCode, ExpiredCode]

toStr : VerifyCodeErr -> Str
toStr = \err ->
    when err is
        WrongCode -> "Wrong code"
        ExpiredCode -> "Expired code"
