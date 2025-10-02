using Yunir
using Distributions
using CairoMakie
using QuranTree

crps, tnzl = load(QuranData());
crpstbl = table(crps)
tnzltbl = table(tnzl)
bw_texts = verses(tnzltbl)

texts = map(x -> string.(x), split.(bw_texts))
r = Syllabification(true, Syllable(1, 1, 10))

tajweed_timings = Dict{String,Int64}(
    "i" => 1, # kasra
    "a" => 1, # fatha
    "u" => 1, # damma
    "F" => 1, # fatha tanween
    "N" => 1, # damma tanween
    "K" => 1, # kasra tanween
    "iy" => 2, # kasra + yaa
    "aA" => 2, # fatha + alif
    "uw" => 2, # damma + waw
    "^" => 6 # maddah
)

all_segments = []
k = 1
for text in texts
    segments = Segment[]
    j = 1
    for i in text
        if j == 1
            push!(segments, r(encode(i), isarabic=false, first_word=true, silent_last_vowel=false))
        elseif j == length(text)
            push!(segments, r(encode(i), isarabic=false, first_word=false, silent_last_vowel=true))
        else
            push!(segments, r(encode(i), isarabic=false, first_word=false, silent_last_vowel=false))
        end
        j += 1
        println(k, "-", j)
    end
    k += 1
    push!(all_segments, segments)
end

all_segments[7]
encode(texts[7][end])

function code1() 
    r(encode(texts[7][end]), isarabic=false, first_word=false, silent_last_vowel=true)
end

out = map(segments -> syllabic_consistency(segments, tajweed_timings), all_segments)

all_segments[7]
out[7]
syllabic_consistency(all_segments[7], tajweed_timings)
print(out[7])

arabic("l~a*")