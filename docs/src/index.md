# Welcome to Nur.jl Documentation
Nur.jl is a light suite for Arabic Natural Language Processing (ANLP). It offers APIs for the building blocks of ANLP specifically _dediacritization_, _normalization_, _transliteration_ (including _custom transliteration_), _simple encoding_, and _orthographical analysis_.

Nur (سلام) /səˈläm/ is the Arabic word for "peace," a common greeting among Arabic-speaking countries and among non-Arabic-speaking Muslims around the world.
## Installation
To install the package, run the following:
```julia
julia> using Pkg
julia> Pkg.add("Nur")
```
## Outline
```@contents
Pages = [
    "man/basic_utilities.md",
    "man/orthography.md",
    "man/qurantree.md",
    "man/api.md",
]
Depth = 2
```