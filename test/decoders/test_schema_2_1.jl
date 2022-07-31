include(joinpath("..", "common.jl"))

test_collection_fn = joinpath(
    TEST_DATA_PATH,
    "postman_collection_2_1_0.json"
)

schema = Postman.Schema_2_1_0()
collection = Postman.load(test_collection_fn)
@test collection.info.schema == Postman.get_schema_url(schema)

@test !isempty(collection.item)
@test collection.item[1].request.method == "GET"
@test !isempty(collection.item[1].request.url.raw)
