#!/usr/bin/julia

using DSP: conv
const KRNL = ones(Int, (3,3))
const NBRS = CartesianIndex.((i,j) for j ∈ -1:1, i ∈ -1:1)
const ITERATIONS = 2


function paint_image(image::Matrix{Int})
    map = Dict{Int,Char}(0=>'.', 1=>'#')
    chars = getindex.(Ref(map), image)
    for row ∈ eachrow(chars)
        println(string(row...))
    end
end

function enhance_image(image::Matrix{Int}, algorithm::Vector{Int}, count::Int)::Matrix{Int}
    for itr ∈ 1:count
        next_image = Matrix{Int}(undef, size(image) .+ 2)
        indices = CartesianIndices(image)
        outdices = CartesianIndices(next_image)
        void_polarity = Bool(algorithm[1]) ? Int(iseven(itr)) : 0
        for x ∈ outdices
            y = x - CartesianIndex(1, 1)
            z = sum(
                2^(9 - i) * (y + n ∈ indices ? image[y+n] : void_polarity)
                for (i, n) ∈ enumerate(NBRS)
            )
            next_image[x] = algorithm[z+1]
        end
        image = next_image
    end
    return image
end

function part_one(algorithm::Vector{Int}, image::Matrix{Int})::Int 
    return sum(enhance_image(image, algorithm, 2))
end

function part_two(algorithm::Vector{Int}, image::Matrix{Int})::Int
    sum(enhance_image(image, algorithm, 50))
end

function parse_line(line::String)::Vector{Int}
    get.(Ref(charMap), collect(line), nothing)
end

const INPUT_FILE = ARGS[1]
const inputs = readlines(INPUT_FILE)
const charMap = Dict{Char,Int}('.' => 0, '#' => 1)
const algorithm = parse_line(inputs[1])
const image = vcat([parse_line(line)' for line in inputs[3:end]]...)

println("PART ONE: $(part_one(algorithm, image))")
println("PART TWO: $(part_two(algorithm, image))")

