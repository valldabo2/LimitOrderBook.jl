using Base

mutable struct PriceLevels
    levels::Array{PriceLevel, 1}
    ask::UInt128
    bid::UInt128
    max_price::UInt128
    min_price::UInt128

    function PriceLevels(max_price::UInt128, min_price::UInt128)
        n_prices = max_price - min_price + 1
        new(Array{PriceLevel, 1}(undef, n_prices), max_price,
            min_price, max_price, min_price)::PriceLevels
    end
end

function Base.size(pls::PriceLevels)::Tuple{UInt128}
    return size(pls.levels)
end

function price_to_index(price::UInt128, min_price::UInt128)::Int
    return Int(price - min_price + 1)
end

function index_to_price(index::UInt128, min_price::UInt128)::UInt128
    return index + min_price - 1
end

function insert_order!(pls::PriceLevels, order::LimitOrder)

    price_index = price_to_index(order.price, pls.min_price)
    if !isassigned(pls.levels, Int(price_index))
        pls.levels[price_index] = PriceLevel()
    end

    if side(order) == BUY

        # Assert price lower than ask, might be removed
        @assert order.price < pls.ask "Inserted buy order with larger price than current ask"
        
       
        add!(get_level(pls, order.price), order)

        if order.price > pls.bid
            pls.bid = order.price
        end
    else
        # Assert price higher than bid, might be removed
        @assert order.price > pls.bid "Inserted sell order with lower price than current bid"
        add!(get_level(pls, order.price), order)

        if order.price < pls.ask
            pls.ask = order.price
        end

    end

end

function get_level(pls::PriceLevels, price::UInt128)::PriceLevel
    price_index = price_to_index(price, pls.min_price)
    return pls.levels[price_index]
end

function update_ask!(pls::PriceLevels)::UInt128
    ask = pls.ask + 1
    while ask < pls.max_price
        ask_index = price_to_index(ask, pls.min_price)
        if isassigned(pls.levels, ask_index)
            if pls.levels[ask_index].size > 0
                pls.ask = ask
                return ask
            end
        end
        ask = ask + 1
    end
    pls.ask = ask
    return pls.ask
end

function update_bid!(pls::PriceLevels)::UInt128
    bid = pls.bid - 1
    while bid > pls.min_price
        bid_index = price_to_index(bid, pls.min_price)
        if isassigned(pls.levels, bid_index)
            if pls.levels[bid_index].size > 0
                pls.bid = bid
                return bid

            end
        end
        bid = bid - 1
    end
    pls.bid = bid
    return pls.bid
end


