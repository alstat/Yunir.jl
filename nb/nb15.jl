# test
using QuranTree
using CairoMakie

crps, tnzl = load(QuranData());
crps_tbl = table(crps)
tnzl_tbl = table(tnzl)
bw_texts = Buckwalter.(verses(crps_tbl[1]))

last_syllable(bw_texts[1])
last_syllable(Buckwalter("bisomi {ll~ahi {lr~aHoma`ni {lr~aHiymi")) === (LastRecitedSyllable(Buckwalter("iy")), LastRecitedSyllable(Buckwalter("iym")), LastRecitedSyllable(Buckwalter("Hiym")))

alfatihah_bw = [
    Buckwalter("bisomi {ll~ahi {lr~aHoma`ni {lr~aHiymi"),
    Buckwalter("{loHamodu lil~ahi rab~i {loEa`lamiyna"),
    Buckwalter("{lr~aHoma`ni {lr~aHiymi"),
    Buckwalter("ma`liki yawomi {ld~iyni"),
    Buckwalter("<iy~aAka naEobudu wa<iy~aAka nasotaEiynu"),
    Buckwalter("{hodinaA {lS~ira`Ta {lomusotaqiyma"),
    Buckwalter("Sira`Ta {l~a*iyna >anoEamota Ealayohimo gayori {lomagoDuwbi Ealayohimo walaA {lD~aA^l~iyna")
]

y1_chars = Vector{LastRecitedSyllable}()
y2_chars = Vector{LastRecitedSyllable}()
y3_chars = Vector{LastRecitedSyllable}()
for text in alfatihah_bw
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
y1_dict == Dict(LastRecitedSyllable(Buckwalter("iy")) => 1)
y2_dict == Dict(LastRecitedSyllable(Buckwalter("iym")) => 1, LastRecitedSyllable(Buckwalter("iyn")) => 2)
y3_dict == Dict(
    LastRecitedSyllable(Buckwalter("Eiyn")) => 4, 
    LastRecitedSyllable(Buckwalter("~iyn")) => 3,
    LastRecitedSyllable(Buckwalter("qiym")) => 5,
    LastRecitedSyllable(Buckwalter("Hiym")) => 1,
    LastRecitedSyllable(Buckwalter("miyn")) => 2
)


rvis = RhythmicVis(last_recited::VisType, LastRecitedVisArgs(three))
f, d = rvis(bw_texts)
f
