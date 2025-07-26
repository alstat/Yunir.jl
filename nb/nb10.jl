using PyCall, Distances, Clustering, LinearAlgebra, StatsBase, QuranTree, Yunir

# Load Python libraries using PyCall
sentence_transformers = pyimport("sentence_transformers")
torch = pyimport("torch")
np = pyimport("numpy")
sklearn_cluster = pyimport("sklearn.cluster")
umap = pyimport("umap")

# Load the embedding model (your existing code)
model = sentence_transformers.SentenceTransformer("MatMulMan/CL-AraBERTv0.1-base-33379-arabic_tydiqa")

"""
    get_embeddings(sentences)

Takes a list of Arabic sentences and returns their embeddings as a Julia matrix.
"""
function get_embeddings(sentences)
    py_embeddings = model.encode(sentences, convert_to_numpy=true, normalize_embeddings=true)
    return py_embeddings  # Return as numpy array for easier clustering
end

"""
    perform_topic_modeling(documents, num_topics=10, method="kmeans")

Performs topic modeling on a list of Arabic documents using embeddings from the BERT model.
Returns cluster assignments and centroids.

Parameters:
- documents: List of Arabic texts
- num_topics: Number of topics to extract
- method: Clustering method ("kmeans" or "dbscan")

Returns:
- topic_assignments: Array of topic IDs for each document
- topic_centroids: Matrix of topic centroids
"""
function perform_topic_modeling(documents, num_topics=10, method="kmeans")
    # Get document embeddings
    embeddings = get_embeddings(documents)
    
    # Apply clustering based on selected method
    if method == "kmeans"
        # K-means clustering
        kmeans = sklearn_cluster.KMeans(n_clusters=num_topics, random_state=42)
        topic_assignments = kmeans.fit_predict(embeddings)
        topic_centroids = kmeans.cluster_centers_
    elseif method == "dbscan"
        # DBSCAN clustering (doesn't need num_topics)
        dbscan = sklearn_cluster.DBSCAN(eps=0.5, min_samples=5)
        topic_assignments = dbscan.fit_predict(embeddings)
        
        # Calculate centroids for each cluster
        unique_clusters = unique(topic_assignments)
        topic_centroids = zeros(length(unique_clusters), size(embeddings, 2))
        
        for (i, cluster) in enumerate(unique_clusters)
            if cluster == -1  # noise points in DBSCAN
                continue
            end
            cluster_points = embeddings[topic_assignments .== cluster, :]
            topic_centroids[i, :] = mean(cluster_points, dims=1)
        end
    else
        error("Unsupported clustering method: $method")
    end
    
    return topic_assignments, topic_centroids
end

"""
    extract_topic_keywords(documents, topic_assignments, num_topics, top_n=10)

Extract representative keywords for each topic using TF-IDF.
This is a simple approach - for better results, you might want to use a Python library.

Parameters:
- documents: List of Arabic texts
- topic_assignments: Array of topic IDs for each document
- num_topics: Number of topics
- top_n: Number of keywords to extract per topic

Returns:
- topic_keywords: Dictionary mapping topic IDs to lists of keywords
"""
function extract_topic_keywords(documents, topic_assignments, num_topics, top_n=10)
    # Use Python's scikit-learn for TF-IDF
    sklearn_feature_extraction = pyimport("sklearn.feature_extraction.text")
    
    # Create TF-IDF vectorizer
    vectorizer = sklearn_feature_extraction.TfidfVectorizer(max_features=5000)
    X = vectorizer.fit_transform(documents)
    feature_names = vectorizer.get_feature_names_out()
    
    # Extract top words for each topic
    topic_keywords = Dict()
    
    for topic_id in 0:(num_topics-1)  # Python's clusters are 0-indexed
        # Get documents in this topic
        topic_docs = findall(x -> x == topic_id, topic_assignments)
        
        if isempty(topic_docs)
            topic_keywords[topic_id] = []
            continue
        end
        
        # Calculate average TF-IDF scores for this topic
        topic_tfidf = mean(X[topic_docs, :], dims=1)
        
        # Get indices of top words
        top_indices = sortperm(vec(topic_tfidf), rev=true)[1:min(top_n, length(feature_names))]
        
        # Get the actual words
        topic_keywords[topic_id] = [feature_names[i] for i in top_indices]
    end
    
    return topic_keywords
end

"""
    visualize_topics(embeddings, topic_assignments)

Creates a 2D visualization of topics using UMAP.
Returns coordinates that can be plotted.
"""
function visualize_topics(embeddings, topic_assignments)
    # Reduce dimensions for visualization using UMAP
    umap_reducer = umap.UMAP(n_neighbors=15, min_dist=0.1, n_components=2)
    umap_embeddings = umap_reducer.fit_transform(embeddings)
    
    return umap_embeddings, topic_assignments
end

# Load Quran data
crps, tnzl = load(QuranData());
crps_tbl, tnzl_tbl = table(crps), table(tnzl)
v1 = get_embeddings(verses(tnzl_tbl[1])[1])
v2 = get_embeddings(verses(tnzl_tbl[1])[2])

documents = verses(tnzl_tbl)

# Perform topic modeling
num_topics = 5
topic_assignments, topic_centroids = perform_topic_modeling(documents, num_topics)

topic_assignments

topic_centroids

# Extract keywords for each topic
topic_keywords = extract_topic_keywords(documents, topic_assignments, num_topics)

embeddings = get_embeddings(documents)
viz_coords, _ = visualize_topics(embeddings, topic_assignments)
