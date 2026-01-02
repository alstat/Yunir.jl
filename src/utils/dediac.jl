"""
    dediac(s::String; isarabic::Bool=true)

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
function dediac(s::Union{Ar,Bw})
    trans = Transliterator()
    return s isa Bw ? Bw(replace(s.text, trans.rx_diacs => s"")) : 
        Ar(replace(s.text, trans.rx_ardiacs => s""))
end