struct MorphologyDBFlags
    analysis::Bool
    generation::Bool
    reinflection::Bool
end

function MorphologyDBFlags(analysis, generation, reinflection)
    return MorphologyDBFlags(true, false, false)
end

mutable struct MorphologyDB
    fpath::String

    with_analysis::Bool
    with_reinflection::Bool
    with_generation::Bool
    default_key::String

    flags::MorphologyDBFlags
    defines::Dict
    defaults::Dict
    order::Union{Vector{String},Nothing}
    tokenizations::Set
    compute_feats::Set

    stem_backoffs::Dict
    prefix_hash::Dict
    suffix_hash::Dict
    stem_hash::Dict

    prefix_cat_hash::Dict
    suffix_cat_hash::Dict
    lemma_hash::Dict

    prefix_stem_compat::Dict
    stem_suffix_compat::Dict
    prefix_suffix_compat::Dict
    stem_prefix_compat::Dict
    max_prefix_size::Int64
    max_suffix_size::Int64
end

function MorphologyDB(fpath::String, flags::Vector{T}=:a) where T<:Symbol
    with_analysis = false
    with_generation = false
    with_reinflection = false
    default_key = "pos"

    for flag in flags
        if flag == :a
            with_analysis = true
        elseif flag == :g
            with_generation = true
        elseif flag == :r
            with_reinflection = true
            with_analysis = true
            with_generation = true
        else
            throw(DomainError(flag, "flags can only take :a, :g, and/or :r."))
        end
    end

    if with_analysis && with_generation
        with_reinflection = true
    end
    flags = MorphologyDBFlags(with_analysis, with_reinflection, with_generation)
    defines = Dict()
    defaults = Dict()
    order = nothing
    tokenizations = Set()
    compute_feats = Set()
    stem_backoffs = Dict()

    prefix_hash = Dict()
    suffix_hash = Dict()
    stem_hash = Dict()

    prefix_cat_hash = Dict()
    suffix_cat_hash = Dict()
    lemma_hash = Dict()

    prefix_stem_compat = Dict()
    stem_suffix_compat = Dict()
    prefix_suffix_compat = Dict()
    stem_prefix_compat = Dict()
    max_prefix_size = 0
    max_suffix_size = 0

    return MorphologyDB(fpath, with_analysis, with_generation, with_reinflection, default_key,
        flags, defines, defaults, order, tokenizations, compute_feats, stem_backoffs,
        prefix_hash, suffix_hash, stem_hash, prefix_cat_hash, suffix_cat_hash, lemma_hash,
        prefix_stem_compat, stem_suffix_compat, prefix_suffix_compat, stem_prefix_compat,
        max_prefix_size, max_suffix_size)
end

struct DatabaseParseError <: Exception
    message::String
end