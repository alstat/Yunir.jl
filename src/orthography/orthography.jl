abstract type AbstractCharacter end
abstract type AbstractDiacritic <: AbstractCharacter end
abstract type AbstractConsonant <: AbstractCharacter end
abstract type AbstractSolar <: AbstractConsonant end
abstract type AbstractLunar <: AbstractConsonant end
abstract type AbstractVowel <: AbstractDiacritic end
abstract type AbstractTanween <: AbstractDiacritic end
abstract type AbstractQuranPauseMark <: AbstractCharacter end
abstract type AbstractNumber <: AbstractCharacter end
abstract type AbstractArabicSymbol <: AbstractCharacter end

struct Tatweel end
struct Orthography
    data::Vector{Type}
end

struct Fatha <: AbstractVowel end
struct Fathatan <: AbstractTanween end
struct Damma <: AbstractVowel end
struct Dammatan <: AbstractTanween end
struct Kasra <: AbstractVowel end
struct Kasratan <: AbstractTanween end

struct Shadda <: AbstractDiacritic end
struct Sukun <: AbstractDiacritic end
struct Maddah <: AbstractDiacritic end 
struct HamzaAbove <: AbstractDiacritic end
struct AlifKhanjareeya <: AbstractDiacritic end

struct SmallHighSeen <: AbstractCharacter end
struct SmallHighRoundedZero <: AbstractCharacter end
struct SmallHighUprightRectangularZero <: AbstractCharacter end
struct SmallHighMeemIsolatedForm <: AbstractCharacter end
struct SmallLowSeen <: AbstractCharacter end
struct SmallWaw <: AbstractCharacter end
struct SmallYa <: AbstractCharacter end
struct SmallHighNoon <: AbstractCharacter end
struct EmptyCenterLowStop <: AbstractCharacter end
struct EmptyCenterHighStop <: AbstractCharacter end
struct RoundedHighStopWithFilledCenter <: AbstractCharacter end
struct SmallLowMeem <: AbstractCharacter end

macro consonant(name, parent, numeral, vocal)
    esc(quote
        struct $name <: $parent end
        vocals(::Type{$name}) = $vocal
        numerals(::Type{$name}) = $numeral
    end)
end

macro number(name)
    esc(quote
        struct $name <: AbstractNumber end
    end)
end

macro arsymbol(name)
    esc(quote
        struct $name <: AbstractArabicSymbol end
    end)
end

# for non-consonant with no vocal and numeral
vocals(x) = try vocals(x) catch nothing end
numerals(x) = try numerals(x) catch nothing end

vocals(x::Orthography) = vocals.(x.data)
numerals(x::Orthography) = numerals.(x.data)

@consonant Alif AbstractLunar 1 :soft
@consonant AlifMaksurah AbstractLunar 10 :soft
@consonant Ba AbstractLunar 2 :labial
@consonant Ta AbstractSolar 400 :palate
@consonant TaMarbuta AbstractSolar 5 :palate
@consonant Tha AbstractSolar 500 :gingival
@consonant Jeem AbstractLunar 3 :orifice
@consonant HHa AbstractLunar 8 :guttural
@consonant Kha AbstractLunar 600 :guttural
@consonant Dal AbstractSolar 4 :palate
@consonant Thal AbstractSolar 700 :gingival
@consonant Ra AbstractSolar 200 :liquid
@consonant Zain AbstractSolar 7 :sibilant
@consonant Seen AbstractSolar 60 :sibilant
@consonant Sheen AbstractSolar 300 :orifice
@consonant Sad AbstractSolar 90 :sibilant
@consonant DDad AbstractSolar 800 :orifice
@consonant TTa AbstractSolar 9 :palate
@consonant DTha AbstractSolar 900 :gingival
@consonant Ain AbstractLunar 70 :guttural
@consonant Ghain AbstractLunar 1000 :guttural
@consonant Fa AbstractLunar 80 :labial
@consonant Qaf AbstractLunar 100 :uvula
@consonant Kaf AbstractLunar 20 :uvula
@consonant Lam AbstractSolar 30 :liquid
@consonant Meem AbstractLunar 40 :labial
@consonant Noon AbstractSolar 50 :liquid
@consonant Waw AbstractLunar 6 :labial
@consonant Ha AbstractLunar 5 :guttural
@consonant Hamza AbstractLunar 1 :soft
@consonant Ya AbstractLunar 10 :soft
@consonant AlifMaddah AbstractLunar 1 :soft
@consonant AlifHamzaAbove AbstractLunar 1 :soft
@consonant AlifHamzaBelow AbstractLunar 1 :soft
@consonant AlifHamzatWasl AbstractLunar 1 :soft
@consonant WawHamzaAbove AbstractLunar 6 :soft
@consonant YaHamzaAbove AbstractLunar 10 :soft

@number Zero
@number One
@number Two
@number Three
@number Four
@number Five
@number Six
@number Seven
@number Eight
@number Nine

@arsymbol Comma
@arsymbol QuestionMark
@arsymbol Semicolon
@arsymbol DateSeparator

macro data(expr)
    return esc(Meta.parse(string(expr) * ".data"))
end

"""
    isfeat(x::Orthography, y::Type{<:AbstractConsonant})

checks if x is a y feature.
```julia-repl
julia> ar_basmala = "بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ";
julia> arb_token = tokenize(ar_basmala)
4-element Vector{String}:
 "بِسْمِ"
 "ٱللَّهِ"
 "ٱلرَّحْمَٰنِ"
 "ٱلرَّحِيمِ"
julia> arb_parsed2 = parse.(Orthography, arb_token)
4-element Vector{Orthography}:
 Orthography(Type[Ba, Kasra, Seen, Sukun, Meem, Kasra])
 Orthography(Type[AlifHamzatWasl, Lam, Lam, Shadda, Fatha, Ha, Kasra])
 Orthography(Type[AlifHamzatWasl, Lam, Ra, Shadda, Fatha, HHa, Sukun, Meem, Fatha, AlifKhanjareeya, Noon, Kasra])
 Orthography(Type[AlifHamzatWasl, Lam, Ra, Shadda, Fatha, HHa, Kasra, Ya, Meem, Kasra])
julia> isfeat(arb_parsed2[1], AbstractLunar)
6-element BitVector:
 1
 0
 0
 0
 1
 0
```
"""
function isfeat(x::Orthography, y::Type{<:AbstractConsonant})
    return x.data .<: y
end

function Base.getindex(x::Orthography, i::BitVector)
    return x.data[i]
end