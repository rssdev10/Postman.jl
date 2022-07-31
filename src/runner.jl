module Runner
using ...Postman
using ...Postman.Collections
using HTTP

const CONTENT_TYPE = Dict(
    "text" => "text/plain",
    "html" => "text/html",
    "javascript" => "application/javascript",
    "json" => "application/json",
    "xml" => "application/xml"
)
const EMPTY_BODY = (HTTP.nobody, Dict())

function get_variables_ranges(str::String)
    result = Vector{Tuple{String,UnitRange}}()
    last_pos = 1
    rng = findfirst("{{", str)
    while !isnothing(rng)
        last_pos = last(rng) + 1
        rng_end = findnext("}}", str, last_pos)

        isnothing(rng_end) && break

        last_pos = last(rng_end) + 1
        push!(result, (
            str[last(rng)+1:first(rng_end)-1],
            first(rng):last(rng_end)+1
        ))

        rng = findnext("{{", str, last_pos)
    end

    return result
end

function replace_variables(
    str::String,
    ranges::Vector{Tuple{String,UnitRange}},
    variables::Dict)::String

    first_idx = !isempty(ranges) ? first(last(ranges[begin])) : length(str)
    last_idx = length(str)

    new_str = str[begin:first_idx-1]

    for i = 1:length(ranges)
        (var, range) = ranges[i]
        value = get(variables, var, nothing)
        isnothing(value) && continue

        if i < length(ranges)
            _, next_range = ranges[i+1]
            last_idx = last(next_range) + 1
            next_idx = first(next_range) - 1
        else
            next_idx = length(str)
        end

        new_str *= string(value)
        new_str *= str[last(range):next_idx]
    end

    return new_str
end

function normalize_uri(uri_str::String, variables=Dict())

    uri = HTTP.URI(uri_str)
    if !HTTP.isvalid(uri) || !startswith(uri_str, "http")
        uri = HTTP.URI(string("http://", uri))
    end

    uri_str::String = string(uri)
    ranges = get_variables_ranges(uri_str)
    return HTTP.URI(replace_variables(uri_str, ranges, variables))
end

function get_body(body_rec::Union{Collections.Body,Nothing})
    isnothing(body_rec) && return EMPTY_BODY
    isnothing(body_rec.mode) && return EMPTY_BODY

    body = getfield(body_rec, Symbol(body_rec.mode))
    isnothing(body) && return EMPTY_BODY

    language = nothing
    if !isnothing(body_rec.options)
        item = get(body_rec.options, body_rec.mode, nothing)
        if !isnothing(item)
            language = get(item, "language", nothing)
        end
    end
    content_type = Dict("Content-Type" =>
        get(CONTENT_TYPE, language, "text/plain")
    )

    return (body, content_type)
end

function normalize_headers(headers::Vector{})
    Dict(
        begin
            header, content = split(header, ':')
            header => content
        end
        for header in something(item.request.header, [])
    )
end

function run(item::Postman.Collections.Item; variables=Dict(), verbose=0)
    @debug item
    (isnothing(item.request) || isnothing(item.request.url)) && return nothing

    uri = normalize_uri(item.request.url.raw, variables)
    headers = something(item.request.header, Collections.Header[]) |>
              h -> Dict(header.key => header.value for header in h)

    body, content_type = get_body(item.request.body)

    r = HTTP.request(
        item.request.method,
        uri,
        merge(content_type, headers),
        body;
        verbose=verbose
    )
    @debug r.status
    @debug String(r.body)

    return r
end
end
