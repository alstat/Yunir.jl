Rhythmic Analysis
=============
The prevalence of poetry in Arabic literature necessitates scientific tool to study the rhythmic signatures. Unfortunately, there are no resources for such methodology until the recent work of [asaadthesis](@citet). This section will demonstrate the APIs for doing rhythmic analysis based on the methodologies proposed by [asaadthesis](@citet). To do this, there are two types of text that will be studied, and these are pre-Islamic poetry and the Holy Qur'an.

## Arabic Poetry
The first data is from a well known author, [Al-Mutanabbi المتنبّي](https://en.wikipedia.org/wiki/Al-Mutanabbi), who authored several poetry including the titled [*'Indeed, every woman with a swaying walk'*](https://www.youtube.com/watch?v=9c1IrQwfYFM), which will be the basis for this section.
## Loading Data
The following codes assigns the said poem of Al-Mutanabbi to a variable `poem`.
```@example abc
using Yunir
@transliterator :default

poem = """
    أَلَا كُلُّ مَاشِيَةِ الخَيْزَلَى؛
    فِدًى كُلِّ مَاشِيَةِ الهَيْذَبَى؛
    وَكُلِّ نَجَاةٍ بُجَاوِيَّةٍ،
    خَنُوفٍ وَمَا بِي حُسْنُ المِشَى؛
    وَلَكِنَّهُنَّ حِبَالُ الحَيَاةِ،
    وَكَيْدُ العُدَاةِ وَمَيْطُ الأَذَى؛
    ضَرَبْتُ بِهَا التِّيهَ ضَرْبَ القِمَا
    رِ إِمَّا لِهَذَا وَإِمَّا لِذَا؛
    إِذَا فَزِعَتْ قَدَّمَتْهَا الجِيَادُ،
    وَبِيضُ السُّيُوفِ وَسُمْرُ القَنَا؛
    فَمَرَّتْ بِنَخْلٍ وَفِي رَكْبِهَا،
    عَنِ العَالَمِينَ وَعَنْهُ غِنَى؛
    وَأَمْسَتْ تُخَيِّرُنَا بِالنَّقَا،
    بِوَادِي المِيَاهِ وَوَادِي القُرَى؛
    وَقُلْنَا لَهَا أَيْنَ أَرْضُ العِرَاقِ؟
    فَقَالَتْ وَنَحْنُ بِتُرْبَانَهَا؛
    وَهَبَّتْ بِحِسْمَى هُبُوبَ الدَّبُو
    رِ مُسْتَقْبِلَاتٍ مَهَبَّ الصَّبَا؛
    رَوَامِي الكِفَافِ وَكِبْدِ الوِهَادِ،
    وَجَارِ البُوَيْرَةِ وَادِي الغَضَى؛
    وَجَابَتْ بُسَيْطَةَ جَوْبَ الرِّدَا،
    بَيْنَ النَّعَامِ وَبَيْنَ المَهَا؛
    إِلَى عُقْدَةِ الجَوْفِ حَتَّى شَفَتْ،
    بِمَاءِ الجُرَاوِيِّ بَعْضَ الصَّدَى؛
    وَلَاحَ لَهَا صَوَرٌ وَالصَّبَاحُ،
    وَلَاحَ الشَّغُورُ لَهَا وَالضُّحَى؛
    وَمَسَّى الجُمَيْعِيَّ دِئْدَاؤُهَا،
    وَغَادَى الأَضَارِعَ ثُمَّ الدَّنَا؛
    فَيَا لَكَ لَيْلًا عَلَى أَعْكُشٍ،
    أَحَمَّ البِلَادِ خَفِيَّ الصُّوَى؛
    وَرَدْنَا الرُّهَيْمَةَ فِي جَوْزِهِ،
    وَبَاقِيهِ أَكْثَرُ مِمَّا مَضَى؛
    فَلَمَّا أَنَخْنَا رَكَزْنَا الرِّمَاحَ،
    بَيْنَ مَكَارِمِنَا وَالعُلَى؛
    وَبِتْنَا نُقَبِّلُ أَسْيَافَنَا،
    وَنَمْسَحُهَا مِنْ دِمَاءِ العِدَى؛
    لِتَعْلَمَ مِصْرُ وَمَنْ بِالعِرَاقِ،
    وَمَنْ بِالعَوَاصِمِ أَنِّي الفَتَى؛
    وَأَنِّي وَفَيْتُ وَأَنِّي أَبَيْتُ،
    وَأَنِّي عَتَوْتُ عَلَى مَنْ عَتَا؛
    وَمَا كُلُّ مَنْ قَالَ قَوْلًا وَفَى،
    وَلَا كُلُّ مَنْ سِيمَ خَسْفًا أَبَى؛
    وَلَا بُدَّ لِلْقَلْبِ مِنْ آلَةٍ،
    وَرَأْيٍ يُصَدِّعُ صُمَّ الصَّفَا؛
    وَمَنْ يَكُ قَلْبٌ كَقَلْبِي لَهُ،
    يَشُقُّ إِلَى العِزِّ قَلْبَ التَّوَى؛
    وَكُلُّ طَرِيقٍ أَتَاهُ الفَتَى،
    عَلَى قَدَرِ الرِّجْلِ فِيهِ الخُطَى؛
    وَنَامَ الخُوَيْدِمُ عَنْ لَيْلِنَا،
    وَقَدْ نَامَ قَبْلُ عَمًى لَا كَرَى؛
    وَكَانَ عَلَى قُرْبِنَا بَيْنَنَا،
    مَهَامِهُ مِنْ جَهْلِهِ وَالعَمَى؛
    وَمَنْ جَهِلَتْ نَفْسُهُ قَدْرَهُ،
    رَأَى غَيْرُهُ مِنْهُ مَا لَا يَرَى.
"""
```
## Extracting Syllables
Now let's try extracting the syllables for the first line. To do this, let's convert the text into a vector of stanzas of the `poem`. We therefore split the text on the `";\n"` separator, where the `\n` is the code for line break. The function `strip` simply removes the whitespaces before and after each stanza.
```@example abc
texts = map(x -> strip(string(x)), split.(poem, "\n"))
```
Next is to initialize the syllabification for each stanza, suppose we want to capture the consonant before and after each vowel to represent one syllable. For example, for the word `basmala`, the syllabification if only the consonant preceding the vowel is considered then we have `ba`, `ma`, and `la`. To specify this configuration for the syllable, we do it as follows:
```@repl abc
syllable = Syllable(1, 0, 10)
```
Here the first argument represents the number of characters prior to the vowel is considered, the next argument which is 0 is the number of character after the vowel, and 10 in the third argument simply mean how many vowels do we need to capture for each word. So that, 10 here assures us that we capture all vowels of any word because most usually has less than 10 vowels.
```@repl abc
r = Syllabification(false, syllable)
```
Then, the following will syllabicize the first word in the said poem.
```@repl abc
r(
    string(split(texts[1], " ")[1]), 
    isarabic=true, 
    first_word=true, 
    silent_last_vowel=false
)
```
The parameter `isarabic` ask if the output segment should be in Arabic form. The segment is defined here as the joined slices of the syllables. The `first_word` parameter checks if the input text is a first word of a sentence or phrase. Finally the last parameter aims to capture the case of silencing the vowel of the last word.

From the output above, there are two syllables, the first being `أَ` and the second is `لَا`, both are separated with `?`.
!!! warning "Caution"
    It is important to note that syllabification works only on a fully diacritize text as in the input poem here, and that is because each syllable contain a vowel. If not fully diacritize, then the syllabification will consider a syllable with only consonant and no vowel.

So that, if we want to extract the syllables all lines in the poem, then:
```@example abc
# Process only the first 3 lines for demonstration
line_syllables = Array[]
for line in texts
    words = string.(split(line, " "))

    word_syllables = Segment[]
    i = 1
    for word in words
        if i === 1
            push!(word_syllables, r(word, isarabic=true, first_word=true))
        elseif i === length(words)
            push!(word_syllables, r(word, isarabic=true, first_word=false, silent_last_vowel=false))
        else
            push!(word_syllables, r(word, isarabic=true, first_word=false))
        end
        i += 1
    end
    push!(line_syllables, word_syllables)
end
```
To extract the syllables of the words in first line of the poem, we run the following code:
```@repl abc
line_syllables[1]
```
And for the last line of the poem
```@repl abc
line_syllables[end-1]
```
!!! info "Note"
    The indexing is set to `end-1` because the last line of the `texts` variable is a blank line space as seen in the results of the `texts` variable assigned to the mapping function above.
## References
```@bibliography
Pages = ["rhythmic_analysis.md"]
Canonical = false
```