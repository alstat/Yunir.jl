using PyCall

# Import required Python libraries
bertopic = pyimport("bertopic")
sentence_transformers = pyimport("sentence_transformers")
# Import UMAP correctly - the class is directly in the module
umap = pyimport("umap")
UMAP = umap.UMAP  # Access the UMAP constructor directly
sklearn_cluster = pyimport("sklearn.cluster")
np = pyimport("numpy")
umap_py = pyimport("umap.umap_")
UMAP = umap_py.UMAP

"""
    topic_model_with_bertopic(documents; num_topics=10, clustering_method="kmeans", language="arabic")

Performs topic modeling on documents using BERTopic with a specified embedding model.

Parameters:
- documents: List/Array of text documents
- num_topics: Number of topics to extract (for KMeans)
- clustering_method: Clustering method ("kmeans" or "dbscan")
- language: Language of documents for stopwords (default: "arabic")
- embedding_model_name: Name of the SentenceTransformer model to use

Returns:
- topic_model: Trained BERTopic model (Python object)
- topics: Array of topic assignments for each document
- probabilities: Topic probability distributions (if available)
"""
function topic_model_with_bertopic(
    documents;
    num_topics=10, 
    clustering_method="kmeans", 
    language="arabic",
    embedding_model_name="MatMulMan/CL-AraBERTv0.1-base-33379-arabic_tydiqa"
)
    # Load the embedding model
    embedding_model = sentence_transformers.SentenceTransformer(embedding_model_name)
    
    # Set up UMAP for dimensionality reduction with parameters for small datasets
    # n_neighbors must be less than the number of samples
    # n_components must be less than n_neighbors
    umap_model = UMAP(
        n_neighbors=2,           # Reduced from 15 for small datasets
        n_components=2,          # Reduced from 5
        min_dist=0.1,
        metric="cosine",
        random_state=42
    )
    
    # Set up the clustering model based on method parameter
    if clustering_method == "kmeans"
        cluster_model = sklearn_cluster.KMeans(n_clusters=num_topics, random_state=42)
    elseif clustering_method == "dbscan"
        cluster_model = sklearn_cluster.DBSCAN(eps=0.5, min_samples=5)
    else
        error("Unsupported clustering method: $clustering_method")
    end
    
    # Create the BERTopic model with parameters suitable for small datasets
    topic_model = bertopic.BERTopic(
        embedding_model=embedding_model,      # Use our specific embedding model
        umap_model=umap_model,                # Dimensionality reduction
        hdbscan_model=cluster_model,          # Our clustering method
        language=language,                    # Specify language for stopwords
        calculate_probabilities=true,         # Get probability distributions
        nr_topics="auto",                     # Let BERTopic decide on the number of topics
        min_topic_size=1,                     # Allow very small topics (good for small datasets)
        verbose=true
    )
    
    # Fit the model and transform documents
    topics, probabilities = topic_model.fit_transform(documents)
    
    # Convert to Julia arrays to make them more Julia-friendly
    topics_array = convert(Array, topics)
    probabilities_array = probabilities !== nothing ? convert(Array, probabilities) : nothing
    
    return topic_model, topics_array, probabilities_array
end

"""
    get_topic_info(topic_model)

Get information about the topics in the trained BERTopic model.
Returns a Dict with topic information.
"""
function get_topic_info(topic_model)
    try
        py_topic_info = topic_model.get_topic_info()
        
        # Convert pandas DataFrame to Julia-friendly Dict
        topic_info = Dict()
        
        # Try a more direct approach to access pandas DataFrame
        for i in 0:(py_topic_info.shape[0]-1)
            try
                # Get row as a Series
                row = py_topic_info.iloc[i]
                
                # Create a Dict for this row using get() for safety
                row_dict = Dict()
                for col in py_topic_info.columns
                    # Access each column value safely
                    val = row.get(col, "N/A")  # Use get with default
                    row_dict[string(col)] = val
                end
                
                # Store in our result Dict using 1-based indexing for Julia
                topic_info[i+1] = row_dict
            catch e
                println("Error processing topic info row $i: $e")
            end
        end
        
        if isempty(topic_info)
            throw(ErrorException("Failed to extract topic info from DataFrame"))
        end
        
        return topic_info
    catch e
        println("Error getting topic info: $e")
        
        # Fallback to direct topic access
        topics_dict = topic_model.get_topics()
        
        # Create a simplified topic info structure
        simplified_info = Dict()
        for (i, (topic_id, keywords)) in enumerate(topics_dict)
            # Safely extract top words
            top_words = []
            try
                # Get keywords in a safer way
                for j in 0:min(4, length(keywords)-1)
                    try
                        word = string(keywords[j].__getitem__(0))
                        push!(top_words, word)
                    catch
                        continue
                    end
                end
            catch
                # If we can't get keywords this way, use a placeholder
                top_words = ["N/A"]
            end
            
            name = "Topic $topic_id: $(join(top_words, ", "))"
            
            simplified_info[i] = Dict(
                "Topic" => topic_id,
                "Name" => name,
                "Count" => 0  # We don't have this info in the fallback
            )
        end
        
        return simplified_info
    end
end

"""
    get_topic_keywords(topic_model, topic_id)

Get the keywords for a specific topic.
Returns an array of tuples (word, score).
"""
function get_topic_keywords(topic_model, topic_id)
    try
        py_keywords = topic_model.get_topic(topic_id)
        
        # Check if py_keywords is empty or None
        if py_keywords === nothing || length(py_keywords) == 0
            return []
        end
        
        # Convert to Julia array of tuples directly using PyCall's conversion
        keywords = []
        for i in 0:(length(py_keywords)-1)
            try
                # Access each tuple by index to avoid direct iteration issues
                tup = py_keywords[i]
                # Convert Python tuple to Julia tuple
                word = string(tup.__getitem__(0))  # Get first element (word)
                score = float(tup.__getitem__(1))  # Get second element (score)
                push!(keywords, (word, score))
            catch e
                println("Error processing keyword at index $i: $e")
            end
        end
        
        return keywords
    catch e
        println("Error getting keywords for topic $topic_id: $e")
        return []  # Return empty array on error
    end
end

"""
    visualize_topics(topic_model; output_file=nothing)

Visualize the topics. If output_file is provided, saves the visualization to that file.
Otherwise, displays it if in an interactive environment.

Note: This requires UMAP and Plotly to be properly installed in the Python environment.
If visualization fails, it will provide a fallback text representation.
"""
function visualize_topics(topic_model; output_file=nothing)
    try
        # Try a different approach for visualization - use the precomputed embeddings
        if output_file !== nothing
            # Get a direct reference to the visualization function
            viz_func = topic_model.visualize_topics
            
            # Check if vis is available
            if viz_func === nothing
                error("Visualization function not available")
            end
            
            # Try to get the figure without UMAP reduction (which causes the error)
            fig = nothing
            
            try
                # Try with reduced_embeddings=true to use precomputed embeddings
                fig = viz_func(reduced_embeddings=true)
            catch e1
                # If that fails, try with a different approach
                try
                    # Try with normalize=false
                    fig = viz_func(normalize=false)
                catch e2
                    # Try with both
                    try
                        fig = viz_func(normalized=false, reduced_embeddings=true)
                    catch e3
                        # If all visualization attempts fail, use a fallback approach
                        if hasattr(topic_model, "topic_embeddings_")
                            # If embeddings are available but visualization fails,
                            # we could try to create a basic plot manually
                            error("Could not create visualization: $e3")
                        else
                            error("No precomputed embeddings available")
                        end
                    end
                end
            end
            
            # If we got a figure, save it
            if fig !== nothing
                fig.write_html(output_file)
                println("Visualization saved to $output_file")
                return fig
            end
        else
            # In interactive environments, return the figure
            try
                fig = topic_model.visualize_topics(reduced_embeddings=true)
                return fig
            catch e
                println("Could not create interactive visualization: $e")
                return nothing
            end
        end
    catch e
        println("Could not create visualization: $e")
        println("Providing text-based topic representation instead:")
        
        # Fallback to text representation
        try
            topics = topic_model.get_topics()
            println("\nTopic Keywords (text representation):")
            
            # Process topics safely
            for (topic_id, keywords) in topics
                top_words = []
                try
                    # Get top 5 words safely
                    for i in 0:min(4, length(keywords)-1)
                        try
                            word = string(keywords[i].__getitem__(0))
                            push!(top_words, word)
                        catch ek
                            # Skip this word if we can't extract it
                        end
                    end
                    
                    if !isempty(top_words)
                        println("Topic $topic_id: $(join(top_words, ", "))")
                    else
                        println("Topic $topic_id: [No keywords available]")
                    end
                catch et
                    println("Topic $topic_id: [Error extracting keywords: $et]")
                end
            end
        catch e2
            println("Could not retrieve topic keywords: $e2")
        end
        
        # Create a very basic text file as fallback
        if output_file !== nothing
            try
                # Generate a text version of the topic model
                text_output = "BERTopic Visualization (Text Version)\n\n"
                text_output *= "Topics and Top Keywords:\n"
                
                topics = topic_model.get_topics()
                for (topic_id, keywords) in topics
                    text_output *= "Topic $topic_id:\n"
                    
                    # Try to get keywords safely
                    for i in 0:min(9, length(keywords)-1)
                        try
                            word = string(keywords[i].__getitem__(0))
                            score = float(keywords[i].__getitem__(1))
                            text_output *= "  $word ($(round(score, digits=4)))\n"
                        catch
                            continue
                        end
                    end
                    text_output *= "\n"
                end
                
                # Count documents per topic
                text_output *= "Document Distribution:\n"
                try
                    topic_counts = Dict{Any,Int}()
                    for topic in topic_model.topics_
                        topic_counts[topic] = get(topic_counts, topic, 0) + 1
                    end
                    
                    for (topic, count) in topic_counts
                        text_output *= "Topic $topic: $count documents\n"
                    end
                catch ec
                    text_output *= "Could not retrieve document distribution: $ec\n"
                end
                
                # Save the text file with a modified name
                text_file = replace(output_file, ".html" => ".txt")
                open(text_file, "w") do f
                    write(f, text_output)
                end
                println("Text fallback saved to $text_file")
            catch ef
                println("Could not create text fallback: $ef")
            end
        end
        
        return nothing
    end
end

# Example usage
function example(arabic_docs::Vector{String})
    # Example Arabic documents - adding more examples to avoid dimensionality problems
    # arabic_docs = [
    #     "تعتبر اللغة العربية من أقدم اللغات في العالم",
    #     "الذكاء الاصطناعي يتطور بسرعة كبيرة في العالم العربي",
    #     "توجد تحديات كبيرة في معالجة اللغة العربية آليا",
    #     "تحليل البيانات أصبح جزءا مهما من الأعمال الحديثة",
    #     "الترجمة الآلية تحسنت كثيرا في السنوات الأخيرة",
    #     "تطبيقات الذكاء الاصطناعي متنوعة في مختلف المجالات",
    #     "البرمجة باللغة العربية تواجه تحديات تقنية",
    #     "أنظمة التعرف على الكلام العربي تتطور بشكل سريع",
    #     "معالجة اللغات الطبيعية مجال مهم في علوم الحاسوب",
    #     "تقنيات التعلم العميق غيرت طريقة فهم الآلات للغة"
    # ]
    
    # Run topic modeling with fewer topics for a small dataset
    model, document_topics, doc_probabilities = topic_model_with_bertopic(
        arabic_docs,
        num_topics=3,  # Reduced from 5, must be <= number of documents
        clustering_method="dbscan"
    )
    
    # Print topic assignments for each document
    println("Topic assignments for each document:")
    for (i, (doc, topic)) in enumerate(zip(arabic_docs, document_topics))
        # Safe truncation for Unicode text like Arabic
        shortened_doc = if length(doc) > 30
            first_chars = first(doc, 30)
            string(first_chars, "...")
        else
            doc
        end
        println("Document $i: $shortened_doc | Topic: $topic")
    end
    
    # Get topic information with error handling
    try
        topic_info = get_topic_info(model)
        println("\nTopic Information:")
        for (i, info) in topic_info
            # Safe access with get() to avoid KeyError
            topic_id = get(info, "Topic", "Unknown")
            count = get(info, "Count", 0)
            name = get(info, "Name", "Unnamed")
            println("Topic $topic_id: $count documents, Name: $name")
        end
    catch e
        println("\nCould not get topic information: $e")
        # Alternative method: directly access the topic model info
        println("\nAvailable topics: $(model.get_topics())")
    end
    
    # Get keywords for a specific topic with error handling
    try
        # Use first document's topic instead of hardcoding
        if !isempty(document_topics)
            topic_id = document_topics[1]/
            
            # Check if this topic exists in the model
            all_topics = model.get_topics()
            if topic_id in keys(all_topics)
                keywords = get_topic_keywords(model, topic_id)
                println("\nKeywords for Topic $topic_id:")
                
                # Make sure we have keywords
                if !isempty(keywords)
                    for (word, score) in keywords[1:min(5, length(keywords))]
                        println("$word: $score")
                    end
                else
                    println("No keywords found for topic $topic_id")
                end
            else
                println("\nTopic $topic_id not found in model")
                # Get a valid topic from the model
                valid_topics = collect(keys(all_topics))
                if !isempty(valid_topics)
                    sample_topic = first(valid_topics)
                    println("Using sample topic $sample_topic instead")
                    keywords = get_topic_keywords(model, sample_topic)
                    if !isempty(keywords)
                        for (word, score) in keywords[1:min(5, length(keywords))]
                            println("$word: $score")
                        end
                    end
                end
            end
        else
            println("\nNo document topics available")
        end
    catch e
        println("\nCould not get keywords: $e")
    end
    
    # Save visualization to file with error handling
    try
        visualize_topics(model, output_file="bertopic_visualization.html")
        println("\nVisualization saved to bertopic_visualization.html")
    catch e
        println("\nCould not create visualization: $e")
    end
    
    return model  # Return the model for further exploration
end

using QuranTree, Yunir
# Load Quran data
crps, tnzl = load(QuranData());
crps_tbl, tnzl_tbl = table(crps), table(tnzl)

documents = verses(tnzl_tbl)
function save_strings_to_file(strings::Vector{String}, filename::String)
    open(filename, "w") do file
        for str in strings
            println(file, str)  # Writes each string on a new line
        end
    end
end

save_strings_to_file(dediac.(documents), "nb/output.txt")

example(dediac.(documents))