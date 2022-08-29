# Postman.jl

The primary purpose of this project is to allow the reuse of [Postman's manually created requests](https://www.postman.com/) for web services in Julia applications and unit tests.

The project implements a simple parser/runner of the Postman collections with minimal coverage of the Postman collection format.

## Example

```julia
using Postman
using HTTP

collection = Postman.load("postman_collection.json")

for item in collection
    @info "Process item: " * item.name # filter by name if required

    @time response::HTTP.Messages.Response = Postman.run(
        item, variables=Dict("port" => PORT)
    )

    dump(response)
end
```

Variables might be used for URLs only. For a string with `{{va1}}` markup all the occurrences will be removed or replaced by values of the same variables names provided through `variables` keyword argument.

## Note
 Postman.jl is implemented for Postman collection schema 2.1.0 only. See the [sample collection](test/data/postman_collection_2_1_0.json).

 If you want to use previous versions, please import and export them with [Postman](https://www.postman.com/) application.

 By default, schema 2.1.0 will be applied for all unknown collection formats.

 If you have a newer version, don't hesitate to add a new converter to the [internal representation](src/collection_common.jl). All the converters should be added into [the directory](src/decoders) with appropriate [test of the format](test/decoders/test_schema_2_1.jl).
