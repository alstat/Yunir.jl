# test
using QuranTree
using CairoMakie
using Yunir

crps, tnzl = load(QuranData());
crps_tbl = table(crps)
tnzl_tbl = table(tnzl)
bw_texts = Bw.(verses(crps_tbl[1]))
dump(bw_texts[1])
alfatihah_bw = [
    Bw("bisomi {ll~ahi {lr~aHoma`ni {lr~aHiymi"),
    Bw("{loHamodu lil~ahi rab~i {loEa`lamiyna"),
    Bw("{lr~aHoma`ni {lr~aHiymi"),
    Bw("ma`liki yawomi {ld~iyni"),
    Bw("<iy~aAka naEobudu wa<iy~aAka nasotaEiynu"),
    Bw("{hodinaA {lS~ira`Ta {lomusotaqiyma"),
    Bw("Sira`Ta {l~a*iyna >anoEamota Ealayohimo gayori {lomagoDuwbi Ealayohimo walaA {lD~aA^l~iyna")
]

function gen_rhythms(bw_texts)
    texts = map(x -> string.(split(x.text)), bw_texts)
    r = Syllabification(true, Syllable(1, 0, 10))
    tajweed_timings = Dict{Bw,Int64}(
        Bw("i") => 1, # kasra
        Bw("a") => 1, # fatha
        Bw("u") => 1, # damma
        Bw("F") => 1, # fatha tanween
        Bw("N") => 1, # damma tanween
        Bw("K") => 1, # kasra tanween
        Bw("iy") => 2, # kasra + yaa
        Bw("aA") => 2, # fatha + alif
        Bw("a`") => 2, # fatha + small alif
        Bw("iY") => 2, # fatha + alif
        Bw("uw") => 2, # damma + waw
        Bw("^") => 4 # maddah
    )

    all_segments = []
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

    return map(segments -> syllabic_consistency(segments, tajweed_timings), all_segments)
end

surah = 1
rhythms = gen_rhythms(bw_texts)
fig = Figure(size=(900,900))
mgrd = fig[1, 1] = GridLayout()
grd1 = mgrd[1, 1] = GridLayout()
grd2 = mgrd[1, 2] = GridLayout()
grd3 = mgrd[2, 1] = GridLayout()
grd4 = mgrd[2, 2] = GridLayout()
