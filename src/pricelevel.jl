using DataStructures
using DataStructures: OrderedDict, Deque
using Base

mutable struct PriceLevel
    orders::OrderedDict{UInt128, LimitOrder}
    size::UInt128
    function PriceLevel()
        new(OrderedDict{UInt128, LimitOrder}(), UInt128(0))
    end
end

function orders(pl::PriceLevel)::Array{LimitOrder}
    return pl.orders.vals
end

function Base.size(pl::PriceLevel)::UInt128
    return pl.size
end

function add!(pl::PriceLevel, o::LimitOrder)
    pl.orders[id(o)] = o
    pl.size += size(o)
end

function remove!(pl::PriceLevel, order_id::UInt128)
    o = pop!(pl.orders, order_id)
    pl.size -= size(o)

    if pl.size == UInt128(0)
        pl.orders = OrderedDict{UInt128, LimitOrder}()
    end
end

function DataStructures.first(pl::PriceLevel)
    return DataStructures.first(pl.orders).second
end

function match!(pl::PriceLevel, size::UInt128, trades::Deque{LimitOrder})
    # Matches the size to the price level
    for order in values(pl.orders)
        diff = order.size - size
        # Current limit order is larger than ordered size
        if diff > 0
            order.size = order.size - diff
            pl.size = pl.size - diff
            push!(trades, LimitOrder(order.price, diff, order.trader_id,
                                     order.side, order.order_id))
            return trades, 0
        # Current limit order is smaller or equal to than ordered size
        elseif diff <= 0
            push!(trades, order)
            size = size - order.size
            pl.size = pl.size - order.size
            if diff == 0
                pop!(pl.orders)
            end
            return trades, size
        end
    end
end
