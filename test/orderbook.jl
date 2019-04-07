@testset "OrderBook" begin

    max_price = UInt128(100)
    min_price = UInt128(1)
    orderbook = OrderBook(max_price, min_price)
    order_id_expected = UInt128(0)

    @testset "Insert Buy orders" begin 
        
        for p in 1:20

            price = UInt128(p)
            size = UInt128(10)
            trader_id = UInt128(1)
            side = BUY # Buy
            trades, order_id = limitorder!(orderbook, side,
                                       price, size, trader_id)

            # Check order_id
            order_id_expected = order_id_expected + 1
            @test order_id == order_id_expected

            # Check bid and bid size
            bid = best_bid(orderbook)
            @test bid == price
            bid_size = best_bid_size(orderbook)
            @test bid_size == size


        end

    end

    @testset "Insert Sell orders" begin 

        for p in 100:-1:80

            price = UInt128(p)
            size = UInt128(10)
            trader_id = UInt128(1)
            side = SELL # Buy
            trades, order_id = limitorder!(orderbook, side,
                                       price, size, trader_id)

            # Check order_id
            order_id_expected = order_id_expected + 1
            @test order_id == order_id_expected

            # Check bid and bid size
            ask = best_ask(orderbook)
            @test ask == price
            ask_size = best_ask_size(orderbook)
            @test ask_size == size


        end

    end

    println(best_ask(orderbook))
    println(best_bid(orderbook))

    #trades = marketorder!(orderbook, side, size, trader_id)

    #cancel!(orderbook, order_id)

    #update!(orderbook, order_id, size)

end

