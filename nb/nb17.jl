using Yunir
using PyCall
using Distances
using QuranTree
using Random
using Statistics
Random.seed!(123)

sentence_transformers = pyimport("sentence_transformers")
generations = 50
population = 1_000
slicer = Slicer(7, 1., CosineDist())
model_path = "/Users/al-ahmadgaidasaad/Documents/School/Islamic Studies/ma-thesis-codes/models/CL-Arabert"
emodel = sentence_transformers.SentenceTransformer(model_path);

_, tnzl = load(QuranData());
tnzl_tbl = table(tnzl)


ayahs_ver = verses(tnzl_tbl[2]);
ayahs_emb = AyahEmbeddings(emodel.encode(ayahs_ver))
first_gen = gen_midpoints(size(ayahs_emb.emb)[1], population, slicer)

scores = Float64[]
childrens = AyahMidpoints(copy(first_gen.midpoints))
for generation in 1:generations
    @info "Generation $generation"
    childrens = AyahMidpoints(
        hcat(
            [selection(ayahs_emb, childrens, 3, slicer).midpoints for _ in 1:population]...
        )
    )
    crossover!(childrens, 0.8)
    mutate!(childrens, 0.8)
    refine!(childrens)
    score = fitness(
        five_summary(
            gen_slices(ayahs_emb, childrens)
            ), 
        slicer
    ).dist |> mean
    push!(scores, score)
    @show score
end
