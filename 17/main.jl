#!/usr/bin/julia
const INPUT_FILE = ARGS[1]

const inputs = parse.(Int,
    vcat(split.(split(readline(INPUT_FILE)[16:end], ", y="), "..")...)
)

struct Target
    xmin::Int
    xmax::Int
    ymin::Int
    ymax::Int
end

function in_target(p::Vector{Int}, target::Target)::Bool
   (   p[1] >= target.xmin && p[1] <= target.xmax
    && p[2] >= target.ymin && p[2] <= target.ymax)
end

function part_one(inputs)::Int
    target = Target(inputs...)
    max_y_vel = -(target.ymin + 1)
    return max_y_vel*(max_y_vel+1)/2
end

function part_two(inputs)::Int

    target = Target(inputs...)

    vmin = [floor(Int, (1 + sqrt(1 + 8target.xmin)) / 2), target.ymin]
    vmax = [target.xmax, -(target.ymin + 1)]

    result = 0
    for vx ∈ vmin[1]:vmax[1], vy ∈ vmin[2]:vmax[2]
        p = [0, 0]
        v = [vx, vy]
        while p[1] < target.xmax && p[2] > target.ymin
            # time step
            p .+= v
            v .-= (sign(v[1]), 1)

            # calculate max visited height
            if in_target(p, target)
                result += 1
                break
            end
        end
    end
    return result
end

println("PART ONE: $(part_one(inputs))")
println("PART TWO: $(part_two(inputs))")

