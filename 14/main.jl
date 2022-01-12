#!/usr/bin/julia
const Polymer = Vector{Char}
const Pair = NTuple{2,Char}
const Insertion = Tuple{Pair,Char}

function part_one(polymer::Polymer, insertions::Vector{Insertion})::Int
    steps = 10
    # println(join(string.(polymer)))
    for _ ∈ 1:steps

        # vector to hold insertions
        updates = fill(' ', length(polymer) - 1)

        # match insertions across polymer
        for (query, insertion) ∈ insertions
            for i ∈ 1:length(polymer)-1
                pair = Tuple(polymer[i:i+1])
                if pair == query
                    updates[i] = insertion
                end
            end
        end

        # update polymer
        offset = 0
        for (i, update) in enumerate(updates)
            if 'A' <= update <= 'Z'
                insert!(polymer, offset + i + 1, update)
                offset += 1
            end
        end
        # println(join(string.(polymer)))
    end

    # calculate score
    frequencies = map(c -> count(x -> x == c, polymer), unique(polymer))
    # println.(t for t in zip(unique(polymer), frequencies))

    maximum(frequencies) - minimum(frequencies)

end

function part_two(polymer::Polymer, insertions::Vector{Insertion})::Int
    pair_counts = Dict{Pair,Int}()
    for i ∈ 1:length(polymer)-1
        mergewith!(+, pair_counts,
            Dict(Tuple(polymer[i:i+1]) => 1)
        )
    end
    
    @show pair_counts
    frequencies = Dict{Char,Int}()
    for c in polymer
        mergewith!(+, frequencies, Dict(c => 1))
    end
    @show(frequencies)

    steps = 40
    for step ∈ 1:steps
        # dictionary to hold insertions
        updates = Dict{Pair,Int}()

        # match insertions across polymer
        for (query, insertion) ∈ insertions
            for (pair, count) ∈ pair_counts
                if pair == query
                    pair_counts[pair] = 0
                    mergewith!(+, updates,
                        Dict((pair[1], insertion) => count, (insertion, pair[2]) => count)
                    )
                    mergewith!(+, frequencies, Dict(insertion => count))
                end
            end
        end

        # update polymer
        mergewith!(+, pair_counts, updates)
    end
    (maximum(values(frequencies)) - minimum(values(frequencies)))
end

const INPUT_FILE = ARGS[1]
const lines = collect(eachline(INPUT_FILE))

const polymer1 = collect(popfirst!(lines))
const polymer2 = deepcopy(polymer1)
const insertions = map(lines[2:end]) do line
    pair, n = split(line, " -> ")
    (Tuple(collect(pair)), only(n))
end

println("PART ONE: $(part_one(polymer1, insertions))")
println("PART TWO: $(part_two(polymer2, insertions))")

