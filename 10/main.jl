#!/usr/bin/julia
const INPUT_FILE = ARGS[1]
const inputs = readlines(INPUT_FILE)

const OPENERS = ('(', '[', '{', '<')
const CLOSERS = Dict{Char,Char}(
    '(' => ')',
    '[' => ']',
    '{' => '}',
    '<' => '>'
)

function part_one(lines::Vector{String})::Int
    POINTS = Dict{Char,Int}(
        ')' => 3,
        ']' => 57,
        '}' => 1197,
        '>' => 25137
    )
    result = 0
    for line in lines
        queue = Char[]
        for char in line
            if char in OPENERS
                push!(queue, char)
            else
                if char != CLOSERS[pop!(queue)]
                    result += POINTS[char]
                end
            end
        end
    end
    return result
end

function part_two(lines::Vector{String})::Int
    POINTS = Dict{Char,Int}(
        ')' => 1,
        ']' => 2,
        '}' => 3,
        '>' => 4
    )
    results = Int[]
    for line in lines
        queue = Char[]
        corrupted = false
        for char ∈ line
            if char ∈ OPENERS
                push!(queue, char)
            elseif char != CLOSERS[pop!(queue)]
                corrupted = true
                break
            end
        end
        if corrupted
            continue
        end
        result = 0
        while length(queue) > 0
            result *= 5
            result += POINTS[CLOSERS[pop!(queue)]]
        end
        push!(results, result)
    end
    return sort(results)[length(results)÷ 2 + 1]
end

println("PART ONE: $(part_one(inputs))")
println("PART TWO: $(part_two(inputs))")

