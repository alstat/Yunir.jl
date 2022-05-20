function decode(c::Union{Char,String}, encoder::AbstractEncoder)
    return string(encoder.decode[Symbol(c)])
end

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
    words = ""
    for c in s
        if c === ' '
            words *= " "
        else
            words *= decode(c, encoder)
        end
    end
    return words
end