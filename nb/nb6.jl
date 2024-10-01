using Distributions
using CairoMakie
using QuranTree
using Yunir

crps, tnzl = load(QuranData());
crpstbl = table(crps)
tnzltbl = table(tnzl)
bw_texts = verses(tnzltbl[1])



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