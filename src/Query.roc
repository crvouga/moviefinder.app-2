module [Query, OrderBy, OrderByDirection, Where, todoQuery, mediaQuery]

OrderByDirection : [Asc, Desc]

Query a : {
    limit : U64,
    offset : U64,
    orderBy : OrderBy a,
    where : Where a,
} where a implements Eq

OrderBy a : [Asc a, Desc a] where a implements Eq

Where a : [
    And (List (Where a)),
    Or (List (Where a)),
    EqNum a F64,
    NeqNum a F64,
    EqStr a Str,
    Like a Str,
    Gte a F64,
] where a implements Eq

#
#
#
#
#

TodoField : [Id, Title, Completed]

todoQuery : Query TodoField
todoQuery = {
    limit: 10,
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
    limit: 10,
    offset: 0,
    orderBy: Desc Rating,
    where: And [
        Gte Rating 10,
    ],
}
