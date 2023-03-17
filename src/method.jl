Hε(x::Real, ε::Real) = (1 + tanh(x / ε)) / 2;

ωfα(α, f, x) = exp(-α * f(x));

function meanValue!(X, cache)
  D = cache.D
  f = cache.f
  N = cache.N
  vf = cache.vf
  α = cache.α

  ∑ω = 0.0
  for d = 1:D
    vf[d] = 0.0
  end

  for i = 1:N
    xi = view(X, :, i)
    ωi = ωfα(α, f, xi)
    ∑ω += ωi
    for d = 1:D
      vf[d] += ωi * xi[d]
    end
  end

  for d = 1:D
    vf[d] /= ∑ω
  end
  return nothing
end

function dt!(Ẋ, X, cache, t)
  meanValue!(X, cache)

  D = cache.D
  f = cache.f
  N = cache.N
  vf = cache.vf
  ε = cache.ε
  λ = cache.λ

  fvf = f(vf)

  for i = 1:N
    xi = view(X, :, i)
    fi = f(xi)
    C = λ * Hε(fi - fvf, ε)
    for d = 1:D
      Ẋ[d, i] = C * (vf[d] - xi[d])
    end
  end
  return nothing
end

function dW!(Ẋ, X, cache, t)
  D = cache.D
  N = cache.N
  sqrt2σ = cache.sqrt2σ
  vf = cache.vf

  for i = 1:N
    xi = view(X, :, i)
    C = 0.0
    for d = 1:D
      C += (xi[d] - vf[d])^2
    end
    C = sqrt2σ * sqrt(C)
    for d = 1:D
      Ẋ[d, i] = C
    end
  end
  return nothing
end
