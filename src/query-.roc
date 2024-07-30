module [Query, SortDirection]

SortDirection : [Asc, Desc]

Query field value : {
    limit : Int,
    offset : Int,
    orderBy : OrderBy field,
    where : Where field,
}

OrderBy field : {
    field : field,
    direction : SortDirection,
}

Value : [Str, Int, Bool]

(Where field) = List (WhereClause field)

WhereOperation : [Eq, Neq, Gt, Gte, Lt, Lte, In, Like, And, Or]

WhereClause field : {
    operation : WhereOperation,
    field : field,
    value : Value,
}

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
    orderBy: {
        field: Id,
        direction: Asc,
    },
    where: {
        combine: And,
        clauses: [
            {
                operation: Eq,
                field: Completed,
                value: Bool False,
            },
        ],
    },
}
