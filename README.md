# Yunir.jl <img src="docs/src/assets/logo.png" align="right" width="100"/>
[![CI](https://github.com/alstat/Yunir.jl/actions/workflows/ci.yml/badge.svg)](https://github.com/alstat/Yunir.jl/actions/workflows/ci.yml)
[![codecov](https://codecov.io/gh/alstat/Yunir.jl/branch/main/graph/badge.svg?token=lKsVEpMDca)](https://codecov.io/gh/alstat/Yunir.jl)
[![](https://img.shields.io/badge/docs-dev-blue.svg)](https://alstat.github.io/Yunir.jl/dev/)
[![MIT License](https://img.shields.io/badge/license-MIT-green.svg)](https://github.com/alstat/Yunir.jl/blob/master/LICENSE)

Yunir.jl is a light suite for Arabic Natural Language Processing (ANLP). It offers APIs for the building blocks of ANLP specifically _dediacritization_, _normalization_, _transliteration_ (including _custom transliteration_), _simple encoding_, and _orthographical analysis_.

Yunir (ينير) /yunīr/ is the Arabic word for "illuminate" or "enlighten." The logo is a Kufi calligraphy of the Arabic word نور /nūr/ or "light," that is, a heatless light such as that of the light of the moon.
## Installation
To install the package run the following:
```julia
julia> using Pkg
julia> Pkg.add("Yunir")
```