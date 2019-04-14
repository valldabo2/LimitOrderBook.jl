@testset "OrderBook" begin
    @testset "Passive Orders" begin
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
    end

    @testset "Aggressive Orders" begin

        @testset "Buy Order" begin

            max_price = UInt128(15)
            min_price = UInt128(7)
            orderbook = OrderBook(max_price, min_price)
            order_id_expected = UInt128(0)

            # Place passive sell order
            limitorder!(orderbook, SELL, UInt128(10), UInt128(100), UInt128(1))

            # Match sell order
            trades, order_id = limitorder!(orderbook, BUY, UInt128(10),
                                          UInt128(10), UInt128(2))

            @test amount(trades) == 10*10

            trades, order_id = limitorder!(orderbook, BUY, UInt128(11),
                                           UInt128(40), UInt128(2))

            @test amount(trades) == 10*40

            # Not there exists 50 left of the sell order
            ask = best_ask(orderbook)
            ask_volume = best_ask_size(orderbook)
            @test ask == 10
            @test ask_volume == 50

            # We insert another sell order at price 11
            limitorder!(orderbook, SELL, UInt128(11), UInt128(100), UInt128(1))

            # If we place a buy order at 11 for 151 we should get 50 for 10 and
            # 100 for 11
            trades, order_id = limitorder!(orderbook, BUY, UInt128(11),
                                           UInt128(151), UInt128(2))
            
            @test amount(trades) == 10*50 + 11*100
        end

        @testset "Sell Order" begin
            max_price = UInt128(15)
            min_price = UInt128(7)
            orderbook = OrderBook(max_price, min_price)
            order_id_expected = UInt128(0)

            # Place passive buy order
            limitorder!(orderbook, BUY, UInt128(10), UInt128(100), UInt128(1))
            # Match buy order
            trades, order_id = limitorder!(orderbook, SELL, UInt128(10),
                                           UInt128(10), UInt128(2))

            @test amount(trades) == 10*10

            trades, order_id = limitorder!(orderbook, SELL, UInt128(9),
                                           UInt128(40), UInt128(2))

            @test amount(trades) == 10*40

            # Not there exists 50 left of the buy order
            bid = best_bid(orderbook)
            bid_volume = best_bid_size(orderbook)
            @test bid == 10
            @test bid_volume == 50

            # # We insert another sell order at price 11
            # limitorder!(orderbook, BUY, UInt128(11), UInt128(100), UInt128(1))

            # # If we place a sell order at 11 for 151 we should get 50 for 10 and
            # # 100 for 11
            # trades, order_id = limitorder!(orderbook, SELL, UInt128(11),
            #                                UInt128(151), UInt128(2))
            
            # @test amount(trades) == 10*50 + 11*100
        end
 
    end

    #trades = marketorder!(orderbook, side, size, trader_id)

    #cancel!(orderbook, order_id)

    #update!(orderbook, order_id, size)

end

