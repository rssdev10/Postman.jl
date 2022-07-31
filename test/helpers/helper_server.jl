using HTTP

function start_server(port=8081)
    # HTTP.listen! and HTTP.serve! are the non-blocking versions of HTTP.listen/HTTP.serve
    server = HTTP.serve!(port) do request::HTTP.Request
        @info request
        @info request.method
        @info HTTP.header(request, "Content-Type")
        @info request.body
        try
            return HTTP.Response(String(request))
        catch e
            return HTTP.Response(400, "Error: $e")
        end
    end
end

function stop_server(server)
    # HTTP.serve! returns an `HTTP.Server` object that we can close manually
    close(server)
end
