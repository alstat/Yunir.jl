# include("../../constants.jl")

using Makie
using CairoMakie
using QuranTree
using Yunir

struct Syllables
    char_idx1::Int64
    char_idx2::Int64
end

struct Rhyme
    texts::Vector{String}
    syllables_indices::Syllables
end

function last_syllables(r::Rhyme)
    syllables = Vector{String}()
    for texts in r.texts
        push!(syllables, texts[(end-r.syllables_indices.char_idx2):(end-r.syllables_indices.char_idx1)])
    end
    return syllables
end

function transition(r::Rhyme)
    syllables = last_syllables(r)
    y = unique(syllables)
    y_dict = Dict{String,Int64}()
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
    y_vec = Vector{Int64}()
    for i in syllables
        push!(y_vec, y_dict[i])
    end
    return y_vec, y_dict 
end


crps, tnzl = load(QuranData());
crpstbl = table(crps)
tnzltbl = table(tnzl)

# -----------------
# Surah Al-Fatihah
# -----------------
bw_texts = encode.(verses(tnzltbl[1]))

r = Rhyme(replace.(bw_texts, "o" => ""), Syllables(1, 4))
y, ydict = transition(r)

# plotting

f = Figure(resolution=(500, 500));
a1 = Axis(f[1,1], 
    xlabel="Ayah Number",
    ylabel="Last Pronounced Syllable\n\n\n",
    title="Surah Al-Fatihah Rhythmic Patterns\n\n",
    yticks=(unique(y), unique(last_syllables(r))), 
    xticks = collect(eachindex(last_syllables(r)))
)
lines!(a1, collect(eachindex(last_syllables(r))), y)
f