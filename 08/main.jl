#!/usr/bin/julia
const INPUT_FILE = ARGS[1]
const inputs = map(eachline(INPUT_FILE)) do i
    Tuple(split.(split(i, " | ")))
end

function part_one(lines)::Int
    sum(
        count(d -> length(d) in (2, 3, 4, 7), outputs)
        for (uniques, outputs) in lines
    )
end

function part_two(lines)::Int

    segment_map = Dict{String, Int}(
        "abcefg" => 0,
        "cf" => 1,
        "acdeg" => 2,
        "acdfg" => 3,
        "bcdf" => 4,
        "abdfg" => 5,
        "abdefg" => 6,
        "acf" =>  7,
        "abcdefg" => 8,
        "abcdfg" => 9
    )

    result = 0
    for (uniques, outputs) in lines
        wire_map = Dict{Char,Char}()
    
        one, four, seven, eight = uniques[indexin([2, 4, 3, 7], length.(uniques))]
        zero_six_nine = uniques[@. length(uniques) == 6]
        nine = popat!(zero_six_nine, findfirst(issubset.(four, zero_six_nine)))
        six = popat!(zero_six_nine, findfirst(@. !issubset(one, zero_six_nine)))
        zero = zero_six_nine[]
    
        wire_map[setdiff(seven, one)[]] = 'a'
        wire_map[setdiff(eight, nine)[]] = 'e'
        wire_map[setdiff(eight, six)[]] = 'c'
        wire_map[setdiff(eight, zero)[]] = 'd'
        wire_map[setdiff(seven, keys(wire_map))[]] = 'f'
        wire_map[setdiff(four, keys(wire_map))[]] = 'b'
        wire_map[setdiff(eight, keys(wire_map))[]] = 'g'
    
        result += parse(Int, join(
            string.(
                segment_map[(join ∘ sort ∘ collect)(map(o -> get(wire_map, o, 'X'), output))]
                for output in outputs
            )
        ))
    end
    return result
end

println("PART ONE: $(part_one(inputs))")
println("PART TWO: $(part_two(inputs))")

