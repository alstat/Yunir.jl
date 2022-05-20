"""
    dediac(s::String)

Dediacritize the input `String` object.

# Examples
```julia-repl
julia> bw_basmala = "bisomi {ll~ahi {lr~aHoma`ni {lr~aHiymi"
julia> dediac(bw_basmala)
"bsm {llh {lrHmn {lrHym"
julia> dediac(arabic(bw_basmala))
"بسم ٱلله ٱلرحمن ٱلرحيم"
```
"""
function dediac(s::String)
    trans = Transliterator()
    isarabic = in(Symbol(s[1]), collect(keys(trans.encode))) ? true : false
    return !isarabic ? replace(s, trans.rx_diacs => s"") : 
        replace(s, trans.rx_ardiacs => s"")
end