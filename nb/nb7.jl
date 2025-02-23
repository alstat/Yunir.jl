function (r::Syllabification)(text::String; isarabic::Bool=false, first_word::Bool=false, silent_last_vowel::Bool=false)
    jvowels = join([c.char for c in BW_VOWELS])
    text = isarabic ? encode(text) : text
    
    vowel_idcs = vowel_indices(text, isarabic)
    
    harakaat = Harakaat[]
    segment_text = ""
    
    if length(vowel_idcs) == 0
        return handle_no_vowels(text, BW_VOWELS, jvowels)
    end
    
    if silent_last_vowel
        cond = string(text[end]) .∈ BW_VOWELS
        is_silent = sum(cond)
        penalty = is_silent < 1 ? 1 : 0
    else 
        is_silent = 0
        penalty = 1
    end

    uplimit = r.syllable.nvowels > (count_vowels(text, isarabic) - is_silent) ? 
              (count_vowels(text, isarabic) - is_silent) : r.syllable.nvowels
              
    for i in 0:(uplimit-is_silent-penalty)
        vowel_idx = vowel_idcs[end-i-is_silent]
        cond = string(text[vowel_idx]) .∈ BW_VOWELS
        
        if sum(cond) > 0
            push!(harakaat, isarabic ? arabic(BW_VOWELS[cond][1]) : BW_VOWELS[cond][1])

            lead_length = length(text[1:(vowel_idx-1)])
            trail_length = length(text[(vowel_idx+1):end])

            lead_nchars_lwlimit = lead_length > r.syllable.lead_nchars ? r.syllable.lead_nchars : lead_length
            trail_nchars_uplimit = trail_length > r.syllable.trail_nchars ? r.syllable.trail_nchars : trail_length
            vowel = text[vowel_idx]

            lead_text = text[(vowel_idx-lead_nchars_lwlimit):(vowel_idx-1)]
            trail_text = text[(vowel_idx+1):(vowel_idx+trail_nchars_uplimit)]

            # Handle first word special case
            first_word_text = handle_first_word(text, first_word, vowel_idx, vowel_idcs, BW_VOWELS, harakaat, isarabic)

            # Handle maddah and leading characters
            lead_text = handle_leading_text(text, vowel_idx, lead_nchars_lwlimit, lead_text)

            # Handle trailing characters with maddah preservation
            trail_text = handle_trailing_text(text, vowel_idx, trail_nchars_uplimit, trail_text, BW_LONG_VOWELS, BW_VOWELS, silent_last_vowel)

            if i == 0
                segment_text = first_word_text * lead_text * vowel * trail_text
            else
                segment_text = first_word_text * lead_text * vowel * trail_text * "?" * segment_text
            end
        end
    end
    
    if isarabic
        return Segment(arabic(segment_text), reverse(harakaat))
    else
        return Segment(segment_text, reverse(harakaat))
    end
end

function handle_first_word(text, first_word, vowel_idx, vowel_idcs, BW_VOWELS, harakaat, isarabic)
    if first_word && vowel_idx == vowel_idcs[1]
        if text[1] == '{'
            first_word_harakaat = filter(x -> x.char == "a", BW_VOWELS)[1]
            push!(harakaat, isarabic ? arabic(first_word_harakaat) : first_word_harakaat)
            return "{" * text[2] * "?"
        end
    end
    return ""
end

function handle_leading_text(text, vowel_idx, lead_nchars_lwlimit, lead_text)
    if vowel_idx > lead_nchars_lwlimit && text[vowel_idx-lead_nchars_lwlimit] == '~'
        lead_candidate = text[vowel_idx-lead_nchars_lwlimit-1]
        lead_text = lead_candidate * lead_text
    end
    return lead_text
end

function handle_trailing_text(text, vowel_idx, trail_nchars_uplimit, trail_text, BW_LONG_VOWELS, BW_VOWELS, silent_last_vowel)
    if (vowel_idx + trail_nchars_uplimit + 1) <= length(text)
        trail_candidate1 = text[vowel_idx + trail_nchars_uplimit + 1]
        
        # Check if next character is a long vowel
        lvowel_cond = trail_candidate1 .∈ BW_LONG_VOWELS
        
        if (vowel_idx + trail_nchars_uplimit + 2) <= length(text)
            trail_candidate2 = text[vowel_idx + trail_nchars_uplimit + 2]
            
            # Handle maddah (^) explicitly
            if trail_candidate2 == '^'
                trail_text *= trail_candidate1 * "^"
            # Handle long vowel cases
            elseif sum(lvowel_cond) > 0
                if trail_candidate2 != 'o'
                    if silent_last_vowel
                        trail_text *= trail_candidate1 * trail_candidate2
                    else
                        trail_text *= trail_candidate1
                    end
                else
                    trail_text *= trail_candidate1
                end
            # Handle consonant with sukuun
            elseif sum(lvowel_cond) == 0 && 
                   sum(string(trail_candidate1) .∈ BW_VOWELS) == 0 && 
                   trail_candidate2 == 'o'
                trail_text *= trail_candidate1
            end
        end
    end
    return trail_text
end

function handle_no_vowels(text, BW_VOWELS, jvowels)
    orthogs = parse(Orthography, arabic(text)).data
    harakaat = Harakaat[]
    segment_text = ""
    i = 1
    
    while i <= length(text)
        if i < length(text) && text[i+1] == '^'
            segment_text *= text[i] * "^?"
            i += 2
        else
            if i < length(text)
                segment_text *= text[i] * "?"
            else
                segment_text *= text[i]
            end
            i += 1
        end
    end
    
    return Segment(segment_text, harakaat)
end