using Yunir
using QuranTree

crps, tnzl = load(QuranData());
crpstbl = table(crps)
tnzltbl = table(tnzl)
bw_texts = (verses(tnzltbl))

texts = String[]
for text in bw_texts
	push!(texts, split(text, " ")[end])
end

r = Rhyme(true, Syllable(1, 1, 2))
r.(texts, true)
r.(encode.(texts), false)