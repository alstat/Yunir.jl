# test
using Yunir
using CairoMakie

bw_texts = [
    Bw("bisomi {ll~ahi {lr~aHoma`ni {lr~aHiymi"),
    Bw("{loHamodu lil~ahi rab~i {loEa`lamiyna"),
    Bw("{lr~aHoma`ni {lr~aHiymi"),
    Bw("ma`liki yawomi {ld~iyni"),
    Bw("<iy~aAka naEobudu wa<iy~aAka nasotaEiynu"),
    Bw("{hodinaA {lS~ira`Ta {lomusotaqiyma"),
    Bw("Sira`Ta {l~a*iyna >anoEamota Ealayohimo gayori {lomagoDuwbi Ealayohimo walaA {lD~aA^l~iyna")
]

last_syllable(LastRecited(A), bw_texts[1])
last_syllable(LastRecited(B), Bw("bisomi {ll~ahi {lr~aHoma`ni {lr~aHiymi")) === (LastRecitedSyllable(Bw("iy")), LastRecitedSyllable(Bw("iym")))
last_syllable(LastRecited(C), Bw("bisomi {ll~ahi {lr~aHoma`ni {lr~aHiymi")) === (LastRecitedSyllable(Bw("iy")), LastRecitedSyllable(Bw("iym")), LastRecitedSyllable(Bw("Hiym")))






LastRecited(A)

y1_chars = Vector{LastRecitedSyllable}()
y2_chars = Vector{LastRecitedSyllable}()
y3_chars = Vector{LastRecitedSyllable}()
for text in bw_texts
    chars_tuple = last_syllable(text)
    push!(y1_chars, chars_tuple[1])
    push!(y2_chars, chars_tuple[2])
    push!(y3_chars, chars_tuple[3])
end
y1, y1_dict = to_number(y1_chars)
y2, y2_dict = to_number(y2_chars)
y3, y3_dict = to_number(y3_chars)

y1 == [1, 1, 1, 1, 1, 1, 1]
y2 == [1, 2, 1, 2, 2, 1, 2]
y3 == [1, 2, 1, 3, 4, 5, 3]
y1_dict == Dict(LastRecitedSyllable(Bw("iy")) => 1)
y2_dict == Dict(LastRecitedSyllable(Bw("iym")) => 1, LastRecitedSyllable(Bw("iyn")) => 2)
y3_dict == Dict(
    LastRecitedSyllable(Bw("Eiyn")) => 4, 
    LastRecitedSyllable(Bw("~iyn")) => 3,
    LastRecitedSyllable(Bw("qiym")) => 5,
    LastRecitedSyllable(Bw("Hiym")) => 1,
    LastRecitedSyllable(Bw("miyn")) => 2
)

rvis = RhythmicVis(LastRecited(A))
f, d = rvis(bw_texts)
f



###
LastRecited(LastRecitedVariants.one)