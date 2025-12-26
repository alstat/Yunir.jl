@enum VisType last_recited schimiller
@enum LastRecitedVariants one two three

abstract type AbstractRhythmicVisArgs end;
abstract type AbstractSyllable end;
struct RhythmicVis{T <: AbstractRhythmicVisArgs}
	type::VisType
    args::T
end

struct LastRecitedVisArgs <: AbstractRhythmicVisArgs
    variant::LastRecitedVariants
    fig_args::Makie.Figure
    title::String
end
LastRecitedVisArgs() = LastRecitedVisArgs(one, Figure(resolution=(800, 800)), "")
LastRecitedVisArgs(variant::LastRecitedVariants) = LastRecitedVisArgs(variant, Figure(resolution=(800, 800)), "")

struct LastRecitedSyllable <: AbstractSyllable
    syllable::Buckwalter
end

function (r::RhythmicVis)(texts::Array{Buckwalter})::Tuple{Makie.Figure,NTuple{3,Tuple{Array{Int64,1},Dict{LastRecitedSyllable,Int64}}}}
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
    last_syllable(text::Buckwalter)

Extracts the last recited syllable from one to two characters prior and after the said vowel.
"""
function last_syllable(text::Buckwalter)::NTuple{3,LastRecitedSyllable}
    out1 = Buckwalter(replace(text.text[end-3:end-2], "o" => ""))
    out2 = Buckwalter(replace(text.text[end-3:end-1], "o" => "")) 
    out3 = Buckwalter(replace(text.text[end-4:end-1], "o" => ""))
    return LastRecitedSyllable(out1), LastRecitedSyllable(out2), LastRecitedSyllable(out3)
end

"""
    to_number(texts::Array{LastRecitedSyllable})

Converts 
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
    vis_args::LastRecitedVisArgs=LastRecitedVisArgs())::Makie.Figure
    f = vis_args.fig_args;
    a1 = Axis(f[1, 1], 
        ylabel="Last Pronounced Syllable\n\n\n",
        title=vis_args.title,
        yticks=(unique(y1), unique(string.(x1))),
        xticks = collect(eachindex(x1))
    )
    lines!(a1, collect(eachindex(x1)), y1)

    if x2 !== nothing && x3 !== nothing
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
        hidexdecorations!(a1)
        lines!(a2, collect(eachindex(x2)), y2)
        hidexdecorations!(a2)
        lines!(a3, collect(eachindex(x3)), y3)
    elseif x2 !== nothing && x3 === nothing
        a2 = Axis(f[2, 1], 
            ylabel="3 Characters\n\n\n",
            yticks=(unique(y2), unique(string.(x2))),
            xticks = collect(eachindex(x2))
        )
        hidexdecorations!(a1)
        lines!(a2, collect(eachindex(x2)), y2)
    elseif x2 === nothing && x3 !== nothing 
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
