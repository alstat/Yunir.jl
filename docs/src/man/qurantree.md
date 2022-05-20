Working with QuranTree.jl
========
Yunir.jl can seemlessly work with [QuranTree.jl](https://alstat.github.io/QuranTree.jl/dev/).
```@setup abc
using Pkg
Pkg.add("QuranTree")
```
```@repl abc
using Yunir
using QuranTree

data = QuranData();
crps, tnzl = load(data);
crpsdata = table(crps)
tnzldata = table(tnzl)
Yunir.arabic(verses(crpsdata[114])[1])
```
!!! note "Note"
    You have to install QuranTree.jl to run the above example. To install, run
    ```julia
    using Pkg
    Pkg.add("QuranTree")
    ```
## Normalization
```@repl abc
ikhlas = crpsdata[114]
ikhlas_vrs = verses(ikhlas)
ikhlas_nrm = Yunir.normalize.(ikhlas_vrs)
Yunir.arabic.(ikhlas_nrm)
```
## Dediacritization
```@repl abc
ikhlas_ddc = Yunir.dediac.(ikhlas_vrs)
Yunir.arabic.(ikhlas_ddc)
```
## Transliteration
```@repl abc
ar_ikhlas = verses(tnzldata[114])
Yunir.encode.(ar_ikhlas)
```