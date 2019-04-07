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

