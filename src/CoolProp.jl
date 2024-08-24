module Ai4ECoolProp
using Oxygen
using CoolProp
using HTTP
using JSON

function coolproppurefluid(req::HTTP.Request)

    requestbody = JSON.parse(String(req.body))

    fluid = requestbody["fluid"]
    inputparameter1 = requestbody["inputparameter1"]
    inputvalue1 = requestbody["inputvalue1"]
    inputparameter2 = requestbody["inputparameter2"]
    inputvalue2 = requestbody["inputvalue2"]
    unit_system = requestbody["unit_system"]
    input_longname_to_key = Dict(
        "Density (mass) [kg/m^3]" => "Dmass",
        "Pressure [Pa]" => "P",
        "Temperature [K]" => "T",
        "Enthalpy [J/kg]" => "Hmass",
        "Entropy [J/kg/K]" => "Smass",
        "Internal Energy [J/kg]" => "Umass",
        "Vapor Quality [kg/kg]" => "Q"
    )

    key1 = input_longname_to_key[inputparameter1]
    key2 = input_longname_to_key[inputparameter2]

    result = Dict{String,Any}()

    result["fluid"] = fluid
    result["Temperature [K]"] = CoolProp.PropsSI("T", key1, inputvalue1, key2, inputvalue2, fluid)
    result["Pressure [Pa]"] = CoolProp.PropsSI("P", key1, inputvalue1, key2, inputvalue2, fluid)
    result["Vapor quality [kg/kg]"] = CoolProp.PropsSI("Q", key1, inputvalue1, key2, inputvalue2, fluid)
    result["Speed of sound [m/s]"] = CoolProp.PropsSI("A", key1, inputvalue1, key2, inputvalue2, fluid)

    if unit_system == "Mole-based"
        result["Density [mol/m3]"] = CoolProp.PropsSI("Dmolar", key1, inputvalue1, key2, inputvalue2, fluid)
        result["Enthalpy [J/mol]"] = CoolProp.PropsSI("Hmolar", key1, inputvalue1, key2, inputvalue2, fluid)
        result["Entropy [J/mol/K]"] = CoolProp.PropsSI("Smolar", key1, inputvalue1, key2, inputvalue2, fluid)
        result["Constant-pressure specific heat [J/mol/K]"] = CoolProp.PropsSI("Cpmolar", key1, inputvalue1, key2, inputvalue2, fluid)
        result["Constant-volume specific heat [J/mol/K]"] = CoolProp.PropsSI("Cvmolar", key1, inputvalue1, key2, inputvalue2, fluid)
    elseif unit_system == "Mass-based"
        result["Density [kg/m3]"] = CoolProp.PropsSI("Dmass", key1, inputvalue1, key2, inputvalue2, fluid)
        result["Enthalpy [J/kg]"] = CoolProp.PropsSI("Hmass", key1, inputvalue1, key2, inputvalue2, fluid)
        result["Entropy [J/kg/K]"] = CoolProp.PropsSI("Smass", key1, inputvalue1, key2, inputvalue2, fluid)
        result["Constant-pressure specific heat [J/kg/K]"] = CoolProp.PropsSI("Cpmass", key1, inputvalue1, key2, inputvalue2, fluid)
        result["Constant-volume specific heat [J/kg/K]"] = CoolProp.PropsSI("Cvmass", key1, inputvalue1, key2, inputvalue2, fluid)
    else
        return HTTP.Response(400, "Invalid unit system")
    end

    # 生成 p-T 饱和数据
    Ttriple = CoolProp.PropsSI("Ttriple", fluid)
    Tcrit = CoolProp.PropsSI("Tcrit", fluid)
    temperatures = range(Ttriple + 0.1, stop=Tcrit - 0.1, length=100)
    pressures = [CoolProp.PropsSI("P", "T", T, "Q", 0.0, fluid) for T in temperatures]

    saturation_data = Dict("temperatures" => temperatures, "pressures" => pressures)
    result["saturation_data"] = saturation_data

    return HTTP.Response(200, JSON.json(result))
end

function InitRouter()
    Oxygen.route([Oxygen.POST], "/coolprop/purefluid/v1/json/", coolproppurefluid)
end

end

