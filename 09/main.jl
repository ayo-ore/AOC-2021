#!/usr/bin/julia

using DelimitedFiles

const INPUT_FILE = ARGS[1]
const inputs = vcat([adjoint(parse.(Int, split(line, ""))) for line in eachline(INPUT_FILE)]...)

const DIRS = ((1,0), (-1,0), (0,1), (0,-1))
function get_neighbors(heights::Matrix{Int}, loc::CartesianIndex)::Vector{CartesianIndex{2}}
    [loc + d for d ∈ CartesianIndex.(DIRS) if loc + d in CartesianIndices(heights)]
end

function is_low_point(heights::Matrix{Int}, loc::CartesianIndex{2})::Bool
    for neighbor in get_neighbors(heights, loc)
        if heights[neighbor] <= heights[loc]
            return false
        end
    end
    return true
end

function part_one(heights::Matrix{Int})::Int
    sum(heights[i] + 1 for i in CartesianIndices(heights) if is_low_point(heights, i))
end


function basin_size(heights::Matrix{Int}, start::CartesianIndex{2}, visited::BitMatrix, size::Int)
    if visited[start] || heights[start] == 9
        return size
    else
        visited[start] = true
        size += 1
        for neighbor in get_neighbors(heights, start)
            if !visited[neighbor]
                size = basin_size(heights, neighbor, visited, size)
            end
        end
        return size
    end
end

function part_two(heights::Matrix{Int})::Int
    basin_sizes = [
        basin_size(heights, i, falses(size(heights)), 0)
        for i ∈ CartesianIndices(heights) if is_low_point(heights, i) 
    ]
    return prod((reverse ∘ sort)(basin_sizes)[1:3])
end

println("PART ONE: $(part_one(inputs))")
println("PART TWO: $(part_two(inputs))")

