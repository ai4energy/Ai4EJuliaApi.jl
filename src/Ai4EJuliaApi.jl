module Ai4EJuliaApi

using Oxygen, HTTP

include("CoolProp.jl")
using .Ai4ECoolProp

function main_help(req::HTTP.Request)
    return "using /ping to check the healthy of the api."
end

function health_check(req::HTTP.Request)
    return Dict("ai4ejuliaapi" => "healthy!")
end

function InitMainRouter()
    Oxygen.route([Oxygen.GET], "/", main_help)
    Oxygen.route([Oxygen.GET], "/ping", health_check)
end

function InitRouter()
    println("Initializing main router")
    InitMainRouter()
    Ai4ECoolProp.InitRouter()
end

function julia_main()::Cint
    InitRouter()
    # in linux docker
    # Oxygen.serve(host="0.0.0.0", port=19801, show_banner=false, reuseaddr=true)
    Oxygen.serve(host="0.0.0.0", port=19801, show_banner=false)
    return 0
end

end # module Ai4EJuliaApi
