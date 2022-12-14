using Returns
using Test
using Distributions, Random, LinearAlgebra, StatsBase

@testset "Returns.jl" begin
    t = 100 #t = time
    sims = 1000 #sims = simulations
    means = collect(0.01:0.01:0.1)
    vols = zeros(length(means)) .+ 0.05
    correls = zeros(length(means), length(vols)) .+ 0.02
    for i=1:size(correls,1)
        correls[i,i] = 1.0
    end

    #2 Create Returns
    returns = CholeskyReturns(t, sims, means, vols, correls)
    returns2 = CholeskyReturns(t, sims, means, vols, correls)

    #Calculate the mu and vols for all each asset classes in all simulations
    allmeans = [[mean(returns[:,i,j]) for i=1:length(means)] for j=1:sims]
    allvols = [[std(returns[:,i,j]) for i=1:length(means)] for j=1:sims]

    #Calculate the average mu and vol
    rvols = [mean([i[j] for i in allvols]) for j in 1:length(means)]
    rmeans = [mean([i[j] for i in allmeans]) for j in 1:length(means)]

    #Test the mus and vols are within 1% of inputs
    @test maximum(abs.(rvols - vols)) <= 0.01
    @test maximum(abs.(rmeans - means)) <= 0.01

    #Test reproducibility
    @test returns == returns2

end #test
