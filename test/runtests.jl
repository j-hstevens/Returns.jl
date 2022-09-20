using Returns
using Test
using Distributions, Random, LinearAlgebra, CSV, DataFrames, StatsBase

@testset "Returns.jl" begin
    #1.a Load Key Files
    ltcmas = CSV.File("assets/" .* readdir("assets/")) |> DataFrame
    #1.b Set time(t), simulations(sims),
    t = 100
    sims = 1000
    #1.c Load annual means(means), annual volaility(vols) and correlations
    means = ltcmas."Arithmetic Return 2022 (%)" ./ 100
    vols = ltcmas."Annualized Volatility (%)" ./ 100
    correls = LowerTriangular(Array(ltcmas[:, Between("U.S. Inflation","Gold")]))
    correls = min.(correls + correls', 1.0)
    #2 Create Returns
    returns = CholeskyReturns(t, sims, means, vols, correls)

    allmeans = [[mean(returns[:,i,j]) for i=1:length(means)] for j=1:sims]
    allvols = [[std(returns[:,i,j]) for i=1:length(means)] for j=1:sims]
    rvols = [mean([i[j] for i in allvols]) for j in 1:length(means)]
    rmeans = [mean([i[j] for i in allmeans]) for j in 1:length(means)]

    @test maximum(abs.(rvols - vols)) <= 0.1
    @test maximum(abs.(rmeans - means)) <= 0.1

end #test
