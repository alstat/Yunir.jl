"""
    LastRecitedVariants

Enum specifying the variant of last-recited visualization.

# Variants
- `A`: Single subplot showing only the last recited syllable
- `B`: Two subplots showing the syllable and the syllable with trailing consonant
- `C`: Three subplots showing the syllable, syllable with trailing consonant, and syllable with leading and trailing consonants
"""
@enum LastRecitedVariants A B C

"""
    AbstractRhythmicVisArgs

Abstract base type for rhythmic visualization arguments. Concrete subtypes define specific visualization configurations.
"""
abstract type AbstractRhythmicVisArgs end;

"""
    AbstractSyllable

Abstract base type for syllable representations used in rhythmic analysis.
"""
abstract type AbstractSyllable end;

"""
    RhythmicVis(args::T) where T <: AbstractRhythmicVisArgs

Create a `RhythmicVis` object with the specified visualization type and arguments.

# Arguments
- `args::T`: Visualization arguments, must be a subtype of `AbstractRhythmicVisArgs`

# Examples
```julia
# Create a visualization with default LastRecited arguments
vis = RhythmicVis(LastRecited())

# Create with specific variant
vis = RhythmicVis(LastRecited(B))
```
"""
struct RhythmicVis{T<:AbstractRhythmicVisArgs}
    args::T
end

"""
    LastRecited <: AbstractRhythmicVisArgs

Configuration for last recited syllable visualization.

# Fields
- `variant::LastRecitedVariants`: Specifies the visualization variant (A, B, or C) which determines
  how many subplots to create and what syllable components to display.

# Examples
```julia
# Create with variant A (single subplot)
lr = LastRecited(A)

# Create with variant B (two subplots)
lr = LastRecited(B)

# Create with variant C (three subplots)
lr = LastRecited(C)
```
"""
struct LastRecited <: AbstractRhythmicVisArgs
    variant::LastRecitedVariants
end

"""
    LastRecited()

Create a `LastRecited` object with default variant `A` (single subplot showing only the last syllable).
"""
LastRecited() = LastRecited(A::LastRecitedVariants)

"""
    LastRecitedSyllable <: AbstractSyllable

Represents a syllable extracted from the end of a text in Buckwalter transliteration.

# Fields
- `syllable::Bw`: The syllable in Buckwalter encoding

# Examples
```julia
syllable = LastRecitedSyllable(Bw("mA"))
```
"""
struct LastRecitedSyllable <: AbstractSyllable
    syllable::Bw
end

"""
    (r::RhythmicVis)(texts::Vector{Bw}; fig_kwargs...)

Generate a rhythmic visualization from an array of Bw-encoded texts.

This is a functor/callable method for `RhythmicVis` objects that analyzes the last recited
syllables in each text and creates a visualization showing how they vary across the texts.

# Arguments
- `texts::Vector{Bw}`: Array of texts in Bw transliteration
- `fig_kwargs...`: Keyword arguments passed to the `lines!` plotting function (e.g., color, linewidth)

# Returns
A tuple containing:
- `Makie.Figure`: The generated visualization figure
- Data tuple: A tuple of 1-3 data tuples (depending on variant), where each element contains:
  - `Vector{Int64}`: Y-axis numeric positions for each text
  - `Dict{LastRecitedSyllable,Int64}`: Dictionary mapping unique syllables to their assigned positions

The number of data tuples returned depends on the variant:
- Variant A: 1-tuple of data
- Variant B: 2-tuple of data
- Variant C: 3-tuple of data

# Examples
```julia
# Single subplot visualization
vis = RhythmicVis(LastRecited(A))
fig, ((positions, syllable_map),) = vis(buckwalter_texts)

# Three subplot visualization
vis = RhythmicVis(LastRecited(C))
fig, (data1, data2, data3) = vis(buckwalter_texts, color=:blue)
```
"""
function (r::RhythmicVis)(texts::Vector{Bw}; fig_kwargs...)::Tuple{Makie.Figure,
    Union{
        NTuple{1,Tuple{Vector{Int64},Dict{LastRecitedSyllable,Int64}}},
        NTuple{2,Tuple{Vector{Int64},Dict{LastRecitedSyllable,Int64}}},
        NTuple{3,Tuple{Vector{Int64},Dict{LastRecitedSyllable,Int64}}}
    }}
    if typeof(r.args) === LastRecited
        if r.args.variant === A::LastRecitedVariants
            y1_chars = Vector{LastRecitedSyllable}()
        elseif r.args.variant === B::LastRecitedVariants
            y1_chars = Vector{LastRecitedSyllable}()
            y2_chars = Vector{LastRecitedSyllable}()
        elseif r.args.variant === C::LastRecitedVariants
            y1_chars = Vector{LastRecitedSyllable}()
            y2_chars = Vector{LastRecitedSyllable}()
            y3_chars = Vector{LastRecitedSyllable}()
        else
            throw("Unknown variant of LastRecitedVariants assigned.")
        end

        for text in texts
            chars_tuple = last_syllable(r.args, text)
            if r.args.variant === A::LastRecitedVariants
                push!(y1_chars, chars_tuple[1])
            elseif r.args.variant === B::LastRecitedVariants
                push!(y1_chars, chars_tuple[1])
                push!(y2_chars, chars_tuple[2])
            elseif r.args.variant === C::LastRecitedVariants
                push!(y1_chars, chars_tuple[1])
                push!(y2_chars, chars_tuple[2])
                push!(y3_chars, chars_tuple[3])
            else
                throw("Unknown variant of LastRecitedVariants assigned.")
            end
        end
        if r.args.variant === A::LastRecitedVariants
            y1, y1_dict = to_numbers(y1_chars)
            fig = vis(y1_chars, y1; fig_kwargs...)
            return fig, ((y1, y1_dict),)
        elseif r.args.variant === B::LastRecitedVariants
            y1, y1_dict = to_numbers(y1_chars)
            y2, y2_dict = to_numbers(y2_chars)
            fig = vis(y1_chars, y1, x2=y2_chars, y2=y2; fig_kwargs...)
            return fig, ((y1, y1_dict), (y2, y2_dict))
        elseif r.args.variant === C::LastRecitedVariants
            y1, y1_dict = to_numbers(y1_chars)
            y2, y2_dict = to_numbers(y2_chars)
            y3, y3_dict = to_numbers(y3_chars)
            fig = vis(y1_chars, y1, x2=y2_chars, y2=y2, x3=y3_chars, y3=y3; fig_kwargs...)
            return fig, ((y1, y1_dict), (y2, y2_dict), (y3, y3_dict))
        else
            throw("Unknown variant of LastRecitedVariants assigned.")
        end
    end
end

"""
    last_syllable(lr::LastRecited, text::Bw)

Extract the last syllable(s) from Buckwalter-encoded text according to the specified variant.

The function extracts different representations of the final syllable based on the variant:
- Variant A: Returns 1-tuple with just the last syllable (2 characters from end, positions end-3:end-2)
- Variant B: Returns 2-tuple with the syllable and syllable+trailing consonant (positions end-3:end-1)
- Variant C: Returns 3-tuple with syllable, syllable+trailing, and leading+syllable+trailing (positions end-4:end-1)

# Arguments
- `lr::LastRecited`: Configuration specifying which variant to use
- `text::Bw`: The Buckwalter-encoded text to extract from

# Returns
A tuple of `LastRecitedSyllable` objects (1, 2, or 3 elements depending on variant)

# Examples
```julia
text = Bw("...mAno")
lr = LastRecited(A)
(syl,) = last_syllable(lr, text)  # Returns 1-tuple

lr = LastRecited(C)
(syl, syl_trailing, full) = last_syllable(lr, text)  # Returns 3-tuple
```
"""
function last_syllable(lr::LastRecited, text::Bw)::Union{
    NTuple{1,LastRecitedSyllable},
    NTuple{2,LastRecitedSyllable},
    NTuple{3,LastRecitedSyllable}
}
    if lr.variant === A::LastRecitedVariants
        out1 = Bw(replace(text.text[end-3:end-2], "o" => ""))
        (LastRecitedSyllable(out1),)
    elseif lr.variant === B::LastRecitedVariants
        out1 = Bw(replace(text.text[end-3:end-2], "o" => ""))
        out2 = Bw(replace(text.text[end-3:end-1], "o" => ""))
        LastRecitedSyllable(out1), LastRecitedSyllable(out2)
    elseif lr.variant === C::LastRecitedVariants
        out1 = Bw(replace(text.text[end-3:end-2], "o" => ""))
        out2 = Bw(replace(text.text[end-3:end-1], "o" => ""))
        out3 = Bw(replace(text.text[end-4:end-1], "o" => ""))
        LastRecitedSyllable(out1), LastRecitedSyllable(out2), LastRecitedSyllable(out3)
    else
        throw("Unknown variant of LastRecitedVariants assigned.")
    end
end

"""
    to_numbers(texts::Vector{LastRecitedSyllable})

Convert syllables to numeric y-axis positions for visualization.

Assigns a unique integer to each unique syllable in the order of first appearance. This mapping
is used to position syllables on the y-axis of the visualization plot.

# Arguments
- `texts::Vector{LastRecitedSyllable}`: Array of syllables to convert

# Returns
A tuple containing:
- `Vector{Int64}`: Numeric position for each syllable in `texts` (same length as input)
- `Dict{LastRecitedSyllable,Int64}`: Dictionary mapping each unique syllable to its assigned position

# Examples
```julia
syllables = [syl1, syl2, syl1, syl3]  # syl1 appears twice
positions, mapping = to_numbers(syllables)
# positions = [1, 2, 1, 3]  # Same syllables get same position
# mapping = Dict(syl1=>1, syl2=>2, syl3=>3)
```
"""
function to_numbers(texts::Vector{LastRecitedSyllable})::Tuple{Vector{Int64},Dict{LastRecitedSyllable,Int64}}
    y = unique(texts)
    y_dict = Dict{LastRecitedSyllable,Int64}()
    for i in eachindex(y)
        if i == 1
            y_dict[y[i]] = i
        end

        if y[i] ∈ keys(y_dict)
            continue
        else
            y_dict[y[i]] = i
        end
    end
    y_vec = Vector{Int64}()
    for text in texts
        push!(y_vec, y_dict[text])
    end
    return y_vec, y_dict
end

"""
    vis(x1::Vector{LastRecitedSyllable}, y1::Vector{Int64}; kwargs...)

Create a Makie figure visualizing the progression of last recited syllables across texts.

The function creates 1-3 vertically stacked subplots depending on which optional data arguments
are provided. Each subplot shows a line plot tracking how the last recited syllable patterns
change across the sequence of texts.

# Arguments
- `x1::Vector{LastRecitedSyllable}`: Syllable data for the first (required) subplot
- `y1::Vector{Int64}`: Numeric y-axis positions for the first subplot

# Keyword Arguments
- `x2::Union{Nothing,Vector{LastRecitedSyllable}}=nothing`: Optional syllable data for second subplot
- `y2::Union{Nothing,Vector{Int64}}=nothing`: Optional y-axis positions for second subplot
- `x3::Union{Nothing,Vector{LastRecitedSyllable}}=nothing`: Optional syllable data for third subplot
- `y3::Union{Nothing,Vector{Int64}}=nothing`: Optional y-axis positions for third subplot
- `fig::Makie.Figure=Makie.Figure(resolution=(800, 800))`: The Makie figure to draw into
- `title::String="Title"`: Title displayed at the top of the figure
- `xlabel::String="Line Index"`: Label for the x-axis
- `ylabel::Vector{String}`: Y-axis labels for up to 3 subplots (defaults to syllable descriptions)
- `fig_kwargs...`: Additional keyword arguments passed to the `lines!` function

# Returns
- `Makie.Figure`: The figure with rendered visualization

# Subplot Behavior
- If only `x1`/`y1` provided: Creates single subplot
- If `x1`/`y1` and `x2`/`y2` provided: Creates 2 vertically stacked subplots
- If all `x1`/`y1`, `x2`/`y2`, and `x3`/`y3` provided: Creates 3 vertically stacked subplots

# Examples
```julia
# Single subplot
fig = vis(syllables1, positions1, title="Last Syllable Analysis")

# Two subplots
fig = vis(syllables1, positions1, x2=syllables2, y2=positions2)

# Three subplots with custom styling
fig = vis(syllables1, positions1,
          x2=syllables2, y2=positions2,
          x3=syllables3, y3=positions3,
          title="Complete Analysis",
          color=:blue, linewidth=2)
```
"""
function vis(x1::Vector{LastRecitedSyllable}, y1::Vector{Int64};
    x2::Union{Nothing,Vector{LastRecitedSyllable}}=nothing,
    y2::Union{Nothing,Vector{Int64}}=nothing,
    x3::Union{Nothing,Vector{LastRecitedSyllable}}=nothing,
    y3::Union{Nothing,Vector{Int64}}=nothing,
    fig::Makie.Figure=Makie.Figure(resolution=(800, 800)),
    title::String="Title",
    xlabel::String="Line Index",
    ylabel::Vector{String}=["Last Pronounced Syllable\n\n\n", "3 Characters\n\n\n", "3-4 Characters\n\n"],
    fig_kwargs...)::Makie.Figure
    x1 = map(x -> x.syllable.text, x1)
    f = fig
    a1 = Axis(f[1, 1],
        xlabel=xlabel,
        ylabel=ylabel[1],
        title=title,
        yticks=(unique(y1), unique(string.(x1))),
        xticks=collect(eachindex(x1))
    )
    lines!(a1, collect(eachindex(x1)), y1)

    if x2 !== nothing && x3 !== nothing
        x2 = map(x -> x.syllable.text, x2)
        x3 = map(x -> x.syllable.text, x3)
        a2 = Axis(f[2, 1],
            ylabel=ylabel[2],
            yticks=(unique(y2), unique(string.(x2))),
            xticks=collect(eachindex(x2))
        )
        a3 = Axis(f[3, 1],
            xlabel=xlabel,
            ylabel=ylabel[3],
            yticks=(unique(y3), unique(string.(x3))),
            xticks=collect(eachindex(x3))
        )
        lines!(a2, collect(eachindex(x2)), y2; fig_kwargs...)
        lines!(a3, collect(eachindex(x3)), y3; fig_kwargs...)
        hidexdecorations!(a1)
        hidexdecorations!(a2)
    elseif x2 !== nothing && x3 === nothing
        x2 = map(x -> x.syllable.text, x2)
        a2 = Axis(f[2, 1],
            xlabel=xlabel,
            ylabel=ylabel[2],
            yticks=(unique(y2), unique(string.(x2))),
            xticks=collect(eachindex(x2))
        )
        hidexdecorations!(a1)
        lines!(a2, collect(eachindex(x2)), y2; fig_kwargs...)
    elseif x2 === nothing && x3 !== nothing
        x3 = map(x -> x.syllable.text, x3)
        a3 = Axis(f[3, 1],
            xlabel=xlabel,
            ylabel=ylabel[3],
            yticks=(unique(y3), unique(string.(x3))),
            xticks=collect(eachindex(x3))
        )
        hidexdecorations!(a1)
        lines!(a3, collect(eachindex(x3)), y3; fig_kwargs...)
    else
    end
    f
end
