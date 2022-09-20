module Returns

using Distributions, Random, StatsBase, LinearAlgebra, Base.Threads, Reexport

include("Cholesky_Function.jl")
using Reexport
export CholeskyReturns

end #module
