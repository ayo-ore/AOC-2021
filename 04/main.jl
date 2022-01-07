#!/usr/bin/julia
const INPUT_FILE = ARGS[1]

input_lines = collect(eachline(INPUT_FILE))
const draws = map(s -> parse(Int, s), split(popfirst!(input_lines), ','))
boards = Matrix{Int}[]
while length(input_lines) > 0
    deleteat!(input_lines, 1)
    board = Matrix{Int}(undef, 5, 5)
    for row in 1:5
        board[row,:] = map(s -> parse(Int, s),
                            split(popfirst!(input_lines), keepempty=false))
    end
    push!(boards, board)
end

function board_won(crosses)
    row_counts = zeros(Int, 5)
    col_counts = zeros(Int, 5)
    for idx in crosses
        row_counts[idx[1]] += 1
        col_counts[idx[2]] += 1
        if any(row_counts .== 5) || any(col_counts .== 5)
            return true
        end
    end
    return false
end

function uncrossed_sum(board, crosses)
    sum(
        b for (i,b) in enumerate(board)
            if !(CartesianIndices(board)[i] in crosses)
    )
end

function part_one(boards, draws)::Int
    boards_crosses = [CartesianIndex{2}[] for _ in 1:length(boards)]
    for draw in draws
        for (board, crosses) in zip(boards, boards_crosses)
            cross = findfirst(board .== draw)
            if cross !== nothing
                push!(crosses, cross)
                if board_won(crosses)
                    return uncrossed_sum(board, crosses) * draw
                end
            end
        end
    end
end

function part_two(boards, draws)::Int
    boards_crosses = [CartesianIndex{2}[] for _ = 1:length(boards)]
    boards_won = falses(length(boards))
    for draw in draws
        for (idx, (board, crosses)) in enumerate(zip(boards, boards_crosses))
            if !boards_won[idx]
                cross = findfirst(board .== draw)
                if cross !== nothing
                    push!(crosses, cross)
                    if board_won(crosses)
                        boards_won[idx] = true
                        if all(boards_won)
                            return uncrossed_sum(board, crosses) * draw
                        end
                    end
                end
            end
        end
    end
end

println("PART ONE: $(part_one(boards, draws))")
println("PART TWO: $(part_two(boards, draws))")

