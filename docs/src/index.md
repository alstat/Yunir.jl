# Welcome to Yunir.jl Documentation
Yunir.jl is a light suite for Arabic Natural Language Processing (ANLP). It offers APIs for the building blocks of ANLP specifically _dediacritization_, _normalization_, _transliteration_ (including _custom transliteration_), _simple encoding_, and _orthographical analysis_.

Yunir (ينير) /yunīr/ is the Arabic word for "illuminate." The logo is a Kufi calligraphy of the Arabic word نور /nūr/ or "light," specifically, a heatless light such as that of the light of the moon.
## Installation
To install the package, run the following:
```julia
julia> using Pkg
julia> Pkg.add("Yunir")
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