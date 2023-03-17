using Consensus
using Test

import Distributions.Uniform
import LinearAlgebra.norm

NegParabola(x) = -Parabola(x);

for method in (:minimise, :maximise, :minimize, :maximize)
  @eval begin
    function $(Symbol(method, :Test))(f, N)
      x = rand(Uniform(-3, 3), N)
      z = $method(f, x)
      @test norm(z) < norm(x)
    end
  end
end

function dimTest(N)
  @testset "Parabola" begin
    minimiseTest(Parabola, N)
  end

  @testset "Ackley" begin
    minimiseTest(AckleyFunction, N)
  end

  @testset "Rastrigin" begin
    minimiseTest(RastriginFunction, N)
  end
end

function tests()
  @testset "minimise" begin
    @testset "1D" begin
      dimTest(1)
    end

    @testset "5D" begin
      dimTest(5)
    end

    @testset "20D" begin
      dimTest(5)
    end

    @testset "shifted" begin
      f(x) = Parabola(x, 1, 2)
      minimiseTest(f, 1)
    end
  end

  @testset "minimize" begin
    minimizeTest(Parabola, 1)
  end

  @testset "maximise" begin
    maximiseTest(NegParabola, 1)
  end

  @testset "maximize" begin
    maximizeTest(NegParabola, 1)
  end
end

tests()
