"""
	Harakaat(char::Union{String, Char}, is_tanween::Bool)

Create a `Harakaat` object using `char` as the Arabic orthography, which is expected to be the 
short vowels, sukūn, and tanween.

```julia-repl
julia> fatha = arabic("a")
julia> Harakaat(fatha, false)
Harakaat("َ", false)
```
"""
struct Harakaat
	char::Union{String, Char}
	is_tanween::Bool
end

const AR_VOWELS = [
	Harakaat(Char(0x064B) |> string, true),
	Harakaat(Char(0x064C) |> string, true),
	Harakaat(Char(0x064D) |> string, true),
	Harakaat(Char(0x064E) |> string, false),
	Harakaat(Char(0x064F) |> string, false),
	Harakaat(Char(0x0650) |> string, false),
]

function Base.string(x::Harakaat)
	Harakaat(string(x.char), x.is_tanween)
end

Yunir.encode(x::Harakaat) = Harakaat(encode(string(x.char)), x.is_tanween)
Yunir.arabic(x::Harakaat) = Harakaat(arabic(string(x.char)), x.is_tanween)


"""
	Segment(text::String, harakaat::Array{Harakaat})

Create a `Segment` object from `text`, which is the form of the segments of syllables, 
where vowels of which are also listed as `harakaat`.

```julia-repl
julia> bw_segment = "~aH?Hiy"
julia> Segment(bw_segment, Harakaat[Harakaat("a", false), Harakaat("i", false)])
Segment("~aH?Hiy", Harakaat[Harakaat("a", false), Harakaat("i", false)])
```
"""
struct Segment
	segment::String
	harakaat::Array{Harakaat}
end

Yunir.encode(x::Segment) = Segment(encode(x.segment), encode.(x.harakaat))
Yunir.arabic(x::Segment) = Segment(arabic(x.segment), encode.(x.harakaat))

Base.occursin(x::String, y::Harakaat) = occursin(x, y.char)

function Base.broadcasted(::typeof(in), s::AbstractString, mss::Vector{Harakaat})
	return [occursin(s, ms) for ms ∈ mss]
end

const BW_VOWELS = encode.(AR_VOWELS)

"""
	Syllable{T <: Number}(
	    lead_nchars::T,
	    trail_nchars::T,
	    nvowels::T
    )

Create a `Syllable` object specifying the number of vowels `nvowels` to capture, and 
also the number of leading (`lead_nchars`) and trailing characters (`trail_nchars`) 
around the vowel. This object is used as an input for the `Rhyme` object.

The following code creates a `Syllable`, which specifies 3 syllables with 1 leading and trailing characters to include.

```julia-repl
julia> Syllable(1, 1, 3)
Syllable{Int64}(1, 1, 3)
```
"""
struct Syllable{T <: Number}
	lead_nchars::T
	trail_nchars::T
	nvowels::T
end

"""
	Rhyme(is_quran::Bool, last_syllable::Syllable)

Create a `Rhyme` object with specifics for the `last_syllable` contructed through `Syllable`. 
It also takes argument for `is_quran` to handle Qur'an input, which does not recite the last vowel in every last word of the verse.

The following code creates a `Syllable`, which specifies 3 syllables with 1 leading and trailing characters to include.

```julia-repl
julia> ar_raheem_alamiyn = ["ٱلرَّحِيمِ", "ٱلْعَٰلَمِينَ"]
2-element Vector{String}:
 "ٱلرَّحِيمِ"
 "ٱلْعَٰلَمِينَ"

julia> r = Rhyme(true, Syllable(1, 1, 3))
Rhyme(true, Syllable{Int64}(1, 1, 3))

julia> output = r.(ar_raheem_alamiyn, true)
2-element Vector{Segment}:
 Segment("َّح?حِي", Harakaat[Harakaat("َ", false), Harakaat("ِ", false)])
 Segment("عَٰ?لَم?مِي", Harakaat[Harakaat("َ", false), Harakaat("َ", false), Harakaat("ِ", false)])

julia> encode.(output)
2-element Vector{Segment}:
 Segment("~aH?Hiy", Harakaat[Harakaat("a", false), Harakaat("i", false)])
 Segment("Ea`?lam?miy", Harakaat[Harakaat("a", false), Harakaat("a", false), Harakaat("i", false)])
```
"""
struct Rhyme
	is_quran::Bool
	last_syllable::Syllable
end

function count_vowels(text::String, isarabic::Bool=false)
    text = isarabic ? encode(text) : text
	jvowels = join([c.char for c in BW_VOWELS])
    return count(c -> c in jvowels, text)
end

function vowel_indices(text::String, isarabic::Bool=false)
    text = isarabic ? encode(text) : text
	jvowels = join([c.char for c in BW_VOWELS])
	return findall(c -> c in jvowels, text)
end

"""
	(r::Rhyme)(text::String, isarabic::Bool=false)

Call function for the `Rhyme` object. It extracts the rhyme features of `text` using the options
from the `Rhyme` object specified by `r`. It can handle both Arabic and Buckwalter input by toggling `isarabic`.

```julia-repl
julia> ar_raheem = "ٱلرَّحِيمِ"
"ٱلرَّحِيمِ"

julia> r = Rhyme(true, Syllable(1, 2, 1))
Rhyme(true, Syllable{Int64}(1, 2, 1))

julia> output = r(ar_raheem, true)
Segment("حِيم", Harakaat[Harakaat("ِ", false)])

julia> encode(output)
Segment("Hiym", Harakaat[Harakaat("i", false)])
```
"""
function (r::Rhyme)(text::String, isarabic::Bool=false)
    text = isarabic ? encode(text) : text

	vowel_idcs = vowel_indices(text, isarabic)
	harakaat = Harakaat[]
	segment_text = ""

	if r.is_quran
		cond = string(text[end]) .∈ BW_VOWELS
		silent_vowel = sum(cond)
		penalty = sum(cond) < 1 ? 1 : 0
	end

	uplimit = r.last_syllable.nvowels > (count_vowels(text, isarabic) - silent_vowel) ? (count_vowels(text, isarabic) - silent_vowel) : r.last_syllable.nvowels
	for i in 0:uplimit-silent_vowel-penalty
		vowel_idx = vowel_idcs[end-i-silent_vowel]
		cond = string(text[vowel_idx]) .∈ BW_VOWELS
		if sum(cond) > 0
			push!(harakaat, isarabic ? arabic(BW_VOWELS[cond][1]) : BW_VOWELS[cond][1])

			lead_length = length(text[1:(vowel_idx-1)])
			trail_length = length(text[(vowel_idx+1):end])

			lead_nchars_lwlimit = lead_length > r.last_syllable.lead_nchars ? r.last_syllable.lead_nchars : lead_length
			trail_nchars_uplimit = trail_length > r.last_syllable.trail_nchars ? r.last_syllable.trail_nchars : trail_length
			vowel = text[vowel_idx]

			lead_text = text[(vowel_idx-lead_nchars_lwlimit):(vowel_idx-1)]
			trail_text = text[(vowel_idx+1):(vowel_idx+trail_nchars_uplimit)]

			if i == 0
				segment_text = lead_text * vowel * trail_text
			else
				segment_text = lead_text * vowel * trail_text * "?" * segment_text
			end
		else
			continue
		end
	end
    if isarabic
        return Segment(arabic(segment_text), reverse(harakaat))
	else
        return Segment(segment_text, reverse(harakaat))
    end
end