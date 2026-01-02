struct Ar
    text::Union{String,Char}
end

struct Bw
    text::Union{String,Char}
end

# Make Ar and Bw iterable by delegating to their .text field
Base.iterate(x::Ar) = iterate(x.text)
Base.iterate(x::Ar, state) = iterate(x.text, state)
Base.iterate(x::Bw) = iterate(x.text)
Base.iterate(x::Bw, state) = iterate(x.text, state)

# Support length for Ar and Bw
Base.length(x::Ar) = length(x.text)
Base.length(x::Bw) = length(x.text)

# Support equality comparison
Base.:(==)(x::Ar, y::Ar) = x.text == y.text
Base.:(==)(x::Bw, y::Bw) = x.text == y.text
Base.:(==)(x::Ar, y::String) = x.text == y
Base.:(==)(x::String, y::Ar) = x == y.text
Base.:(==)(x::Bw, y::String) = x.text == y
Base.:(==)(x::String, y::Bw) = x == y.text
Base.:(==)(x::Ar, y::Char) = x.text == y
Base.:(==)(x::Char, y::Ar) = x == y.text
Base.:(==)(x::Bw, y::Char) = x.text == y
Base.:(==)(x::Char, y::Bw) = x == y.text

# Support hash for use in dictionaries and sets
Base.hash(x::Ar, h::UInt) = hash(x.text, h)
Base.hash(x::Bw, h::UInt) = hash(x.text, h)

# Support indexing
Base.getindex(x::Ar, i::Union{Int64,Vector{Int64},UnitRange{Int64}}) = getindex(x.text, i)
Base.getindex(x::Bw, i::Union{Int64,Vector{Int64},UnitRange{Int64}}) = getindex(x.text, i)
Base.firstindex(x::Ar) = firstindex(x.text)
Base.firstindex(x::Bw) = firstindex(x.text)
Base.lastindex(x::Ar) = lastindex(x.text)
Base.lastindex(x::Bw) = lastindex(x.text)