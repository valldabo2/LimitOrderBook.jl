include("order.jl")
include("pricelevel.jl")

tic
for i in 1:1000
    LimitOrder(0,0,0,0)
end
toc
