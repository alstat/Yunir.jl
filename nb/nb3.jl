using Yunir
using QuranTree

struct Harakaat
	char::Union{String, Char}
	is_tanwin::Bool
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
	Harakaat(string(x.char), x.is_tanwin)
end

Yunir.encode(x::Harakaat) = Harakaat(encode(string(x.char)), x.is_tanwin)
Yunir.arabic(x::Harakaat) = Harakaat(arabic(string(x.char)), x.is_tanwin)

Yunir.encode(x::Segment) = Segment(encode(x.text), encode.(x.harakat))
Yunir.arabic(x::Segment) = Segment(arabic(x.text), encode.(x.harakat))
Base.occursin(x::String, y::Harakaat) = occursin(x, y.char)

function Base.broadcasted(::typeof(in), s::AbstractString, mss::Vector{Harakaat})
	return [occursin(s, ms) for ms ∈ mss]
end

const BW_VOWELS = encode.(AR_VOWELS)

struct Segment
	text::String
	harakat::Array{Harakaat}
end

struct Syllable{T <: Number}
	lead_nchars::T
	trail_nchars::T
	nvowels::T
end

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


crps, tnzl = load(QuranData());
crpstbl = table(crps)
tnzltbl = table(tnzl)
bw_texts = (verses(tnzltbl))

texts = String[]
for text in bw_texts
	push!(texts, split(text, " ")[end])
end
arabic.(texts)

r = Rhyme(true, Syllable(1, 1, 3))
segments = r.(encode.(texts), false)

Syllable(1, 1, 3)
segments = r.(texts, true)
segments
arabic.(segments)
[arabic(o.text) for o in out]

Harakaat(fatha, false)


ar_raheem = "ٱلرَّحِيمِ"
r = Rhyme(true, Syllable(1, 1, 2))
r.(ar_raheem, true)

bw_raheem = encode("ٱلرَّحِيمِ")
r = Rhyme(true, Syllable(1, 1, 2))
r.(bw_raheem, false)



ar_raheem_alamiyn = ["ٱلرَّحِيمِ", "ٱلْعَٰلَمِينَ"]
r = Rhyme(true, Syllable(1, 1, 3))
output = r.(ar_raheem_alamiyn, true)


ar_raheem_alamiyn = ["ٱلرَّحِيمِ", "ٱلْعَٰلَمِينَ"]
r = Rhyme(true, Syllable(1, 1, 2))
segments = encode.(r.(ar_raheem_alamiyn, true))
transition(segments, Segment)
transition(segments, Harakaat)
syllables, y_vec, y_dict = transition(segments, Harakaat)
using Makie
using CairoMakie
f = Figure(resolution=(500, 500));
a1 = Axis(f[1,1], 
    xlabel="Ayah Number",
    ylabel="Last Pronounced Syllable\n\n\n",
    title="Surah Al-Fatihah Rhythmic Patterns\n\n",
    yticks=(unique(y_vec), unique(syllables)), 
)
lines!(a1, collect(eachindex(syllables)), y_vec)
f
