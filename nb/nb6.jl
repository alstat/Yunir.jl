using Yunir
using Distributions
using CairoMakie
using QuranTree

crps, tnzl = load(QuranData());
crpstbl = table(crps)
tnzltbl = table(tnzl)
<<<<<<< HEAD
bw_texts = verses(tnzltbl)

texts = map(x -> string.(x), split.(bw_texts))
r = Syllabification(true, Syllable(0, 0, 2))
=======
bw_texts = verses(tnzltbl[1])

texts = string.(split(bw_texts[6]))
r = Syllabification(true, Syllable(1, 0, 5))
>>>>>>> parent of b5b987d (add syllabic_consistency)

texts[1][end]
encode(texts[1][end])
r(encode(texts[1][end]), isarabic=false, first_word=false, silent_last_vowel=false)

tajweed_timings = Dict{String,Int64}(
<<<<<<< HEAD
    "i"  => 1, # kasra
    "a"  => 1, # fatha
    "u"  => 1, # damma
    "F"  => 1, # fatha tanween
    "N"  => 1, # damma tanween
    "K"  => 1, # kasra tanween
    "iy" => 2, # kasra + yaa
    "aA" => 2, # fatha + alif
    "uw" => 2, # damma + waw
    "^"  => 4 # maddah
)

# texts
ar_raheem = encode("ٱلرَّحِيمِ")
r = Syllabification(true, Syllable(1, 0, 1))
r(ar_raheem, isarabic=false, silent_last_vowel=true)

ar_raheem = encode("ٱلرَّحِيمِ")
r = Syllabification(true, Syllable(1, 2, 2))
r(ar_raheem, isarabic=false, silent_last_vowel=false)

encode(ar_raheem)
encode(texts[7][end])
encode(texts[8][end])
all_segments = []
k = 1
for text in texts
    segments = Segment[]
    j = 1
    for i in text
        if j == 1
            push!(segments, r(encode(i), isarabic=false, first_word=true, silent_last_vowel=false))
        elseif j == length(texts)
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
all_segments[2]
all_segments[8][end]

syllabic_consistency([all_segments[2][2]], tajweed_timings)

texts[7][end]
r(encode(texts[7][end]), isarabic=false, first_word=false, silent_last_vowel=false)

r(encode(texts[2][1]), isarabic=false, first_word=false, silent_last_vowel=false)
encode(texts[8][5])
r(encode(texts[8][5]), isarabic=false, first_word=false, silent_last_vowel=false)
syllabic_consistency([r(encode(texts[8][5]), isarabic=false, first_word=false, silent_last_vowel=false)], tajweed_timings)


encode(texts[8][5])
encode.(texts[7])
all_segments


out = map(segments -> syllabic_consistency(segments, tajweed_timings), all_segments)
out[1:7]
out[8]
encode(texts[7][2])

all_segments[7]

####
function syllabic_consistency(segments::Vector{Segment}, syllable_timing::Dict{String,Int64})
    segment_scores = Int64[]
=======
    "i" => 1,
    "a" => 1,
    "u" => 1,
    "F" => 1,
    "N" => 1,
    "K" => 1,
    "iy" => 2,
    "aA" => 2,
    "uw" => 2,
    "^" => 4
)

function syllabic_consistency(segments)
    segment_scores = []
>>>>>>> parent of b5b987d (add syllabic_consistency)
    for segment in segments
        syllables = split(segment.segment, "?")

        syllable_scores = []
        for syllable in syllables
            if occursin('{', syllable)
                push!(syllable_scores, tajweed_timings["a"])
            else
                push!(syllable_scores, tajweed_timings[syllable[vowel_indices(string(syllable))]])
            end
        end
        push!(segment_scores, syllable_scores...)
    end
    return segment_scores
end


syllabic_consistency(segments)
f1 = segment_scores
f2 = segment_scores



sum([f1...,f2...])
1/(1+std([9,11,6,6,13,9,24]))



vowel_idsyllables
tajweed_timings[o[1][vowel_indices(string(o[1]))]]

verse_orthogs = Vector{Orthography}[]
for verse in bw_texts
    push!(verse_orthogs, parse.(Orthography, string.(split(verse, " "))))
end
verse_orthogs
verse_orthogs[1]
word_orthogs

out = []
for word_orthogs in verse_orthogs
    word_struct = String[]
    for word_orthog in word_orthogs
        syllabic_struct = String[]
        for orthog in word_orthog.data
            if orthog == Sukun
                push!(syllabic_struct, "-")
            elseif orthog <: AbstractConsonant
                push!(syllabic_struct, "C")
            elseif orthog <: AbstractVowel
                push!(syllabic_struct, "V")
            else
                push!(syllabic_struct, "X")
                println(orthog)
            end
        end
        push!(word_struct, join(syllabic_struct, ""))
    end
    push!(out, word_struct)
end
out



isfeat(AbstractConsonant, parse(Orthography, bw_texts1[1]))

ortho = parse.(Orthography, string.(split(bw_texts1[1], " ")))
isfeat.(AbstractConsonant, ortho[1].data)

ortho[1].data[1] <: AbstractConsonant









using Statistics

# Define syllable types and their timing values
const SYLLABLE_TIMING = Dict("CV" => 1, "CVC" => 2, "CVV" => 2, "CVVC" => 3)

# Function to convert a verse to its syllabic structure
function to_syllabic_structure(verse::String)
    # This is a simplified version. In a real implementation,
    # you'd need a more sophisticated method to determine syllable structure.
    syllables = split(verse, "-")
    return [get(SYLLABLE_TIMING, s, 1) for s in syllables]
end

# Calculate syllabic consistency
function syllabic_consistency(verses)
    syllable_counts = [length(v) for v in verses]
    return 1 / var(syllable_counts)
end

# Calculate rhyme strength
function rhyme_strength(verses)
    n = length(verses)
    matches = sum(verses[i][end] == verses[j][end] 
                  for i in 1:n for j in (i+1):n)
    return 2 * matches / (n * (n - 1))
end

# Calculate edit distance for rhythmic pattern regularity
function edit_distance(a, b)
    m, n = length(a), length(b)
    dp = zeros(Int, m+1, n+1)
    for i in 1:m+1
        dp[i, 1] = i - 1
    end
    for j in 1:n+1
        dp[1, j] = j - 1
    end
    for i in 2:m+1
        for j in 2:n+1
            if a[i-1] == b[j-1]
                dp[i, j] = dp[i-1, j-1]
            else
                dp[i, j] = min(dp[i-1, j], dp[i, j-1], dp[i-1, j-1]) + 1
            end
        end
    end
    return dp[m+1, n+1]
end

# Calculate rhythmic pattern regularity
function rhythmic_pattern_regularity(verses)
    n = length(verses)
    total_distance = sum(edit_distance(verses[i], verses[i+1]) for i in 1:n-1)
    max_length = maximum(length.(verses))
    return 1 - total_distance / ((n - 1) * max_length)
end

# Assume perfect tajweed adherence for simplicity
tajweed_adherence(verses) = 1.0

# Main analysis function
function analyze_quranic_rhythm(verses::Vector{String}, weights::Vector{Float64})
    syllabic_verses = [to_syllabic_structure(v) for v in verses]
    
    sc = syllabic_consistency(syllabic_verses)
    rs = rhyme_strength(syllabic_verses)
    rpr = rhythmic_pattern_regularity(syllabic_verses)
    ta = tajweed_adherence(syllabic_verses)
    
    scores = [sc, rs, rpr, ta]
    return (scores'weights) / sum(weights)
end

# Example usage
verse = [
    "CVC-CV-C-CV-CV-C-CVC-CV-V-CV-C-CV-CVV-CV",
    "CVC-CVC-CV-CV-CV-V-CV-CVC-CVC-CV-V-CV-CVV-CV"
]
weights = [0.25, 0.25, 0.25, 0.25]

scor = analyze_quranic_rhythm(verse, weights)
println("Final score: ", round(score, digits=4))