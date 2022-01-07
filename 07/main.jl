#!/usr/bin/julia
const INPUT_FILE = ARGS[1]
const inputs = parse.(Int, split(readline(INPUT_FILE), ','))

function part_one(positions)::Int
    minimum((sum(@.abs(positions - x)) for x in 1:maximum(positions)))
end


function part_two(positions)::Int
    minimum((sum((n -> (n^2 + n) / 2).(abs.(positions .- x))) for x in 1:maximum(positions)))
end

println("PART ONE: $(part_one(inputs))")
println("PART TWO: $(part_two(inputs))")

