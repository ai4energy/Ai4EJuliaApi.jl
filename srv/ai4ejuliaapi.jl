using Ai4EJuliaApi
Ai4EJuliaApi.InitRouter()
port = parse(Int, get(ENV, "PORT", "9001"))
# Ai4EJuliaApi.Oxygen.serve(host="0.0.0.0", port=19801, show_banner=false, reuseaddr=true)
Ai4EJuliaApi.Oxygen.serve(host="0.0.0.0", port=port, show_banner=false)