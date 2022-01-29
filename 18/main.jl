#!/usr/bin/julia

mutable struct SFElement
    n::Int
    l::Int
end
SFNumber = Vector{SFElement}

function Base.parse(::Type{SFNumber}, s::String)::SFNumber
    chars = collect(s)
    levels = cumsum((chars .== '[') - (chars .== ']'))
    return [
        SFElement(c-'0', l) for (c,l) in zip(chars, levels) if '0' <= c <= '9'
    ]
end

function reduce!(num::SFNumber)

    while true
        explode_idx = findfirst(
            map(i -> num[i].l == num[i+1].l && num[i].l >= 5, 1:length(num)-1)
        )
        split_idx = findfirst(map(e -> e.n >= 10, num))
        if explode_idx !== nothing
            explode!(num, explode_idx)
        elseif split_idx !== nothing
            split!(num, split_idx)
        else
            break
        end
    end
end

function explode!(num::SFNumber, idx::Int)
    L = popat!(num, idx)
    R = popat!(num, idx)

    if idx > 1
        num[idx-1].n += L.n
    end
    if idx <= length(num)
        num[idx].n += R.n
    end
    insert!(num, idx, SFElement(0, L.l - 1))
end

function split!(num::SFNumber, idx)
    N = popat!(num, idx)
    insert!(num, idx, SFElement(cld(N.n, 2), N.l + 1))
    insert!(num, idx, SFElement(fld(N.n, 2), N.l + 1))
end

function Base.:+(a::SFNumber, b::SFNumber)::SFNumber
    sum = map(e -> SFElement(e.n, e.l + 1), vcat(a, b))
    reduce!(sum)
    return sum
end

function magnitude(num::SFNumber)::Int
    max_level = Inf
    while max_level > 1
        max_level, idx = findmax([e.l for e ∈ num])
        L = popat!(num, idx)
        R = popat!(num, idx)
        insert!(num, idx, SFElement(3 * L.n + 2 * R.n, max_level - 1))
    end
    return num[].n
end

const INPUT_FILE = ARGS[1]
const inputs = parse.(SFNumber, eachline(INPUT_FILE))

function part_one(inputs)::Int
    return(magnitude(sum(inputs)))
end

function part_two(inputs)::Int
    return maximum(magnitude.(x + y for x ∈ inputs, y ∈ inputs if x != y))
end

println("PART ONE: $(part_one(inputs))")
println("PART TWO: $(part_two(inputs))")

