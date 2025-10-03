using Documenter
using DocumenterCitations
using Yunir

bib = CitationBibliography(joinpath(@__DIR__, "src", "refs.bib"))

makedocs(;
    sitename = "Yunir.jl",
    format = Documenter.HTML(
        assets = ["assets/favicon.ico","assets/citations.css"],
        repolink = "https://github.com/alstat/Yunir.jl"
    ),
    plugins=[bib],
    authors = "Al-Ahmadgaid B. Asaad",
    repo = Remotes.GitHub("alstat", "Yunir.jl"),
    remotes = nothing,
    modules = [Yunir],
    pages = [
        "Home" => "index.md",
        "Basic Utilities" => "man/basic_utilities.md",
        "Orthographical Analysis" => "man/orthography.md",
        "Text Alignment" => "man/text_alignment.md",
        "Rhytmic Analysis" => "man/rhythmic_analysis.md",
        "Symmetry Analysis" => "man/symmetry_analysis.md",
        "References" => "man/references.md",
        "API" => "man/api.md",
    ]
)

# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.
deploydocs(
    repo = "github.com/alstat/Yunir.jl.git",
    devbranch = "main",
    target = "build"
)