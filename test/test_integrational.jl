include("common.jl")

test_collection_fn = joinpath(
    TEST_DATA_PATH,
    "postman_collection_2_1_0.json"
)

PORT = rand(8080:9000)

include(joinpath("helpers", "helper_server.jl"))

server = start_server(PORT)

collection = Postman.load(test_collection_fn)

for item in collection
    @info "Process item: " * item.name # filter by name if required

    @time response = Postman.run(item, variables=Dict("port" => PORT))
    @info response
    @test occursin(item.request.method, String(response.body))
end

stop_server(server)
