function minimise(f::Function, x::AbstractVector{<:Real}; args...)
  options = getOptions(; args...)
  optimisers, _ = minimiseWithParsedOptions(f, x, options)
  optimiser = mean(optimisers)
  if options.returnSamples
    return optimiser, optimisers
  else
    return optimiser
  end
end

function getOptions(; args...)
  options = merge(DEFAULT_OPTIONS, args)
  @assert options.ε > 0
  return options
end

function minimiseWithParsedOptions(
  f::Function,
  x::AbstractVector{<:Real},
  options::NamedTuple,
)
  cache = getCache(f, x, options)
  X0 = getInitialState(x, cache)
  T = Float64(cache.T)
  time = (0.0, T)

  function remakeProblem(prob, i, repeat)
    cache = getCache(f, x, options)
    X0 = getInitialState(x, cache)
    return remake(prob, u0 = X0, p = cache)
  end
  problem = SDEProblem(dt!, dW!, X0, time, cache)
  ensembleProblem = EnsembleProblem(problem, prob_func = remakeProblem)
  solutions = nothing
  @suppress_err begin
    solutions = solve(
      ensembleProblem,
      cache.integrator,
      EnsembleThreads(),
      dt = cache.Δt,
      saveat = T,
      trajectories = cache.M,
    )
  end
  optimisers = map(getOptimiser, solutions)
  return optimisers, solutions
end

function getOptimiser(solution)
  X = solution[end]
  cache = solution.prob.p
  meanValue!(X, cache)
  return cache.vf
end

function getCache(f::Function, x::AbstractVector{<:Real}, options::NamedTuple)
  D = length(x)
  sqrt2σ = sqrt(2) * options.σ
  vf = zeros(D)
  newFields = (; D, f, vf, sqrt2σ)
  cache = merge(options, newFields)
  return cache
end

function getInitialState(x::AbstractVector{<:Real}, cache::NamedTuple)
  D, N, R = cache.D, cache.N, cache.R
  X0 = zeros(D, N)
  for n in 1:N, d in 1:D
    X0[d, n] = rand(Uniform(x[d] - R, x[d] + R))
  end
  return X0
end

function minimise(f::Function, x::Real; args...)
  g(x) = f(x[1])
  return minimise(g::Function, [x]; args...)
end

function maximise(f::Function, x; args...)
  g(x) = -f(x)
  return minimise(g::Function, x; args...)
end

minimize(f::Function, x; args...) = minimise(f, x; args...);
maximize(f::Function, x; args...) = maximise(f, x; args...);
