using Distributions, Random, StatsBase, LinearAlgebra

function CholeskyReturns(t::Int64, sims::Int64, means::Vector{Float64},
    vols::Vector{Float64}, correls::Matrix{Float64}; seed=123)

    #Pre-Allocate returns
    returns = zeros(t, length(means), sims)

    #Convert the mean vector into a matrix
    mean = repeat(means', t)

    #Calculate the lu decomposition for an upper triangular matrix
    chol = cholesky(cor2cov(correls, vols)).U

    #Generate the returns in a normal distribution, multiply by the cholesky...
    #matrix and add the means back to the now correlated distribution

    #Set the seed
    Random.seed!(seed)

    #Check if threading is desired
    for i in 1:sims
        returns[:,:,i] = randn!(returns[:,:,i]) * chol + mean
    end #i
    return returns
end #function

export CholeskyReturns
