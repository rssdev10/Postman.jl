"""
  Base structrures for internal representation of Postman collections

  The structrures based on https://schema.postman.com/collection/json/v2.1.0/draft-04/collection.json
"""
module Collections

struct Body
    mode::Union{String,Nothing} # "raw","urlencoded","formdata","file","graphql" 
    raw::String
    urlencoded::Union{Vector,Nothing}
    formdata::Union{Vector,Nothing}
    file::Union{Dict,Nothing}
    graphql::Union{Dict,Nothing}
    options::Union{Dict,Nothing}
    disabled::Union{Bool,Nothing}
end

# "id": "#/definitions/url"
struct Url
    """The string representation of the request URL, including the protocol, host, path, hash, query parameter(s) and path variable(s)."""
    raw::String

    protocol::Union{String,Nothing}
    host::Union{String,Vector{String},Nothing}

    path::Union{String,Vector,Nothing}
    port::Union{String,Nothing}
    query::Union{Vector,Nothing}
    hash::Union{String,Nothing}
    variable::Union{Vector,Nothing}
end

# "id": "#/definitions/header"
struct Header
    key::String
    value::String
    disabled::Union{Bool,Nothing}
end

#   "id": "#/definitions/request"
struct Request
    """
    "GET", "PUT", "POST", "PATCH", "DELETE",
    "COPY", "HEAD", "OPTIONS",
    "LINK", "UNLINK", "PURGE", "LOCK", "UNLOCK",
    "PROPFIND", "VIEW"
    """
    method::Union{String,Nothing}
    header::Union{Vector{Header},Nothing}
    body::Union{Body,Nothing}
    url::Union{Url,Nothing}
end

# "id": "#/definitions/item"
struct Item
    name::String
    request::Union{Request,Nothing}
    response::Union{Vector{Any},Nothing}
end

# "id": "#/definitions/item-group"
struct ItemGroup
end

# "id": "#/definitions/info"
struct Info
    _postman_id::Union{String,Nothing}
    name::String
    schema::String
end

# "id": "https://schema.getpostman.com/json/collection/v2.1.0/"
struct Collection
    info::Info
    item::Union{Vector{Item},Nothing}
end


function Base.iterate(collection::Collection)
    isnothing(collection.item) && return nothing

    return Base.iterate(collection.item)
end

Base.iterate(collection::Collection, state) =
    Base.iterate(collection.item, state)

end