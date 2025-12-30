using Yunir
using QuranTree

crps, tnzl = load(QuranData());
crpstbl = table(crps)
tnzltbl = table(tnzl)
bw_texts = verses(tnzltbl[2])[2:end]
bw_texts2 = verses(tnzltbl[5])[2:end]

function extract_endword(s::Vector{String})
    texts = String[]
    for text in s
        push!(texts, split(text, " ")[end])
    end
    return texts
end

r = Rhyme(true, Syllable(1, 1, 1))
r.(encode.(bw_texts), true)
segments = r.(encode.(extract_endword(bw_texts)), false)

# segments2 = r.(encode.(extract_endword(bw_texts2)), false)

join(map(x -> x.harakaat, segments), "")

o = align(join(map(x -> x.harakaat[1], segments), ""), join(map(x -> x.harakaat[1], segments2), ""))
f = plot(o)
f[1]
o.alignment

score(o)

o = align(join(encode.(bw_texts), " "), join(encode.(bw_texts2), " "))
o.alignment
score(o)
o[1][2,2].alignment
score(o[1][1,1])
o[2]

# plotting
using Makie
using CairoMakie
set_theme!(fonts = (; regular = "Comic Sans", bold = "Monaco"))
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