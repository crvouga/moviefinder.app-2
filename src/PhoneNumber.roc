module [PhoneNumber, fromStr, toStr, format, fromUrlSafeStr, toUrlSafeStr]

PhoneNumber := Str implements [Eq, Encoding, Decoding]

ensureCountryCode : Str -> Str
ensureCountryCode = \str ->
    if str |> Str.startsWith "+" then
        str
    else
        "+1$(str)"

validChars : Set Str
validChars = Set.fromList ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "+"]

keepValidChars : Str -> Str
keepValidChars = \str ->
    str |> chars |> List.keepIf (\char -> Set.contains validChars char) |> Str.joinWith ""

fromStr : Str -> Result PhoneNumber [InvalidPhoneNumber]
fromStr = \str ->
    cleaned = str |> Str.trim |> keepValidChars
    when cleaned is
        "" -> Err InvalidPhoneNumber
        _ -> cleaned |> ensureCountryCode |> @PhoneNumber |> Ok

toStr : PhoneNumber -> Str
toStr = \@PhoneNumber phoneNumber -> phoneNumber

chars : Str -> List Str
chars = \str ->
    Str.walkUtf8
        str
        []
        (
            \state, byte ->
                char = [byte] |> Str.fromUtf8 |> Result.withDefault ""
                List.append state char
        )

toUrlSafeStr : PhoneNumber -> Str
toUrlSafeStr = \phoneNumber ->
    phoneNumber
    |> toStr
    |> keepValidChars
    |> Str.replaceEach "+" "plus"

fromUrlSafeStr : Str -> Result PhoneNumber [InvalidPhoneNumber]
fromUrlSafeStr = \str ->
    str
    |> Str.replaceEach "plus" "+"
    |> Str.replaceEach "-" " "
    |> fromStr

format : PhoneNumber -> Str
format = \@PhoneNumber str ->
    countryCode = str |> chars |> List.takeFirst 2 |> Str.joinWith ""

    when countryCode is
        "+1" ->
            withoutCountryCode = str |> chars |> List.dropFirst 2
            areaCode = withoutCountryCode |> List.takeFirst 3 |> Str.joinWith ""
            middle = withoutCountryCode |> List.dropFirst 3 |> List.takeFirst 3 |> Str.joinWith ""
            end = withoutCountryCode |> List.dropFirst 6 |> Str.joinWith ""

            "+1 ($(areaCode)) $(middle)-$(end)"

        _ -> str

expect (fromStr "+12345678901") |> Result.map format == Ok "+1 (234) 567-8901"
