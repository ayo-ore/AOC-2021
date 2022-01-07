#!/usr/bin/julia

const INPUT_FILE = ARGS[1]
const depths = map(i::String -> parse(Int, i), eachline(INPUT_FILE))

function part_one(depths::Vector{Int})::Int
    diffs = depths[2:end] - depths[1:end-1]
    diffs_are_positive = 0 .< diffs
    sum(diffs_are_positive)
end

function part_two(depths::Vector{Int})::Int
    window_depths = [sum(depths[i-2:i]) for i in eachindex(depths) if i>2]
    part_one(window_depths)
end

println("PART ONE: $(part_one(depths))")
println("PART TWO: $(part_two(depths))")
