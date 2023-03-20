function Parabola(x::AbstractVector{<:Real}, B::Real = 0, C::Real = 0)
  D = length(x)
  res = 0.0
  for d in 1:D
    res += (x[d] - B)^2
  end
  return res / 2 + C
end

function AckleyFunction(x::AbstractVector{<:Real}, B::Real = 0, C::Real = 0)
  first = AckleyFirstTerm(x, B)
  second = AckleySecondTerm(x, B)
  return 20 * (1 - exp(first)) - exp(second) + ℯ + C
end

function AckleyFirstTerm(x::AbstractVector{Float64}, B::Real)
  D = length(x)
  C = -0.2 / sqrt(D)
  res = 0.0
  for d in 1:D
    res += (x[d] - B)^2
  end
  return C * sqrt(res)
end

function AckleySecondTerm(x::AbstractVector{Float64}, B::Real)
  D = length(x)
  res = 0.0
  for d in 1:D
    arg = 2π * (x[d] - B)
    if !isinf(arg)
      res += cos(arg)
    end
  end
  return res / D
end

function RastriginFunction(x::AbstractVector{<:Real}, B::Real = 0, C::Real = 0)
  first = RastriginFirstTerm(x, B)
  second = RastriginSecondTerm(x, B)
  return 10 * (1 - first) + second + C
end

function RastriginFirstTerm(x::AbstractVector{Float64}, B::Real)
  D = length(x)
  res = 0.0
  for d in 1:D
    arg = 2π * (x[d] - B)
    if !isinf(arg)
      res += cos(arg)
    end
  end
  return res / D
end

function RastriginSecondTerm(x::AbstractVector{Float64}, B::Real)
  D = length(x)
  res = 0.0
  for d in 1:D
    res += (x[d] - B)^2
  end
  return res / D
end
