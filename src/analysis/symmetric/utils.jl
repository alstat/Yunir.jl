using Distributions
using Distances
using Statistics

"""
Slicer Configuration

params:
    num_slices - number of slices
    var_slices - variability of slices, parameter for Dirichlet distribution
    dist_formula - distance metric for measuring similarity or distances of the slices
"""
struct Slicer
    num_slices::Int64
    var_slices::Union{Float64,Vector{Float64}}
    dist_formula::Distances.UnionSemiMetric
end

function show(io::IO, ::MIME"text/plain", slicer::Slicer)
    println(io, "Slicer")
    println(io, " ├ num_slices: ", slicer.num_slices)
    println(io, " ├ var_slices: ", slicer.var_slices)
    println(io, " └ dist_formula: ", typeof(slicer.dist_formula,))
end

"""
Ayah Embeddings Type

params:
    num_slices - number of slices
    var_slices - variability of slices, parameter for Dirichlet distribution
"""
struct AyahEmbeddings{T <: Union{Float32,Float64}}
    emb::Matrix{T} 
end

function show(io::IO, ::MIME"text/plain", ae::AyahEmbeddings{T}) where T
    print(io, "AyahEmbeddings{$T}, ")
    show(io, MIME("text/plain"), ae.emb)
end

# ayahs_ver = verses(tnzl_tbl[2]);
# ayahs_emb = AyahEmbeddings(emodel.encode(ayahs_ver))

"""
Midpoints Generator

params:
    n_ayahs - total number of ayahs
    n - number of samples of slices to generate
    slicer - Slicer configuration
"""
mutable struct AyahMidpoints{T <: Integer}
    midpoints::Matrix{T}
end

function show(io::IO, ::MIME"text/plain", am::AyahMidpoints{T}) where T
    print(io, "AyahMidpoints{$T}, ")
    show(io, MIME("text/plain"), am.midpoints)
end

function refine!(mp::AyahMidpoints{T})::AyahMidpoints{T} where T <: Integer
    midpoints = sort(mp.midpoints, dims=1)
    mp_size = size(midpoints)
    adjusted_midpoints = Matrix{Int64}(undef, mp_size...)
    for j in 1:mp_size[2]
        for i in 1:mp_size[1]
            if i == 1
                if midpoints[i, j] <= 1
                    adjusted_midpoints[i, j] = 2
                else
                    adjusted_midpoints[i, j] = midpoints[i, j]
                end
            else
                if midpoints[i, j] - adjusted_midpoints[i-1, j] == 0
                    adjusted_midpoints[i, j] = adjusted_midpoints[i-1, j] + 1
                elseif midpoints[i, j] - adjusted_midpoints[i-1, j] < 1
                    diff = adjusted_midpoints[i-1, j] - midpoints[i, j]
                    adjusted_midpoints[i, j] = adjusted_midpoints[i-1, j] + diff + 1
                else
                    adjusted_midpoints[i, j] = midpoints[i, j]
                end
            end
        end
    end

    mp.midpoints = adjusted_midpoints
    return mp
end

function gen_midpoints(n_ayahs::T, n::T, slicer::Slicer)::AyahMidpoints{T} where T <: Integer
    if slicer.var_slices isa Float64
        dir_samples = rand(Dirichlet(repeat([slicer.var_slices], slicer.num_slices - 1)), n)    
    else
        if slicer.num_slices != length(slicer.var_slices)
            error("Slicer.num_slices should be equal to length of Slicer.var_slices")
        else
            dir_samples = rand(Dirichlet(slicer.var_slices), n)
        end
    end

    # proportion the ayahs into slices using Dirichlet samples
    # midpoints = ceil.(n_ayahs .* dir_samples)
    # midpoints = mapslices(sort, midpoints, dims=1)
    # midpoints = Integer.(unique(midpoints, dims=2)) # drop any duplicate samples
    
    midpoints = sort(rand(DiscreteUniform(10, n_ayahs-10), slicer.num_slices - 1, n), dims=1)
    return refine!(AyahMidpoints(midpoints))
end

"""
Slices Generator

params:
    ayahs_emb - the embeddings to slice
    midpoints - the midpoints used for slicing
"""
function gen_slices(ayahs_emb::AyahEmbeddings{T}, mp::AyahMidpoints{<:Integer})::Vector{Vector{AyahEmbeddings{T}}} where T <: Union{Float32,Float64}
    ayahs_emb = ayahs_emb.emb
    midpoints = mp.midpoints
    
    slices = Vector{AyahEmbeddings{<:Union{Float32,Float64}}}[]
    mp_size = size(midpoints)
    for j in 1:mp_size[2]
        slice = AyahEmbeddings{<:Union{Float32,Float64}}[]
        for i in 1:mp_size[1]
            if i == 1
                push!(slice, AyahEmbeddings(ayahs_emb[1:(midpoints[i, j]-1),:]))
            elseif i < mp_size[1]
                push!(slice, AyahEmbeddings(ayahs_emb[midpoints[i-1, j]:(midpoints[i, j]-1),:]))
            else
                try
                    push!(slice, AyahEmbeddings(ayahs_emb[midpoints[i-1, j]:(midpoints[i, j]-1),:]))
                    push!(slice, AyahEmbeddings(ayahs_emb[midpoints[i, j]:end,:]))
                catch
                    @info "$i, $j"
                end
            end
        end
        push!(slices, slice)
    end
    return slices
end

"""
Compute Five Number Summary

five_summary(v::Vector{T}) where T<:Union{Float32,Float64}
params:
    v - data (e.g. embeddings)

five_summary(slices::Vector{Vector{Matrix{T}}}) where T<:Union{Float32,Float64}
params:
    slices - slices of data (e.g. ayah embeddings)
"""
function five_summary(v::Vector{T})::Vector{T} where T <: Union{Float32,Float64}
    sv = sort(v)

    min = minimum(sv)
    q1 = quantile(sv, 0.25)
    med = median(sv)
    q3 = quantile(sv, 0.5)
    max = maximum(sv)

    return [min, q1, med, q3, max]
end

function five_summary(
        slices::Vector{Vector{AyahEmbeddings{T}}}
        )::Vector{Vector{AyahEmbeddings{T}}} where T <: Union{Float32,Float64}
    five_nums = Vector{AyahEmbeddings{<:Union{Float32,Float64}}}[]
    for slice in slices
        five_num = AyahEmbeddings{<:Union{Float32,Float64}}[]
        for i in 1:size(slice)[1]
            push!(five_num, mapslices(five_summary, slice[i].emb, dims=1) |> AyahEmbeddings)
        end
        push!(five_nums, five_num)
    end
    return five_nums
end

struct AyahDistances{T <: Union{Float32,Float64}}
    dist::Vector{T}
    formula::Distances.UnionSemiMetric
end

function show(io::IO, ::MIME"text/plain", ae::AyahDistances{T}) where T
    print(io, "AyahDistances{$T, $(typeof(ae.formula))}, ")
    show(io, MIME("text/plain"), ae.dist)
end

"""
Circular-wise Computation of the Distance of Slices

params:
    five_nums - five number summaries
    slicer - Slicer configuration
    dist - a Distances UnionSemiMetric
"""
function fitness(five_nums::Vector{Vector{AyahEmbeddings{T}}}, slicer::Slicer)::AyahDistances{Float64} where T <: Union{Float32,Float64}
    med_idx = Int64(median(1:slicer.num_slices))
    costs = Float64[]
    for five_num in five_nums
        cost = Float64[]
        for i in 1:(med_idx-1)
            ring_dist = mean(colwise(slicer.dist_formula, five_num[i].emb, five_num[end-i+1].emb)) # dist -> 0
            cen_lower = mean(colwise(slicer.dist_formula, five_num[med_idx].emb, five_num[i].emb)) # dist -> 1 to 2
            cen_upper = mean(colwise(slicer.dist_formula, five_num[med_idx].emb, five_num[end-i+1].emb))  # dist -> 1 to 2
            
            push!(cost, ring_dist - cen_lower - cen_upper)
        end
        push!(costs, sum(cost))
    end
    return AyahDistances(costs, slicer.dist_formula)
end

"""
    Tournament Selection of Parent's Chromosome

The function selects the parent's chromosome using tournament selection

params:
    ayahs_emb - Ayah embeddings
    mp - Midpoints of the Ayah
    k - The size of samples from where the parent is chosen
"""
function selection(ayahs_emb::AyahEmbeddings{<:Union{Float32,Float64}}, mp::AyahMidpoints{T}, k::T, slicer::Slicer)::AyahMidpoints{T} where T <: Integer
    midpoints = mp.midpoints
    mp_size = size(mp.midpoints)
    sample_indices = sample(1:mp_size[2], k)

    parents = AyahMidpoints(midpoints[:, sample_indices])
    refine!(parents)
    parents_ayahs = gen_slices(ayahs_emb, parents)
    parents_fivsum = five_summary(parents_ayahs)
    parents_fit = fitness(parents_fivsum, slicer)

    # select the parent with the minimum fitness
    return AyahMidpoints(parents.midpoints[:, [sortperm(parents_fit.dist)[1]]])
end

"""
    Parent's Chromosome Crossover 

The parents chromosome are crossed-over 
"""
function crossover!(mp::AyahMidpoints{T}, rate::Float64) where T <: Integer
    mp_size = size(mp.midpoints)
    
    child1 = Vector{Int64}[]
    child2 = Vector{Int64}[]
    for i in 1:2:mp_size[2]
        if i < mp_size[2]
            x_parent = mp.midpoints[:, i]
            y_parent = mp.midpoints[:, i+1]
        else
            x_index = rand(DiscreteUniform(1, mp_size[2]-1))
            x_parent = mp.midpoints[:, x_index]
            y_parent = mp.midpoints[:, i]
        end
        pt = rand(DiscreteUniform(1, mp_size[1]-2))

        if rand() < rate        
            push!(child1, vcat(x_parent[1:(pt-1)], y_parent[pt:end]))
            push!(child2, vcat(y_parent[1:(pt-1)], x_parent[pt:end]))
        else
            push!(child1, x_parent)
            push!(child2, y_parent)
        end
    end
    return AyahMidpoints(sort(hcat(child1..., child2...), dims=1))
end

function mutate!(mp::AyahMidpoints, rate::Float64)
    mp_size = size(mp.midpoints)
    for i in 1:mp_size[2]
        if rand() < rate
            mp.midpoints[:, i] = mp.midpoints[:, i] - rand(DiscreteUniform(-2, 2), mp_size[1])
        end
    end
    
    return mp
end