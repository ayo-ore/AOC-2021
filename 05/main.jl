#!/usr/bin/julia
const INPUT_FILE = ARGS[1]
const inputs = map(eachline(INPUT_FILE)) do i
    Tuple(map(s -> Tuple(parse.(Int, split(s, ','))), split(i, " -> ")))
end

function increment_count!(counts, loc)
    if haskey(counts, loc)
        counts[loc] += 1
    else 
        counts[loc] = 1
    end
end

function part_one(endpoints::Vector{NTuple{2,NTuple{2,Int}}})::Int
    counts = Dict{NTuple{2,Int},Int}()
    for (a, b) in endpoints
        if any(a .== b)
            x = collect(a)
            increment_count!(counts, Tuple(x))
            dx = collect(b .- a)
            for _ = 1:max(abs.(dx)...)
                x += sign.(dx)
                increment_count!(counts, Tuple(x))
            end
        end
    end
    return length(filter(x -> x > 1, collect(values(counts))))
end

function part_two(endpoints::Vector{NTuple{2,NTuple{2,Int}}})::Int
    counts = Dict{NTuple{2,Int},Int}()
    for (a, b) in endpoints
        x = collect(a)
        increment_count!(counts, Tuple(x))
        dx = collect(b .- a)
        for _ = 1:max(abs.(dx)...)
            x += sign.(dx)
            increment_count!(counts, Tuple(x))
        end
    end
    return length(filter(x -> x > 1, collect(values(counts))))
end

println("PART ONE: $(part_one(inputs))")
println("PART TWO: $(part_two(inputs))")

