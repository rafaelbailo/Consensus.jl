using Consensus
using Test

const N = 20;

function tests()
  @testset "meanValue!" begin
    f = AckleyFunction
    x = rand(N)
    options = Consensus.getOptions()
    cache = Consensus.getCache(f, x, options)
    X = Consensus.getInitialState(x, cache)

    @test @isAllocationFree Consensus.meanValue!(X, cache)
  end

  @testset "dt!" begin
    f = AckleyFunction
    x = rand(N)
    options = Consensus.getOptions()
    cache = Consensus.getCache(f, x, options)
    X = Consensus.getInitialState(x, cache)
    Ẋ = zero(X)
    t = rand()

    @test @isAllocationFree Consensus.dt!(Ẋ, X, cache, t)
  end

  @testset "dW!" begin
    f = AckleyFunction
    x = rand(N)
    options = Consensus.getOptions()
    cache = Consensus.getCache(f, x, options)
    X = Consensus.getInitialState(x, cache)
    Ẋ = zero(X)
    t = rand()

    @test @isAllocationFree Consensus.dW!(Ẋ, X, cache, t)
  end
end

tests()
