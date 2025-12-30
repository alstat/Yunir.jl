# test
using Yunir
using CairoMakie

function rhythmic_states(texts::Vector{Bw}, state_timings::Dict{Bw,Int64})::Vector{Vector{Int64}}
    texts = map(x -> string.(split(x.text)), texts)
    r = Syllabification(true, Syllable(1, 0, 10))

    all_segments = Vector{Segment}[]
    k = 1
    for text in texts
        segments = Segment[]
        j = 1
        for i in text
            @info i
            if j == 1
                push!(segments, r(encode(i), isarabic=false, first_word=true, silent_last_vowel=false))
            elseif j == length(text)
                push!(segments, r(encode(i), isarabic=false, first_word=false, silent_last_vowel=true))
            else
                push!(segments, r(encode(i), isarabic=false, first_word=false, silent_last_vowel=false))
            end
            j += 1
        end
        k += 1
        push!(all_segments, segments)
    end
    return map(segments -> syllabic_consistency(segments, state_timings), all_segments)
end

tajweed_timings = Dict{Bw,Int64}(
    Bw("i") => 1, # kasra
    Bw("a") => 1, # fatha
    Bw("u") => 1, # damma
    Bw("F") => 1, # fatha tanween
    Bw("N") => 1, # damma tanween
    Bw("K") => 1, # kasra tanween
    Bw("iy") => 2, # kasra + yaa
    Bw("aA") => 2, # fatha + alif
    Bw("uw") => 2, # damma + waw
    Bw("a`") => 2,
    Bw("^") => 4 # maddah
)

bw_texts = [
    Bw("bisomi {ll~ahi {lr~aHoma`ni {lr~aHiymi"),
    Bw("{loHamodu lil~ahi rab~i {loEa`lamiyna"),
    Bw("{lr~aHoma`ni {lr~aHiymi"),
    Bw("ma`liki yawomi {ld~iyni"),
    Bw("<iy~aAka naEobudu wa<iy~aAka nasotaEiynu"),
    Bw("{hodinaA {lS~ira`Ta {lomusotaqiyma"),
    Bw("Sira`Ta {l~a*iyna >anoEamota Ealayohimo gayori {lomagoDuwbi Ealayohimo walaA {lD~aA^l~iyna")
]
rhythms = rhythmic_states(bw_texts, tajweed_timings)
fig = Figure(size=(900,900))
mgrd = fig[1, 1] = GridLayout()
grd1 = mgrd[1, 1] = GridLayout()
grd2 = mgrd[1, 2] = GridLayout()
grd3 = mgrd[2, 1] = GridLayout()
grd4 = mgrd[2, 2] = GridLayout()
