using Documenter
using Yunir

makedocs(
    sitename = "Yunir.jl",
    format = Documenter.HTML(
        assets = ["assets/favicon.ico"]
    ),
    authors = "Al-Ahmadgaid B. Asaad",
    modules = [Yunir],
    pages = [
        "Home" => "index.md",
        "Basic Utilities" => "man/basic_utilities.md",
        "Orthographical Analysis" => "man/orthography.md",
        "Working with QuranTree.jl" => "man/qurantree.md",
        "API" => "man/api.md",
        # "Arabic Grammar" => [
        #     "Introduction" => "book/introduction.md",
        #     "Ch1. Structure" => "book/structure.md",
        #     "Ch2. Verb" => "book/verb.md"
        # ]
    ]
)

# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.
deploydocs(
    repo = "github.com/alstat/Yunir.jl.git"
)