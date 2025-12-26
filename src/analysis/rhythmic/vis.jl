@enum VisType last_recited schimiller

abstract type AbstractRhythmicVisArgs end;
abstract type AbstractSyllable end;
struct RhythmicVis{T} where T <: AbstractRhythmicVisArgs
	type::VisType
    args::T
end

struct LastRecitedVisArgs <: AbstractRhythmicVisArgs
    fig_args::Figure
    title::String
end
LastRecitedVisArgs() = LastRecitedVisArgs(Figure(resolution=(800, 800)), "")

struct LastRecitedSyllable <: AbstractSyllable
    syllable::Buckwalter
end

function (r::RhythmicVis)(texts::Array{Buckwalter})
	if r.type == last_recited
        y1_chars, y2_chars, y3_chars = last_syllable.(texts)
        y1, y1_dict = encode_to_number(y1_chars)
        y2, y2_dict = encode_to_number(y2_chars)
        y3, y3_dict = encode_to_number(y3_chars)
	end
end

"""
    last_syllable(text::Buckwalter)

Extracts the last recited syllable from one to two characters prior and after the said vowel.
"""
function last_syllable(text::Buckwalter)::Tuple{Buckwalter,Buckwalter,Buckwalter}
    out1 = Buckwalter(replace(text[end-3:end-2], "o" => ""))
    out2 = Buckwalter(replace(text[end-3:end-1], "o" => ""))
    out3 = Buckwalter(replace(text[end-4:end-1], "o" => ""))
    return LastRecitedSyllable(out1), LastRecitedSyllable(out2), LastRecitedSyllable(out3)
end

"""
    to_number(texts::Array{LastRecitedSyllable})

Converts 
"""
function to_number(texts::Array{LastRecitedSyllable})
    y = unique(map(x -> x.syllable.text, texts))
    y_dict = Dict()
    for i in eachindex(y)
        if i == 1
            y_dict[y[i]] = i
        end
        
        if y[i] .∈ Ref(Set(keys(y_dict)))
            continue
        else
            y_dict[y[i]] = i
        end
    end
    y_vec = Array{Int64,1}()
    for i in ychars
        push!(y_vec, y_dict[i])
    end
    return y_vec, y_dict # scaling to 100 since algo will fail saying range step cannot 0
end

bw_texts = verses(crps_tbl[1])
y1_chars, y2_chars, y3_chars = last_syllable(bw_texts)
y1, y1_dict = encode_to_number(y1_chars)
y2, y2_dict = encode_to_number(y2_chars)
y3, y3_dict = encode_to_number(y3_chars)

function vis(x1::Array{String,1}, y1::Array{Int64,1}; 
    x2::Union{Nothing,Array{String,1}}=nothing, 
    x3::Union{Nothing,Array{String,1}}=nothing, 
    y2::Union{Nothing,Array{Int64,1}}=nothing, 
    y3::Union{Nothing,Array{Int64,1}}=nothing, 
    vis_args::LastRecitedVisArgs)
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
