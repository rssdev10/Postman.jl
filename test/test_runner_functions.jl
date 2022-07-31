using Test
using Postman

replacements = Dict("host" => "localhost", "port" => 8081)

str = "{{host}}:{{port}}"

ranges = Postman.Runner.get_variables_ranges(str)
res_str = Postman.Runner.replace_variables(str, ranges, replacements)
@test res_str == "localhost:8081"

for (str, result) in [
    ("{{host}}:{{port}}", "localhost:8081"),
    ("{{host}}:{{port", "localhost:{{port"),
    ("host}}:{{port}}", "host}}:8081"),
    ("{{host:port}}", ""),
    ("{{host}}:{{port}}{{path}}", "localhost:8081"),
    ("{{schema}}{{host}}:{{port}}{{path}}", "localhost:8081"),
    ("{{host}}:{{smt}}{{port}}", "localhost:8081")
]
    local ranges = Postman.Runner.get_variables_ranges(str)
    local res_str = Postman.Runner.replace_variables(str, ranges, replacements)
    @test res_str == result
end
