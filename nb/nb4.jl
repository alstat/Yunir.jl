using Yunir
using QuranTree

crps, tnzl = load(QuranData());
crpstbl = table(crps)
tnzltbl = table(tnzl)
bw_texts = verses(tnzltbl[1])

texts = String[]
for text in bw_texts
	push!(texts, split(text, " ")[end])
end

r = Rhyme(true, Syllable(1, 2, 1))
r.(texts, true)
segments = r.(encode.(texts), false)

# plotting
using Makie
using CairoMakie

syllables, y_vec, y_dict = transition(segments, Segment)
# syllables = [join(s.harakaat) for s in segments]
f = Figure(resolution=(500, 500));
a1 = Axis(f[1,1], 
    xlabel="Ayah Number",
    ylabel="Last Pronounced Syllable\n\n\n",
    title="Surah Al-Fatihah Rhythmic Patterns\n\n",
    yticks=(unique(y_vec), unique(syllables)), 
    # xticks = collect(eachindex(syllables))
)
lines!(a1, collect(eachindex(syllables)), y_vec)
f