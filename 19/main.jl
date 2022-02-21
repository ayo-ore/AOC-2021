#!/usr/bin/julia

using LinearAlgebra

Beacon = Vector{Int}
Scanner = Vector{Beacon}
const REQUIRED_MATCHES = 12
#                                            +z
#                                            ^
#                                            | /
#                                            |/
#                                      _ _ _ |_ _ _ _\ +y
#                                           /|        
#                                          / |   
#                                         V       
#                                       +x         
#

# function get_orientation_matrices()::Vector{Matrix{Int}}
#     orientations::Vector{Matrix{Int}} = []
#     for fa ∈ 1:3, fd ∈ 1:-2:-1, s ∈ (-1, 1), o ∈ (-1, 1)
#         R = zeros(Int, (3, 3))
#         # fill first row, which sets facing direction
#         R[1, fa] = fd
#         # fill remaining 2x2 with det -fd matrix
#         yz = setdiff(1:3, [fa])
#         R[2, yz[(3-o)÷2]] = s * fd
#         R[3, yz[(3+o)÷2]] = s * o * (-1)^(fa % 2 + 1)

#         push!(orientations, R)
#     end
#     return orientations
# end

# using SO(3) generators :'(
# function get_orientation_matrices()::Nothing#Vector{Matrix{Int}}
#     Lx::Matrix{Int} = [0 0 0
#         0 0 -1
#         0 1 0]
#     Ly::Matrix{Int} = [0 0 1
#         0 0 0
#         -1 0 0]
#     Lz::Matrix{Int} = [0 -1 0
#         1 0 0
#         0 0 0]
#     rotations = [
#         round.(Int, exp(π * t * L / 2))
#         for L::Matrix{Int} ∈ (Lx, Ly, Lz), t::Float64 ∈ 1:3
#     ]
#     # return unique(r1 * r2 for r1 ∈ rotations, r2 ∈ rotations)
#     orientations = unique(r1 * r2 for r1 ∈ rotations, r2 ∈ rotations)
#     for o ∈ orientations
#         display(o)
#         println()
#     end
#     @show length(orientations)
#     @show all(det.(orientations) .== 1)

# end

function get_orientation_matrices()::Vector{Matrix{Int}}
    orientations::Vector{Matrix{Int}} = []
    for f ∈ 1:3, s1 ∈ (1, -1)
        row1::Vector{Int} = zeros(Int, 3)
        row1[f] = s1
        for u ∈ setdiff(1:3, f), s2 ∈ (1, -1)
            row2::Vector{Int} = zeros(Int, 3)
            row2[u] = s2
            row3::Vector{Int} = cross(row1, row2)
            matrix = vcat(permutedims.([row1, row2, row3])...)
            push!(orientations, matrix)
        end
    end
    return orientations
end

function get_displacements(scanner::Scanner)::Matrix{Vector{Int}}
    [a - b for a ∈ scanner, b ∈ scanner]
end

@inline function distance(l1::Vector{Int}, l2::Vector{Int})
    return sum(abs.(l1 - l2))
end

function solve(scanners::Vector{Scanner})

    # cache orientation matrices
    orientations::Vector{Matrix{Int}} = get_orientation_matrices()

    # cache displacements
    displacements::Vector{Matrix{Vector{Int}}} = get_displacements.(scanners)

    # cache reoriented displacements
    reoriented_displacements::Matrix{Matrix{Vector{Int}}} = [
        Ref(O) .* D for D ∈ displacements, O ∈ orientations
    ]

    # initialize constants and containers
    S::Int = length(scanners)               # number of scanners

    scanner_matched::BitArray{1} = falses(S)
    scanner_matched[begin] = true      # matches start relative to first scanner

    T = zeros(Int, 3)                  # dispacement between matched scanners
    BMI = Set{Int}()                   # matched beacon indices
    NBMI::Int = 0                      # number of matched beacon indices

    got_disp::Bool = false             # flag to avoid recalculating scanner displacements
    locations::Vector{Vector{Int}} = [[0,0,0]]
    while sum(scanner_matched) < S

        for i ∈ eachindex(scanners), j ∈ eachindex(scanners)

            @inbounds if !scanner_matched[i] || scanner_matched[j]
                continue
            end

            # iterate through orientations
            for o ∈ 1:24

                # empty matched beacon indices
                empty!(BMI) # USE BITARRAY INSTEAD?

                # iterate through pairs of beacons from matched scanner
                got_disp = false
                for k ∈ 1:length(scanners[i]), l ∈ k+1:length(scanners[i])

                    # match displacements
                    @inbounds swap = findfirst((displacements[i][l, k],) .== reoriented_displacements[j, o])

                    if swap !== nothing
                        # update matched beacons
                        union!(BMI, (l, k))

                        # get displacement between scanners
                        if !got_disp
                            @inbounds T = orientations[o] * scanners[j][swap[1]] - scanners[i][l]
                            got_disp = true
                        end
                    end

                    # check if required number of beacons have been matched
                    NBMI = length(BMI)
                    if NBMI >= REQUIRED_MATCHES

                        # report match
                        println("Matched scanner $(j-1) to scanner $(i-1)")
                        println("\tBeacons: $(NBMI)")
                        println("\tOrientation: $(orientations[o])")
                        println("\tDisplacement: $(-T)")

                        # reorient and translate unmatched scanner
                        @inbounds scanners[j] = (Ref(orientations[o]) .* scanners[j]) .- Ref(T)

                        # reorient displacements
                        @inbounds displacements[j] = reoriented_displacements[j, o]

                        # mark unmatched scanner as matched
                        @inbounds scanner_matched[j] = true

                        # add scanner location to array
                        push!(locations, T)

                        break
                    end
                end

                if scanner_matched[j]
                    break
                end
            end
        end
        # return 0
    end
    println("PART ONE: $(length(unique(vcat(scanners...))))")
    println("PART TWO: $(maximum(distance(l1, l2) for l1 ∈ locations, l2 ∈ locations))")
end

const INPUT_FILE = ARGS[1]
const inputs = map(split(readchomp(INPUT_FILE), r"--- scanner (\d|\d\d) ---", keepempty = false)) do scanner
    [parse.(Int, split(line, ',')) for line in split(scanner, '\n', keepempty = false)]
end

solve(inputs)


