# Conda.pip_interop(true)
# Conda.pip("install", "sentence-transformers")
# Conda.pip("install", "torch")
using PyCall
using Distances
using QuranTree
using Yunir

crps, tnzl = load(QuranData());
crps_tbl, tnzl_tbl = table(crps), table(tnzl)

sentence_transformers = pyimport("sentence_transformers")
torch = pyimport("torch")
model = sentence_transformers.SentenceTransformer("MatMulMan/CL-AraBERTv0.1-base-33379-arabic_tydiqa")

"""
    get_embeddings(sentences)

Takes a list of Arabic sentences and returns their embeddings as a Julia matrix.
"""
function get_embeddings(sentences)
    py_embeddings = model.encode(sentences, convert_kwargs=Dict("normalize_embeddings" => true))
    return hcat(py_embeddings...)'  # Convert Python list of tensors to Julia matrix
end

v1 = get_embeddings(verses(tnzl_tbl[1])[1])
v2 = get_embeddings(verses(tnzl_tbl[1])[2])

# 



cosine_similarity(v1, v2)

cosine_similarity(v1, v2)
"""
    cosine_similarity(vec1, vec2)

Computes the cosine similarity between two vectors.
"""
function cosine_similarity(vec1, vec2)
    return 1 - cosine_dist(vec1, vec2)  # Distances.jl defines cosine distance (1 - similarity)
end



"""
    extract_ring_structure(verses)

Identifies mirrored verse pairs and detects a central axis if a chiastic pattern exists.
"""
function extract_ring_structure(verses)
    # Get embeddings
    embeddings = get_embeddings(verses)

    n = size(embeddings, 1)  # Number of verses
    mirrored_pairs = []

    # Check mirrored similarities
    for i in 1:div(n, 2)
        j = n - i + 1
        similarity = cosine_similarity(embeddings[i, :], embeddings[j, :])
        
        if similarity > 0.8  # Threshold for mirroring
            push!(mirrored_pairs, (i, j))
        end
    end

    # Find central verse if n is odd
    center = n % 2 == 1 ? div(n, 2) + 1 : nothing

    return mirrored_pairs, center
end

# Example Arabic verses (Surah snippet)
vrs = [
    "بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ",
    "ذَٰلِكَ الْكِتَابُ لَا رَيْبَ ۛ فِيهِ",
    "اللَّهُ نُورُ السَّمَاوَاتِ وَالْأَرْضِ",
    "فَاتَّبِعُونِي يُحْبِبْكُمُ اللَّهُ",
    "ذَٰلِكَ الْكِتَابُ لَا رَيْبَ ۛ فِيهِ",
    "بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ"
]


get_embeddings(vrs)

# Run the chiastic structure detection
mirrored_sections, central_axis = extract_ring_structure(vrs)

println("Mirrored Sections: ", mirrored_sections)
println("Central Axis: ", central_axis)
