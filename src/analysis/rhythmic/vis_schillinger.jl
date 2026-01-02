
"""
    Schillinger <: AbstractRhythmicVisArgs

A structure for visualizing rhythmic patterns using Joseph Schillinger's rhythmic graph theory.

# Fields
- `state_timings::Dict{Bw,RState}`: A dictionary mapping Buckwalter-encoded vowel patterns
  to rhythmic states with their durations and descriptions.

# Example
```julia
tajweed_timings = Dict{Bw,RState}(
    Bw("i") => RState(1, "short"),  # kasra
    Bw("a") => RState(1, "short"),  # fatha
    Bw("u") => RState(1, "short"),  # damma
    Bw("iy") => RState(2, "long"),  # kasra + yaa
    Bw("aA") => RState(2, "long"),  # fatha + alif
    Bw("uw") => RState(2, "long"),  # damma + waw
    Bw("^") => RState(4, "maddah")  # maddah
)

schillinger = Schillinger(tajweed_timings)
```

See also: [`rhythmic_states`](@ref), [`vis`](@ref)
"""
struct Schillinger <: AbstractRhythmicVisArgs
    state_timings::Dict{Bw,RState}
end

"""
    rhythmic_states(data::Schillinger, texts::Vector{Bw}) -> Vector{Vector{RState}}

Analyzes Buckwalter-encoded Arabic texts and converts them into rhythmic states based on
Schillinger's rhythmic theory.

# Arguments
- `data::Schillinger`: A Schillinger object containing the mapping of vowel patterns to rhythmic states.
- `texts::Vector{Bw}`: A vector of Buckwalter-encoded Arabic text strings to analyze.

# Returns
- `Vector{Vector{RState}}`: A vector where each element corresponds to a text input and contains
  the rhythmic states for each syllable in that text.

# Details
The function performs the following steps:
1. Splits each text into individual words
2. Applies syllabification to each word:
   - First word: `first_word=true, silent_last_vowel=false`
   - Last word: `first_word=false, silent_last_vowel=true`
   - Middle words: `first_word=false, silent_last_vowel=false`
3. Maps syllables to rhythmic states using the provided timing dictionary

# Example
```julia
tajweed_timings = Dict{Bw,RState}(
    Bw("i") => RState(1, "short"),
    Bw("a") => RState(1, "short"),
    Bw("iy") => RState(2, "long"),
    Bw("aA") => RState(2, "long")
)

schillinger = Schillinger(tajweed_timings)
texts = [Bw("bisomi {ll~ahi")]
states = rhythmic_states(schillinger, texts)
```

See also: [`Schillinger`](@ref), [`vis`](@ref)
"""
function rhythmic_states(data::Schillinger, texts::Union{Vector{Ar},Vector{Bw}})::Vector{Vector{RState}}
    texts = map(x -> x isa Ar ? Ar.(string.(split(x.text))) : Bw.(string.(split(x.text))), texts)
    r = Syllabification(true, Syllable(1, 0, 10))

    all_segments = Vector{Segment}[]
    k = 1
    for text in texts
        segments = Segment[]
        j = 1
        for i in text
            @info i
            if j == 1
                push!(segments, r(i isa Bw ? i : encode(i), first_word=true, silent_last_vowel=false))
            elseif j == length(text)
                push!(segments, r(i isa Bw ? i : encode(i), first_word=false, silent_last_vowel=true))
            else
                push!(segments, r(i isa Bw ? i : encode(i), first_word=false, silent_last_vowel=false))
            end
            j += 1
        end
        k += 1
        push!(all_segments, segments)
    end
    return map(segments -> syllabic_consistency(segments, data.state_timings), all_segments)
end

"""
    vis(rhythms::Vector{Vector{RState}}, fig::Makie.Figure=Figure(size=(900,900)),
        title::String="Title", xlabel::String="Time in Seconds", ylabel::String="Line") -> Figure

Visualizes Joseph Schillinger's rhythmic graph using a staircase plot.

# Arguments
- `rhythms::Vector{Vector{RState}}`: A vector of rhythmic state sequences, typically output from
  [`rhythmic_states`](@ref). Each inner vector represents the rhythmic pattern of one line/verse.
- `fig::Makie.Figure`: Optional pre-existing Makie Figure object. Defaults to a new Figure with
  size (900, 900).
- `title::String`: Title for the plot. Defaults to "Title".
- `xlabel::String`: Label for the x-axis. Defaults to "Time in Seconds".
- `ylabel::String`: Label for the y-axis. Defaults to "Line".

# Returns
- `Makie.Figure`: A Makie Figure object containing the rhythmic visualization.

# Details
The visualization creates a separate subplot for each input text, displaying the rhythmic pattern
as a staircase plot where:
- Each step represents a rhythmic state
- The width of each step corresponds to the duration of that state
- Steps alternate between two levels (0 and 1) to clearly show rhythmic changes
- All subplots share the same x-axis for easy comparison

# Example
```julia
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
rhythms = rhythmic_states(Schillinger(tajweed_timings), bw_texts)
fig = vis(rhythms)
```

See also: [`Schillinger`](@ref), [`rhythmic_states`](@ref)
"""
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
