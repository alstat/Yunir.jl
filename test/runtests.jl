using Test
using Yunir

@info "encoding"
ar_basmala = "بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ"
@test encode(ar_basmala) === "bisomi {ll~ahi {lr~aHoma`ni {lr~aHiymi"

@info "dediac and arabic"
bw_basmala = "bisomi {ll~ahi {lr~aHoma`ni {lr~aHiymi"
@test dediac(bw_basmala) === "bsm {llh {lrHmn {lrHym"
@test arabic(dediac(bw_basmala)) === "بسم ٱلله ٱلرحمن ٱلرحيم"
@test dediac(arabic(bw_basmala)) === arabic(dediac(bw_basmala))

@info "normalizing"
ar_basmala = "بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ"
@test normalize(ar_basmala, :alif_khanjareeya) === "بِسْمِ ٱللَّهِ ٱلرَّحْمَانِ ٱلرَّحِيمِ"
@test normalize(ar_basmala, :hamzat_wasl) === "بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ"

sentence1 = "وَٱلَّذِينَ يُؤْمِنُونَ بِمَآ أُنزِلَ إِلَيْكَ وَمَآ أُنزِلَ مِن قَبْلِكَ وَبِٱلْءَاخِرَةِ هُمْ يُوقِنُونَ"
@test normalize(sentence1, :alif_maddah) === "وَٱلَّذِينَ يُؤْمِنُونَ بِمَا أُنزِلَ إِلَيْكَ وَمَا أُنزِلَ مِن قَبْلِكَ وَبِٱلْءَاخِرَةِ هُمْ يُوقِنُونَ"
@test normalize(sentence1, :alif_hamza_above) === "وَٱلَّذِينَ يُؤْمِنُونَ بِمَآ اُنزِلَ إِلَيْكَ وَمَآ اُنزِلَ مِن قَبْلِكَ وَبِٱلْءَاخِرَةِ هُمْ يُوقِنُونَ"

sentence2 = "إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ"
@test normalize(sentence2, :alif_hamza_below) === "اِيَّاكَ نَعْبُدُ وَاِيَّاكَ نَسْتَعِينُ"

sentence3 = "ٱلَّذِينَ يُؤْمِنُونَ بِٱلْغَيْبِ وَيُقِيمُونَ ٱلصَّلَوٰةَ وَمِمَّا رَزَقْنَٰهُمْ يُنفِقُونَ"
@test normalize(sentence3, :waw_hamza_above) === "ٱلَّذِينَ يُوْمِنُونَ بِٱلْغَيْبِ وَيُقِيمُونَ ٱلصَّلَوٰةَ وَمِمَّا رَزَقْنَٰهُمْ يُنفِقُونَ"
@test normalize(sentence3, :ta_marbuta) === "ٱلَّذِينَ يُؤْمِنُونَ بِٱلْغَيْبِ وَيُقِيمُونَ ٱلصَّلَوٰهَ وَمِمَّا رَزَقْنَٰهُمْ يُنفِقُونَ"

sentence4 = "ٱللَّهُ يَسْتَهْزِئُ بِهِمْ وَيَمُدُّهُمْ فِى طُغْيَٰنِهِمْ يَعْمَهُونَ"
@test normalize(sentence4, :ya_hamza_above) === "ٱللَّهُ يَسْتَهْزِيُ بِهِمْ وَيَمُدُّهُمْ فِى طُغْيَٰنِهِمْ يَعْمَهُونَ"

sentence5 = "ذَٰلِكَ ٱلْكِتَٰبُ لَا رَيْبَ فِيهِ هُدًى لِّلْمُتَّقِينَ"
@test normalize(sentence5, :alif_maksura) === "ذَٰلِكَ ٱلْكِتَٰبُ لَا رَيْبَ فِيهِ هُدًي لِّلْمُتَّقِينَ"

@test normalize(ar_basmala, [:alif_khanjareeya, :hamzat_wasl]) === "بِسْمِ اللَّهِ الرَّحْمَانِ الرَّحِيمِ"

sentence6 = "ﷺ"
@test normalize(sentence6) === "صلى الله عليه وسلم"

sentence7 = "ﷻ"
@test normalize(sentence7) === "جل جلاله"

sentence8 = "﷽"
@test normalize(sentence8) === ar_basmala

@test normalize("بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ") === "بِسْمِ اللَّهِ الرَّحْمَانِ الرَّحِيمِ"

@info "tokenization"
sentence10 = "هَلْ,; ذَهَبْتَ إِلَى المَكْتَبَةِ؟"
@info tokenize(sentence10) === ["هَلْ", "ذَهَبْتَ", "إِلَى", "المَكْتَبَةِ", ",", ";", "؟"]
@info tokenize(sentence10, false) === ["هَلْ,;", "ذَهَبْتَ", "إِلَى", "المَكْتَبَةِ؟"]

@info "transliterator"
my_encoder = Dict(
    Symbol(Char(0x0621)) => Symbol('('),
    Symbol(Char(0x0622)) => Symbol('\''),
    Symbol(Char(0x0623)) => Symbol('&'),
    Symbol(Char(0x0624)) => Symbol('>'),
    Symbol(Char(0x0625)) => Symbol('}'),
    Symbol(Char(0x0626)) => Symbol('<'),
    Symbol(Char(0x0627)) => Symbol('b'),
    Symbol(Char(0x0628)) => Symbol('A'),
    Symbol(Char(0x0629)) => Symbol('t'),
    Symbol(Char(0x062A)) => Symbol('p'),
    Symbol(Char(0x062B)) => Symbol('j'),
    Symbol(Char(0x062C)) => Symbol('v'),
    Symbol(Char(0x062D)) => Symbol('x'),
    Symbol(Char(0x062E)) => Symbol('H'),
    Symbol(Char(0x062F)) => Symbol('*'),
    Symbol(Char(0x0630)) => Symbol('d'),
    Symbol(Char(0x0631)) => Symbol('z'),
    Symbol(Char(0x0632)) => Symbol('r'),
    Symbol(Char(0x0633)) => Symbol('$'),
    Symbol(Char(0x0634)) => Symbol('s'),
    Symbol(Char(0x0635)) => Symbol('D'),
    Symbol(Char(0x0636)) => Symbol('S'),
    Symbol(Char(0x0637)) => Symbol('Z'),
    Symbol(Char(0x0638)) => Symbol('T'),
    Symbol(Char(0x0639)) => Symbol('g'),
    Symbol(Char(0x063A)) => Symbol('E'),
    Symbol(Char(0x0640)) => Symbol('f'),
    Symbol(Char(0x0641)) => Symbol('_'),
    Symbol(Char(0x0642)) => Symbol('k'),
    Symbol(Char(0x0643)) => Symbol('q'),
    Symbol(Char(0x0644)) => Symbol('m'),
    Symbol(Char(0x0645)) => Symbol('l'),
    Symbol(Char(0x0646)) => Symbol('h'),
    Symbol(Char(0x0647)) => Symbol('n'),
    Symbol(Char(0x0648)) => Symbol('Y'),
    Symbol(Char(0x0649)) => Symbol('w'),
    Symbol(Char(0x064A)) => Symbol('F'),
    Symbol(Char(0x064B)) => Symbol('y'),
    Symbol(Char(0x064C)) => Symbol('K'),
    Symbol(Char(0x064D)) => Symbol('N'),
    Symbol(Char(0x064E)) => Symbol('u'),
    Symbol(Char(0x064F)) => Symbol('a'),
    Symbol(Char(0x0650)) => Symbol('~'),
    Symbol(Char(0x0651)) => Symbol('i'),
    Symbol(Char(0x0652)) => Symbol('^'),
    Symbol(Char(0x0653)) => Symbol('o'),
    Symbol(Char(0x0654)) => Symbol('`'),
    Symbol(Char(0x0670)) => Symbol('#'),
    Symbol(Char(0x0671)) => Symbol(':'),
    Symbol(Char(0x06DC)) => Symbol('{'),
    Symbol(Char(0x06DF)) => Symbol('\"'),
    Symbol(Char(0x06E0)) => Symbol('@'),
    Symbol(Char(0x06E2)) => Symbol(';'),
    Symbol(Char(0x06E3)) => Symbol('['),
    Symbol(Char(0x06E5)) => Symbol('.'),
    Symbol(Char(0x06E6)) => Symbol(','),
    Symbol(Char(0x06E8)) => Symbol('-'),
    Symbol(Char(0x06EA)) => Symbol('!'),
    Symbol(Char(0x06EB)) => Symbol('%'),
    Symbol(Char(0x06EC)) => Symbol('+'),
    Symbol(Char(0x06ED)) => Symbol(']')
);

@transliterator my_encoder "MyEncoder"
@test encode(ar_basmala) === "A~\$^l~ :mmiun~ :mziux^lu#h~ :mziux~Fl~"
@test arabic(encode(ar_basmala)) === ar_basmala

old_keys = collect(keys(BW_ENCODING));
new_vals = reverse(collect(values(BW_ENCODING)));
my_encoder = Dict(old_keys .=> new_vals)
@transliterator my_encoder "MyEncoder"

@info "Orthographical Analysis"
arb_token = tokenize(ar_basmala)

@test parse(Orthography, arb_token[1]) isa Orthography

arb_parsed2 = parse.(Orthography, arb_token)
@test numerals(arb_parsed2[1]) == [2, nothing, 60, nothing, 40, nothing]

@test isfeat(arb_parsed2[1], AbstractLunar) == [1, 0, 0, 0, 1, 0]
@test arb_parsed2[1][isfeat(arb_parsed2[1], AbstractLunar)] == [Ba, Meem]

@test vocals(arb_parsed2[1]) == [:labial, nothing, :sibilant, nothing, :labial, nothing]

@test parse(SimpleEncoding, ar_basmala) === "Ba+Kasra | Seen+Sukun | Meem+Kasra | <space> | AlifHamzatWasl | Lam | Lam+Shadda+Fatha | Ha+Kasra | <space> | AlifHamzatWasl | Lam | Ra+Shadda+Fatha | HHa+Sukun | Meem+Fatha+AlifKhanjareeya | Noon+Kasra | <space> | AlifHamzatWasl | Lam | Ra+Shadda+Fatha | HHa+Kasra | Ya | Meem+Kasra" 

@info "Alignment"
shamela0012129 = "خرج مع ابي بكر الصديق رضي الله عنه في تجارة الي بصري ومعهم نعيمان وكان نعيمان ممن شهد——- بدرا ايضا وك——-ان علي الزاد فقال له سويبط———– اطعمني فقال حتي يجء ابو بكر فقال اما والله لاغيظنك فمروا بقوم فقال لهم سويبط -تشترون مني عبدا قا—لوا نعم فقال انه عبد له كلام وهو قاءل لكم اني حر فان كنتم اذا قال لكم هذه المقالة تركتموه فلا تفسدوا علي عبدي قا-لوا بل نشتريه منك فاشتروه بعشر قلاءص ثم جاءوا فوضعوا في عنقه حبلا ف—————قال نعيمان ان هذا يستهزء بكم واني حر فقالوا قد عرفنا –خبرك وانطلقوا به فلما جاء ابو بكر -اخبروه فاتبعهم ورد عليهم القلاءص واخذه فلما قدموا علي النبي صلي الله عليه وسلم اخبروه فضحك هو واصحابه من ذلك حولا"
shamela0023790 = "خرج— ابو بكر——————– في تجارة——— ومعه- نعيمان وسويبط بن حرملة وكانا شهدا بدر—–ا وكان نعيمان علي الزاد فقال له سويبط وكان مزاحا اطعمني فقال حتي يجء ابو بكر فقال اما والله لاغيظنك فمروا بقوم فقال لهم سويبط اتشترون مني عبدا لي قالوا نعم ق-ال انه عبد له كلام وهو قاءل لكم اني حر فان كنتم اذا قال لكم هذه المقالة تركتموه فلا تفسدوا علي عبدي فقالوا بل نشتريه منك——– بعشر قلاءص ثم جاءوا فوضعوا في عنقه حبلا وعمامة واشتروه فقال نعيمان ان هذا يستهزء بكم واني حر قا-لوا قد اخبرنا بخبرك وانطلقوا به و—-جاء ابو بكر فاخبروه فاتبعهم فرد عليهم القلاءص واخذه فلما قدموا علي النبي صلي الله عليه وسلم اخبروه فضحك هو واصحابه منهما- حول"
shamela0012129_cln = clean(shamela0012129)
shamela0023790_cln = clean(shamela0023790)
mapping = Dict(
    "الله" => "ﷲ",
    "لا" => "ﻻ"
);
shamela0012129_nrm = normalize(shamela0012129_cln, mapping)
shamela0023790_nrm = normalize(shamela0023790_cln, mapping)

shamela0012129_enc = encode(shamela0012129_nrm)
shamela0023790_enc = encode(shamela0023790_nrm)
res = align(shamela0012129_enc, shamela0023790_enc);

@test count_matches(res) == 515
@test count_mismatches(res) == 16
@test count_insertions(res) == 50
@test count_deletions(res) == 52
@test count_aligned(res) == 633
@test score(res) == 66

shamela0012129 = "خرج مع ابي بكر الصديق رضي الله عنه في تجارة الي بصري ومعهم نعيمان وكان نعيمان ممن شهد——- بدرا ايضا وك——-ان علي الزاد فقال له سويبط———– اطعمني فقال حتي يجء ابو بكر فقال اما والله لاغيظنك فمروا بقوم فقال لهم سويبط -تشترون مني عبدا قا—لوا نعم فقال انه عبد له كلام وهو قاءل لكم اني حر فان كنتم اذا قال لكم هذه المقالةAA تركتموه فلا تفسدوا علي عبدي قا-لوا بل نشتريه منك فاشتروه بعشر قلاءص ثم جاءوا فوضعوا في عنقه حبلا ف—————قال نعيمان ان هذا يستهزء بكم واني حر فقالوا قد عرفنا –خبرك وانطلقوا به فلما جاء ابو بكر -اخبروه فاتبعهم ورد عليهم القلاءص واخذه فلما قدموا علي النبي صلي الله عليه وسلم اخبروه فضحك هو واصحابه من ذلك حولا"
shamela0023790 = "خرج— ابو بكر——————– في تجارة——— ومعه- نعيمان وسويبط بن حرملة وكانا شهدا بدر—–ا وكان نعيمان علي الزاد فقال له سويبط وكان مزاحا اطعمني فقال حتي يجء ابو بكر فقال اما والله لاغيظنك فمروا بقوم فقال لهم سويبط اتشترون مني عبدا لي قالوا نعم ق-ال انه عبد له كلام وهو قاءل لكم اني حر فان كنتم اذا قال لكم هذه المقالة تركتموه  AAفلا تفسدوا علي عبدي فقالوا بل نشتريه منك——– بعشر قلاءص ثم جاءوا فوضعوا في عنقه حبلا وعمامة واشتروه فقال نعيمان ان هذا يستهزء بكم واني حر قا-لوا قد اخبرنا بخبرك وانطلقوا به و—-جاء ابو بكر فاخبروه فاتبعهم فرد عليهم القلاءص واخذه فلما قدموا علي النبي صلي الله عليه وسلم اخبروه فضحك هو واصحابه منهما- حول"
shamela0012129 = string.(split(shamela0012129, "AA"))
shamela0023790 = string.(split(shamela0023790, "AA"))
shamela0012129_cln = clean.(shamela0012129)
shamela0023790_cln = clean.(shamela0023790)
mapping = Dict(
    "الله" => "ﷲ",
    "لا" => "ﻻ"
);
shamela0012129_nrm = normalize(shamela0012129_cln, mapping)
shamela0023790_nrm = normalize(shamela0023790_cln, mapping)

shamela0012129_enc = encode.(shamela0012129_nrm)
shamela0023790_enc = encode.(shamela0023790_nrm)

res, scr = align(shamela0012129_enc, shamela0023790_enc);
@test count_matches(res[1,1]) == 247
@test scr == [49 154; 167 27]

function capture_io(x)
    io = IOBuffer()
    println(io, x)
    return String(take!(io))
end

shamela0012129 = "خبروه فضحك هو واصحابه من ذلك حولا"
shamela0023790 = "اخبروه فضحك هو واصحابه منهما- حول"
shamela0012129_cln = clean(shamela0012129)
shamela0023790_cln = clean(shamela0023790)
mapping = Dict(
    "الله" => "ﷲ",
    "لا" => "ﻻ"
);
shamela0012129_nrm = normalize(shamela0012129_cln, mapping)
shamela0023790_nrm = normalize(shamela0023790_cln, mapping)

shamela0012129_enc = encode(shamela0012129_nrm)
shamela0023790_enc = encode(shamela0023790_nrm)
res = align(shamela0012129_enc, shamela0023790_enc);

out = capture_io(res);
@test out == "PairwiseAlignment\n١-reference\n٢-target\n\n٢    اخبروه فضحك هو واصحابه منٓهما حو\n      اااااااااااااااااااااااا    ااا\n١    ٓخبروه فضحك هو واصحابه من ذلك حو\n\n\n"