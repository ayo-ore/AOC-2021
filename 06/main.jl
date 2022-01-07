#!/usr/bin/julia
const INPUT_FILE = ARGS[1]
const inputs = parse.(Int, split(readline(INPUT_FILE), ','))

function histogram_timers(timers)
    hist = zeros(Int, 9)
    for timer in timers
        hist[timer+1] += 1
    end
    return hist
end

function part_one(timers)::Int
    timers_histogram = histogram_timers(timers)
    for _ = 1:80
        reset = timers_histogram[1]
        timers_histogram = circshift(timers_histogram, -1)
        timers_histogram[7] += reset
    end
    return sum(timers_histogram)
end

function part_two(timers)::Int
    timers_histogram = histogram_timers(timers)
    for _ = 1:256
        reset = timers_histogram[1]
        timers_histogram = circshift(timers_histogram, -1)
        timers_histogram[7] += reset
    end
    return sum(timers_histogram)
end

println("PART ONE: $(part_one(inputs))")
println("PART TWO: $(part_two(inputs))")

