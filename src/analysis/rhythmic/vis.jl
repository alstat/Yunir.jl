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
Base.join(harakaat::Array{Harakaat}) = join([h.char for h in harakaat], "?")

"""
	transition(segments::Array{Segment}, type::Union{Type{Harakaat},Type{Segment}})

Extracts the transitions of the `segments` by indexing it into `x`` and `y`, where `x` is the index of the segment, and `y` is the index of its vowels or harakaat.
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

julia> transition(segments, Segment)
(["~aH?Hiy", "lam?miy"], [1, 2], Dict("~aH?Hiy" => 1, "lam?miy" => 2))

julia> transition(segments, Harakaat)
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
function transition(segments::Array{Segment}, type::Union{Type{Harakaat},Type{Segment}})
    if type == Harakaat
        syllables = [join(s.harakaat) for s in segments]
    else
        syllables = [join(s.text) for s in segments]
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
    return syllables, y_vec, y_dict 
end
