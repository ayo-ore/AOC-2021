#!/usr/bin/julia
const INPUT_FILE = ARGS[1]
const inputs = readline(INPUT_FILE)
const ops = [+, *, min, max, >, <, ==] 

function read_literals(bits::Vector{Char})::Int
    literal = ""
    done = false
    while !done
        prefix = popfirst!(bits)
        done = prefix == '0'
        literal *= join(splice!(bits, 1:4))
    end
    return parse(Int, literal, base = 2)
end

function read_packet_one(bits::Vector{Char}, s::Int = 0)::Union{Int,Nothing}
    if all(bits .== '0')
        empty!(bits)
        return s
    end
    vr = parse(Int, join(splice!(bits, 1:3)), base = 2)
    id = parse(Int, join(splice!(bits, 1:3)), base = 2)
    s += vr
    
    if id == 4
        read_literals(bits)
    else
        len_id = popfirst!(bits)
        if len_id == '0'
            len = parse(Int, join(splice!(bits, 1:15)), base = 2)
            arg_packets = splice!(bits, 1:len)
            while length(arg_packets) > 0
                s = read_packet_one(arg_packets, s)
            end
        else
            len = parse(Int, join(splice!(bits, 1:11)), base = 2)
            for _ ∈ 1:len
                s = read_packet_one(bits, s)
            end
        end

    end
    return s
end

function part_one(chars)::Int
    bits = collect(
        mapreduce(
            i -> last(bitstring(parse(Int, string(i), base = 16)), 4),
            *, chars))

    return read_packet_one(bits)
end

function read_packet_two(bits::Vector{Char}, value::Int=0)::Union{Int,Nothing}

    if all(bits .== '0')
        empty!(bits)
        return value
    end
    
    vr = parse(Int, join(splice!(bits, 1:3)), base = 2)
    id = parse(Int, join(splice!(bits, 1:3)), base = 2)

    if id == 4
        return read_literals(bits)
    else
        offset = id < 4
        op = ops[id+offset]
        values = Int[]
        len_id = popfirst!(bits)
        if len_id == '0'
            len = parse(Int, join(splice!(bits, 1:15)), base = 2)
            arg_packets = splice!(bits, 1:len)
            while length(arg_packets) > 0
                push!(values, read_packet_two(arg_packets))
            end
        else
            len = parse(Int, join(splice!(bits, 1:11)), base = 2)
            for _ ∈ 1:len
                push!(values, read_packet_two(bits))
            end
        end
        return reduce(op, values)
    end
    throw("Unreachable?")
end

function part_two(chars)::Int
    bits = collect(
        mapreduce(
            i -> last(bitstring(parse(Int, string(i), base = 16)), 4),
            *, chars))

    return read_packet_two(bits)
end

println("PART ONE: $(part_one(inputs))")
println("PART TWO: $(part_two(inputs))")

