using Colors
using CairoMakie
using GraphMakie
using Graphs
using Makie

"""
	join(harakaat::Array{Harakaat})

Join function for handling `Harakaat` object. It joins the harakaat together with `?` separator.

```julia-repl
julia> ar_raheem = "ٱلرَّحِيمِ"
"ٱلرَّحِيمِ"

julia> r = Rhyme(true, Syllable(1, 2, 2))
Rhyme(true, Syllable{Int64}(1, 2, 2))

julia> output = r(ar_raheem, true)
Segment("َّحِ?حِيم", Harakaat[Harakaat("َ", false), Harakaat("ِ", false)])

julia> join(encode(output).harakaat)
"a?i"
```
"""
Base.join(harakaat::Array{Harakaat}, delim::String="?") = join([h.char for h in harakaat], delim)


"""
    Sequence(sequence::Vector{String}, y_axis::Vector{Int64})

Create a `Sequence` object for the rhythmic `sequence` data, with  `y_axis` as its y-axis ticks for plotting.
"""
struct Sequence
    sequence::Vector{String}    
    yaxis::Vector{Int64}
end

"""
	sequence(segments::Array{Segment}, type::Union{Type{Harakaat},Type{Segment}})

Extracts the sequence of the `segments` by indexing it into `x`` and `y`, where `x` is the index of the segment, and `y` is the index of its vowels or harakaat.
It returns a tuple containing the following `y`, `y_dict` (the mapping dictionary with key represented by `x` and value represented by `y`), `syllables` represented by `x`.

```julia-repl
julia> ar_raheem_alamiyn = ["ٱلرَّحِيمِ", "ٱلْعَٰلَمِينَ"]
2-element Vector{String}:
 "ٱلرَّحِيمِ"
 "ٱلْعَٰلَمِينَ"

julia> r = Rhyme(true, Syllable(1, 1, 2))
Rhyme(true, Syllable{Int64}(1, 1, 2))

julia> segments = encode.(r.(ar_raheem_alamiyn, true))
2-element Vector{Segment}:
 Segment("~aH?Hiy", Harakaat[Harakaat("a", false), Harakaat("i", false)])
 Segment("lam?miy", Harakaat[Harakaat("a", false), Harakaat("i", false)])

julia> sequence(segments, Segment)
(["~aH?Hiy", "lam?miy"], [1, 2], Dict("~aH?Hiy" => 1, "lam?miy" => 2))

julia> sequence(segments, Harakaat)
(["a?i", "a?i"], [1, 1], Dict("a?i" => 1))

julia> syllables, y_vec, y_dict = transition(segments, Harakaat)
(["a?i", "a?i"], [1, 1], Dict("a?i" => 1))

julia> using Makie

julia> using CairoMakie

julia> f = Figure(resolution=(500, 500));

julia> a1 = Axis(f[1,1], 
           xlabel="Ayah Number",
           ylabel="Last Pronounced Syllable\n\n\n",
           title="Surah Al-Fatihah Rhythmic Patterns\n\n",
           yticks=(unique(y_vec), unique(syllables)), 
       )
Axis with 1 plots:
 ┗━ Mesh{Tuple{GeometryBasics.Mesh{3, Float32, GeometryBasics.TriangleP{3, Float32, GeometryBasics.PointMeta{3, Float32, Point{3, Float32}, (:normals,), Tuple{Vec{3, Float32}}}}, GeometryBasics.FaceView{GeometryBasics.TriangleP{3, Float32, GeometryBasics.PointMeta{3, Float32, Point{3, Float32}, (:normals,), Tuple{Vec{3, Float32}}}}, GeometryBasics.PointMeta{3, Float32, Point{3, Float32}, (:normals,), Tuple{Vec{3, Float32}}}, GeometryBasics.NgonFace{3, GeometryBasics.OffsetInteger{-1, UInt32}}, StructArrays.StructVector{GeometryBasics.PointMeta{3, Float32, Point{3, Float32}, (:normals,), Tuple{Vec{3, Float32}}}, @NamedTuple{position::Vector{Point{3, Float32}}, normals::Vector{Vec{3, Float32}}}, Int64}, Vector{GeometryBasics.NgonFace{3, GeometryBasics.OffsetInteger{-1, UInt32}}}}}}}


julia> lines!(a1, collect(eachindex(syllables)), y_vec)
Lines{Tuple{Vector{Point{2, Float32}}}}

julia> f
```
"""
function sequence(segments::Array{Segment}, type::Union{Type{Harakaat},Type{Segment}})
    if type == Harakaat
        syllables = [join(s.harakaat) for s in segments]
    else
        syllables = [join(s.segment) for s in segments]
    end

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
    return Sequence(syllables, y_vec)
end

function transition(seq::Sequence)
    seq = seq.sequence
    transition_counts = Dict{Tuple{String,String}, Int}()
    state_counts = Dict{String, Int}()
    
    for (current, next) in zip(seq, @view seq[2:end])
        transition_counts[(current, next)] = get(transition_counts, (current, next), 0) + 1
        state_counts[current] = get(state_counts, current, 0) + 1
    end
    state_counts[seq[end]] = get(state_counts, seq[end], 0) + 1  # Count the last state
    
    transition_probs = Dict{Tuple{String,String}, Float64}()
    for ((from, to), count) in transition_counts
        transition_probs[(from, to)] = count / state_counts[from]
    end
    
    return transition_probs
end

function GraphMakie.graphplot(probs::Dict{Tuple{String,String}, Float64}, resolution=(500, 500))
    states = unique(vcat(first.(keys(probs)), last.(keys(probs))))
    n = length(states)
    
    # Create a mapping from states to indices
    state_to_index = Dict(state => i for (i, state) in enumerate(states))
    index_to_state = Dict(i => state for (state, i) in state_to_index)
    
    # Create the graph
    g = DiGraph(n)
    
    # Add edges and calculate edge weights
    edge_weights = Float64[]
    for ((from, to), prob) in probs
        add_edge!(g, state_to_index[from], state_to_index[to])
        push!(edge_weights, prob)
    end
    
    # Create the plot
    f = Figure(resolution = resolution)
    ax = Axis(f[1,1])
    
    # Use the actual state labels for nlabels
    nlabels = [string(index_to_state[i]) for i in 1:nv(g)]
    
    # Create edge labels (probabilities)
    distances = collect(0.05:0.05:ne(g)*0.05)
    elabels = repr.(round.(distances, digits=2))
    # elabels = [string(round(w, digits=2)) for w in edge_weights]
    
    # Create the graph plot
    graphplot!(ax, g;
               curve_distance=distances,
               nlabels = nlabels,
               nlabels_align = (:center, :center),
               nlabels_textsize = 14,
               node_size = 30,
               node_color = :lightblue,
               edge_width = 2 .* sqrt.(edge_weights ./ maximum(edge_weights)) .+ 1,
               edge_color = [RGB((w/maximum(edge_weights)), 0, 1-(w/maximum(edge_weights))) for w in edge_weights],
               elabels_textsize = 12,
               elabels_align = (:center, :center),
               arrow_size = 15,
               elabels = elabels)
    
    hidedecorations!(ax)
    hidespines!(ax)
    ax.aspect = DataAspect()
    
    return f
end