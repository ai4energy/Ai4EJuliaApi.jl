module Ai4EJuliaApi

using Oxygen
using HTTP
using JSON3
using Logging
using Dates

const DEFAULT_PORT = 9801
const API_VERSION = "v1"

include("CoolProp.jl")
using .Ai4ECoolProp

function main_help(req::HTTP.Request)
    return """
    Ai4E Julia API $(API_VERSION)
    Endpoints:
      GET  /          : 显示帮助信息
      GET  /ping      : 健康检查
      POST /mediaprop/coolprop/purefluid : 纯工质物性计算
      POST /mediaprop/coolpro/mixture   : 混合工质物性计算
    """
end

function health_check(req::HTTP.Request)
    return Dict(
        "service" => "Ai4EJuliaApi",
        "status" => "healthy",
        "timestamp" => now()
    )
end

function InitMainRouter()
    Oxygen.route([Oxygen.GET], "/", main_help)
    Oxygen.route([Oxygen.GET], "/ping", health_check)
end

function InitRouter()
    @info "Initializing routers..."
    try
        InitMainRouter()
        Ai4ECoolProp.InitRouter()
        @info "All routers initialized successfully"
    catch e
        @error "Router initialization failed" exception=(e, catch_backtrace())
        rethrow()
    end
end

function julia_main()::Cint
    try
        # 初始化路由
        InitRouter()
        
        # 启动前预热（可选）
        @info "Preheating CoolProp..."
        Ai4ECoolProp.preheat()
        
        # 启动服务
        @info "Starting server on port $(DEFAULT_PORT)"
        Oxygen.serve(
            host="0.0.0.0",
            port=DEFAULT_PORT,
            show_banner=false,
            reuseaddr=true,
            graceful_shutdown=true
        )
    catch e
        @error "Server crashed" exception=(e, catch_backtrace())
        return 1
    end
    return 0
end

end # module Ai4EJuliaApi
