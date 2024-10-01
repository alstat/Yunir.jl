using Distributions
using CairoMakie
using QuranTree
using Yunir

crps, tnzl = load(QuranData());
crpstbl = table(crps)
tnzltbl = table(tnzl)
bw_texts1 = verses(tnzltbl[1])
bw_texts2 = verses(tnzltbl[6])

function extract_endword(s::Array{String}, idx::Int64=1)
    texts = String[]
    for text in s
        push!(texts, split(text, " ")[idx])
    end
    return texts
end


r = Rhyme(true, Syllable(1, 1, 1))
segments1 = r.(encode.(extract_endword(bw_texts1)), false)
segments2 = r.(encode.(extract_endword(bw_texts2)), false)

out1 = transition(segments1, Harakaat)
out2 = transition(segments2, Harakaat)

hist(diff(findall(x -> x == "i", out[1])))
hist(diff(findall(x -> x == "u", out[1])))

# align two rhythmic patterns
out1[1]
aout = align(join(out1[1]), join(out2[1]))
aout.alignment
plot(aout)[1]
score(aout)


####
function compute_transition_probabilities2(sequence::Vector{T}) where T
    transition_counts = Dict{Tuple{T,T}, Int}()
    state_counts = Dict{T, Int}()
    
    for (current, next) in zip(sequence, @view sequence[2:end])
        transition_counts[(current, next)] = get(transition_counts, (current, next), 0) + 1
        state_counts[current] = get(state_counts, current, 0) + 1
    end
    state_counts[sequence[end]] = get(state_counts, sequence[end], 0) + 1  # Count the last state
    
    transition_probs = Dict{Tuple{T,T}, Float64}()
    for ((from, to), count) in transition_counts
        transition_probs[(from, to)] = count / state_counts[from]
    end
    
    return transition_probs
end
# Example usage
sequence = out1[1]
probs = compute_transition_probabilities2(sequence)
probs
# Print results
for ((from, to), prob) in sort(collect(probs))
    println("$from -> $to: $prob")
end

#----------------
using Graphs
using GraphMakie
using Colors
using CairoMakie

function visualize_transition_probabilities(probs::Dict{Tuple{T,T}, Float64}, resolution=(500, 500)) where T
    # Extract unique states
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

# Example usage
sequence = out1[1]#["a", "i", "a", "i", "u", "u", "u", "i", "i", "u", "u", "i", "i", "i", "i", "u", "i", "i", "i", "N"]

# Reuse the compute_transition_probabilities function from earlier
function compute_transition_probabilities(sequence::Vector{T}) where T
    transition_counts = Dict{Tuple{T,T}, Int}()
    state_counts = Dict{T, Int}()
    
    for (current, next) in zip(sequence, @view sequence[2:end])
        transition_counts[(current, next)] = get(transition_counts, (current, next), 0) + 1
        state_counts[current] = get(state_counts, current, 0) + 1
    end
    state_counts[sequence[end]] = get(state_counts, sequence[end], 0) + 1
    
    transition_probs = Dict{Tuple{T,T}, Float64}()
    for ((from, to), count) in transition_counts
        transition_probs[(from, to)] = count / state_counts[from]
    end
    
    return transition_probs
end

probs = compute_transition_probabilities(sequence)
visualize_transition_probabilities(probs)

println("Graph has been saved as 'transition_probabilities_graph.png'")


