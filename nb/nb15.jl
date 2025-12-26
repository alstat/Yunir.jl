# test
using QuranTree
using CairoMakie

crps, tnzl = load(QuranData());
crps_tbl = table(crps)
tnzl_tbl = table(tnzl)
bw_texts = Buckwalter.(verses(crps_tbl[1]))

rvis = RhythmicVis(last_recited, LastRecitedVisArgs(three))
f, d = rvis(bw_texts)
f



d
f
y1_chars = Array{LastRecitedSyllable,1}()
y2_chars = Array{LastRecitedSyllable,1}()
y3_chars = Array{LastRecitedSyllable,1}()
for text in bw_texts
    chars_tuple = last_syllable(text)
    push!(y1_chars, chars_tuple[1])
    push!(y2_chars, chars_tuple[2])
    push!(y3_chars, chars_tuple[3])
end




y_dict = Dict{LastRecitedSyllable,Int64}()
y_dict[y3_chars[1]] = 1


y3_chars[1] ∈ Ref(Set(keys(y_dict)))
y1_chars

y1_chars, y2_chars, y3_chars = last_syllable.(bw_texts)
y1, y1_dict = encode_to_number(y1_chars)
y2, y2_dict = encode_to_number(y2_chars)
y3, y3_dict = encode_to_number(y3_chars)
