using CSV
using DataFrames
using JLD2

include("lib/julia/_internals.jl")

# set seed
import Random
Random.seed!(66)

# get the name of all communities
matrix_names = readdir("data/clean/maximal")
matrix_names = replace.(matrix_names, ".csv" => "")

# feeding rules
max = DataFrame(CSV.File("data/feeding_rules/feeding_rules_maximal.csv"))
min = DataFrame(CSV.File("data/feeding_rules/feeding_rules_minimum.csv"))

rules = [
    "maximal" "minimum"
    max min
]

networks = DataFrame(
    node = String[],
    location = String[],
    time = Any[],
    rules = String[],
    basal = String[],
    downsample = String[],
    network = Any[],
);

for i in eachindex(matrix_names)

    file_name = matrix_names[i]
    # get relevant info from slug
    str_cats = split(file_name, r"_")

    for k in axes(rules, 1)

        feeding_rules = rules[2, k]
        feeding = rules[1, k]

        # import data frame
        df = DataFrame(CSV.File.(joinpath("data/clean/", feeding, "$file_name.csv")))

        # some manipulating of the data frame
        if occursin("guild", file_name)
            rename!(df, :guild => :species)
        end
        df[!, :size] = convert.(String, df[!, :size])
        df[!, :tiering] = convert.(String, df[!, :tiering])
        df[!, :motility] = convert.(String, df[!, :motility])
        df[!, :feeding] = convert.(String, df[!, :feeding])
        df[!, :species] = convert.(String, df[!, :species])
        # remove unwanted cols
        traits = unique(collect(feeding_rules.trait_type_resource))
        traits = convert.(String, traits)
        push!(traits, "species")
        push!(traits, "time_pre_during_post")
        select!(df, traits)

        for time = 1:5
            # select correct time period
            pfim_df = filter(df -> occursin.("$time", df.time_pre_during_post), df)

            # add zooplankton node
            push!(
                pfim_df,
                ["zooplankton" "zooplankton" "zooplankton" "zooplankton" "zooplankton" "$j"],
            )

            for basal ∈ [true, false]

                if basal == true
                    # add primary node
                    push!(pfim_df, ["primary" "primary" "primary" "primary" "primary" "$j"])
                end

                N = pfim.PFIM(pfim_df, feeding_rules)

                d = Dict{Symbol,Any}(
                    :time => time,
                    :location => str_cats[1],
                    :node => str_cats[4],
                    :network => N,
                    :downsample => "false",
                    :rules => string(feeding),
                    :basal => string(basal),
                )

                push!(networks, d)

                if richness(N) > 0

                    N = pfim.PFIM(pfim_df, feeding_rules; downsample = true)

                    d = Dict{Symbol,Any}(
                        :time => time,
                        :location => str_cats[1],
                        :node => str_cats[4],
                        :network => N,
                        :downsample => "true",
                        :rules => string(feeding),
                        :basal => string(basal),
                    )

                    push!(networks, d)

                end

            end
        end
    end
end
