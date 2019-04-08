using Base

mutable struct PriceLevels
    levels::Array{PriceLevel, 1}
    ask::UInt128
    bid::UInt128

    function PriceLevels(max_price::UInt128, min_price::UInt128)
        n_prices = max_price - min_price + 1
        new(Array{PriceLevel, 1}(undef, n_prices), max_price,
            min_price)
    end
end

function Base.size(pls::PriceLevels)
    return size(pls.levels)
end

function insert_order!(pls::PriceLevels, order::LimitOrder)

    # Could have an undefined price level
    if !isdefined(pls.levels, Int(order.price))
            pls.levels[order.price] = PriceLevel()
    end
 
    if side(order) == BUY

        # Assert price lower than ask, might be removed
        @assert order.price < pls.ask "Inserted buy order with larger price than current ask"
        
       
        add!(pls.levels[order.price], order)

        if order.price > pls.bid
            pls.bid = order.price
        end
    else
        # Assert price higher than bid, might be removed
        @assert order.price > pls.bid "Inserted sell order with lower price than current bid"
        add!(pls.levels[order.price], order)

        if order.price < pls.ask
            pls.ask = order.price
        end

    end

end

function get_level(pls::PriceLevels, price::UInt128)::PriceLevel
    return pls.levels[Int(price)]
end

