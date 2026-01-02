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

# String conversion
Base.string(x::Ar) = string(x.text)
Base.string(x::Bw) = string(x.text)
Base.String(x::Ar) = String(x.text)
Base.String(x::Bw) = String(x.text)

# Display methods
Base.show(io::IO, x::Ar) = print(io, "Ar(\"", x.text, "\")")
Base.show(io::IO, x::Bw) = print(io, "Bw(\"", x.text, "\")")
Base.print(io::IO, x::Ar) = print(io, x.text)
Base.print(io::IO, x::Bw) = print(io, x.text)

# String operations - occursin
Base.occursin(needle::AbstractString, haystack::Ar) = occursin(needle, haystack.text)
Base.occursin(needle::AbstractString, haystack::Bw) = occursin(needle, haystack.text)
Base.occursin(needle::Ar, haystack::AbstractString) = occursin(needle.text, haystack)
Base.occursin(needle::Bw, haystack::AbstractString) = occursin(needle.text, haystack)
Base.occursin(needle::Ar, haystack::Ar) = occursin(needle.text, haystack.text)
Base.occursin(needle::Bw, haystack::Bw) = occursin(needle.text, haystack.text)
Base.occursin(needle::Char, haystack::Ar) = occursin(needle, haystack.text)
Base.occursin(needle::Char, haystack::Bw) = occursin(needle, haystack.text)
Base.occursin(needle::Regex, haystack::Ar) = occursin(needle, haystack.text)
Base.occursin(needle::Regex, haystack::Bw) = occursin(needle, haystack.text)

# contains (modern Julia alias for occursin)
Base.contains(haystack::Ar, needle) = occursin(needle, haystack.text)
Base.contains(haystack::Bw, needle) = occursin(needle, haystack.text)

# String splitting
Base.split(x::Ar, dlm; kwargs...) = split(x.text, dlm; kwargs...)
Base.split(x::Bw, dlm; kwargs...) = split(x.text, dlm; kwargs...)

# String replacement
Base.replace(x::Ar, pat_repl::Pair...; kwargs...) = Ar(String(replace(x.text, pat_repl...; kwargs...)))
Base.replace(x::Bw, pat_repl::Pair...; kwargs...) = Bw(String(replace(x.text, pat_repl...; kwargs...)))

# Prefix/suffix checking
Base.startswith(x::Ar, prefix::Union{AbstractString,Char}) = startswith(x.text, prefix)
Base.startswith(x::Bw, prefix::Union{AbstractString,Char}) = startswith(x.text, prefix)
Base.endswith(x::Ar, suffix::Union{AbstractString,Char}) = endswith(x.text, suffix)
Base.endswith(x::Bw, suffix::Union{AbstractString,Char}) = endswith(x.text, suffix)

# Whitespace stripping
Base.strip(x::Ar; kwargs...) = Ar(String(strip(x.text; kwargs...)))
Base.strip(x::Bw; kwargs...) = Bw(String(strip(x.text; kwargs...)))
Base.lstrip(x::Ar; kwargs...) = Ar(String(lstrip(x.text; kwargs...)))
Base.lstrip(x::Bw; kwargs...) = Bw(String(lstrip(x.text; kwargs...)))
Base.rstrip(x::Ar; kwargs...) = Ar(String(rstrip(x.text; kwargs...)))
Base.rstrip(x::Bw; kwargs...) = Bw(String(rstrip(x.text; kwargs...)))

# Case conversion
Base.uppercase(x::Ar) = Ar(String(uppercase(x.text)))
Base.uppercase(x::Bw) = Bw(String(uppercase(x.text)))
Base.lowercase(x::Ar) = Ar(String(lowercase(x.text)))
Base.lowercase(x::Bw) = Bw(String(lowercase(x.text)))
Base.uppercasefirst(x::Ar) = Ar(String(uppercasefirst(x.text)))
Base.uppercasefirst(x::Bw) = Bw(String(uppercasefirst(x.text)))
Base.lowercasefirst(x::Ar) = Ar(String(lowercasefirst(x.text)))
Base.lowercasefirst(x::Bw) = Bw(String(lowercasefirst(x.text)))

# String concatenation
Base.:*(x::Ar, y::Ar) = Ar(String(x.text * y.text))
Base.:*(x::Bw, y::Bw) = Bw(String(x.text * y.text))
Base.:*(x::Ar, y::AbstractString) = Ar(String(x.text * y))
Base.:*(x::Bw, y::AbstractString) = Bw(String(x.text * y))
Base.:*(x::AbstractString, y::Ar) = Ar(String(x * y.text))
Base.:*(x::AbstractString, y::Bw) = Bw(String(x * y.text))

# String repetition
Base.:^(x::Ar, n::Integer) = Ar(String(x.text ^ n))
Base.:^(x::Bw, n::Integer) = Bw(String(x.text ^ n))

# Empty check
Base.isempty(x::Ar) = isempty(x.text)
Base.isempty(x::Bw) = isempty(x.text)

# String internals
Base.ncodeunits(x::Ar) = ncodeunits(x.text)
Base.ncodeunits(x::Bw) = ncodeunits(x.text)
Base.codeunit(x::Ar) = codeunit(x.text)
Base.codeunit(x::Bw) = codeunit(x.text)
Base.codeunit(x::Ar, i::Integer) = codeunit(x.text, i)
Base.codeunit(x::Bw, i::Integer) = codeunit(x.text, i)

# String reversal
Base.reverse(x::Ar) = Ar(String(reverse(x.text)))
Base.reverse(x::Bw) = Bw(String(reverse(x.text)))

# Regex matching
Base.match(r::Regex, x::Ar, idx::Integer=1) = match(r, x.text, idx)
Base.match(r::Regex, x::Bw, idx::Integer=1) = match(r, x.text, idx)
Base.eachmatch(r::Regex, x::Ar; kwargs...) = eachmatch(r, x.text; kwargs...)
Base.eachmatch(r::Regex, x::Bw; kwargs...) = eachmatch(r, x.text; kwargs...)

# Find operations
Base.findfirst(pattern, x::Ar) = findfirst(pattern, x.text)
Base.findfirst(pattern, x::Bw) = findfirst(pattern, x.text)
Base.findlast(pattern, x::Ar) = findlast(pattern, x.text)
Base.findlast(pattern, x::Bw) = findlast(pattern, x.text)
Base.findnext(pattern, x::Ar, start::Integer) = findnext(pattern, x.text, start)
Base.findnext(pattern, x::Bw, start::Integer) = findnext(pattern, x.text, start)
Base.findprev(pattern, x::Ar, start::Integer) = findprev(pattern, x.text, start)
Base.findprev(pattern, x::Bw, start::Integer) = findprev(pattern, x.text, start)
Base.findall(pattern, x::Ar) = findall(pattern, x.text)
Base.findall(pattern, x::Bw) = findall(pattern, x.text)

# Comparison operations
Base.cmp(x::Ar, y::Ar) = cmp(x.text, y.text)
Base.cmp(x::Bw, y::Bw) = cmp(x.text, y.text)
Base.cmp(x::Ar, y::AbstractString) = cmp(x.text, y)
Base.cmp(x::Bw, y::AbstractString) = cmp(x.text, y)
Base.cmp(x::AbstractString, y::Ar) = cmp(x, y.text)
Base.cmp(x::AbstractString, y::Bw) = cmp(x, y.text)
Base.isless(x::Ar, y::Ar) = isless(x.text, y.text)
Base.isless(x::Bw, y::Bw) = isless(x.text, y.text)
Base.isless(x::Ar, y::AbstractString) = isless(x.text, y)
Base.isless(x::Bw, y::AbstractString) = isless(x.text, y)
Base.isless(x::AbstractString, y::Ar) = isless(x, y.text)
Base.isless(x::AbstractString, y::Bw) = isless(x, y.text)

# SubString support
Base.SubString(x::Ar, i::Integer, j::Integer=lastindex(x)) = SubString(x.text, i, j)
Base.SubString(x::Bw, i::Integer, j::Integer=lastindex(x)) = SubString(x.text, i, j)
Base.SubString(x::Ar, r::UnitRange{<:Integer}) = SubString(x.text, r)
Base.SubString(x::Bw, r::UnitRange{<:Integer}) = SubString(x.text, r)

# Joining support (for arrays of Ar/Bw)
Base.join(strings::AbstractVector{Ar}, delim::AbstractString="") = join([s.text for s in strings], delim)
Base.join(strings::AbstractVector{Bw}, delim::AbstractString="") = join([s.text for s in strings], delim)
Base.join(io::IO, strings::AbstractVector{Ar}, delim::AbstractString="") = join(io, [s.text for s in strings], delim)
Base.join(io::IO, strings::AbstractVector{Bw}, delim::AbstractString="") = join(io, [s.text for s in strings], delim)