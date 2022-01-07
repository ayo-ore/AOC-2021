#!/usr/bin/julia

const INPUT_FILE = ARGS[1]
const inputs = map(eachline(INPUT_FILE)) do i
    [parse(Bool, bit) for bit in i]
end

function part_one(numbers = Vector{BitVector})::Int
    gamma, epsilon = zeros(2)
    bitwise_sums = sum(numbers)
    most_frequent_bits = round.(Int, bitwise_sums / length(numbers))
    for (i, b) in enumerate(reverse(most_frequent_bits))
        val = 2^(i-1)
        if b==1
            gamma += val
        else
            epsilon += val
        end
    end
    gamma * epsilon
end

function part_two(numbers = Vector{BitVector})::Int
    gamma, epsilon = zeros(2)

    remaining_numbers = deepcopy(numbers)
    pos = 1
    while length(remaining_numbers) > 1
        bitwise_average = mapreduce(v -> v[pos], +, remaining_numbers) / length(remaining_numbers)
        most_frequent_bit = bitwise_average == 0.5 ? 1 : round(Int, bitwise_average)
        filter!(n -> n[pos] == most_frequent_bit, remaining_numbers)
        pos += 1
    end
    gamma = parse(Int, reduce(*, string.(Int.(remaining_numbers[]))), base = 2)
    remaining_numbers = numbers
    pos = 1
    while length(remaining_numbers) > 1
        bitwise_average = mapreduce(v -> v[pos], +, remaining_numbers) / length(remaining_numbers)
        most_frequent_bit = bitwise_average == 0.5 ? 1 : round(Int, bitwise_average)
        filter!(n -> n[pos] != most_frequent_bit, remaining_numbers)
        pos += 1
    end
    epsilon = parse(Int, reduce(*, string.(Int.(remaining_numbers[]))), base = 2)
    gamma * epsilon
end

println("PART ONE: $(part_one(inputs))")
println("PART TWO: $(part_two(inputs))")

