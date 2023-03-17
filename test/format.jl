using Consensus
using Test
using JuliaFormatter

function tests()
  @test format(".", remove_extra_newlines = true, indent = 2, margin = 80)
end

tests()
