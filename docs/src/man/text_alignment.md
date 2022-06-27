Text Alignment
========
Text alignment is used for pairwise comparison of texts (e.g. books), with the aim of checking for deletions, insertions, matches and mismatches in the target texts relative to a reference texts. This is the same task as sequence alignment of two DNA sequence as in Biology. Indeed, Yunir.jl supports this by extending the [BioAlignments.jl](https://github.com/BioJulia/BioAlignments.jl) APIs 
to sequence of Arabic texts. Yunir.jl uses `align` function for aligning two texts.

## How it works
The way it works is that, [BioAlignments.jl](https://github.com/BioJulia/BioAlignments.jl) requires a Roman characters as input for pairwise alignment. Therefore, any Arabic characters must first be transliterated to Roman characters. This is possible using Yunir.jl's `encode` function. The resulting alignment, which is in Roman characters, is then transliterated back to Arabic for easy interpretation.

## KITAB project's text reuse 
We will consider a simple example based on "text reuse" case study of [KITAB project](https://kitab-project.org/methods/text-reuse). The following are portions of two books with IDs Shamela0012129-ara1 and Shamela0023790-ara1. The goal is to compare the two by aligning the characters, and see the similarity based on matches, mismatches, deletions and insertions of characters.
```@raw html
<table>
    <thead>
        <th>Shamela0012129-ara1</th>
        <th>Shamela0023790-ara1</th>
    </thead>
    <tbody>
        <tr>
            <td>خرج مع ابي بكر الصديق رضي الله عنه في تجارة الي بصري ومعهم نعيمان وكان نعيمان ممن شهد——- بدرا ايضا وك——-ان علي الزاد فقال له سويبط———– اطعمني فقال حتي يجء ابو بكر فقال اما والله لاغيظنك فمروا بقوم فقال لهم سويبط -تشترون مني عبدا قا—لوا نعم فقال انه عبد له كلام وهو قاءل لكم اني حر فان كنتم اذا قال لكم هذه المقالة تركتموه فلا تفسدوا علي عبدي قا-لوا بل نشتريه منك فاشتروه بعشر قلاءص ثم جاءوا فوضعوا في عنقه حبلا ف—————قال نعيمان ان هذا يستهزء بكم واني حر فقالوا قد عرفنا –خبرك وانطلقوا به فلما جاء ابو بكر -اخبروه فاتبعهم ورد عليهم القلاءص واخذه فلما قدموا علي النبي صلي الله عليه وسلم اخبروه فضحك هو واصحابه من ذلك حولا</td>
            <td>خرج— ابو بكر——————– في تجارة——— ومعه- نعيمان وسويبط بن حرملة وكانا شهدا بدر—–ا وكان نعيمان علي الزاد فقال له سويبط وكان مزاحا اطعمني فقال حتي يجء ابو بكر فقال اما والله لاغيظنك فمروا بقوم فقال لهم سويبط اتشترون مني عبدا لي قالوا نعم ق-ال انه عبد له كلام وهو قاءل لكم اني حر فان كنتم اذا قال لكم هذه المقالة تركتموه فلا تفسدوا علي عبدي فقالوا بل نشتريه منك——– بعشر قلاءص ثم جاءوا فوضعوا في عنقه حبلا وعمامة واشتروه فقال نعيمان ان هذا يستهزء بكم واني حر قا-لوا قد اخبرنا بخبرك وانطلقوا به و—-جاء ابو بكر فاخبروه فاتبعهم فرد عليهم القلاءص واخذه فلما قدموا علي النبي صلي الله عليه وسلم اخبروه فضحك هو واصحابه منهما- حول</td>
        </tr>
    </tbody>
</table>
```
### Data processing
To have a quality output, we will need to process the texts to remove unnecessary noise. First, we need to remove all non-Arabic characters. The following will input the two candidate books:
```@repl abc
using Yunir

shamela0012129 = "خرج مع ابي بكر الصديق رضي الله عنه في تجارة الي بصري ومعهم نعيمان وكان نعيمان ممن شهد——- بدرا ايضا وك——-ان علي الزاد فقال له سويبط———– اطعمني فقال حتي يجء ابو بكر فقال اما والله لاغيظنك فمروا بقوم فقال لهم سويبط -تشترون مني عبدا قا—لوا نعم فقال انه عبد له كلام وهو قاءل لكم اني حر فان كنتم اذا قال لكم هذه المقالة تركتموه فلا تفسدوا علي عبدي قا-لوا بل نشتريه منك فاشتروه بعشر قلاءص ثم جاءوا فوضعوا في عنقه حبلا ف—————قال نعيمان ان هذا يستهزء بكم واني حر فقالوا قد عرفنا –خبرك وانطلقوا به فلما جاء ابو بكر -اخبروه فاتبعهم ورد عليهم القلاءص واخذه فلما قدموا علي النبي صلي الله عليه وسلم اخبروه فضحك هو واصحابه من ذلك حولا";
shamela0023790 = "خرج— ابو بكر——————– في تجارة——— ومعه- نعيمان وسويبط بن حرملة وكانا شهدا بدر—–ا وكان نعيمان علي الزاد فقال له سويبط وكان مزاحا اطعمني فقال حتي يجء ابو بكر فقال اما والله لاغيظنك فمروا بقوم فقال لهم سويبط اتشترون مني عبدا لي قالوا نعم ق-ال انه عبد له كلام وهو قاءل لكم اني حر فان كنتم اذا قال لكم هذه المقالة تركتموه فلا تفسدوا علي عبدي فقالوا بل نشتريه منك——– بعشر قلاءص ثم جاءوا فوضعوا في عنقه حبلا وعمامة واشتروه فقال نعيمان ان هذا يستهزء بكم واني حر قا-لوا قد اخبرنا بخبرك وانطلقوا به و—-جاء ابو بكر فاخبروه فاتبعهم فرد عليهم القلاءص واخذه فلما قدموا علي النبي صلي الله عليه وسلم اخبروه فضحك هو واصحابه منهما- حول";
```
Next, we remove the non-Arabic characters like the dashes using the `clean` function:
```@repl abc
shamela0012129_cln = clean(shamela0012129)
shamela0023790_cln = clean(shamela0023790)
```
!!! tips "Tips"
    The `clean` function removes the non-Arabic characters through regex, which is set at the third argument of the function. That is, `clean(shamela0012129)` is actually equivalent to:
    ```julia
    clean(shamela0012129; replace_non_ar="", target_regex=r"[A-Za-z0-9\(:×\|\–\[\«\»\]~\)_@./#&+\—-]*")
    ```
    In case there are still non-Arabic characters not captured using the default regex, simply insert it to the default pattern.
!!! warning "Caution"
    It is important that all non-Arabic characters be removed since any special character might be transliterated to a particular Arabic character once transliterating the output back to Arabic, and the result might mislead. See the section "How it works" above.
    
Next, we need to expand the special Arabic characters such as Allah, الله, since some text editors
combines this into the unicode [U+FDF2](https://www.compart.com/en/unicode/U+FDF2). This is also true
with Lam-Alif, ﻻ, [U+FEFB](https://www.compart.com/en/unicode/U+FEFB). We will add space between these letters
to display the alignment of the characters properly, with a caveat that it should be understood that these characters are connected when encountering their sequence in the output. So that, "الله" becomes "ا ل ل ه" and "ﻻ" becomes "ل ا" in the output. The function to use is `expand_archars`.
```@repl abc
shamela0012129_exp = expand_archars(shamela0012129_cln)
shamela0023790_exp = expand_archars(shamela0023790_cln)
```
### Encoding
As emphasized above, Yunir.jl is based on [BioAlignments.jl](https://github.com/BioJulia/BioAlignments.jl) APIs to do
the pairwise alignment. To do this, [BioAlignments.jl](https://github.com/BioJulia/BioAlignments.jl) requires 
a Roman character input. Therefore, the input Arabic texts need to be encoded or transliterated to Roman characters.
```@repl abc
shamela0012129_enc = encode(shamela0012129_exp)
shamela0023790_enc = encode(shamela0023790_exp)
```
### Alignment
Finally, we can do the alignment as follows:
```@repl abc
res = align(shamela0012129_enc, shamela0023790_enc);
res
```
Unfortunately, many software and text editors including the Julia REPL 
have default left-to-right printing, and hence the alignment above is
not clear. What you can do is to copy the output above and paste it into a text
editor with Arabic Monospace font (e.g. [Kawkab font](https://makkuk.com/kawkab-mono/#:~:text=Kawkab%20Mono%20(%D9%83%D9%88%D9%83%D8%A8%20%D9%85%D9%88%D9%86%D9%88)%20is,a%20void%20in%20this%20niche.)),
and set it to right-justified. Here is the result under macOS's Text Editor (after setting the page to right-justified):

![Alignment-Output-in-Text-Editor](../assets/alignment1.png)

The result of the alignment is a list of groups of reference text indicated by the Arabic 
character ١, and the target texts indicated by the Arabic character ٢. If the characters of reference and target match, a Alif (i.e., ا)
between their rows is placed. Further, if a tatweel (i.e., "ـ") is present in the target text,
it means those tatweels represent the deletion of characters from the reference text. On the other hand, if a tatweel is present in the reference
text, it means an insertion of characters was done in the target text. Lastly, if both characters of target and reference texts do not match,
a space is inserted between their rows.

### Alignment in Buckwalter
We can actually extract the encoded version, which is in Buckwalter transliteration mapping. This can be accessed via the `.alignment` property of the `res` above. That is,
```@repl abc
res.alignment
```
This is the same with the result above, but this one is the Buckwalter encoded Arabic input.

The number in the left side is the index of the first character in the row, whereas the number in the right side is the index of the last character in the row.
### Alignment statistics
From the results above, we can extract the score of alignment which is a 
distance measure between the reference and the target texts. The lower the score
the similar the two texts therefore.
```@repl abc
score(res)
```
Other statistics are as follows
```@repl abc
count_matches(res)
count_mismatches(res)
count_insertions(res)
count_deletions(res)
count_aligned(res)
```