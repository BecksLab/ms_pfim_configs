using CSV
using DataFrames
using JLD2

include("lib/julia/_internals.jl")

# import networks object
networks = load_object("data/output/networks/networks.jlds")

topology = DataFrame(
    node = String[],
    location = String[],
    time = Any[],
    rules = String[],
    primary = String[],
    downsample = String[],
    richness = Int64[],
    links = Int64[],
    connectance = Float64[],
    diameter = Int64[],
    complexity = Float64[],
    distance = Float64[],
    basal = Float64[],
    top = Float64[],
    generality = Float64[],
    vulnerability = Float64[],
    S1 = Float64[],
    S2 = Float64[],
    S4 = Float64[],
    S5 = Float64[],
);

for i in 1:nrow(networks)
    
    d = _network_summary(networks.network[i])

    d[:node] = networks.node[i]
    d[:location] = networks.location[i]
    d[:time] = networks.time[i]
    d[:rules] = networks.rules[i]
    d[:primary] = networks.basal[i]
    d[:downsample] = networks.downsample[i]

    push!(topology, d)
end

# write summaries as .csv
CSV.write(
    "data/output/networks/topology.csv",
    topology,
)