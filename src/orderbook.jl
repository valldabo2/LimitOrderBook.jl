import DataStructures: Deque

mutable struct OrderBook
    price_levels::PriceLevels
    order_id::UInt128 # Does it need to be this big?
    orders::Dict{UInt128, LimitOrder}

    function OrderBook(max_price::UInt128, min_price::UInt128)::OrderBook
        new(PriceLevels(max_price, min_price), UInt128(0), Dict{UInt128, LimitOrder}())
    end
end

function limitorder!(ob::OrderBook, side::Bool, price::UInt128,
                     size::UInt128, trader_id::UInt128)::Tuple{Deque{LimitOrder}, UInt128}                                          
    # Init trades
    trades = Deque{LimitOrder}()

    # Matching
    if side == BUY
        ask = best_ask(ob)
        while (price >= ask) & (size > 0)
            price_level = get_level(ob.price_levels, ask)
            trades, size = match!(price_level, size, trades)
            if price_level.size == 0
                ask = update_ask!(ob.price_levels)
            end
        end
    # Matches a sell order to buy orders
    else
        bid = best_bid(ob)
        while (price <= bid) & (size > 0)
            price_level = get_level(ob.price_levels, bid)
            trades, size = match!(price_level, size, trades)
            if price_level.size == 0
                bid = update_bid!(ob.price_levels)
            end
        end
    end

    if size > 0
        # After Matching, just input the limit order
        ob.order_id = ob.order_id + 1
        order = LimitOrder(price, size, trader_id, side, ob.order_id)
        ob.orders[ob.order_id] = order

        # Input order
        insert_order!(ob.price_levels, order)

        return trades, ob.order_id
    else
        return trades, UInt128(0)
    end
end

function marketorder!(ob::OrderBook, side::Bool, size::UInt128,
                     trader_id::UInt128)


    return 0
end

function cancel!(ob::OrderBook, order_id::UInt128)

    @assert order_id in keys(ob.orders) "order_id not in orderbook"

    order = pop!(ob.orders, order_id)
    price_level = get_level(ob.price_levels, order.price)
    remove!(price_level, order_id)

    if (order.price == best_bid(ob)) & (size(price_level) == 0)
        update_bid!(ob.price_levels)
    elseif (order.price == best_ask(ob)) & (size(price_level) == 0)
        update_ask!(ob.price_levels)
    end
end

function update!(ob::OrderBook, order_id::UInt128, size::UInt128)
    order = ob.orders[order_id]
    diff = size - order.size
    order.size = size
    pl = get_level(ob.price_levels, order.price)
    pl.size = pl.size + diff
end

function best_bid(ob::OrderBook)::UInt128
    return ob.price_levels.bid
end

function best_bid_size(ob::OrderBook)::UInt128
    bid = best_bid(ob)
    return size(get_level(ob.price_levels, bid))
end


function best_ask(ob::OrderBook)::UInt128
    return ob.price_levels.ask
end

function best_ask_size(ob::OrderBook)::UInt128
    ask = best_ask(ob)
    return size(get_level(ob.price_levels, ask))
end

