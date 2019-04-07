using LimitOrderBook
using Test
using Base

@testset "LimitOrderBook" begin
    include("order.jl")
    include("pricelevel.jl")
    include("pricelevels.jl")
    include("orderbook.jl")
end


