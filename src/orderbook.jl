mutable struct OrderBook
    price_levels::PriceLevels
    order_id::UInt128 # Does it need to be this big?
    function OrderBook(max_price::UInt128, min_price::UInt128)
        new(PriceLevels(max_price, min_price), UInt128(0))
    end
end

function limitorder!(ob::OrderBook, side::Bool, price::UInt128,
                     size::UInt128, trader_id::UInt128)                                          
    # After Matching, just input the limit order
    ob.order_id = ob.order_id + 1
    order = LimitOrder(price, size, trader_id, side, ob.order_id)

    # Input order
    insert_order!(ob.price_levels, order)


    return 0, ob.order_id
end

function marketorder!(ob::OrderBook, side::Bool, size::UInt128,
                     trader_id::UInt128)


    return 0
end

function cancel!(ob::OrderBook, order_id::UInt128)::Bool

    return true
end

function update!(ob::OrderBook, order_id::UInt128, size::UInt128)::Bool

    return true
end

function best_bid(ob::OrderBook)::UInt128
    return ob.price_levels.bid
end

function best_bid_size(ob::OrderBook)::UInt128
    bid = best_bid(ob)
    return size(ob.price_levels.levels[bid])
end


function best_ask(ob::OrderBook)::UInt128
    return ob.price_levels.ask
end

function best_ask_size(ob::OrderBook)::UInt128
    ask = best_ask(ob)
    return size(ob.price_levels.levels[ask])
end
 7
