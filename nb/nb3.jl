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

struct Segment
    text::String
    harakat::Array{Harakaat}
end

struct Syllable{T <: Number}
    lead_nchars::T
    trail_nchars::T
    nvowels::T
end

struct Rhyme
    is_quran::Bool
    last_syllable::Syllable
end


function count_vowels(text::String, vowels::Array{Harakaat}=BW_VOWELS)
    jvowels = join([c.char for c in vowels])
    return count(c -> c in jvowels, text)
end

function vowel_indices(s::String, vowels::Array{Harakaat}=BW_VOWELS)
    jvowels = join([c.char for c in vowels])
    return findall(c -> c in jvowels, s)
end

function (r::Rhyme)(text::String)
    vowel_idcs = vowel_indices(text)
    harakaat = Harakaat[]
    segment_text = ""

    if r.is_quran
        cond = string(text[end]) .∈ BW_VOWELS
        silent_vowel = sum(cond)
        penalty = sum(cond) < 1 ? 1 : 0 
    end

    uplimit = r.last_syllable.nvowels > (count_vowels(text) - silent_vowel) ? (count_vowels(text) - silent_vowel) : r.last_syllable.nvowels
    for i in 0:uplimit - silent_vowel - penalty
        vowel_idx = vowel_idcs[end - i - silent_vowel]
        cond = string(text[vowel_idx]) .∈ BW_VOWELS
        if sum(cond) > 0
            push!(harakaat, BW_VOWELS[cond][1])
            
            lead_length = length(text[1:(vowel_idx-1)])
            trail_length = length(text[(vowel_idx+1):end])

            lead_nchars_lwlimit = lead_length > r.last_syllable.lead_nchars ? r.last_syllable.lead_nchars : lead_length
            trail_nchars_uplimit = trail_length > r.last_syllable.trail_nchars ? r.last_syllable.trail_nchars : trail_length
            vowel = text[vowel_idx]

            lead_text = text[(vowel_idx-lead_nchars_lwlimit):(vowel_idx-1)]
            trail_text = text[(vowel_idx+1):(vowel_idx+trail_nchars_uplimit)]

            if i == 0
                segment_text = lead_text * vowel * trail_text
            else
                segment_text = lead_text * vowel * trail_text * "?" * segment_text
            end
        else
            continue
        end
    end
    return Segment(segment_text, reverse(harakaat))
end

crps, tnzl = load(QuranData());
crpstbl = table(crps)
tnzltbl = table(tnzl)
bw_texts = encode.(verses(tnzltbl))

texts = String[]
for text in bw_texts
    push!(texts, split(text, " ")[end])
end
arabic.(texts)

r = Rhyme(true, Syllable(1, 1, 3))
segments = r.(texts)

[arabic(o.text) for o in out]