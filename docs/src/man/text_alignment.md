Text Alignment
========
Text alignment is used for pairwise comparison of texts (e.g. books), with the aim of checking for deletions, insertions, matches and mismatches in the target texts relative to a reference texts. This is the same task as sequence alignment of two DNA sequence as in Biology. Indeed, Yunir.jl supports this by extending the [BioAlignments.jl](https://github.com/BioJulia/BioAlignments.jl) APIs 
to sequence of Arabic texts. Yunir.jl uses `align` function for aligning two texts.

## How it works
The way it works is that, [BioAlignments.jl](https://github.com/BioJulia/BioAlignments.jl) requires a Roman characters as input for pairwise alignment. Therefore, any Arabic characters must first be transliterated to Roman characters. This is possible using Yunir.jl's `encode` function. The resulting alignment, which is in Roman characters, is then transliterated back to Arabic for easy interpretation.

## KITAB project's text reuse 
We will consider a simple example based on "text reuse" case study of [KITAB project](https://kitab-project.org/methods/text-reuse). The following are portions of two books with IDs Shamela0012129-ara1 and Shamela0023790-ara1 which was detected by "passim" (the tool used by KITAB project) as similar. The goal is to compare the two input texts by aligning the characters, and see the similarity based on matches, mismatches, deletions and insertions of characters. In the example texts below, we'll confirm the matches and see how Yunir.jl's APIs work on text alignment.
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
To have a quality output, we will need to process the texts to remove unnecessary noise. First, we need to remove all non-Arabic characters. To start with, the following will input the two candidate texts:
```@setup abc
using Pkg
Pkg.add("CairoMakie")
Pkg.add("Colors")
using CairoMakie
CairoMakie.activate!(type = "svg")
```
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
    The `clean` function removes the non-Arabic characters through RegEx or [Regular Expression](https://en.wikipedia.org/wiki/Regular_expression), which is set at the third argument of the function. That is, `clean(shamela0012129)` is actually equivalent to:
    ```julia
    clean(shamela0012129; replace_non_ar="", target_regex=r"[A-Za-z0-9\(:×\|\–\[\«\»\]~\)_@./#&+\—-]*")
    ```
    In case there are still non-Arabic characters not captured using the default regex, simply insert it to the default pattern.
!!! warning "Caution"
    It is important that all non-Arabic characters be removed since any special character might be transliterated to a particular Arabic character once transliterating the output back to Arabic, and the result might mislead. See the section "How it works" above.
    
Next, we need to normalize the word Allah, الله, into a single Unicode [U+FDF2](https://www.compart.com/en/unicode/U+FDF2). This is because this word or name consist of 4 consonants, but most software assigns this into a single Unicode when detected, and hence it is better to convert it in the first place. This is also true with Lam-Alif, ﻻ, composed of two letters but we can assign it to a single Unicode [U+FEFB](https://www.compart.com/en/unicode/U+FEFB). To do this, we define a mapping of these characters for the normalizer and then use it to normalize the input texts.
```@repl abc
mapping = Dict(
    "الله" => "ﷲ",
    "لا" => "ﻻ"
);
shamela0012129_nrm = normalize(shamela0012129_cln, mapping)
shamela0023790_nrm = normalize(shamela0023790_cln, mapping)
```
### Encoding
As emphasized above, Yunir.jl is based on [BioAlignments.jl](https://github.com/BioJulia/BioAlignments.jl) APIs to do
the pairwise alignment, and [BioAlignments.jl](https://github.com/BioJulia/BioAlignments.jl) requires 
a Roman input character. Therefore, the input Arabic texts need to be encoded or transliterated to Roman characters.
```@repl abc
shamela0012129_enc = encode(shamela0012129_nrm)
shamela0023790_enc = encode(shamela0023790_nrm)
```
### Alignment
Finally, we can do the alignment as follows:
```@repl abc
res1 = align(shamela0012129_enc, shamela0023790_enc);
res1
```
Unfortunately, many software and text editors including the Julia REPL have default left-to-right printing, and hence the alignment above is not clear. What you can do is to copy the output above and paste it into a text editor with Arabic Monospace font (e.g. [Kawkab font](https://makkuk.com/kawkab-mono/#:~:text=Kawkab%20Mono%20(%D9%83%D9%88%D9%83%D8%A8%20%D9%85%D9%88%D9%86%D9%88)%20is,a%20void%20in%20this%20niche.)),
and set it to right-justified or set the text direction to right-to-left (RTL). Here is the result under the [Notepad++](https://notepad-plus-plus.org/) (after setting the text direction to RTL):

![Alignment-Output-in-Text-Editor](../assets/alignment2.png)

The result of the alignment is a list of groups of reference text indicated by the Arabic 
character ١, and the target texts indicated by the Arabic character ٢. 
!!! note "Definitions"
    - *Match*, if the characters of reference and target did match, a Alif (i.e., ا) between their rows is placed. 
    - *Deletion*, if a tatweel (i.e., "ـ") is present in the target text, it means those tatweels represent the deletion of characters from the reference text. 
    - *Insertion*, if a tatweel is present in the reference text, it means an insertion of characters was done in the target text. 
    - *Mismatch*, if both characters of target and reference texts did not match, a space is inserted between their rows.
!!! note "Note"
    If we did not normalize the word "الله" into a single character, there would be four Alif if all letters did match, but because most software prints this as a single character, then there will be four Alif for a single character, and this will make the output confusing to readers. This is true for لا as well.

### Alignment in Buckwalter
We can actually extract the encoded version, which is in extended Buckwalter transliteration mapping. This can be accessed via the `.alignment` property of the `res` above. That is,
```@repl abc
res1.alignment
```
This is the same with the result above, but this one is the Buckwalter encoded Arabic input.

The number in the left side is the index of the first character in the row, whereas the number in the right side is the index of the last character in the row.
### Alignment statistics
From the results above, we can extract the score of the alignment which is a 
distance measure between the reference and the target texts. The lower the score
the similar the two texts therefore.
```@repl abc
score(res1)
```
Other statistics are as follows
```@repl abc
count_matches(res1)
count_mismatches(res1)
count_insertions(res1)
count_deletions(res1)
count_aligned(res1)
```

## Multiple Alignments
At times, especially when working with books, the input texts are long enough that it becomes
computationally expensive to do the alignment directly. A simple solution is to partition the input 
texts into parts and do the alignment, pairing the texts by permutation.
For example, in the KITAB's text reuse use case the books are partitioned into "milestone" which is
indicated by a prefix `ms` in the texts. To mimick this, we'll add `ms` into the 
`shamela0012129` and `shamela0023790` as follows:
```@repl abc
shamela0012129 = "خرج مع ابي بكر الصديق رضي الله عنه في تجارة الي بصري ومعهم نعيمان وكان نعيمان ممن شهد——- بدرا ايضا وك——-ان علي الزاد فقال له سويبط———– اطعمني فقال حتي يجء ابو بكر فقال اما والله لاغيظنك فمروا بقوم فقال لهم سويبط -تشترون مني عبدا قا—لوا نعم فقال انه عبد له كلام وهو قاءل لكم اني حر فان كنتم اذا قال لكم هذهmsتركتموه فلا تفسدوا علي عبدي قا-لوا بل نشتريه منك فاشتروه بعشر قلاءص ثم جاءوا فوضعوا في عنقه حبلا ف—————قال نعيمان ان هذا يستهزء بكم واني حر فقالوا قد عرفنا –خبرك وانطلقوا به فلما جاء ابو بكر -اخبروه فاتبعهم ورد عليهم القلاءص واخذه فلما قدموا علي النبي صلي الله عليه وسلم اخبروه فضحك هو واصحابه من ذلك حولا";
shamela0023790 = "خرج— ابو بكر——————– في تجارة——— ومعه- نعيمان وسويبط بن حرملة وكانا شهدا بدر—–ا وكان نعيمان علي الزاد فقال له سويبط وكان مزاحا اطعمني فقال حتي يجء ابو بكر فقال اما والله لاغيظنك فمروا بقوم فقال لهم سويبط اتشترون مني عبدا لي قالوا نعم ق-ال انه عبد له كلام وهو قاءل لكم اني حر فان كنتم اذا قال لكم هذه المقالة تركتموهmsفلا تفسدوا علي عبدي فقالوا بل نشتريه منك——– بعشر قلاءص ثم جاءوا فوضعوا في عنقه حبلا وعمامة واشتروه فقال نعيمان ان هذا يستهزء بكم واني حر قا-لوا قد اخبرنا بخبرك وانطلقوا به و—-جاء ابو بكر فاخبروه فاتبعهم فرد عليهم القلاءص واخذه فلما قدموا علي النبي صلي الله عليه وسلم اخبروه فضحك هو واصحابه منهما- حول";
```
We will then split this into milestones,
```@repl abc
shamela0012129 = string.(split(shamela0012129, "ms"))
shamela0023790 = string.(split(shamela0023790, "ms"))
```
Then as before, we clean the splitted texts:
```@repl abc
shamela0012129_cln = clean.(shamela0012129)
shamela0023790_cln = clean.(shamela0023790)
```
!!! note "Note"
    In Julia, we suffix the name of the function with `.` to broadcast the function to each item of the list. In this case, we clean each splitted texts.
Next, we normalize the characters as before:
```@repl abc
mapping = Dict(
    "الله" => "ﷲ",
    "لا" => "ﻻ"
);
shamela0012129_nrm = normalize(shamela0012129_cln, mapping)
shamela0023790_nrm = normalize(shamela0023790_cln, mapping)
```
And we encode them as follows
```@repl abc
shamela0012129_enc = encode.(shamela0012129_nrm)
shamela0023790_enc = encode.(shamela0023790_nrm)
```
Finally, we run the alignment.
```@repl abc
res2, scr = align(shamela0012129_enc, shamela0023790_enc);
```
Note that if the input texts are Array or Matrix the `align` function returns a tuple, comprising of the result of the alignment in Matrix, and the corresponding scores in Matrix.

Here is the score of the comparison, where the rows correspond to the index of the partitions of the reference text, and the 
columns correspond to the index of the partitions of the target text.
```@repl abc
scr
```
The corresponding result of the score is also a Matrix, but it is huge since each cell of the matrix correspond to the result of the alignment and printing it would be difficult to understand. It is therefore better to simply index the Matrix to view only part of it.

For example, the corresponding result of the score in the first row first column is given below
```@repl abc
res2[1,1] # result of the score scr[1,1]
```
For the result of the score in the second row first column, we have
```@repl abc
res2[2,1] # result of the score scr[2,1]
```
Finally, as before we can extract the statistics for each result:
```@repl abc
count_matches(res2[2,1])
count_mismatches(res2[2,1])
count_insertions(res2[2,1])
count_deletions(res2[2,1])
count_aligned(res2[2,1])
```
## Visualization
In this section, we are going to display the alignment by plotting the results.
```@example abc
using CairoMakie
f, a, xys = plot(res1, :matches)
a[1].xlabel = "Shamela0023790"
a[1].xlabelsize = 20
a[1].xticks = 0:2:unique(xys[1][1])[end]
a[3].xlabel = "Shamela0012129"
a[3].xlabelsize = 20
a[3].xticks = 0:2:unique(xys[2][1])[end]
f
```
The figure above is divided into three subplots arranged in rows. You can think of the figure as two input text displayed in horizontal (i.e, sideways) orientation. In this orientation, the x-axis becomes the rows of the texts, that is, you can think of the x-axis as the rows of the texts in the book. In this case, we have two books, the reference and the target books. Each dot in reference and target corresponds to the characters that have matched. The lines and curves in the middle (colored in red) represent the connections of the rows of the texts where the matched happened. Further, the y-axis correspond to the length of the rows, in this case 60 characters per row. As you can see, the top tick label of the y-axis is 0 and the bottom tick label of the y-axis is 60, this is because the writing of Arabic is right-to-left, and so we can think of the 0th-tick at the top as the starting index of the first character in both texts, and the row ends at the 60th-tick at the bottom.

We added further customization to the plot, readers are encouraged to explore the API.

As for the plot of insertions of characters, we have:
```@example abc
f, a, xys = plot(res1, :insertions)
a[1].xlabel = "Shamela0023790"
a[1].xlabelsize = 20
a[1].xticks = 0:2:unique(xys[1][1])[end]
a[3].xlabel = "Shamela0012129"
a[3].xlabelsize = 20
a[3].xticks = 0:2:unique(xys[2][1])[end]
f
```
For deletions, we have:
```@example abc
f, a, xys = plot(res1, :deletions)
a[1].xlabel = "Shamela0023790"
a[1].xlabelsize = 20
a[1].xticks = 0:2:unique(xys[1][1])[end]
a[3].xlabel = "Shamela0012129"
a[3].xlabelsize = 20
a[3].xticks = 0:2:unique(xys[2][1])[end]
f
```
And for mismatches, we have
```@example abc
f, a, xys = plot(res1, :mismatches)
a[1].xlabel = "Shamela0023790"
a[1].xlabelsize = 20
a[1].xticks = 0:2:unique(xys[1][1])[end]
a[3].xlabel = "Shamela0012129"
a[3].xlabelsize = 20
a[3].xticks = 0:2:unique(xys[2][1])[end]
f
```
## Cost Model
The pairwise alignment above works by minimizing a cost function, which is define by a cost model. It is important that we understand how the cost model is setup so that we can give proper scoring for the mismatches, matches, deletions and insertions. To define a cost model, we use [BioAligments.jl](https://github.com/BioJulia/BioAlignments.jl)'s `CostModel` struct.

The default cost model is given by
```@setup def
using Pkg
Pkg.add("BioAlignments")
```
```@repl def
using BioAlignments
costmodel = CostModel(match=0, mismatch=1, insertion=1, deletion=1)
```
!!! note "Interpretation of CostModel"
    The instantiated `costmodel` above tells us that, if a matched happened between the characters of the reference and the target texts, we set it to 0. Otherwise, that is, if mismatch, insertions or deletions happened, then the distance is 1.
!!! note "Optimization of the Alignment"
    The alignment is optimized by minimizing the cost function defined by the cost model, by prioritizing matches since it gives the algorithm a lower distance (which is 0)

If we set the costmodel to the following,
```@repl def
using BioAlignments
costmodel = CostModel(match=0, mismatch=10, insertion=3, deletion=1)
```
Then if a mismatch happened, the algorithm will instead consider it a deletion as much as possible to avoid a distance score of 10 (for mismatch) and go for a distance of 1 (for deletion) instead.

Consider the following example,
```@example def
using Yunir
etgt = "رضي الله عنه"
eref = "صلي الله عليه وسلم"
mapping = Dict("الله" => "ﷲ",)
etgt_nrm = normalize(etgt, mapping)
eref_nrm = normalize(eref, mapping)
costmodel = CostModel(match=0, mismatch=1, insertion=1, deletion=1);
res_c1 = align(encode(eref_nrm), encode(etgt_nrm), costmodel=costmodel)
res_c1
```
Now, compare the result if we increased the mismatch and insertion in the cost model.
```@example def
costmodel = CostModel(match=0, mismatch=10, insertion=5, deletion=1)
res_c2 = align(encode(eref_nrm), encode(etgt_nrm), costmodel=costmodel)
res_c2
```
You can copy and paste the result to any text editor with Arabic monospace, like in [Notepad++](https://notepad-plus-plus.org/) screenshot above to see the alignment properly.

You will notice that, in `res_c1` above we have 3 mismatches, but in `res_c2` the algorithm avoided assigning mismatches and instead prioritized deletions and insertions. This can be confirmed below:
```@repl def
count_mismatches(res_c1)
count_deletions(res_c1)
count_insertions(res_c1)
count_mismatches(res_c2)
count_deletions(res_c2)
count_insertions(res_c2)
```
## Visualizing Aggregated Alignment
What we've seen so far is at the level of pairwise alignment of individual milestone. This maybe useful for some use cases, but for studies where we look at the macro level alignment, that is, at the level of the book itself or full text, it would require an aggregated visualization of the results.

The following is a simple demo, but we recommend you to checkout [Kitab.jl](https://github.com/alstat/Kitab.jl) for a comprehensive example.

In this example, we are going to use portion of two books, the المعارف and عيون الأخبار both by Ibn Qutayba Dinawari. To download this, we run the following using the Kitab.jl library.
```@setup hij
using Pkg
Pkg.add("Kitab")
Pkg.add("CairoMakie")
```
```@repl hij
using Kitab
using Yunir
macarif_url = "https://raw.githubusercontent.com/OpenITI/RELEASE/f70348b43c92e97582e63b6c4b4a8596e6d4ac84/data/0276IbnQutaybaDinawari/0276IbnQutaybaDinawari.Macarif/0276IbnQutaybaDinawari.Macarif.Shamela0012129-ara1.mARkdown";
cuyunakhbar_url = "https://raw.githubusercontent.com/OpenITI/RELEASE/f70348b43c92e97582e63b6c4b4a8596e6d4ac84/data/0276IbnQutaybaDinawari/0276IbnQutaybaDinawari.CuyunAkhbar/0276IbnQutaybaDinawari.CuyunAkhbar.Shamela0023790-ara1.completed";
Kitab.get(OpenITIDB, [macarif_url, cuyunakhbar_url])
list(OpenITIDB)
cuyunakhbar = load(OpenITIDB, 1)
macarif = load(OpenITIDB, 2)
```
We then split this data into milestone, which is indicated by a prefix `ms` in the text (OpenITI annotates the book by adding milestone indicator for partitioning the book). 
```@repl hij
target = clean.(split(join(cuyunakhbar, " "), "ms"))
reference = clean.(split(join(macarif, " "), "ms"))
```
We then replace empty lines with spaces, users can also delete these lines.
```@repl hij
target = map(x -> x != "" ? x : "   ", target)
reference = map(x -> x != "" ? x : "   ", reference)
```
Like other examples above, we encode the following words to their unicode character.
```@repl hij
mapping = Dict(
    "الله" => "ﷲ",
    "لا" => "ﻻ"
)
target = normalize(target, mapping)
reference = normalize(reference, mapping)
```
We further clean the data by normalization and dediacritization:
```@repl hij
etgt = encode.(normalize.(dediac.(target)));
etgt = string.(strip.(replace.(etgt, r"\s+" => " ")));
eref = encode.(normalize.(dediac.(reference)));
eref = string.(strip.(replace.(eref, r"\s+" => " ")));
```
Finally, we can run the alignment for the first 20 milestones of macarif, and first 30 milestones of cuyunakhbar:
```@repl hij
res, scr = align(eref[1:20], etgt[1:30]);
```
We can then plot the heatmap of the scores:
```@example hij
using CairoMakie
fig, ax, hm = heatmap(1:size(scr, 1), 1:size(scr, 2), scr);
Colorbar(fig[:, end+1], hm)
fig
```
The x-axis contains the index of the reference milestones, and the y-axis contains the target milestone indices. We can plot the alignment of first milestone of reference against first milestone of target
```@example hij
f1, a1, xy1 = plot(res[1,1], :insertions)
f1
```
Finally, to plot all the milestones in one figure, we first filter the scores to those with lower scores or distances, so that we'll have milestones that are indeed similar.
```@example hij
idx = findmin(scr, dims=2)[2][findmin(scr, dims=2)[1] .< 1150]
f2, a2, xy2 = plot(res, idx; midstyles=(color=(:red, 0.7), linewidth=0.1))
f2
```
The `idx` contains the indices of the pairwise alignment with score lower than 1150. The orange line in the reference plot indicates the end of line of the reference text.