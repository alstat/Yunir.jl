"""
    VisType

Enum specifying the type of plot.

# Variants
- `last_recited`: plots the last recited syllable
- `schillinger`: generates the Joseph Schillinger's rhythmic graph
"""
@enum VisType last_recited schillinger

"""
    LastRecitedVariants

Enum specifying the variant of last-recited visualization.

# Variants
- `one`: only shows the syllable in the y-axis of the graph
- `two`: includes additional subplot now accounting the consonant after the syllable
- `three`: is `two` variant but with another suplot now accounting consonants before and after the syllable
"""
@enum LastRecitedVariants one two three

abstract type AbstractRhythmicVisArgs end;
abstract type AbstractSyllable end;

"""
    RhythmicVis(type::VisType, args::T) where T <: AbstractRhythmicVisArgs

Create a `RhythmicVis` object with the specified visualization type and arguments.

# Arguments
- `type::VisType`: The type of rhythmic visualization (from the `VisType` enum)
- `args::T`: Visualization arguments, must be a subtype of `AbstractRhythmicVisArgs`

# Examples
```julia
args = LastRecitedVisArgs(fig, "My Title")
vis = RhythmicVis(last_recited::VisType, args)
```
"""
struct RhythmicVis{T <: AbstractRhythmicVisArgs}
	type::VisType
    args::T
end

"""
    LastRecitedVisArgs <: AbstractRhythmicVisArgs

Create a `LastRecitedVisArgs` with `variant` argument specifying the number of characters before and after the last recited syllable, this variant is 
specified by the `LastRecitedVariants` which takes `one`, `two`, or `three` variant. It also takes `fig_args` argument to specify the details of the `Makie.Figure`.
The third argument `title` specifies the title of the graph.
"""
struct LastRecited <: AbstractRhythmicVisArgs
    variant::LastRecitedVariants
    fig_args::Makie.Figure
    title::String
end

"""
    LastRecited

Create a `LastRecited` object with the following default arguments: `one::LastRecitedVariants`, `Figure(resolution=(800, 800))`, and title="".
"""
LastRecited() = LastRecited(one::LastRecitedVariants, Figure(resolution=(800, 800)), "")

"""
    LastRecitedVisArgs(variant::LastRecitedVariants) 

Create a LastRecitedVisArgs object with custom `variant` specification and default values for the remaining arguments set to: `Figure(resolution=(800, 800))`, and title="".
"""
LastRecited(variant::LastRecitedVariants) = LastRecited(variant, Figure(resolution=(800, 800)), "")

"""
    LastRecitedSyllable <: AbstractSyllable

Create a LastRecitedSyllable object with `syllable` field.
"""
struct LastRecitedSyllable <: AbstractSyllable
    syllable::Bw
end

"""
    (r::RhythmicVis)(texts::Array{Bw})

Generate a rhythmic visualization from an array of Bw-encoded texts.

This is a functor/callable method for `RhythmicVis` objects.

# Arguments
- `texts::Array{Bw}`: Array of texts in Bw transliteration

# Returns
A tuple containing:
- `Makie.Figure`: The generated visualization figure
- `NTuple{3,...}`: A 3-tuple where each element is a tuple of:
  - `Array{Int64,1}`: Array of integer values
  - `Dict{LastRecitedSyllable,Int64}`: Dictionary mapping syllables to counts

# Examples
```julia
vis = RhythmicVis(last_recited, LastRecited())
fig, data = vis(buckwalter_texts)
```
"""
function (r::RhythmicVis)(texts::Array{Bw})::Tuple{Makie.Figure,NTuple{3,Tuple{Array{Int64,1},Dict{LastRecitedSyllable,Int64}}}}
	if r.type == last_recited
        y1_chars = Array{LastRecitedSyllable,1}()
        y2_chars = Array{LastRecitedSyllable,1}()
        y3_chars = Array{LastRecitedSyllable,1}()
        for text in texts
            chars_tuple = last_syllable(text)
            push!(y1_chars, chars_tuple[1])
            push!(y2_chars, chars_tuple[2])
            push!(y3_chars, chars_tuple[3])
        end
        y1, y1_dict = to_number(y1_chars)
        y2, y2_dict = to_number(y2_chars)
        y3, y3_dict = to_number(y3_chars)
        fig = if r.args.variant === one
            vis(y1_chars, y1, vis_args=r.args)
        elseif r.args.variant === two
            vis(y1_chars, y1, x2=y2_chars, y2=y2, vis_args=r.args)
        else
            vis(y1_chars, y1, x2=y2_chars, y2=y2, x3=y3_chars, y3=y3, vis_args=r.args)
        end
        return fig, ((y1, y1_dict), (y2, y2_dict), (y3, y3_dict))
	end
end

"""
    last_syllable(text::Bw)

Extract the last syllables from Buckwalter-encoded text.

Returns a 3-tuple of `LastRecitedSyllable` values which are described as the description of the three variants of `LastRecitedVariants`, respectively.
"""
function last_syllable(text::Bw)::NTuple{3,LastRecitedSyllable}
    out1 = Bw(replace(text.text[end-3:end-2], "o" => ""))
    out2 = Bw(replace(text.text[end-3:end-1], "o" => "")) 
    out3 = Bw(replace(text.text[end-4:end-1], "o" => ""))
    return LastRecitedSyllable(out1), LastRecitedSyllable(out2), LastRecitedSyllable(out3)
end

"""
    to_number(texts::Array{LastRecitedSyllable})

Assign a unique sequence (sorted based on first appearance in the array) of number to the unique values of `LastRecitedSyllable` texts to be used as y-axis location for plotting Rhythmic last recited syllable.
"""
function to_number(texts::Array{LastRecitedSyllable})::Tuple{Array{Int64,1},Dict{LastRecitedSyllable,Int64}}
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
    y_vec = Array{Int64,1}()
    for text in texts
        push!(y_vec, y_dict[text])
    end
    return y_vec, y_dict 
end

function vis(x1::Array{LastRecitedSyllable,1}, y1::Array{Int64,1}; 
    x2::Union{Nothing,Array{LastRecitedSyllable,1}}=nothing, 
    y2::Union{Nothing,Array{Int64,1}}=nothing, 
    x3::Union{Nothing,Array{LastRecitedSyllable,1}}=nothing, 
    y3::Union{Nothing,Array{Int64,1}}=nothing, 
    vis_args::LastRecited=LastRecited())::Makie.Figure
    x1 = map(x -> x.syllable.text, x1)
    f = vis_args.fig_args;
    a1 = Axis(f[1, 1], 
        ylabel="Last Pronounced Syllable\n\n\n",
        title=vis_args.title,
        yticks=(unique(y1), unique(string.(x1))),
        xticks = collect(eachindex(x1))
    )
    lines!(a1, collect(eachindex(x1)), y1)

    if x2 !== nothing && x3 !== nothing
        x2 = map(x -> x.syllable.text, x2)
        x3 = map(x -> x.syllable.text, x3)
        a2 = Axis(f[2, 1], 
            ylabel="3 Characters\n\n\n",
            yticks=(unique(y2), unique(string.(x2))),
            xticks = collect(eachindex(x2))
        )
        a3 = Axis(f[3, 1], 
            ylabel="3-4 Characters\n\n",
            yticks=(unique(y3), unique(string.(x3))),
            xticks = collect(eachindex(x3))
        )
        lines!(a2, collect(eachindex(x2)), y2)
        lines!(a3, collect(eachindex(x3)), y3)
    elseif x2 !== nothing && x3 === nothing
        x2 = map(x -> x.syllable.text, x2)
        a2 = Axis(f[2, 1], 
            ylabel="3 Characters\n\n\n",
            yticks=(unique(y2), unique(string.(x2))),
            xticks = collect(eachindex(x2))
        )
        hidexdecorations!(a1)
        lines!(a2, collect(eachindex(x2)), y2)
    elseif x2 === nothing && x3 !== nothing 
        x3 = map(x -> x.syllable.text, x3)
        a3 = Axis(f[3, 1], 
            ylabel="3-4 Characters\n\n",
            yticks=(unique(y3), unique(string.(x3))),
            xticks = collect(eachindex(x3))
        )
        hidexdecorations!(a1)
        lines!(a3, collect(eachindex(x3)), y3)
    else
    end
    f
end
