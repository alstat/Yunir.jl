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

crps, tnzl = load(QuranData());
crpstbl = table(crps)
tnzltbl = table(tnzl)

# -----------------
# Surah Al-Fatihah
# -----------------

### New approach
struct Segment
    text::String
    harakat::Array{Harakaat}
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


function count_vowels(text, vowels=BW_VOWELS)
    jvowels = join([c.char for c in vowels])
    return count(c -> c in jvowels, text)
end

function (r::Rhyme)(text::String, verbose::Bool=false)
    segments = Segment[]
    segment = Harakaat[]; i = 0; j = 0
    segment_text = ""
    
    if r.is_quran
        cond = string(text[end]) .∈ BW_VOWELS
        silent_vowel = sum(cond)
    end
    
    uplimit = r.last_syllable.nvowels > (count_vowels(text) - silent_vowel) ? (count_vowels(text) - 1) : r.last_syllable.nvowels
    while length(segment) < uplimit
        try
            cond = string(text[end-i]) .∈ BW_VOWELS
            if i == 0
                if sum(cond) > 0
                    i += 1
                    continue
                end
                i += 1
            else
                if sum(cond) > 0
                    push!(segment, BW_VOWELS[cond][1])
                    j += 1

                    # todo: this will go out of bounce for big lead or trail nchars
                    lead_chars = join([text[end-i-k] for k in 1:r.last_syllable.lead_nchars])
                    trail_chars = join([text[end-i+k] for k in 1:r.last_syllable.trail_nchars])
                    new_segment = lead_chars * segment[j].char * trail_chars

                    if j < 2
                        segment_text = new_segment * segment_text
                    else 
                        segment_text = new_segment * "?" * segment_text
                    end
                    push!(segments, Segment(segment_text, segment))
                else
                    i += 1 
                    continue
                end
                i += 1 
            end
        catch
            string(text)
            continue
        end
    end

    if verbose
        return segments
    else
        return segments[end]
    end
end

bw_texts = encode.(verses(tnzltbl[1]))

texts = String[]
for text in bw_texts
    push!(texts, split(text, " ")[end])
end
texts
text = texts[1]
count_vowels(text)
r = Rhyme(true, Syllable(1, 1, 2))


r.(texts)
