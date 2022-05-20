import Base: parse
struct SimpleEncoding end

function parse(::Type{Orthography}, s::String)
    parsed = []
    for c in s
        push!(parsed, ORTHOGRAPHY_TYPES[Symbol(c)])
    end
    return Orthography(parsed)
end

function parse(::Type{SimpleEncoding}, s::String)
    words = ""; i = 1
    for c in s
        if c === ' '
            words *= " | <space>"
        else
            words *= encode(SIMPLE_ENCODING, c, i)
        end
        i += 1
    end
    return words
end

function encode(encoder::Dict, c::Union{Char,String}, i::Int64)
    if in(Symbol(c), AR_DIACS)
        return string("+", encoder[Symbol(c)])
    else
        if i > 1
            return string(" | ", encoder[Symbol(c)])
        else
            return string(encoder[Symbol(c)])
        end
    end
end