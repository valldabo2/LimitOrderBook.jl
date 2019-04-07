@testset "PriceLevel" begin
    pl = PriceLevel()
    @test size(orders(pl)) == (0,)
    @test size(pl) == 0
    oid = UInt128(0)

    o = LimitOrder(UInt128(10),
                   UInt128(1),
                   UInt128(1),
                   BUY,
                   oid)
    add!(pl, o)
    @test size(orders(pl)) == (1,)
    @test size(pl) == 1

    remove!(pl, oid)
    @test size(orders(pl)) == (0,)
    @test size(pl) == 0

    o2 = LimitOrder(UInt128(10),
                   UInt128(1),
                   UInt128(1),
                   BUY,
                   UInt128(2))
    add!(pl, o)
    add!(pl, o2)

    first_order = first(pl)
    @test first_order == o

    remove!(pl, id(o))

    first_order = first(pl)
    @test first_order == o2

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


end
