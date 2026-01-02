# test
using Yunir
using CairoMakie

struct Schillinger <: AbstractRhythmicVisArgs
    state_timings::Dict{Bw,RState}
end

function rhythmic_states(data::Schillinger, texts::Vector{Bw})::Vector{Vector{RState}}
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
    return map(segments -> syllabic_consistency(segments, data.state_timings), all_segments)
end

tajweed_timings = Dict{Bw,RState}(
    Bw("i") => RState(1, "short"), # kasra
    Bw("a") => RState(1, "short"), # fatha
    Bw("u") => RState(1, "short"), # damma
    Bw("F") => RState(1, "short"), # fatha tanween
    Bw("N") => RState(1, "short"), # damma tanween
    Bw("K") => RState(1, "short"), # kasra tanween
    Bw("iy") => RState(2, "long"), # kasra + yaa
    Bw("aA") => RState(2, "long"), # fatha + alif
    Bw("uw") => RState(2, "long"), # damma + waw
    Bw("a`") => RState(2, "long"),
    Bw("^") => RState(4, "maddah") # maddah
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

function vis(rhythms::Vector{Vector{RState}}, fig::Makie.Figure=Figure(size=(900,900)), title::String="Title", xlabel::String="Time in Seconds", ylabel::String="Line")
    mgrd = fig[1, 1] = GridLayout()
    grd = mgrd[1, 1] = GridLayout()

    k = 1
    axs = Axis[]
    phases = rhythms[1]
    for phases in rhythms
        push!(axs, Axis(grd[k, 1], 
            title= k == 1 ? title : "",
            xlabel=k < length(rhythms) ? "" : xlabel,
            ylabel="$(k)", 
            ygridvisible=true, 
            xgridvisible=false,
            yticks=(1:length(phases), repeat([""], length(phases)))))
        
        steps = Int64[]; j = 2
        for phase in phases
            steps = vcat(steps, repeat([(j-1) % 2], phase.state))
            j += 1
        end
        stairs!(axs[k], steps, step=:center)
        
        if k != length(rhythms)
            hidexdecorations!(axs[k])
            hidespines!(axs[k])
        else
            hidespines!(axs[k])
        end
        k += 1
    end
    linkxaxes!(axs..., )
    ax = Axis(mgrd[1,1], ylabel=ylabel * "\n\n\n", 
            ygridvisible=false, 
            xgridvisible=false, 
            xticklabelsvisible=false,
            yticklabelsvisible=false,
            xticksize=0,
            yticksize=0,
            spinewidth=0,

    )
    fig
end

rhythms = rhythmic_states(Schillinger(tajweed_timings), bw_texts)
vis(rhythms)