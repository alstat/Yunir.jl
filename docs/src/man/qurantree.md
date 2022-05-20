Working with QuranTree.jl
========
Nur.jl can seemlessly work with [QuranTree.jl](https://alstat.github.io/QuranTree.jl/dev/).
```@setup abc
using Pkg
Pkg.add("QuranTree")
```
```@repl abc
using Nur
using QuranTree

data = QuranData();
crps, tnzl = load(data);
crpsdata = table(crps)
tnzldata = table(tnzl)
Nur.arabic(verses(crpsdata[114])[1])
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
ikhlas_nrm = Nur.normalize.(ikhlas_vrs)
Nur.arabic.(ikhlas_nrm)
```
## Dediacritization
```@repl abc
ikhlas_ddc = Nur.dediac.(ikhlas_vrs)
Nur.arabic.(ikhlas_ddc)
```
## Transliteration
```@repl abc
ar_ikhlas = verses(tnzldata[114])
Nur.encode.(ar_ikhlas)
```