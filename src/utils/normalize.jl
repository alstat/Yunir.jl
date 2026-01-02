"""
    normalize(s::String)

Normalize a Arabic or Buckwalter `String` characters.

# Examples
```julia-repl
julia> normalize("بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ")
"بِسْمِ اللَّهِ الرَّحْمَانِ الرَّحِيمِ"
```
"""
function normalize(s::Union{Ar,Bw}, char_mapping::Dict=DEFAULT_NORMALIZER)
    x = s isa Ar ? s.text : arabic(s).text
    if x == string(Char(0xFDFA)[1])
        return Ar("صلى الله عليه وسلم")
    elseif x == string(Char(0xFDFB)[1])
        return Ar("جل جلاله")
    elseif x == string(Char(0xFDFD)[1])
        return Ar("بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ")
    else
        for k in collect(keys(char_mapping))
            x = replace(x, string(k) => string(char_mapping[k]))
        end
    end
    return s isa Ar ? Ar(x) : encode(Ar(x))
end

function normalize(astr::Vector{Union{Ar,Bw}}, char_mapping::Dict=DEFAULT_NORMALIZER)
    out = String[]
    for s in astr
        push!(out, normalize(s, char_mapping))
    end
    return out
end

# "بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ" === "بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ"

"""
    normalize(s::String, chars::Vector{Symbol}; isarabic::Bool=true)

Normalize a specific Arabic or Buckwalter `String` character/s (`chars`).

# Examples
```julia-repl
julia> ar_basmala = "بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ"
julia> normalize(ar_basmala, [:alif_khanjareeya, :hamzat_wasl]) === "بِسْمِ اللَّهِ الرَّحْمَانِ الرَّحِيمِ"
```
"""
function normalize(s::Union{Ar,Bw}, chars::Vector{Symbol})
    s = s isa Ar ? s : arabic(s)
    for char in chars
        s = normalize(s, char)        
    end
    return s isa Ar ? s : encode(s)
end

"""
    normalize(s::String, char::Symbol; isarabic::Bool=true)

Normalize a specific Arabic or Buckwalter `String` character (`chars`).

# Examples
```julia-repl
julia> ar_basmala = "بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ"
julia> normalize(ar_basmala, :alif_khanjareeya) === "بِسْمِ ٱللَّهِ ٱلرَّحْمَانِ ٱلرَّحِيمِ"
```
"""
function normalize(s::Union{Ar,Bw}, char::Symbol)
    x = s isa Ar ? s.text : arabic(s).text
    if char === :tatweel
        word = replace(x, string(Char(0x0640)[1]) => "")
    elseif char === :alif_maddah
        word = replace(x, string(Char(0x0622)[1]) => string(Char(0x0627)))
        word = replace(word, string(Char(0x0653)[1]) => "")
    elseif char === :alif_hamza_above
        word = replace(x, string(Char(0x0623)[1]) => string(Char(0x0627)))
    elseif char === :alif_khanjareeya
        word = replace(x, string(Char(0x0670)[1]) => string(Char(0x0627)))
    elseif char === :hamzat_wasl
        word = replace(x, string(Char(0x0671)[1]) => string(Char(0x0627)))
    elseif char === :alif_hamza_below
        word = replace(x, string(Char(0x0625)[1]) => string(Char(0x0627)))
    elseif char === :waw_hamza_above
        word = replace(x, string(Char(0x0624)[1]) => string(Char(0x0648)))
    elseif char === :ya_hamza_above
        word = replace(x, string(Char(0x0626)[1]) => string(Char(0x064A)))
    elseif char === :alif_maksura
        word = replace(x, string(Char(0x0649)[1]) => string(Char(0x064A)))
    elseif char === :ta_marbuta
        word = replace(x, string(Char(0x0629)[1]) => string(Char(0x0647)))
    elseif char === :SAW
        word = replace(x, string(Char(0xFDFA)[1]) => "صلى الله عليه وسلم")
    elseif char === :jalla_jalalu
        word = replace(x, string(Char(0xFDFB)[1]) => "جل جلاله")
    elseif char === :basmala
        word = replace(x, string(Char(0xFDFD)[1]) => "بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ")
    else
        throw(DomainError(char, "Character not found"))
    end
    return s isa Ar ? Ar(word) : encode(Ar(word))
end