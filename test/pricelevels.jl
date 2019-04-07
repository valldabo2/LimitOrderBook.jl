@testset "PriceLevels" begin

    min_price = UInt128(1)
    max_price = UInt128(100)

    pls = PriceLevels(max_price, min_price)
    @test size(pls) == (100,)


    @test pls.bid == 1
    @test pls.ask == 100

end
