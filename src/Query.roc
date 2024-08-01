module [Query, OrderBy, OrderByDirection, Where, todoQuery, mediaQuery]

OrderByDirection : [Asc, Desc]

Query field : {
    limit : I32,
    offset : I32,
    orderBy : OrderBy field,
    where : Where field,
}

OrderBy a : [Asc a, Desc a]

Where a : [
    And (List (Where a)),
    Or (List (Where a)),
    EqNum a F64,
    NeqNum a F64,
    EqStr a Str,
    Like a Str,
    Gte a F64,
]

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
