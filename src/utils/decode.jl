"""
    arabic(s::String[, encoder::AbstractEncoder])

Encode the `String` object into Arabic characters. Custom `encoder`
generated from `@transliterator` can be provided, but default is `Buckwalter`.

# Examples
```julia-repl
julia> bw_basmala = "bisomi {ll~ahi {lr~aHoma`ni {lr~aHiymi"
julia> arabic(bw_basmala)
"بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ"
```
"""
function arabic(s::String)
    trans = Transliterator()
    return arabic(s, trans)
end

function arabic(s::String, encoder::AbstractEncoder)
    for k in collect(keys(encoder.decode))
        s = replace(s, string(k) => string(encoder.decode[k]))
    end
    return s
end