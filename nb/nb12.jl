using Yunir
using QuranTree

crps, tnzl = load(QuranData());
crps_tbl, tnzl_tbl = table(crps), table(tnzl);

function gen_rhythms(bw_texts)
    texts = map(x -> string.(x), split.(bw_texts))
    r = Syllabification(true, Syllable(1, 0, 10))
    tajweed_timings = Dict{String,Int64}(
        "i" => 1, # kasra
        "a" => 1, # fatha
        "u" => 1, # damma
        "F" => 1, # fatha tanween
        "N" => 1, # damma tanween
        "K" => 1, # kasra tanween
        "iy" => 2, # kasra + yaa
        "aA" => 2, # fatha + alif
        "a`" => 2, # fatha + small alif
        "iY" => 2, # fatha + alif
        "uw" => 2, # damma + waw
        "^" => 4 # maddah
    )

    all_segments = []
    k = 1
    for text in texts
        segments = Segment[]
        j = 1
        for i in text
            # @info i
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


bw_texts = verses(crps_tbl)
out = gen_rhythms(bw_texts)
