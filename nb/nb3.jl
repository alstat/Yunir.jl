using Yunir
using QuranTree

const AR_LONG_VOWELS = [
	Char(0x064A) |> string,
	Char(0x0648) |> string,
	Char(0x0627) |> string,
	Char(0x0670) |> string
]

const BW_LONG_VOWELS = encode.(AR_LONG_VOWELS)

function Base.broadcasted(::typeof(in), s::AbstractString, mss::Vector{Harakaat})
	return [occursin(s, ms) for ms ∈ mss]
end

const BW_VOWELS = encode.(AR_VOWELS)

struct Rhyme2
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

i = 0
isarabic = true
silent_vowel = true

function (r::Rhyme2)(text::String; isarabic::Bool=false, first_word::Bool=false, silent_last_vowel::Bool=false)
    text = isarabic ? encode(text) : text
	
	vowel_idcs = vowel_indices(text, isarabic)
	harakaat = Harakaat[]
	segment_text = ""

	if silent_last_vowel
		cond = string(text[end]) .∈ BW_VOWELS
		is_silent = sum(cond)
		penalty = is_silent < 1 ? 1 : 0
	else 
		is_silent = 0
		penalty = 1
	end

	uplimit = r.last_syllable.nvowels > (count_vowels(text, isarabic) - is_silent) ? (count_vowels(text, isarabic) - is_silent) : r.last_syllable.nvowels
	for i in 0:(uplimit-is_silent-penalty)
		vowel_idx = vowel_idcs[end-i-is_silent]
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

			if first_word && vowel_idx == vowel_idcs[1]
				if text[1:2] == "{l"
					first_word_text = "{l?" 
					first_word_harakaat = filter(x -> x.char == "a", BW_VOWELS)[1]
					push!(harakaat, isarabic ? arabic(first_word_harakaat) : first_word_harakaat)
				else 
					first_word_text = ""
				end
			else
				first_word_text = ""
			end

			if (text[vowel_idx-lead_nchars_lwlimit] == '~')
				lead_candidate1 = text[vowel_idx-lead_nchars_lwlimit-1]
				lead_text = lead_candidate1 * lead_text
			end

			if (vowel_idx+trail_nchars_uplimit+1 <= length(text))
				trail_candidate1 = text[vowel_idx+trail_nchars_uplimit+1]
				lvowel_cond = trail_candidate1 .∈ BW_LONG_VOWELS
				if (vowel_idx+trail_nchars_uplimit+2 <= length(text))
					trail_candidate2 = text[vowel_idx+trail_nchars_uplimit+2]
					# trail candidate is a long vowel
					if sum(lvowel_cond) > 0 && trail_candidate2 != 'o'
						if silent_last_vowel
							trail_text *= trail_candidate1 * trail_candidate2
						else
							trail_text *= trail_candidate1
						end
					# trail candidate is a long vowel but with sukuun, so just a silent consonant
					elseif sum(lvowel_cond) > 0 && trail_candidate2 == 'o'
						trail_text *= trail_candidate1
					# trail candidate is a consonant with sukuun
					elseif sum(lvowel_cond) == 0 && sum(string(trail_candidate1) .∈ BW_VOWELS) == 0 && trail_candidate2 == 'o'
						trail_text *= trail_candidate1
					end		
				end
			end

			if i == 0
				segment_text = first_word_text * lead_text * vowel * trail_text
			else
				segment_text = first_word_text * lead_text * vowel * trail_text * "?" * segment_text
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

# texts = String[]
# for text in bw_texts[1]
# 	push!(texts, split(text, " "))
# end


texts = string.(split(bw_texts[5]))
arabic.(texts)
arabic.(texts)
text = texts[2]
r = Rhyme2(true, Syllable(1, 0, 5))
segments = r(encode(texts[2]), isarabic=false, first_word=false, silent_last_vowel=true)
segments = Segment[]
j = 1
for i in texts
	if j == 1
		push!(segments, r(encode(i), isarabic=false, first_word=true, silent_last_vowel=false))
	elseif j == length(texts)
		push!(segments, r(encode(i), isarabic=false, first_word=false, silent_last_vowel=true))
	else
		push!(segments, r(encode(i), isarabic=false, first_word=false, silent_last_vowel=false))
	end
	j += 1
end

segments
encode.(texts)
segments
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
