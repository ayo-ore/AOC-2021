#!/usr/bin/julia
const INPUT_FILE = ARGS[1]
inputs = vcat([adjoint([parse(Int, c) for c in line])
               for line in eachline(INPUT_FILE)]...)

function flash(energies::Matrix{Int}, loc::CartesianIndex{2}, has_flashed::BitMatrix)
    if !has_flashed[loc]
        has_flashed[loc] = true
        energies[loc] = 0
        for dx ∈ -1:1, dy ∈ -1:1
            if (dx,dy) != (0,0)
                neighbor = loc + CartesianIndex(dx, dy)
                try
                    energies[neighbor] += 1
                    if energies[neighbor] > 9
                        flash(energies, neighbor, has_flashed)
                    end
                catch BoundsError
                end
            end
        end
    end
end

function part_one(energies)::Int
    flashes_count::Int = 0
    for _ ∈ 1:100
        energies .+= 1
        has_flashed = falses(size(energies))
        for loc in findall(energies .> 9)
            flash(energies, loc, has_flashed)
        end
        energies[has_flashed] .= 0
        flashes_count += sum(has_flashed)
    end
    return flashes_count
end

function part_two(energies)::Int
    step = 1
    while true
        energies .+= 1
        has_flashed = falses(size(energies))
        for loc in findall(energies .> 9)
            flash(energies, loc, has_flashed)
        end
        energies[has_flashed] .= 0
        if all(energies .== 0)
            return step
        end
        step += 1
    end
end

println("PART ONE: $(part_one(inputs))")
println("PART TWO: $(part_two(inputs))")

