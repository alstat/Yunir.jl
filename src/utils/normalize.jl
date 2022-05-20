function normalize(c::Char, isarabic::Bool, encoder::AbstractEncoder)
    ch = isarabic ? Symbol(c) : encoder.decode[Symbol(c)]
    if !isarabic
        return string(encoder.encode[SP_DEDIAC_MAPPING[ch]])
    else
        return string(SP_DEDIAC_MAPPING[ch])
    end
end

"""
    normalize(s::String)

Normalize a Arabic or Buckwalter `String` characters.

# Examples
```julia-repl
julia> normalize("بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ")
"بِسْمِ اللَّهِ الرَّحْمَانِ الرَّحِيمِ"
```
"""
function normalize(s::String)
    trans = Transliterator()
    if !in(Symbol(s[1]), collect(keys(trans.encode)))
        if in(Symbol(s[1]), SP_DEDIAC_KEYS)
            isarabic = true
        else
            isarabic = false  
        end
    else
        isarabic = true
    end

    word = ""
    for c in s
        if c === ' '
            word *= " "
            continue
        end
        isnormalize = !isarabic ? in(trans.decode[Symbol(c)], SP_DEDIAC_KEYS) : in(Symbol(c), SP_DEDIAC_KEYS)
        if isnormalize
            word *= normalize(c, isarabic, trans)
        else
            word *= c
        end
    end
    
    word = normalize(word, :tatweel)
    return word
end

"""
    normalize(s::String, chars::Array{Symbol,1})

Normalize a specific Arabic or Buckwalter `String` character/s (`chars`).

# Examples
```julia-repl
julia> ar_basmala = "بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ"
julia> normalize(ar_basmala, [:alif_khanjareeya, :hamzat_wasl]) === "بِسْمِ اللَّهِ الرَّحْمَانِ الرَّحِيمِ"
```
"""
function normalize(s::String, chars::Array{Symbol,1})
    for char in chars
        s = normalize(s, char)        
    end
    return s
end

"""
    normalize(s::String, char::Symbol)

Normalize a specific Arabic or Buckwalter `String` character (`chars`).

# Examples
```julia-repl
julia> ar_basmala = "بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ"
julia> normalize(ar_basmala, :alif_khanjareeya) === "بِسْمِ ٱللَّهِ ٱلرَّحْمَانِ ٱلرَّحِيمِ"
```
"""
function normalize(s::String, char::Symbol)
    trans = Transliterator()
    isarabic = in(Symbol(s[1]), collect(keys(trans.encode))) ? true : false

    s = isarabic ? s : arabic(s)
    if char === :tatweel
        word = replace(s, string(Char(0x0640)[1]) => "")
    elseif char === :alif_maddah
        word = replace(s, string(Char(0x0622)[1]) => string(Char(0x0627)))
        word = replace(word, string(Char(0x0653)[1]) => "")
    elseif char === :alif_hamza_above
        word = replace(s, string(Char(0x0623)[1]) => string(Char(0x0627)))
    elseif char === :alif_khanjareeya
        word = replace(s, string(Char(0x0670)[1]) => string(Char(0x0627)))
    elseif char === :hamzat_wasl
        word = replace(s, string(Char(0x0671)[1]) => string(Char(0x0627)))
    elseif char === :alif_hamza_below
        word = replace(s, string(Char(0x0625)[1]) => string(Char(0x0627)))
    elseif char === :waw_hamza_above
        word = replace(s, string(Char(0x0624)[1]) => string(Char(0x0648)))
    elseif char === :ya_hamza_above
        word = replace(s, string(Char(0x0626)[1]) => string(Char(0x064A)))
    elseif char === :alif_maksura
        word = replace(s, string(Char(0x0649)[1]) => string(Char(0x064A)))
    elseif char === :ta_marbuta
        word = replace(s, string(Char(0x0629)[1]) => string(Char(0x0647)))
    elseif char === :SAW
        word = replace(s, string(Char(0xFDFA)[1]) => "صلى الله عليه وسلم")
    elseif char === :jalla_jalalu
        word = replace(s, string(Char(0xFDFB)[1]) => "جل جلاله")
    elseif char === :basmala
        word = replace(s, string(Char(0xFDFD)[1]) => "بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ")
    else
        throw(DomainError(char, "Character not found"))
    end
    return isarabic ? word : encode(word)
end