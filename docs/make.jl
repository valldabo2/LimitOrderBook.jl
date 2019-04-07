using Documenter, LimitOrderBook

makedocs(modules = [LimitOrderBook], sitename = "LimitOrderBook.jl")

deploydocs(
    repo = "github.com/JuliaLang/LimitOrderBook.jl.git",
)
