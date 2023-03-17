# Consensus.jl

[![UnitTests](https://github.com/rafaelbailo/Consensus.jl/actions/workflows/UnitTests.yml/badge.svg)](https://github.com/rafaelbailo/Consensus.jl/actions/workflows/UnitTests.yml)

**Consensus.jl** is a lightweight, gradient-free, stochastic optimisation package for Julia. It uses _Consensus-Based Optimisation_ (CBO), a flavour of _Particle Swarm Optimisation_ (PSO) first introduced by [R. Pinnau, C. Totzeck, O. Tse, and S. Martin (2017)][1]. This is a method of global optimisation particularly suited for rough functions, where gradient descent would fail. It is also useful for optimisation in higher dimensions.

This package was created and is developed by [Dr Rafael Bailo](https://rafaelbailo.com/).

## Usage

The basic command of the library is `minimise(f, x0)`, where `f` is the function you want to minimise, and `x0` is an initial guess. It returns an approximation of the point `x` that minimises `f`.

You have two options to define the objective function:

- `x` is of type `Real`, and `f` is defined as `f(x::Real) = ...`.
- `x` is of type `AbstractVector{<:Real}`, and `f` is defined as `f(x::AbstractVector{<:Real}) = ...`.

### A trivial example

We can demonstrate the functionality of the library by minimising the function $f(x)=x^2$. If you suspect the minimiser is near $x=1$, you can simply run

```jl
using Consensus
f(x) = x^2;
x0 = 1;
x = minimise(f, x0)
```

to obtain

```jl
julia> x
1-element Vector{Float64}:
 0.08057420724239409
```

Your `x` may vary, since the method is stochastic. The answer should be close, but not exactly equal, to zero.

Behind the scenes, **Consensus.jl** is running the algorithm using `N = 50` particles per realisation. It runs the `M = 100` realisations, and returns the averaged result. If you want to parallelise these runs, simply start julia with multiple threads, e.g.:

```sh
$ julia --threads 4
```

**Consensus.jl** will then automatically parallelise the optimisation. This is thanks to the functionality of [StochasticDiffEq.jl](https://github.com/SciML/StochasticDiffEq.jl), which is used under the hood to implement the algorithm.

### Advanced options

There are several parameters that can be customised. The most important are:

- `N`: the number of particles per realisation.
- `M`: the number of realisations, whose results are averaged in the end.
- `T`: the run time of each realisation. The longer this is, the better the results, but the longer you have to wait for them.
- `Δt`: the discretisation step of the realisations. Smaller is more accurate, but slower. If the optimisation fails (returns `Inf` or `NaN`), making this smaller is likely to help.
- `R`: the radius of the initial sampling area, which is centred around your intiial guess `x0`.
- `α`: the exponential weight. The higher this is, the better the results, but you might need to decrease `Δt` if `α` is too large.

We can run the previous example with custom parameters by calling

```jl
julia> x2 = minimise(f, x0, N = 30, M = 100, T = 10, Δt = 0.5, R = 2, α = 500)
1-element Vector{Float64}:
 0.0017988128895332278
```

For the other parameters, please refer to the paper of [R. Pinnau, C. Totzeck, O. Tse, and S. Martin (2017)][1]. You can see the default values of the parameters by evaluating `Consensus.DEFAULT_OPTIONS`.

### Non-trivial examples

Since CBO is not a gradient method, it will perform well on rough functions. **Consensus.jl** implements two well-known test cases in any number of dimensions:

- The [Ackley function](https://en.wikipedia.org/wiki/Ackley_function).
- The [Rastrigin function](https://en.wikipedia.org/wiki/Rastrigin_function).

We can minimise the Ackley function in two dimensions, starting near the point $x=(1,1)$, by running

```jl
julia> x3 = minimise(AckleyFunction, [1, 1])
2-element Vector{Float64}:
 0.0024744433653736513
 0.030533227060295706
```

We can also minimise the Rastrigin function in five dimensions, starting at a random point, with more realisations, and with a larger radius, by running

```jl
julia> x4 = minimise(RastriginFunction, rand(5), M = 200, R = 5)
5-element Vector{Float64}:
 -0.11973689657393186
  0.07882427348951951
  0.18515501300052115
 -0.06532360247574359
 -0.13132340855939928
```

### Auxiliary commands

There is a `maximise(f, x0)` method, which simply minimises the function `g(x) = -f(x)`. Also, if you're that way inclined, you can call `minimize(f, x0)` and `maximize(f, x0)`, in the American spelling.

[1]: http://dx.doi.org/10.1142/S0218202517400061
