using Returns
using Test
using Distributions, Random, LinearAlgebra

@testset "Returns.jl" begin
    t = 50
    sims = 1000
    means = collect(0.01:0.01:0.1)
    vols = zeros(length(means)) .+ 0.05
    correls = LowerTriangular(rand(Normal(-.05, 0.05), length(means), length(vols)))
    correls = correls + UpperTriangular(correls')

    for i=1:size(correls,1)
        correls[i,i] = 1.0
    end

    returns = CholeskyReturns(t, sims, means, vols, correls)

    allmeans = [[mean(returns[:,i,j]) for i=1:length(means)] for j=1:sims]
    allvols = [[std(returns[:,i,j]) for i=1:length(means)] for j=1:sims]
    rvols = [mean([i[j] for i in allvols]) for j in 1:length(means)]
    rmeans = [mean([i[j] for i in allmeans]) for j in 1:length(means)]

    @test maximum(abs.(rvols - vols)) <= 0.01
    @test maximum(abs.(rmeans - means)) <= 0.01

end #test
