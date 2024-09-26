using Yunir
using QuranTree

struct Harakaat
    char::Union{String,Char}
    is_tanwin::Bool
end

const AR_VOWELS = [
    Harakaat(Char(0x064B)[1], true),
    Harakaat(Char(0x064C)[1], true), 
    Harakaat(Char(0x064D)[1], true),
    Harakaat(Char(0x064E)[1], false),
    Harakaat(Char(0x064F)[1], false), 
    Harakaat(Char(0x0650)[1], false), 
]

function Base.string(x::Harakaat) 
    Harakaat(string(x.char), x.is_tanwin)
end

Yunir.encode(x::Harakaat) = Harakaat(encode(string(x.char)), x.is_tanwin)

Base.occursin(x::String, y::Harakaat) = occursin(x, y.char)

function Base.broadcasted(::typeof(in), s::AbstractString, mss::Vector{Harakaat})
    return [occursin(s, ms) for ms ∈ mss]
end

const BW_VOWELS = encode.(string.(AR_VOWELS))

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
using Makie
using CairoMakie

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

### New approach
bw_texts = encode.(verses(tnzltbl[77]))

texts = String[]
for text in bw_texts
    push!(texts, split(text, " ")[end])
end
BW_VOWELS
texts

char_length = 4
text = texts[2]



lead_nchar = 1
trail_nchar = 1


vowels = Harakaat[]


struct Segment
    text::String
    harakat::Harakaat[]
end

struct Syllable
    lead_nchars::Int64
    trail_nchars::Int64
    nvowels::Int64
end

struct Rhyme
    is_quran::Bool
    last_syllable::Syllable
end

function (r::Rhyme)(texts::String)
    for text in texts
        vowel = ""; i = 0
        while vowel == ""
            try
                cond = string(text[end-i]) .∈ BW_VOWELS
                if i == 0
                    if sum(cond) > 0
                        i += 1
                        continue
                    end
                else
                    if sum(cond) > 0
                        vowel = BW_VOWELS[cond][1]
                        push!(vowels, vowel)
                    else
                        i += 1
                        continue
                    end
                end
                i += 1
            catch
                string(text)
                continue
            end
        end
    end

    return text
end



vowels

