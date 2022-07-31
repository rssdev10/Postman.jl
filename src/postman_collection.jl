# https://www.postmanlabs.com/postman-collection/tutorial-concepts.html
# 
# https://schema.postman.com/
# 
# https://github.com/postmanlabs/postman-collection/blob/develop/examples/collection-v2.json

using JSON3
using StructTypes

abstract type Schema end;

include("collection_common.jl")
include("decoders/schema_2_1.jl")

const SCHEMAS = Dict(
    get_schema_url(schm) => schm
    for schm in [
        Schema_2_1_0()
    ]
)

const DEFAULT_SCHEMA = Schema_2_1_0()

function get_schema(schema_str::String)
    get(SCHEMAS, schema_str) do k
        @warn string(
            "Schema ", schema_str, "is not supported.",
            "Default schema is ", get_schema_url(DEFAULT_SCHEMA)
        )
        DEFAULT_SCHEMA
    end
end

"""
Minimal collection description to identify the schema 
"""
struct CollectionMinInfo
    info::Collections.Info
end

StructTypes.StructType(::Type{CollectionMinInfo}) = StructTypes.Struct()

decode(::Schema, str::String) = @error "There is no default schema."

function load(fn::String)::Collections.Collection
    data = open(f -> read(f, String), fn)

    obj = JSON3.read(data, CollectionMinInfo)
    schema = get_schema(obj.info.schema)

    return decode(schema, data)
end
