"""
    clean(s::String, replace_non_ar::String, target_regex::Regex)

Clean the input text by replacing all non-Arabic texts with a string input.
"""
function clean(s::Ar, replace_non_ar::String="", target_regex::Regex = r"[A-Za-z0-9\(:×\|\–\[\«\»\]~\)_@./#&+\—-]*")
    return Ar(replace(s.text, target_regex => replace_non_ar))
end