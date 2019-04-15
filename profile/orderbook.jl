using LimitOrderBook: OrderBook, limitorder!, BUY
using Profile


function generate_orderbook(max_price)
    ob = OrderBook(max_price, UInt128(1))
end

#Profile.clear()
#@profile generate_orderbook(UInt128(100000))
#Profile.print(format=:flat)

function send_passive_limit_orders()
    max_price = UInt128(100000)
    min_price = UInt128(1)
    ob = OrderBook(max_price, min_price)
    iterations = 2
    t = time() 
    for i in 1:iterations
        for price in min_price + 1:max_price - 1
            limitorder!(ob, BUY, price, UInt128(1), UInt128(1))
        end
    end
    println("Passive limit orders per second")
    println( (iterations*max_price) / (time() - t) )
end

send_passive_limit_orders()

#Profile.clear()
#@profile send_passive_limit_orders()
#Profile.print(format=:flat)
