using SafeTestsets

@safetestset "benchmarkFunctions" begin
  include("benchmarkFunctions.jl")
end

@safetestset "method" begin
  include("method.jl")
end

@safetestset "minimise" begin
  include("minimise.jl")
end

@safetestset "format" begin
  include("format.jl")
end
