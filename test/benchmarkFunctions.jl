using Consensus
using Test

const N = 20;

function tests()
  @testset "Ackley Function" begin
    @testset "allocations" begin
      x = rand(N)
      B = rand()
      C = rand()
      @test @isAllocationFree Consensus.AckleyFirstTerm(x, B)
      @test @isAllocationFree Consensus.AckleySecondTerm(x, B)
      @test @isAllocationFree AckleyFunction(x, B, C)
    end

    @testset "values" begin
      B = rand()
      C = rand()
      x = ones(N) * B
      @test AckleyFunction(x, 0, C) >= C
      @test AckleyFunction(x, B, C) ≈ C
      @test AckleyFunction(x * 0, 0, C) ≈ C
      @test AckleyFunction(x * 0) ≈ 0
    end
  end

  @testset "Rastrigin Function" begin
    @testset "allocations" begin
      x = rand(N)
      B = rand()
      C = rand()
      @test @isAllocationFree Consensus.RastriginFirstTerm(x, B)
      @test @isAllocationFree Consensus.RastriginSecondTerm(x, B)
      @test @isAllocationFree RastriginFunction(x, B, C)
    end

    @testset "values" begin
      B = rand()
      C = rand()
      x = ones(N) * B
      @test RastriginFunction(x, 0, C) >= C
      @test RastriginFunction(x, B, C) ≈ C
      @test RastriginFunction(x * 0, 0, C) ≈ C
      @test RastriginFunction(x * 0) ≈ 0
    end
  end

  @testset "Parabola" begin
    @testset "allocations" begin
      x = rand(N)
      B = rand()
      C = rand()
      @test @isAllocationFree Parabola(x, B, C)
    end

    @testset "values" begin
      B = rand()
      C = rand()
      x = ones(N) * B
      @test Parabola(x, 0, C) >= C
      @test Parabola(x, B, C) ≈ C
      @test Parabola(x * 0, 0, C) ≈ C
      @test Parabola(x * 0) ≈ 0
    end
  end
end

tests()
