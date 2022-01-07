#!/usr/bin/julia

const INPUT_FILE = ARGS[1]
const inputs = map(eachline(INPUT_FILE)) do i
    cmd, val = split(i, ' ')
    (String(cmd), parse(Int, val))
end

function part_one(instructions::Vector{Tuple{String, Int}})::Int
    pos, depth = zeros(2)
    for (cmd, val) in instructions
        if cmd=="up"
            depth -= val
        elseif cmd=="down"
            depth += val
        elseif cmd=="forward"
            pos += val
        else throw(ErrorException("Unknown command $(cmd)."))
        end
    end
    pos * depth
end

function part_two(instructions::Vector{Tuple{String,Int}})::Int
    pos, depth, aim = zeros(3)
    for (cmd, val) in instructions
        if cmd == "up"
            aim -= val
        elseif cmd == "down"
            aim += val
        elseif cmd == "forward"
            pos += val
            depth += aim*val
        else
            throw(ErrorException("Unknown command $(cmd)."))
        end
    end
    pos * depth
end

println("PART ONE: $(part_one(inputs))")
println("PART TWO: $(part_two(inputs))")
