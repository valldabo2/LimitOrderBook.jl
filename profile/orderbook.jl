using LimitOrderBook
using Profile
using Printf
using DataStructures

function generate_orderbook(max_price)
    ob = OrderBook(UInt128(max_price), UInt128(1))
end

#Profile.clear()
#@profile generate_orderbook(UInt128(100000))
#Profile.print(format=:flat)

for max_price in [1e2, 1e6, 1e9]
    @printf "Creates orderbook with max price:%.0E \n" max_price
    @time generate_orderbook(max_price)
end


function send_passive_limit_orders(iterations)
    max_price = UInt128(100000)
    min_price = UInt128(1)
    ob = OrderBook(max_price, min_price)
    t = time() 
    for i in 1:iterations
        for price in min_price + 1:max_price - 1
            limitorder!(ob, BUY, price, UInt128(1), UInt128(1))
        end
    end
    @printf "Passive limit orders per second:%.2E \n" (iterations*max_price)/(time() - t) 
end

println("1 iterations")
@time send_passive_limit_orders(1)


println("10 iterations")
@time send_passive_limit_orders(10)

#Profile.clear()
#@profile send_passive_limit_orders()
#Profile.print(format=:flat)

function cancel_orders(iterations)
    max_price = UInt128(100000)
    min_price = UInt128(1)
    ob = OrderBook(max_price, min_price)
    order_ids = Deque{UInt128}()
    for i in 1:iterations
        for price in min_price + 1:max_price - 1
            trades, order_id = limitorder!(ob, BUY, price, UInt128(1), UInt128(1))
            push!(order_ids, order_id)
        end
    end

    n_orders = order_ids.len
    t = time()
    for order_id in order_ids
        cancel!(ob, order_id)
    end
    @printf "Canceled %.0E orders per second \n" n_orders/(time() - t)
    
end

println("Cancels orders: 1 iteration")
@time cancel_orders(1)

println("Cancels orders: 10 iteration")
@time cancel_orders(10)

function match_orders(iterations)
    max_price = UInt128(100000)
    min_price = UInt128(1)
    ob = OrderBook(max_price, min_price)
    order_ids = Deque{UInt128}()
    size = UInt128(1)
    n_orders = UInt128(1)
    for i in 1:iterations
        for price in min_price + 1:max_price - 1
            trades, order_id = limitorder!(ob, BUY, price, size, UInt128(1))
            n_orders = n_orders + 1
        end
    end

    # starts selling
    t = time()
    for i in 1:n_orders - 2
        limitorder!(ob, SELL, min_price, size, UInt128(1))
    end
    @printf "Matched %.3E orders per second \n" n_orders/(time() - t)
end

println("Matches orders: 1 iteration")
@time match_orders(1)

println("Matches orders: 10 iteration")
@time match_orders(10)

function match_large_order(iterations)
    max_price = UInt128(100000)
    min_price = UInt128(1)
    ob = OrderBook(max_price, min_price)
    order_ids = Deque{UInt128}()
    size = UInt128(1)
    n_orders = UInt128(1)
    for i in 1:iterations
        for price in min_price + 1:max_price - 1
            trades, order_id = limitorder!(ob, BUY, price, size, UInt128(1))
            n_orders = n_orders + 1
        end
    end
    t = time()
    limitorder!(ob, SELL, min_price, size*(n_orders - 2), UInt128(1))
    @printf "Matched %.0E orders per second with one order \n" n_orders/(time() - t)
end


println("Matches orders with one large order: 1 iteration")
@time match_large_order(1)


println("Matches orders with one large order: 10 iteration")
@time match_large_order(10)

