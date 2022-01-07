#!/usr/bin/julia
const INPUT_FILE = ARGS[1]

const inputs = map(eachline(INPUT_FILE)) do i
    Tuple(String.(split(i, '-')))
end

function joined(tunnels::Vector{NTuple{2, String}}, cave1::String, cave2::String)::Bool
    for tunnel in tunnels
        # println(setdiff((cave1, cave2), tunnel))
        if isempty(setdiff((cave1, cave2), tunnel)) && cave1 != cave2
            return true
        end
    end
    return false
end

function is_small(cave::String)::Bool
    'a' <= cave[begin] <= 'z'
end

function count_exit_paths_part_one(
    tunnel_map::Dict{String,Vector{String}},
    start::String = "start",
    num_exit_paths::Int = 0,
    path::Vector{String} = ["start"]
    )::Int

    # look at caves joined to start

    for cave ∈ tunnel_map[start]

        # allow only one visit to small caves
        if is_small(cave) && cave ∈ path
            continue
        end

        # extend path by current cave
        next_path = [path...; cave]

        # count path if it's an exit
        if cave == "end"
            num_exit_paths += 1

        # otherwise, search from next cave
        else
            num_exit_paths = count_exit_paths_part_one(tunnel_map, cave, num_exit_paths, next_path)
        end
    end

    return num_exit_paths
end

function part_one(tunnels)::Int

    caves = unique(Iterators.flatten(tunnels))
    tunnel_map = Dict{String,Vector{String}}(
        c1 => [c2 for c2 in caves if joined(tunnels, c1, c2)] for c1 in caves
    )

    return count_exit_paths_part_one(tunnel_map)
end

function count_exit_paths_part_two(
    tunnel_map::Dict{String,Vector{String}},
    start::String = "start",
    num_exit_paths::Int = 0,
    path::Vector{String} = ["start"]
    )::Int

    # look at caves joined to start

    for cave ∈ tunnel_map[start]

        # allow only two visits to small caves
        if is_small(cave)
            small_cave_visitations = count.(
                c .== path for c ∈ filter(is_small, keys(tunnel_map))
            )
            if cave ∈ path && any(small_cave_visitations .> 1) || cave == "start"
                continue
            end
        end

        # extend path by current cave
        next_path = [path...; cave]

        # count path if it's an exit
        if cave == "end"
            num_exit_paths += 1

        # otherwise, search from next cave
        else
            num_exit_paths = count_exit_paths_part_two(tunnel_map, cave, num_exit_paths, next_path)
        end
    end

    return num_exit_paths
end

function part_two(tunnels)::Int
    caves = unique(Iterators.flatten(tunnels))
    tunnel_map = Dict{String,Vector{String}}(
        c1 => [c2 for c2 in caves if joined(tunnels, c1, c2)] for c1 in caves
    )
    return count_exit_paths_part_two(tunnel_map)
end

println("PART ONE: $(part_one(inputs))")
println("PART TWO: $(part_two(inputs))")

