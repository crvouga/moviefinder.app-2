module [VerifyCodeErr, toStr, encode, decode]

VerifyCodeErr : [WrongCode, ExpiredCode, Errored Str]

toStr : VerifyCodeErr -> Str
toStr = \err ->
    when err is
        WrongCode -> "Wrong code"
        ExpiredCode -> "Expired code"
        Errored str -> str

encode : VerifyCodeErr -> Str
encode = \err ->
    when err is
        WrongCode -> "WrongCode"
        ExpiredCode -> "ExpiredCode"
        Errored str -> str

decode : Str -> VerifyCodeErr
decode = \encoded ->
    when encoded is
        "WrongCode" -> WrongCode
        "ExpiredCode" -> ExpiredCode
        _ -> Errored encoded
