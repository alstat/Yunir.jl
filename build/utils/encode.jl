"""
    encode(s::Union{Char,String}, encoder::AbstractEncoder)

Transliterate the input `String` object using a custom `encoder`. Custom `encoder` is
generated using the `@transliterator`.
"""
function encode(s::Union{Char,String}, encoder::AbstractEncoder)
    for k in collect(keys(encoder.encode))
        s = replace(s, string(k) => string(encoder.encode[k]))
    end
    return s
end

"""
    encode(s::String)

Transliterate the input `String` object using `Buckwalter`.

# Examples
```julia-repl
julia> ar_basmala = "بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ"
julia> encode(ar_basmala)
"bisomi {ll~ahi {lr~aHoma`ni {lr~aHiymi"
```
"""
function encode(s::String)
    trans = Transliterator()
    return encode(s, trans)
end