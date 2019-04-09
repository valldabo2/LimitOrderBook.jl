@testset "PriceLevels" begin

    min_price = UInt128(1)
    max_price = UInt128(100)

    pls = PriceLevels(max_price, min_price)
    @test size(pls) == (100,)


    @test pls.bid == 1
    @test pls.ask == 100

    insert_order!(pls, LimitOrder(UInt128(10), UInt128(10),
                                  UInt128(1), BUY, UInt128(1)))
    @test pls.bid == 10

    insert_order!(pls, LimitOrder(UInt128(11), UInt128(10),
                                  UInt128(1), SELL, UInt128(1)))
    @test pls.ask == 11
end
