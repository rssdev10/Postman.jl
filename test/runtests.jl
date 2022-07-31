using Postman
using Test
using Dates

function log(str)
    "$(Dates.format(Dates.now(), "dd.mm.yyyy HH:MM:SS")) - $(str)\n"
end

tests = [
    "test_runner_functions.jl",
    "test_integrational.jl",
    "decoders/test_schema_2_1.jl"
]

@info log("Running tests....")
@testset "Postman.jl" begin
    for test in tests
        @info log("Test: " * test)
        Test.@testset "$test" begin
            include(test)
        end
    end
end
@info log("done.")
