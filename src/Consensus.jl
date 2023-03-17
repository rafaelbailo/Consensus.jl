module Consensus

using StochasticDiffEq
using Suppressor

import Distributions.Uniform
import Statistics.mean

include("benchmarkFunctions.jl")
include("checkAllocations.jl")
include("defaults.jl")
include("method.jl")
include("minimise.jl")

export minimise, maximise, minimize, maximize
export AckleyFunction, Parabola, RastriginFunction
export @isAllocationFree, @isCalledFromFunction

end
