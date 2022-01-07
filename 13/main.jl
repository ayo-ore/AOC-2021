#!/usr/bin/julia
const INPUT_FILE = ARGS[1]

Dot = NTuple{2,Int}
Fold = Tuple{Int,Int}
dots = Dot[]
folds = Fold[]
input_lines = collect(eachline(INPUT_FILE))
while length(input_lines) > 0
    line = popfirst!(input_lines)
    if ',' ∈ line
        push!(dots, Tuple(parse.(Int, split(line, ","))))
    elseif '=' ∈ line
        b, e = split(line, "=")
        push!(folds, (b[end] == 'x' ? 1 : 2, parse(Int, e)))
    end
end

function fold_dots(dots::Vector{Dot}, fold::Fold)::Vector{Dot}
    ax, idx = fold
    non_unique = map(dots) do dot
        Tuple((i == ax ? idx - abs(dot[i] - idx) : dot[i] for i ∈ 1:2))
    end
    return collect(Set(non_unique))
end

function part_one(dots::Vector{Dot}, folds::Vector{Fold})::Int
    return (length(fold_dots(dots, folds[begin])))
end

function part_two(dots, folds)::Nothing
    for fold ∈ folds
        dots = fold_dots(dots, fold)
    end
    xcap, ycap = [maximum(map(x -> x[ax], dots)) for ax ∈ (1,2)]
    for y ∈ 0:ycap
        for x ∈ 0:xcap
            print((x,y) ∈ dots ? "@" : " ")
        end
        println()
    end
end

println("PART ONE: $(part_one(dots, folds))")
println("PART TWO:")
part_two(dots, folds)

