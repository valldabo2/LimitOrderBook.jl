import DataStructures: Deque

@testset "PriceLevel" begin
    pl = PriceLevel()

    # Test creation of price level
    @test size(orders(pl)) == (0,)
    @test size(pl) == 0

    # Test adding a limit order
    oid = UInt128(0)
    o = LimitOrder(UInt128(10), UInt128(1), UInt128(1), BUY, oid)
    add!(pl, o)
    @test size(orders(pl)) == (1,)
    @test size(pl) == 1

    # Test removing a limit order
    remove!(pl, oid)
    @test size(orders(pl)) == (0,)
    @test size(pl) == 0

    # Test that orders are in the correct order
    o2 = LimitOrder(UInt128(10), UInt128(1), UInt128(1), BUY, UInt128(2))
    add!(pl, o)
    add!(pl, o2)

    first_order = first(pl)
    @test first_order == o

    remove!(pl, id(o))

    first_order = first(pl)
    @test first_order == o2

    # Test to input many orders and remove them
    pl = PriceLevel()
    for i in 1:100
        add!(pl, LimitOrder(UInt128(10),
                            UInt128(1),
                            UInt128(1),
                            BUY, UInt128(i)))
    end

    @test size(pl) == 100
    @test size(orders(pl)) == (100,)

    for i in 1:100
        remove!(pl, UInt128(i))
    end

    @test size(pl) == 0
    @test size(orders(pl)) == (0,)

    @testset "Matching" begin
        pl = PriceLevel()
        # Adds three buy orders of size 10
        o1 = LimitOrder(UInt128(10), UInt128(10), UInt128(1), BUY, UInt128(1))
        add!(pl,o1)
        o2 = LimitOrder(UInt128(10), UInt128(10), UInt128(1), BUY, UInt128(2))
        add!(pl,o2)
        o3 = LimitOrder(UInt128(10), UInt128(10), UInt128(1), BUY, UInt128(3))
        add!(pl,o3)

        trades = Deque{LimitOrder}()
        size = UInt128(10)
        trades, size = match!(pl, size, trades)

        #expected_trades = Deque{LimitOrder}()
        #push!(expected_trades, o1)
        #@test trades === expected_trades
        # The entire sized was matched
        @test size == 0
        @test Int(pl.size) == 20
    end

end
