# Basic approach - read lines into a list
def load_strings_from_file(filename):
    with open(filename, 'r', encoding='utf-8') as file:
        # Strip newlines and return as a list of strings
        return [line.strip() for line in file]

# Example usage:
my_strings = load_strings_from_file('nb/output.txt')
my_strings


import numpy as np
import pandas as pd
from bertopic import BERTopic
from sentence_transformers import SentenceTransformer
from sklearn.feature_extraction.text import CountVectorizer
from umap import UMAP
from sklearn.cluster import KMeans
import matplotlib.pyplot as plt
import plotly.express as px
import os
from typing import List, Tuple, Dict, Optional

def load_quran_verses(file_path: str) -> List[str]:
    """
    Load Quran verses from a text file.
    
    Args:
        file_path: Path to the text file containing Quran verses
        
    Returns:
        List of verses as strings
    """
    try:
        with open(file_path, 'r', encoding='utf-8') as file:
            verses = [line.strip() for line in file if line.strip()]
        print(f"Successfully loaded {len(verses)} verses from {file_path}")
        return verses
    except Exception as e:
        print(f"Error loading verses: {e}")
        return []

def preprocess_arabic_text(texts: List[str]) -> List[str]:
    """
    Preprocess Arabic text for better topic modeling.
    This is a basic implementation - extend as needed.
    
    Args:
        texts: List of Arabic text strings
        
    Returns:
        Preprocessed text strings
    """
    processed_texts = []
    
    for text in texts:
        # Remove diacritics (optional - might want to keep for Quranic text)
        # text = remove_diacritics(text)
        
        # Remove any extra whitespace
        text = ' '.join(text.split())
        
        processed_texts.append(text)
    
    return processed_texts

def create_quran_topic_model(
    verses: List[str],
    num_topics: int = 20,
    model_name: str = "MatMulMan/CL-AraBERTv0.1-base-33379-arabic_tydiqa",
    min_topic_size: int = 10,
    embeddings_batch_size: int = 32
) -> Tuple[BERTopic, List[int], np.ndarray]:
    """
    Create and fit a BERTopic model specifically configured for Quranic text.
    
    Args:
        verses: List of Quran verses
        num_topics: Number of topics to extract
        model_name: Name of the SentenceTransformer model to use
        min_topic_size: Minimum size for a topic
        embeddings_batch_size: Batch size for creating embeddings
        
    Returns:
        Tuple of (fitted model, topic assignments, topic probabilities)
    """
    print(f"Loading embedding model: {model_name}")
    embedding_model = SentenceTransformer(model_name)
    
    # Configure UMAP with parameters suitable for Arabic text
    print("Configuring UMAP dimensionality reduction")
    umap_model = UMAP(
        n_neighbors=15,
        n_components=5,
        min_dist=0.0,
        metric='cosine',
        random_state=42
    )
    
    # Use KMeans for a more stable clustering with fixed number of topics
    print(f"Setting up KMeans clustering with {num_topics} topics")
    cluster_model = KMeans(n_clusters=num_topics, random_state=42)
    
    # Configure a vectorizer specifically for Arabic
    # Note: BERTopic's default vectorizer doesn't have Arabic stopwords
    print("Configuring CountVectorizer for Arabic")
    vectorizer_model = CountVectorizer(
        strip_accents=None,  # Keep Arabic diacritics
        stop_words=None,     # No built-in Arabic stopwords
        min_df=5,            # Term must appear in at least 5 documents
        max_df=0.8           # Term must appear in at most 80% of documents
    )
    
    # Create the BERTopic model
    print("Creating BERTopic model")
    topic_model = BERTopic(
        embedding_model=embedding_model,
        umap_model=umap_model,
        hdbscan_model=cluster_model,  # Using KMeans instead of HDBSCAN
        vectorizer_model=vectorizer_model,
        language="arabic",            # Use Arabic specific settings
        min_topic_size=min_topic_size,
        verbose=True,
        calculate_probabilities=True
    )
    
    # Fit the model
    print(f"Fitting model on {len(verses)} verses")
    topics, probs = topic_model.fit_transform(
        verses, 
        embeddings_batch_size=embeddings_batch_size
    )
    
    print(f"Model training complete. Found {len(set(topics)) - (1 if -1 in topics else 0)} topics")
    return topic_model, topics, probs

def analyze_quran_topics(
    topic_model: BERTopic,
    verses: List[str],
    topics: List[int],
    output_dir: str = "quran_topic_analysis"
) -> None:
    """
    Analyze and visualize topics found in the Quran.
    
    Args:
        topic_model: Fitted BERTopic model
        verses: List of Quran verses
        topics: Topic assignments for each verse
        output_dir: Directory to save visualizations and analysis
    """
    # Create output directory if it doesn't exist
    os.makedirs(output_dir, exist_ok=True)
    
    # Get topic information
    topic_info = topic_model.get_topic_info()
    
    # Save topic information to CSV
    topic_info.to_csv(f"{output_dir}/topic_info.csv", index=False)
    print(f"Saved topic information to {output_dir}/topic_info.csv")
    
    # Extract and save top terms for each topic
    topic_terms = {}
    topic_term_weights = {}
    
    for topic in topic_info.Topic:
        if topic != -1:  # Skip outlier topic
            terms = topic_model.get_topic(topic)
            topic_terms[topic] = [term for term, _ in terms[:20]]
            topic_term_weights[topic] = [weight for _, weight in terms[:20]]
    
    # Save topic terms to file
    with open(f"{output_dir}/topic_terms.txt", "w", encoding="utf-8") as f:
        for topic, terms in topic_terms.items():
            f.write(f"Topic {topic}:\n")
            for term, weight in zip(terms, topic_term_weights[topic]):
                f.write(f"  {term}: {weight:.4f}\n")
            f.write("\n")
    
    print(f"Saved topic terms to {output_dir}/topic_terms.txt")
    
    # Create and save topic visualizations
    try:
        # Topic similarity visualization
        topic_model.visualize_topics().write_html(f"{output_dir}/topic_visualization.html")
        print(f"Saved topic visualization to {output_dir}/topic_visualization.html")
    except Exception as e:
        print(f"Error creating topic visualization: {e}")
    
    try:
        # Bar chart of top terms
        topic_model.visualize_barchart(top_n_topics=10).write_html(f"{output_dir}/top_terms_barchart.html")
        print(f"Saved top terms barchart to {output_dir}/top_terms_barchart.html")
    except Exception as e:
        print(f"Error creating barchart visualization: {e}")
    
    # Create a DataFrame with verses and their topics
    verse_topics_df = pd.DataFrame({
        'verse': verses,
        'topic': topics
    })
    
    # Save verses by topic
    verse_topics_df.to_csv(f"{output_dir}/verse_topics.csv", index=False)
    print(f"Saved verse topics to {output_dir}/verse_topics.csv")
    
    # Create separate files for each topic's verses
    for topic in set(topics):
        topic_verses = verse_topics_df[verse_topics_df['topic'] == topic]['verse'].tolist()
        
        if topic_verses:
            with open(f"{output_dir}/topic_{topic}_verses.txt", "w", encoding="utf-8") as f:
                for verse in topic_verses:
                    f.write(f"{verse}\n")
            
            print(f"Saved {len(topic_verses)} verses for Topic {topic}")

def main():
    """
    Main function to run the Quran topic analysis pipeline.
    """
    # Configuration - adjust paths and parameters as needed
    quran_file = "quran_verses.txt"  # File with one verse per line
    output_dir = "quran_topic_analysis"
    num_topics = 15  # Adjust based on your analysis goals
    
    # Load verses
    verses = load_quran_verses(quran_file)
    
    if not verses:
        print("No verses loaded. Please check the file path.")
        return
    
    # Preprocess text (minimal for Quranic text, expand as needed)
    processed_verses = preprocess_arabic_text(verses)
    
    # Create and fit topic model
    topic_model, topics, probs = create_quran_topic_model(
        processed_verses,
        num_topics=num_topics,
        model_name="MatMulMan/CL-AraBERTv0.1-base-33379-arabic_tydiqa"
    )
    
    # Analyze and visualize topics
    analyze_quran_topics(topic_model, verses, topics, output_dir)
    
    # Save the model for future use
    topic_model.save(f"{output_dir}/quran_topic_model")
    print(f"Saved topic model to {output_dir}/quran_topic_model")
    
    print("Quran topic analysis complete!")

if __name__ == "__main__":
    main()