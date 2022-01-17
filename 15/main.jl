#!/usr/bin/julia

const INPUT_FILE = ARGS[1]
const inputs = vcat([adjoint(parse.(Int, collect(line))) for line in eachline(INPUT_FILE)]...)

function risk_to_end_DFS(risks::Matrix{Int}, start::CartesianIndex{2})::Int
    # need BFS
    if start == CartesianIndices(risks)[end]
        return risks[end]
    else
        D = start + CartesianIndex(1, 0)
        R = start + CartesianIndex(0, 1)
        if !(D ∈ CartesianIndices(risks))
            next_risk = risk_to_end_DFS(risks, R)
        elseif !(R ∈ CartesianIndices(risks))
            next_risk = risk_to_end_DFS(risks, D)
        else
            next_risk = min(risk_to_end_DFS(risks, D), risk_to_end_DFS(risks, R))
        end
        return risks[start] + next_risk
    end
end

function risk_to_end_BFS(risks::Matrix{Int}, heads::Dict{CartesianIndex{2},Int}, visited::BitMatrix)::Int

    END = CartesianIndices(risks)[end]
    while true

        # find head with smallest risk
        (risk, head) = findmin(heads)

        visited[head] = true

        # remove heads that cannot win
        # max_exit_risk = 9 * sum(abs.(Tuple(head - END)))
        # filter!(heads) do p
        #     return sum(abs.(Tuple(p.first - END))) < max_exit_risk
        # end

        # remove this head and calculate neighbors
        delete!(heads, head)
        U = head + CartesianIndex(-1, 0)
        D = head + CartesianIndex(1, 0)
        L = head + CartesianIndex(0, -1)
        R = head + CartesianIndex(0, 1)

        for next_head ∈ (U, D, L, R)
            try

                if visited[next_head]
                    continue
                end

                # get new risk
                next_risk = risk + risks[next_head]
                
                # check if we're done
                if next_head == END
                    return next_risk
                
                else
                    # don't overwrite head with a lower risk
                    if next_head ∈ keys(heads) && next_risk > heads[next_head]
                        continue
                    end
                   
                    # add new head to dictionary
                    heads[next_head] = next_risk
                end
            catch BoundsError
            end
        end
        # for i in 1:size(risks)[1]
        #     for j in 1:size(risks)[2]
        #         head = CartesianIndex(i,j)
        #         if head ∈ keys(heads)
        #             print("$(heads[head]) ")
        #         else
        #             print("..")
        #         end
        #     end
        #     println()
        # end
    end
end

function part_one(risks)::Int
    # return risk_to_end_DFS(risks, CartesianIndex(1,1))
    return risk_to_end_BFS(risks, Dict(CartesianIndex(1, 1) => 0), falses(size(risks)))
end

function part_two(risks)::Int

    risks = hcat((risks .+ x for x = 0:4)...)
    risks = vcat((risks .+ x for x = 0:4)...)
    risks = @. ((risks - 1) % 9) + 1

    return part_one(risks)
end

println("PART ONE: $(part_one(inputs))")
println("PART TWO: $(part_two(inputs))")

