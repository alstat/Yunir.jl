"""
    Schillinger
"""
struct Schillinger <: AbstractRhythmicVisArgs
    state_timings::Dict{Bw,Int64}
    fig_args::Makie.Figure
    title::String
end

function rhythmic_states(texts::Vector{Bw}, state_timings::Dict(Bw, int64))::Vector{Int64}
    texts = map(x -> string.(split(x.text)), bw_texts)
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



