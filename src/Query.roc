module [Query, OrderBy, OrderByDirection, Where, todoQuery, mediaQuery]

OrderByDirection : [Asc, Desc]

Query a : {
    limit : U64,
    offset : U64,
    orderBy : OrderBy a,
    where : Where a,
} where a implements Eq & Encoding & Decoding & Inspect

OrderBy a : [Asc a, Desc a] where a implements Eq & Encoding & Decoding & Inspect

Where a : [
    And (List (Where a)),
    Or (List (Where a)),
    EqStr a Str,
    Like a Str,
] where a implements Eq & Encoding & Decoding & Inspect

#
#
#
#
#

TodoField : [Id, Title, Completed]

todoQuery : Query TodoField
todoQuery = {
    limit: 20,
    offset: 0,
    orderBy: Asc Id,
    where: And [
        Like Title "%My Todo%",
    ],
}

#
#
#
#

MediaField : [Id, Title, Genre, Year, Rating]

mediaQuery : Query MediaField
mediaQuery = {
    limit: 20,
    offset: 0,
    orderBy: Desc Rating,
    where: And [],
}
