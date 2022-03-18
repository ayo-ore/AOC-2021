#!/usr/bin/julia

using DataStructures

function part_one(positions::Vector{Int})::Int
    turn::Int = 1
    scores::Vector{Int} = zeros(2)
    player::Int = 1
    while true
        roll::Int = 3*(3 * turn - 1)
        positions[player] = mod1(positions[player] + roll, 10)
        scores[player] += positions[player]

        if any(scores .>= 1000)
            return 3 * turn * min(scores...)
        end

        # next turn
        turn += 1
        # alternate player
        player = 2 / player
    end
end

struct PlayerState
    position::Int
    score::Int
end
PlayerState(position::Int) = PlayerState(position, 0)

function part_two(initial_positions::Vector{Int})::Int

    # count number of unique game states (each player's position and score) at each turn
    roll_counts::Accumulator{Int,Int} = counter([i + j + k for i ∈ 1:3, j ∈ 1:3, k ∈ 1:3])
    state_counts::Accumulator{NTuple{2,PlayerState},Int} = counter([Tuple(PlayerState.(initial_positions))])
    updater::Accumulator{NTuple{2,PlayerState},Int} = counter([])

    win_universes::Vector{Int} = zeros(2)

    player::Int = 1
    while !isempty(state_counts.map)
        
        for (s, sc) ∈ state_counts

            # remove states from previous turn
            dec!(updater, s, sc)

            # consider all possible roll outcomes
            for (r, rc) ∈ roll_counts
            
                # new position is current (position + roll) % 10
                pos = mod1(s[player].position + r, 10)
            
                # new score is the current score + landing position
                scr = s[player].score + pos

                # if the new state has winning score, increment player's winning universes
                if scr >= 21
                    win_universes[player] += sc * rc

                # otherwise, create new state and increment its count
                else
                    # new state has current player at new pos with new score and other player unchanged
                    s′ = Tuple([p == player ? PlayerState(pos, scr) : s[p] for p ∈ 1:2])
                    inc!(updater, s′, sc * rc)
                end
            end
        end

        # merge the updates into total state_counter
        merge!(state_counts, updater)

        # reset updater
        empty!(updater.map)
        
        # remove unoccupied states
        for (s, sc) ∈ state_counts
            if sc == 0
                reset!(state_counts, s)
            end
        end

        # switch turn
        player = 2 / player
    end

    return max(win_universes...)
end

const INPUT_FILE = ARGS[1]
const inputs = map(eachline(INPUT_FILE)) do i
    parse(Int, split(i, ' ')[end])
end

println("PART ONE: $(part_one(inputs))")
println("PART TWO: $(part_two(inputs))")



