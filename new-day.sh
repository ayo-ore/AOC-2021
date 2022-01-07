#!/bin/zsh

set -xe

cd `dirname $0`
typeset -Z2 nextday
nextday=$((`find * -type d|sort -nr|head -1` +1)) 
mkdir $nextday
cd $nextday

touch sample.txt
touch input.txt
main=main.jl
echo '#!/usr/bin/julia
const INPUT_FILE = ARGS[1]
const inputs = map(eachline(INPUT_FILE)) do i
    throw("Not implemented")
end

function part_one(inputs)::Int
    throw("Not implemented")
end

function part_two(inputs)::Int
    throw("Not implemented")
end

println("PART ONE: $(part_one(inputs))")
println("PART TWO: $(part_two(inputs))")
' > $main

chmod +x $main
