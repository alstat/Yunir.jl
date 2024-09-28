using Yunir
using QuranTree

crps, tnzl = load(QuranData());
crpstbl = table(crps)
tnzltbl = table(tnzl)
bw_texts = verses(tnzltbl[2])[1:end]
bw_texts2 = verses(tnzltbl[3])[1:end]

function extract_endword(s::Array{String})
    texts = String[]
    for text in s
        push!(texts, split(text, " ")[end])
    end
    return texts
end

r = Rhyme(true, Syllable(1, 1, 1))
r.(texts, true)
segments = r.(encode.(extract_endword(bw_texts)), false)
segments2 = r.(encode.(extract_endword(bw_texts2)), false)

join(map(x -> x.harakaat, segments), "")

o = align(join(map(x -> x.harakaat[1], segments), ""), join(map(x -> x.harakaat[1], segments2), ""))
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

PairwiseAlignment
١-reference
٢-target

٢    ـــــــــــــــــــــــــــــــــــــــــــــــــــــــــــ
                                                                
١    لَا يُكَلِّفُ ٱللَّهُ نَفْسًا إِلَّا وُسْعَهَا لَهَا مَا كَ

٢    ــــــــــــــــــــــــــــــــــــبــــــــــــــــــــــ
                                         ا                      
١    َبَتْ وَعَلَيْهَا مَا ٱكْتَسَبَتْ رَبَّنَا لَا تُؤَاخِذْنَا

٢    ــِـــــســــــــــــــــــــــــــــــــــــــــــْمــــــ
       ا     ا                                          اا      
١     إِن نَّسِينَآ أَوْ أَخْطَأْنَا رَبَّنَا وَلَا تَحْمِلْ عَ

٢    ـــــــــِـــــــــــــــــــــــــــــ ٱـــــــــــــــــل
              ا                             اا                 ا
١    َيْنَآ إِصْرًا كَمَا حَمَلْتَهُۥ عَلَى ٱلَّذِينَ مِن قَبْل

٢    ـــــــــــــــلــــــــّــــــــــــــــــــــــــَــــهِـ
                    ا        ا                          ا    اا 
١    نَا رَبَّنَا وَلَا تُحَمِّلْنَا مَا لَا طَاقَةَ لَنَا بِهِۦ

٢    ــــــــــــــ ــٱـــــــلــــــــرـَّحْـــــــــــمــــَـٰ
                   ا  ا       ا        ا  ا ا           ا    ا ا
١    وَٱعْفُ عَنَّا وَٱغْفِرْ لَنَا وَٱرْحَمْنَآ أَنتَ مَوْلَىٰ

  …  PairwiseAlignment
١-reference
٢-target

٢    ــــــــــــــــــــــــــــــصِـــــــــــــــــــــــــــ
                                    ا                           
١    لَا يُكَلِّفُ ٱللَّهُ نَفْسًا إِلَّا وُسْعَهَا لَهَا مَا كَ

٢    ــــــــــــــرَـٰطَـ ٱــــــــــــــــــــلـــــــــــــــ
                    ا   ا اا                    ا               
١    َبَتْ وَعَلَيْهَا مَا ٱكْتَسَبَتْ رَبَّنَا لَا تُؤَاخِذْنَا

٢    ــــــَّذِينـــــَــ أَنْعَمْـــــــــــــــــــتَــــــ عَ
           اا ااا     ا  ااا ا ا ا                   اا      ااا
١     إِن نَّسِينَآ أَوْ أَخْطَأْنَا رَبَّنَا وَلَا تَحْمِلْ عَ

٢    َيْـــــهِــــــــــــــمــْـــــــــــ ــغَــيــــــــــْـ
     ااا      ا              ا  ا           ا   ا  ا          ا 
١    َيْنَآ إِصْرًا كَمَا حَمَلْتَهُۥ عَلَى ٱلَّذِينَ مِن قَبْل

٢    ــــرــــــــــــِ ــــــٱلْــــمــــــــــــــــــــــــــ
         ا             ا       اا    ا                          
١    نَا رَبَّنَا وَلَا تُحَمِّلْنَا مَا لَا طَاقَةَ لَنَا بِهِۦ

٢    ـَـغْضُــــــــوــــبِــ ــعَــلَـيْهِمْــــــــــ ــوـــــ
      ا  ا ا        ا     ا  ا   ا   ا  ا  اا          ا  ا     
١    وَٱعْفُ عَنَّا وَٱغْفِرْ لَنَا وَٱرْحَمْنَآ أَنتَ مَوْلَىٰ
