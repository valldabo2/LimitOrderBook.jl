

@testset "LimitOrder" begin


    price = UInt128(10)
    size = UInt128(100)
    trader_id = UInt128(1)
    order_id = UInt128(2)

    order = LimitOrder(price, size, trader_id, BUY, order_id)
    @test order.size == size 
    @test order.trader_id == trader_id
    @test order.side == BUY
    @test order.order_id == order_id
end

