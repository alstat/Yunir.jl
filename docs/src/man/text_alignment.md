Text Alignment
========
Text alignment is used for pairwise comparison of texts (e.g. books) and see 
the matches, mismatches, deletions and insertions in target texts relative to 
the reference texts. This is the same task as comparing DNA sequence alignment 
as in Biology. Yunir.jl supports this by extending the [BioAlignments.jl](https://github.com/BioJulia/BioAlignments.jl) APIs 
for Arabic texts. Yunir.jl uses `align` function for aligning two texts.

## KITAB project's text reuse 
We will consider a simple example based on text reuse case study of [KITAB project](https://kitab-project.org/methods/text-reuse).
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
In this section, we will process the texts in preparation for alignment.
It is important to omit all non-Arabic characters. To do this, let's input the data first
```@repl abc
using Yunir

shamela0012129 = "خرج مع ابي بكر الصديق رضي الله عنه في تجارة الي بصري ومعهم نعيمان وكان نعيمان ممن شهد——- بدرا ايضا وك——-ان علي الزاد فقال له سويبط———– اطعمني فقال حتي يجء ابو بكر فقال اما والله لاغيظنك فمروا بقوم فقال لهم سويبط -تشترون مني عبدا قا—لوا نعم فقال انه عبد له كلام وهو قاءل لكم اني حر فان كنتم اذا قال لكم هذه المقالة تركتموه فلا تفسدوا علي عبدي قا-لوا بل نشتريه منك فاشتروه بعشر قلاءص ثم جاءوا فوضعوا في عنقه حبلا ف—————قال نعيمان ان هذا يستهزء بكم واني حر فقالوا قد عرفنا –خبرك وانطلقوا به فلما جاء ابو بكر -اخبروه فاتبعهم ورد عليهم القلاءص واخذه فلما قدموا علي النبي صلي الله عليه وسلم اخبروه فضحك هو واصحابه من ذلك حولا"
shamela0023790 = "خرج— ابو بكر——————– في تجارة——— ومعه- نعيمان وسويبط بن حرملة وكانا شهدا بدر—–ا وكان نعيمان علي الزاد فقال له سويبط وكان مزاحا اطعمني فقال حتي يجء ابو بكر فقال اما والله لاغيظنك فمروا بقوم فقال لهم سويبط اتشترون مني عبدا لي قالوا نعم ق-ال انه عبد له كلام وهو قاءل لكم اني حر فان كنتم اذا قال لكم هذه المقالة تركتموه فلا تفسدوا علي عبدي فقالوا بل نشتريه منك——– بعشر قلاءص ثم جاءوا فوضعوا في عنقه حبلا وعمامة واشتروه فقال نعيمان ان هذا يستهزء بكم واني حر قا-لوا قد اخبرنا بخبرك وانطلقوا به و—-جاء ابو بكر فاخبروه فاتبعهم فرد عليهم القلاءص واخذه فلما قدموا علي النبي صلي الله عليه وسلم اخبروه فضحك هو واصحابه منهما- حول"
```
Then, we remove the non-Arabic characters like the dashes using the `clean` function:
```@repl abc
shamela0012129_cln = clean(shamela0012129)
shamela0023790_cln = clean(shamela0023790)
```
Next, we need to expand the special Arabic characters such as Allah, الله, since some text editors
combines this into the unicode [U+FDF2](https://www.compart.com/en/unicode/U+FDF2). This is also true
with Lam-Alef, ﻻ,[U+FEFB](https://www.compart.com/en/unicode/U+FEFB). We will add space between the letters
of these words to align the characters. So that, "الله" becomes "ا ل ل ه" and "ﻻ" becomes "ل ا".
```@repl abc
shamela0012129_exp = expand_archars(shamela0012129_cln)
shamela0023790_exp = expand_archars(shamela0023790_cln)
```
### Encoding
As emphasized above, Yunir.jl uses [BioAlignments.jl](https://github.com/BioJulia/BioAlignments.jl) APIs to do
the pairwise alignment. To do this, [BioAlignments.jl](https://github.com/BioJulia/BioAlignments.jl) APIs require 
a Roman character input. Therefore, the arabic texts input needs to be encoded or transliterated to Roman characters.
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
not clear. What you can do is to copy the output and paste it into a text
editor with Arabic Monospace font (e.g. [Kawkab font](https://makkuk.com/kawkab-mono/#:~:text=Kawkab%20Mono%20(%D9%83%D9%88%D9%83%D8%A8%20%D9%85%D9%88%D9%86%D9%88)%20is,a%20void%20in%20this%20niche.)),
and set it to right-justified. Here is the result under macOS's Text Editor (after setting to right-justified):
```@raw html
<img src="https://github.com/alstat/Yunir.jl/raw/main/docs/src/assets/alignment1.png" align="center"/>
```
The result of the alignment is a list of group of 60 characters of reference text indicated by the Arabic 
character ١, and the target texts indicated by the Arabic character ٢. If the character matches, a Alif (i.e., ا)
is inserted between the rows of reference and target characters. If a tatweel (i.e., "ـ") is present in the target row,
it means those tatweels represent the deletion of characters from the reference texts. If a tatweel is present in the reference
text, it means an insertion of characters was done in target text. If both characters of target and reference texts are not matched,
then a space is inserted between their rows.

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