# https://schema.postman.com/json/collection/v2.1.0/docs/index.html
using .Collections

struct Schema_2_1_0 <: Schema end;
get_schema_url(::Schema_2_1_0) = "https://schema.getpostman.com/json/collection/v2.1.0/collection.json"

# "name": "localhost_post",
# "request": {
#     "method": "POST",
#     "header": [],
#     "body": {
#         "mode": "raw",
#         "raw": "{\n    \"data\": \"12345\"\n}",
#         "options": {
#             "raw": {
#                 "language": "json"
#             }
#         }
#     },
#     "url": {
#         "raw": "localhost:8081",
#         "host": [
#             "localhost"
#         ],
#         "port": "8081"
#     }
# },
# "response": []

StructTypes.StructType(::Type{Collections.Collection}) = StructTypes.Struct()
StructTypes.StructType(::Type{Collections.Info}) = StructTypes.Struct()
StructTypes.StructType(::Type{Collections.Item}) = StructTypes.Struct()
StructTypes.StructType(::Type{Collections.Request}) = StructTypes.Struct()
StructTypes.StructType(::Type{Collections.Url}) = StructTypes.Struct()
StructTypes.StructType(::Type{Collections.Body}) = StructTypes.Struct()
StructTypes.StructType(::Type{Collections.Header}) = StructTypes.Struct()

decode(::Schema_2_1_0, str::String) = JSON3.read(str, Collections.Collection)
