module [
    Pagination,
    PageBased,
    fromIndexAndLimit,
    fromPageBased,
    toPageBased,
]

Pagination : {
    limit : U64,
    offset : U64,
}

PageBased : {
    page : U64,
    pageSize : U64,
}

fromPageBased : PageBased -> Pagination
fromPageBased = \pageBased -> {
    limit: pageBased.pageSize,
    offset: (pageBased.page - 1) * pageBased.pageSize,
}

toPageBased : U64, Pagination -> PageBased
toPageBased = \pageSize, pagination -> {
    pageSize,
    page: (pagination.offset // pageSize) + 1,
}

fromIndexAndLimit : { index : U64, limit : U64 } -> Pagination
fromIndexAndLimit = \{ index, limit } -> {
    limit,
    offset: ((index - 1) // limit) * limit,
}
