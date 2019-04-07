 using Base

mutable struct LimitOrder
    price::UInt128
    size::UInt128
    trader_id::UInt128
    side::Bool
    order_id::UInt128
end

function Base.size(o::LimitOrder)::UInt128
    return o.size
end

function trader(o::LimitOrder)::UInt128
    return o.trader_id
end

function side(o::LimitOrder)::Bool
    return o.side
end

function id(o::LimitOrder)::UInt128
    return o.order_id
end

