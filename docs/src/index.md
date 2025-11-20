# Welcome to Yunir.jl Documentation
[![codecov](https://codecov.io/gh/alstat/Yunir.jl/branch/main/graph/badge.svg?token=lKsVEpMDca)](https://codecov.io/gh/alstat/Yunir.jl)
[![MIT License](https://img.shields.io/badge/license-MIT-green.svg)](https://github.com/alstat/Yunir.jl/blob/master/LICENSE)
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.6629868.svg)](https://doi.org/10.5281/zenodo.6629868)

Yunir.jl is a toolkit for Arabic Natural Language Processing (ANLP). It offers APIs for the building blocks of ANLP specifically _dediacritization_, _normalization_, _transliteration_ (including _custom transliteration_), _simple encoding_, and _orthographical analysis_. It also has advanced capabilities for doing _text alignment_, _rhythmic analysis_ and _textual symmetry analysis_. Lastly, it supports [QuranTree.jl](https://alstat.github.io/QuranTree.jl/stable/).

Yunir (ينير) /yunīr/ is the Arabic word for "illuminate." The logo is a Kufic calligraphy of the Arabic word نور /nūr/ or "light," specifically, a heatless light such as that of the light of the moon.
## Installation
To install the package, run the following:
```julia
julia> using Pkg
julia> Pkg.add("Yunir")
```
## Citation
```
@software{al_ahmadgaid_b_asaad_2022_6629868,
  author       = {Al-Ahmadgaid B. Asaad},
  title        = {{Yunir.jl: A lightweight Arabic NLP toolkit for 
                   Julia}},
  month        = jun,
  year         = 2022,
  publisher    = {Zenodo},
  version      = {v0.2.0},
  doi          = {10.5281/zenodo.6629868},
  url          = {https://doi.org/10.5281/zenodo.6629868}
}
```