using Distances

using Yunir

# to be removed in deps
using PyCall
using QuranTree

model_path = "/Users/al-ahmadgaidasaad/Documents/School/Islamic Studies/ma-thesis-codes/models/CL-Arabert"
sentence_transformers = pyimport("sentence_transformers")
emodel = sentence_transformers.SentenceTransformer(model_path);



_, tnzl = load(QuranData());
tnzl_tbl = table(tnzl)

ayahs_ver = verses(tnzl_tbl[2]);
ayahs_emb = AyahEmbeddings(emodel.encode(ayahs_ver))

slicer = Slicer(9, 1.5, CosineDist())
midpoints = gen_midpoints(size(ayahs_emb.emb)[1], 1000, slicer)
slices = gen_slices(ayahs_emb, midpoints)
slices[1]
five_nums = five_summary(slices);
five_nums[1]
five_nums[1][2]
colwise(CosineDist(), five_nums[1][1].emb, five_nums[1][end].emb)
fitness(five_nums, slicer)
selection(ayahs_emb, midpoints, 3, slicer)
selected = Yunir.AyahMidpoints(hcat([selection(ayahs_emb, midpoints, 3, slicer).midpoints for _ in 1:1000]...))
crossover!(selected, 0.8)
mutate!(selected, 0.8)
refine!(selected)

function extract_data(data::DataFrame) 
    return data
end
