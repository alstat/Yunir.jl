using Test
using Yunir
using Makie

@testset "Yunir.jl Unit Tests" begin
    @testset "Basic Text Processing" begin
        @info "encoding"
        ar_basmala = Ar("بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ")
        @test encode(ar_basmala) === Bw("bisomi {ll~ahi {lr~aHoma`ni {lr~aHiymi")

        @info "dediac and arabic"
        bw_basmala = Bw("bisomi {ll~ahi {lr~aHoma`ni {lr~aHiymi")
        @test dediac(bw_basmala) === Bw("bsm {llh {lrHmn {lrHym")
        @test arabic(dediac(bw_basmala)) === Ar("بسم ٱلله ٱلرحمن ٱلرحيم")
        @test dediac(arabic(bw_basmala)) === arabic(dediac(bw_basmala))

        @info "normalizing"
        ar_basmala = Ar("بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ")
        @test normalize(ar_basmala, :alif_khanjareeya) === Ar("بِسْمِ ٱللَّهِ ٱلرَّحْمَانِ ٱلرَّحِيمِ")
        @test normalize(ar_basmala, :hamzat_wasl) === Ar("بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ")

        sentence1 = Ar("وَٱلَّذِينَ يُؤْمِنُونَ بِمَآ أُنزِلَ إِلَيْكَ وَمَآ أُنزِلَ مِن قَبْلِكَ وَبِٱلْءَاخِرَةِ هُمْ يُوقِنُونَ")
        @test normalize(sentence1, :alif_maddah) === Ar("وَٱلَّذِينَ يُؤْمِنُونَ بِمَا أُنزِلَ إِلَيْكَ وَمَا أُنزِلَ مِن قَبْلِكَ وَبِٱلْءَاخِرَةِ هُمْ يُوقِنُونَ")
        @test normalize(sentence1, :alif_hamza_above) === Ar("وَٱلَّذِينَ يُؤْمِنُونَ بِمَآ اُنزِلَ إِلَيْكَ وَمَآ اُنزِلَ مِن قَبْلِكَ وَبِٱلْءَاخِرَةِ هُمْ يُوقِنُونَ")

        sentence2 = Ar("إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ")
        @test normalize(sentence2, :alif_hamza_below) === Ar("اِيَّاكَ نَعْبُدُ وَاِيَّاكَ نَسْتَعِينُ")

        sentence3 = Ar("ٱلَّذِينَ يُؤْمِنُونَ بِٱلْغَيْبِ وَيُقِيمُونَ ٱلصَّلَوٰةَ وَمِمَّا رَزَقْنَٰهُمْ يُنفِقُونَ")
        @test normalize(sentence3, :waw_hamza_above) === Ar("ٱلَّذِينَ يُوْمِنُونَ بِٱلْغَيْبِ وَيُقِيمُونَ ٱلصَّلَوٰةَ وَمِمَّا رَزَقْنَٰهُمْ يُنفِقُونَ")
        @test normalize(sentence3, :ta_marbuta) === Ar("ٱلَّذِينَ يُؤْمِنُونَ بِٱلْغَيْبِ وَيُقِيمُونَ ٱلصَّلَوٰهَ وَمِمَّا رَزَقْنَٰهُمْ يُنفِقُونَ")

        sentence4 = Ar("ٱللَّهُ يَسْتَهْزِئُ بِهِمْ وَيَمُدُّهُمْ فِى طُغْيَٰنِهِمْ يَعْمَهُونَ")
        @test normalize(sentence4, :ya_hamza_above) === Ar("ٱللَّهُ يَسْتَهْزِيُ بِهِمْ وَيَمُدُّهُمْ فِى طُغْيَٰنِهِمْ يَعْمَهُونَ")

        sentence5 = Ar("ذَٰلِكَ ٱلْكِتَٰبُ لَا رَيْبَ فِيهِ هُدًى لِّلْمُتَّقِينَ")
        @test normalize(sentence5, :alif_maksura) === Ar("ذَٰلِكَ ٱلْكِتَٰبُ لَا رَيْبَ فِيهِ هُدًي لِّلْمُتَّقِينَ")

        @test normalize(ar_basmala, [:alif_khanjareeya, :hamzat_wasl]) === Ar("بِسْمِ اللَّهِ الرَّحْمَانِ الرَّحِيمِ")

        sentence6 = Ar("ﷺ")
        @test normalize(sentence6) === Ar("صلى الله عليه وسلم")

        sentence7 = Ar("ﷻ")
        @test normalize(sentence7) === Ar("جل جلاله")

        sentence8 = Ar("﷽")
        @test normalize(sentence8) === ar_basmala

        @test normalize(Ar("بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ")) === Ar("بِسْمِ اللَّهِ الرَّحْمَانِ الرَّحِيمِ")
    end
    @testset "tokenization" begin
        sentence10 = Ar("هَلْ,; ذَهَبْتَ إِلَى المَكْتَبَةِ؟")
        @info tokenize(sentence10) === ["هَلْ", "ذَهَبْتَ", "إِلَى", "المَكْتَبَةِ", ",", ";", "؟"]
        @info tokenize(sentence10, false) === ["هَلْ,;", "ذَهَبْتَ", "إِلَى", "المَكْتَبَةِ؟"]
    end
    @testset "transliterator" begin
        ar_basmala = Ar("بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ")
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
            Symbol(Char(0x06ED)) => Symbol(']'),
        )

        @transliterator my_encoder "MyEncoder"
        @test encode(ar_basmala) === Bw("A~\$^l~ :mmiun~ :mziux^lu#h~ :mziux~Fl~")
        @test arabic(encode(ar_basmala)) === ar_basmala

        old_keys = collect(keys(BW_ENCODING))
        new_vals = reverse(collect(values(BW_ENCODING)))
        my_encoder = Dict(old_keys .=> new_vals)
        @transliterator my_encoder "MyEncoder"
    end
    # @info "Orthographical Analysis"
    # arb_token = tokenize(ar_basmala)

    # @test parse(Orthography, arb_token[1]) isa Orthography

    # arb_parsed2 = parse.(Orthography, arb_token)
    # @test numerals(arb_parsed2[1]) == [2, nothing, 60, nothing, 40, nothing]

    # @test isfeat(arb_parsed2[1], AbstractLunar) == [1, 0, 0, 0, 1, 0]
    # @test arb_parsed2[1][isfeat(arb_parsed2[1], AbstractLunar)] == [Ba, Meem]

    # @test vocals(arb_parsed2[1]) == [:labial, nothing, :sibilant, nothing, :labial, nothing]

    # @test parse(SimpleEncoding, ar_basmala) === "Ba+Kasra | Seen+Sukun | Meem+Kasra | <space> | AlifHamzatWasl | Lam | Lam+Shadda+Fatha | Ha+Kasra | <space> | AlifHamzatWasl | Lam | Ra+Shadda+Fatha | HHa+Sukun | Meem+Fatha+AlifKhanjareeya | Noon+Kasra | <space> | AlifHamzatWasl | Lam | Ra+Shadda+Fatha | HHa+Kasra | Ya | Meem+Kasra" 

    @testset "Alignment" begin
        shamela0012129 = Ar("خرج مع ابي بكر الصديق رضي الله عنه في تجارة الي بصري ومعهم نعيمان وكان نعيمان ممن شهد——- بدرا ايضا وك——-ان علي الزاد فقال له سويبط———– اطعمني فقال حتي يجء ابو بكر فقال اما والله لاغيظنك فمروا بقوم فقال لهم سويبط -تشترون مني عبدا قا—لوا نعم فقال انه عبد له كلام وهو قاءل لكم اني حر فان كنتم اذا قال لكم هذه المقالة تركتموه فلا تفسدوا علي عبدي قا-لوا بل نشتريه منك فاشتروه بعشر قلاءص ثم جاءوا فوضعوا في عنقه حبلا ف—————قال نعيمان ان هذا يستهزء بكم واني حر فقالوا قد عرفنا –خبرك وانطلقوا به فلما جاء ابو بكر -اخبروه فاتبعهم ورد عليهم القلاءص واخذه فلما قدموا علي النبي صلي الله عليه وسلم اخبروه فضحك هو واصحابه من ذلك حولا")
        shamela0023790 = Ar("خرج— ابو بكر——————– في تجارة——— ومعه- نعيمان وسويبط بن حرملة وكانا شهدا بدر—–ا وكان نعيمان علي الزاد فقال له سويبط وكان مزاحا اطعمني فقال حتي يجء ابو بكر فقال اما والله لاغيظنك فمروا بقوم فقال لهم سويبط اتشترون مني عبدا لي قالوا نعم ق-ال انه عبد له كلام وهو قاءل لكم اني حر فان كنتم اذا قال لكم هذه المقالة تركتموه فلا تفسدوا علي عبدي فقالوا بل نشتريه منك——– بعشر قلاءص ثم جاءوا فوضعوا في عنقه حبلا وعمامة واشتروه فقال نعيمان ان هذا يستهزء بكم واني حر قا-لوا قد اخبرنا بخبرك وانطلقوا به و—-جاء ابو بكر فاخبروه فاتبعهم فرد عليهم القلاءص واخذه فلما قدموا علي النبي صلي الله عليه وسلم اخبروه فضحك هو واصحابه منهما- حول")
        shamela0012129_cln = clean(shamela0012129)
        shamela0023790_cln = clean(shamela0023790)
        mapping = Dict(
            Ar("الله") => Ar("ﷲ"),
            Ar("لا") => Ar("ﻻ"),
        )
        shamela0012129_nrm = normalize(shamela0012129_cln, mapping)
        shamela0023790_nrm = normalize(shamela0023790_cln, mapping)

        shamela0012129_enc = encode(shamela0012129_nrm)
        shamela0023790_enc = encode(shamela0023790_nrm)
        res = align(shamela0012129_enc, shamela0023790_enc)

        @test count_matches(res) == 513
        @test count_mismatches(res) == 25
        @test count_insertions(res) == 43
        @test count_deletions(res) == 45
        @test count_aligned(res) == 626
        @test score(res) == 113
    end
    # shamela0012129 = "خرج مع ابي بكر الصديق رضي الله عنه في تجارة الي بصري ومعهم نعيمان وكان نعيمان ممن شهد——- بدرا ايضا وك——-ان علي الزاد فقال له سويبط———– اطعمني فقال حتي يجء ابو بكر فقال اما والله لاغيظنك فمروا بقوم فقال لهم سويبط -تشترون مني عبدا قا—لوا نعم فقال انه عبد له كلام وهو قاءل لكم اني حر فان كنتم اذا قال لكم هذه المقالةAA تركتموه فلا تفسدوا علي عبدي قا-لوا بل نشتريه منك فاشتروه بعشر قلاءص ثم جاءوا فوضعوا في عنقه حبلا ف—————قال نعيمان ان هذا يستهزء بكم واني حر فقالوا قد عرفنا –خبرك وانطلقوا به فلما جاء ابو بكر -اخبروه فاتبعهم ورد عليهم القلاءص واخذه فلما قدموا علي النبي صلي الله عليه وسلم اخبروه فضحك هو واصحابه من ذلك حولا"
    # shamela0023790 = "خرج— ابو بكر——————– في تجارة——— ومعه- نعيمان وسويبط بن حرملة وكانا شهدا بدر—–ا وكان نعيمان علي الزاد فقال له سويبط وكان مزاحا اطعمني فقال حتي يجء ابو بكر فقال اما والله لاغيظنك فمروا بقوم فقال لهم سويبط اتشترون مني عبدا لي قالوا نعم ق-ال انه عبد له كلام وهو قاءل لكم اني حر فان كنتم اذا قال لكم هذه المقالة تركتموه  AAفلا تفسدوا علي عبدي فقالوا بل نشتريه منك——– بعشر قلاءص ثم جاءوا فوضعوا في عنقه حبلا وعمامة واشتروه فقال نعيمان ان هذا يستهزء بكم واني حر قا-لوا قد اخبرنا بخبرك وانطلقوا به و—-جاء ابو بكر فاخبروه فاتبعهم فرد عليهم القلاءص واخذه فلما قدموا علي النبي صلي الله عليه وسلم اخبروه فضحك هو واصحابه منهما- حول"
    # shamela0012129 = string.(split(shamela0012129, "AA"))
    # shamela0023790 = string.(split(shamela0023790, "AA"))
    # shamela0012129_cln = clean.(shamela0012129)
    # shamela0023790_cln = clean.(shamela0023790)
    # mapping = Dict(
    #     "الله" => "ﷲ",
    #     "لا" => "ﻻ"
    # );
    # shamela0012129_nrm = normalize(shamela0012129_cln, mapping)
    # shamela0023790_nrm = normalize(shamela0023790_cln, mapping)

    # shamela0012129_enc = encode.(shamela0012129_nrm)
    # shamela0023790_enc = encode.(shamela0023790_nrm)

    # res, scr = align(shamela0012129_enc, shamela0023790_enc);
    # @test count_matches(res[1,1]) == 246
    # @test scr == [81 220; 221 51]

    # function capture_io(x)
    #     io = IOBuffer()
    #     println(io, x)
    #     return String(take!(io))
    # end

    # shamela0012129 = "خبروه فضحك هو واصحابه من ذلك حولا"
    # shamela0023790 = "اخبروه فضحك هو واصحابه منهما- حول"
    # shamela0012129_cln = clean(shamela0012129)
    # shamela0023790_cln = clean(shamela0023790)
    # mapping = Dict(
    #     "الله" => "ﷲ",
    #     "لا" => "ﻻ"
    # );
    # shamela0012129_nrm = normalize(shamela0012129_cln, mapping)
    # shamela0023790_nrm = normalize(shamela0023790_cln, mapping)

    # shamela0012129_enc = encode(shamela0012129_nrm)
    # shamela0023790_enc = encode(shamela0023790_nrm)
    # res = align(shamela0012129_enc, shamela0023790_enc);

    # out = capture_io(res);
    # @test out == "PairwiseAlignment\n١-reference\n٢-target\n\n٢    اخبروه فضحك هو واصحابه منٓهما حو\n      اااااااااااااااااااااااا    ااا\n١    ٓخبروه فضحك هو واصحابه من ذلك حو\n\n\n"
    @testset "Syllabification" begin
        @transliterator :default
        # texts
        ar_raheem = encode(Ar("ٱلرَّحِيمِ")) # output: "{lr~aHiymi"
        r = Syllabification(true, Syllable(0, 0, 1)) # 1 vowel only, and it will start from the last vowel
        @test r(ar_raheem, first_word=false, silent_last_vowel=false).segment === Segment(Bw("i"), Harakaat[Harakaat(Bw("i"), false)]).segment
        @test r(ar_raheem, first_word=false, silent_last_vowel=false).harakaat == [Harakaat(Bw("i"), false)]
        @test r(ar_raheem, first_word=false, silent_last_vowel=false).harakaat[1].char == Bw("i")
        @test r(ar_raheem, first_word=false, silent_last_vowel=false).harakaat[1].is_tanween == false

        r = Syllabification(true, Syllable(1, 0, 1)) # 1 vowel only, and it will start from the last vowel
        @test r(ar_raheem, first_word=false, silent_last_vowel=false).segment === Segment(Bw("mi"), Harakaat[Harakaat(Bw("i"), false)]).segment
        @test r(ar_raheem, first_word=false, silent_last_vowel=false).harakaat == [Harakaat(Bw("i"), false)]
        @test r(ar_raheem, first_word=false, silent_last_vowel=false).harakaat[1].char == Bw("i")
        @test r(ar_raheem, first_word=false, silent_last_vowel=false).harakaat[1].is_tanween == false

        r = Syllabification(true, Syllable(1, 1, 1)) # 1 vowel only, and it will start from the last vowel
        @test r(ar_raheem, first_word=false, silent_last_vowel=false).segment === Segment(Bw("mi"), Harakaat[Harakaat(Bw("i"), false)]).segment
        @test r(ar_raheem, first_word=false, silent_last_vowel=false).harakaat == [Harakaat(Bw("i"), false)]
        @test r(ar_raheem, first_word=false, silent_last_vowel=false).harakaat[1].char == Bw("i")
        @test r(ar_raheem, first_word=false, silent_last_vowel=false).harakaat[1].is_tanween == false

        r = Syllabification(true, Syllable(1, 2, 1)) # 1 vowel only, and it will start from the last vowel
        @test r(ar_raheem, first_word=false, silent_last_vowel=false).segment === Segment(Bw("mi"), Harakaat[Harakaat(Bw("i"), false)]).segment
        @test r(ar_raheem, first_word=false, silent_last_vowel=false).harakaat == [Harakaat(Bw("i"), false)]
        @test r(ar_raheem, first_word=false, silent_last_vowel=false).harakaat[1].char == Bw("i")
        @test r(ar_raheem, first_word=false, silent_last_vowel=false).harakaat[1].is_tanween == false

        r = Syllabification(true, Syllable(2, 2, 1)) # 1 vowel only, and it will start from the last vowel
        @test r(ar_raheem, first_word=false, silent_last_vowel=false).segment === Segment(Bw("ymi"), Harakaat[Harakaat(Bw("i"), false)]).segment
        @test r(ar_raheem, first_word=false, silent_last_vowel=false).harakaat == [Harakaat(Bw("i"), false)]
        @test r(ar_raheem, first_word=false, silent_last_vowel=false).harakaat[1].char == Bw("i")
        @test r(ar_raheem, first_word=false, silent_last_vowel=false).harakaat[1].is_tanween == false

        # more than 1 vowel
        r = Syllabification(true, Syllable(0, 0, 2)) # 2 vowels, and it will start from the last vowel

        # capture the long vowel
        @test r(ar_raheem, first_word=false, silent_last_vowel=false).segment === Segment(Bw("iy?i"), Harakaat[Harakaat(Bw("i"), false)]).segment
        @test r(ar_raheem, first_word=false, silent_last_vowel=false).harakaat == Harakaat[Harakaat(Bw("i"), false), Harakaat(Bw("i"), false)]
        @test r(ar_raheem, first_word=false, silent_last_vowel=false).harakaat[1].char == Bw("i")
        @test r(ar_raheem, first_word=false, silent_last_vowel=false).harakaat[2].char == Bw("i")
        @test r(ar_raheem, first_word=false, silent_last_vowel=false).harakaat[1].is_tanween == false
        @test r(ar_raheem, first_word=false, silent_last_vowel=false).harakaat[2].is_tanween == false

        r = Syllabification(true, Syllable(0, 1, 2)) # 2 vowels, and it will start from the last vowel
        @test r(ar_raheem, first_word=false, silent_last_vowel=false).segment === Segment(Bw("iy?i"), Harakaat[Harakaat(Bw("i"), false)]).segment
        @test r(ar_raheem, first_word=false, silent_last_vowel=false).harakaat == Harakaat[Harakaat(Bw("i"), false), Harakaat(Bw("i"), false)]
        @test r(ar_raheem, first_word=false, silent_last_vowel=false).harakaat[1].char == Bw("i")
        @test r(ar_raheem, first_word=false, silent_last_vowel=false).harakaat[2].char == Bw("i")
        @test r(ar_raheem, first_word=false, silent_last_vowel=false).harakaat[1].is_tanween == false
        @test r(ar_raheem, first_word=false, silent_last_vowel=false).harakaat[2].is_tanween == false

        r = Syllabification(true, Syllable(1, 1, 2)) # 2 vowels, and it will start from the last vowel
        @test r(ar_raheem, first_word=false, silent_last_vowel=false).segment === Segment(Bw("Hiy?mi"), Harakaat[Harakaat(Bw("i"), false)]).segment
        @test r(ar_raheem, first_word=false, silent_last_vowel=false).harakaat == Harakaat[Harakaat(Bw("i"), false), Harakaat(Bw("i"), false)]
        @test r(ar_raheem, first_word=false, silent_last_vowel=false).harakaat[1].char == Bw("i")
        @test r(ar_raheem, first_word=false, silent_last_vowel=false).harakaat[2].char == Bw("i")
        @test r(ar_raheem, first_word=false, silent_last_vowel=false).harakaat[1].is_tanween == false
        @test r(ar_raheem, first_word=false, silent_last_vowel=false).harakaat[2].is_tanween == false

        r = Syllabification(true, Syllable(2, 2, 2)) # 2 vowels, and it will start from the last vowel
        @test r(ar_raheem, first_word=false, silent_last_vowel=false).segment === Segment(Bw("aHiym?ymi"), Harakaat[Harakaat(Bw("i"), false)]).segment
        @test r(ar_raheem, first_word=false, silent_last_vowel=false).harakaat == Harakaat[Harakaat(Bw("i"), false), Harakaat(Bw("i"), false)]
        @test r(ar_raheem, first_word=false, silent_last_vowel=false).harakaat[1].char == Bw("i")
        @test r(ar_raheem, first_word=false, silent_last_vowel=false).harakaat[2].char == Bw("i")
        @test r(ar_raheem, first_word=false, silent_last_vowel=false).harakaat[1].is_tanween == false
        @test r(ar_raheem, first_word=false, silent_last_vowel=false).harakaat[2].is_tanween == false

        # more than 2 vowels
        r = Syllabification(true, Syllable(0, 0, 3)) # 3 vowels, and it will start from the last vowel
        @test r(ar_raheem, first_word=false, silent_last_vowel=false).segment === Segment(Bw("a?iy?i"), Harakaat[Harakaat(Bw("a"), false), Harakaat(Bw("i"), false), Harakaat(Bw("i"), false)]).segment
        @test r(ar_raheem, first_word=false, silent_last_vowel=false).harakaat == Harakaat[Harakaat(Bw("a"), false), Harakaat(Bw("i"), false), Harakaat(Bw("i"), false)]
        @test r(ar_raheem, first_word=false, silent_last_vowel=false).harakaat[1].char == Bw("a")
        @test r(ar_raheem, first_word=false, silent_last_vowel=false).harakaat[2].char == Bw("i")
        @test r(ar_raheem, first_word=false, silent_last_vowel=false).harakaat[3].char == Bw("i")
        @test r(ar_raheem, first_word=false, silent_last_vowel=false).harakaat[1].is_tanween == false
        @test r(ar_raheem, first_word=false, silent_last_vowel=false).harakaat[2].is_tanween == false
        @test r(ar_raheem, first_word=false, silent_last_vowel=false).harakaat[3].is_tanween == false

        # more than 2 vowels
        r = Syllabification(true, Syllable(1, 1, 3)) # 3 vowels, and it will start from the last vowel

        # remember ~ is a sadda, and therefore needs to have consonant preceding it to know what letter to double
        @test r(ar_raheem, first_word=false, silent_last_vowel=false).segment === Segment(Bw("r~aH?Hiy?mi"), Harakaat[Harakaat(Bw("a"), false), Harakaat(Bw("i"), false), Harakaat(Bw("i"), false)]).segment
        @test r(ar_raheem, first_word=false, silent_last_vowel=false).harakaat == Harakaat[Harakaat(Bw("a"), false), Harakaat(Bw("i"), false), Harakaat(Bw("i"), false)]
        @test r(ar_raheem, first_word=false, silent_last_vowel=false).harakaat[1].char == Bw("a")
        @test r(ar_raheem, first_word=false, silent_last_vowel=false).harakaat[2].char == Bw("i")
        @test r(ar_raheem, first_word=false, silent_last_vowel=false).harakaat[3].char == Bw("i")
        @test r(ar_raheem, first_word=false, silent_last_vowel=false).harakaat[1].is_tanween == false
        @test r(ar_raheem, first_word=false, silent_last_vowel=false).harakaat[2].is_tanween == false
        @test r(ar_raheem, first_word=false, silent_last_vowel=false).harakaat[3].is_tanween == false

        r = Syllabification(true, Syllable(2, 2, 3)) # 3 vowels, and it will start from the last vowel
        @test r(ar_raheem, first_word=false, silent_last_vowel=false).segment === Segment(Bw("r~aHi?aHiym?ymi"), Harakaat[Harakaat(Bw("a"), false), Harakaat(Bw("i"), false), Harakaat(Bw("i"), false)]).segment
        @test r(ar_raheem, first_word=false, silent_last_vowel=false).harakaat == Harakaat[Harakaat(Bw("a"), false), Harakaat(Bw("i"), false), Harakaat(Bw("i"), false)]
        @test r(ar_raheem, first_word=false, silent_last_vowel=false).harakaat[1].char == Bw("a")
        @test r(ar_raheem, first_word=false, silent_last_vowel=false).harakaat[2].char == Bw("i")
        @test r(ar_raheem, first_word=false, silent_last_vowel=false).harakaat[3].char == Bw("i")
        @test r(ar_raheem, first_word=false, silent_last_vowel=false).harakaat[1].is_tanween == false
        @test r(ar_raheem, first_word=false, silent_last_vowel=false).harakaat[2].is_tanween == false
        @test r(ar_raheem, first_word=false, silent_last_vowel=false).harakaat[3].is_tanween == false

        ###
        alhamd = encode(Ar("ٱلْحَمْدُ"))
        r = Syllabification(true, Syllable(0, 0, 1)) # 1 vowel only, and it will start from the last vowel
        @test r(alhamd, first_word=true, silent_last_vowel=false).segment === Segment(Bw("u"), Harakaat[Harakaat(Bw("u"), false)]).segment
        @test r(alhamd, first_word=true, silent_last_vowel=false).harakaat == [Harakaat(Bw("u"), false)]
        @test r(alhamd, first_word=true, silent_last_vowel=false).harakaat[1].char == Bw("u")
        @test r(alhamd, first_word=true, silent_last_vowel=false).harakaat[1].is_tanween == false

        alhamd = encode(Ar("ٱلْحَمْدُ")) # output: "{loHamodu"
        r = Syllabification(true, Syllable(0, 0, 2)) # 1 vowel only, and it will start the finding of vowel from right to left of the letters
        @test r(alhamd, first_word=true, silent_last_vowel=true).segment === Segment(Bw("{?a"), Harakaat[Harakaat(Bw("a"), false), Harakaat(Bw("a"), false)]).segment
        @test r(alhamd, first_word=true, silent_last_vowel=true).harakaat == [Harakaat(Bw("a"), false), Harakaat(Bw("a"), false)]
        @test r(alhamd, first_word=true, silent_last_vowel=true).harakaat[1].char == Bw("a")
        @test r(alhamd, first_word=true, silent_last_vowel=true).harakaat[2].char == Bw("a")

        alhamd = encode(Ar("ٱلْحَمْدُ")) # output: "{loHamodu"
        r = Syllabification(true, Syllable(0, 1, 2)) # 1 vowel only, and it will start the finding of vowel from right to left of the letters
        @test r(alhamd, first_word=true, silent_last_vowel=true).segment === Segment(Bw("{l?am"), Harakaat[Harakaat(Bw("a"), false), Harakaat(Bw("a"), false)]).segment
        @test r(alhamd, first_word=true, silent_last_vowel=true).harakaat == [Harakaat(Bw("a"), false), Harakaat(Bw("a"), false)]
        @test r(alhamd, first_word=true, silent_last_vowel=true).harakaat[1].char == Bw("a")
        @test r(alhamd, first_word=true, silent_last_vowel=true).harakaat[2].char == Bw("a")

        alhamd = encode(Ar("ٱلْحَمْدُ")) # output: "{loHamodu"
        r = Syllabification(true, Syllable(1, 1, 2)) # 1 vowel only, and it will start the finding of vowel from right to left of the letters
        @test r(alhamd, first_word=true, silent_last_vowel=true).segment === Segment(Bw("{l?Ham"), Harakaat[Harakaat(Bw("a"), false), Harakaat(Bw("a"), false)]).segment
        @test r(alhamd, first_word=true, silent_last_vowel=true).harakaat == [Harakaat(Bw("a"), false), Harakaat(Bw("a"), false)]
        @test r(alhamd, first_word=true, silent_last_vowel=true).harakaat[1].char == Bw("a")
        @test r(alhamd, first_word=true, silent_last_vowel=true).harakaat[2].char == Bw("a")

        alhamd = encode(Ar("ٱلْحَمْدُ")) # output: "{loHamodu"
        r = Syllabification(true, Syllable(1, 2, 2)) # 1 vowel only, and it will start the finding of vowel from right to left of the letters
        @test r(alhamd, first_word=true, silent_last_vowel=true).segment === Segment(Bw("{lo?Hamo"), Harakaat[Harakaat(Bw("a"), false), Harakaat(Bw("a"), false)]).segment
        @test r(alhamd, first_word=true, silent_last_vowel=true).harakaat == [Harakaat(Bw("a"), false), Harakaat(Bw("a"), false)]
        @test r(alhamd, first_word=true, silent_last_vowel=true).harakaat[1].char == Bw("a")
        @test r(alhamd, first_word=true, silent_last_vowel=true).harakaat[2].char == Bw("a")

        alhamd = encode(Ar("ٱلْحَمْدُ")) # output: "{loHamodu"
        r = Syllabification(true, Syllable(2, 2, 2)) # 1 vowel only, and it will start the finding of vowel from right to left of the letters
        @test r(alhamd, first_word=true, silent_last_vowel=true).segment === Segment(Bw("{lo?oHamo"), Harakaat[Harakaat(Bw("a"), false), Harakaat(Bw("a"), false)]).segment
        @test r(alhamd, first_word=true, silent_last_vowel=true).harakaat == [Harakaat(Bw("a"), false), Harakaat(Bw("a"), false)]
        @test r(alhamd, first_word=true, silent_last_vowel=true).harakaat[1].char == Bw("a")
        @test r(alhamd, first_word=true, silent_last_vowel=true).harakaat[2].char == Bw("a")
    end

    @testset "Disconnected Letters (Huroof Muqatta'at)" begin
        # Simple cases - individual letters
        r = Syllabification(true, Syllable(0, 0, 1))

        # Test 1: Basic case - Alif Lām Mīm (الم)
        alm = encode(Ar("الم"))
        result = r(alm, first_word=false, silent_last_vowel=false)
        @test result.segment == Bw("A?l?m")
        @test length(result.harakaat) == 4  # 'a' and 'i' for alif, 'a' for lam, 'i' for mim
        @test result.harakaat[1].char == Bw("a")  # First vowel for alif
        @test result.harakaat[2].char == Bw("i")  # Second vowel for alif
        @test result.harakaat[3].char == Bw("a")  # Vowel for lam
        @test result.harakaat[4].char == Bw("i")  # Vowel for mim

        # Test 2: With maddah - Alif Lām Mīm Ṣād (المص)
        alms = encode(Ar("الٓمٓصٓ"))
        result = r(alms, first_word=false, silent_last_vowel=false)
        @test result.segment == Bw("A?l^?m^?S^")
        @test length(result.harakaat) == 5  # 'a' and 'i' for alif, 'a' for lam, 'i' for mim, 'a' for sad
        @test result.harakaat[1].char == Bw("a")  # First vowel for alif
        @test result.harakaat[2].char == Bw("i")  # Second vowel for alif
        @test result.harakaat[3].char == Bw("a")  # Vowel for lam
        @test result.harakaat[4].char == Bw("i")  # Vowel for mim
        @test result.harakaat[5].char == Bw("a")  # Vowel for sad

        # Test 3: Kāf Hā Yā 'Ayn Ṣād (كهيعص)
        khyas = encode(Ar("كهيعص"))
        result = r(khyas, first_word=false, silent_last_vowel=false)
        @test result.segment == Bw("k?h?y?E?S")
        @test length(result.harakaat) == 6
        @test result.harakaat[1].char == Bw("a")  # Vowel for kaf
        @test result.harakaat[2].char == Bw("a")  # Vowel for ha
        @test result.harakaat[3].char == Bw("a")  # Vowel for ya
        @test result.harakaat[4].char == Bw("a")  # Vowel for ayn since it has sound of a first
        @test result.harakaat[5].char == Bw("i")  # Vowel for ayn since it has sound of i second
        @test result.harakaat[6].char == Bw("a") # Vowel for sad

        # Test 4: Ṭā Hā (طه)
        th = encode(Ar("طه"))
        result = r(th, first_word=false, silent_last_vowel=false)
        @test result.segment == Bw("T?h")
        @test length(result.harakaat) == 2
        @test result.harakaat[1].char == Bw("a")  # Vowel for ta
        @test result.harakaat[2].char == Bw("a")  # Vowel for ha

        # Test 5: Ṭā Sīn Mīm (طسم)
        tsm = encode(Ar("طسم"))
        result = r(tsm, first_word=false, silent_last_vowel=false)
        @test result.segment == Bw("T?s?m")
        @test length(result.harakaat) == 3
        @test result.harakaat[1].char == Bw("a")  # Vowel for ta
        @test result.harakaat[2].char == Bw("i")  # Vowel for sin
        @test result.harakaat[3].char == Bw("i")  # Vowel for mim

        # Test 6: Ḥā Mīm (حم)
        hm = encode(Ar("حم"))
        result = r(hm, first_word=false, silent_last_vowel=false)
        @test result.segment == Bw("H?m")
        @test length(result.harakaat) == 2
        @test result.harakaat[1].char == Bw("a")  # Vowel for ha
        @test result.harakaat[2].char == Bw("i")  # Vowel for mim

        # Test 7: Yā Sīn (يس)
        ys = encode(Ar("يس"))
        result = r(ys, first_word=false, silent_last_vowel=false)
        @test result.segment == Bw("y?s")
        @test length(result.harakaat) == 2
        @test result.harakaat[1].char == Bw("a")  # Vowel for ya
        @test result.harakaat[2].char == Bw("i")  # Vowel for sin

        # Test 8: Ṣād (ص)
        s = encode(Ar("صٓ"))
        result = r(s, first_word=false, silent_last_vowel=false)
        @test result.segment == Bw("S^")
        @test length(result.harakaat) == 1
        @test result.harakaat[1].char == Bw("a")  # Vowel for sad

        # Test 9: Qāf (ق)
        q = encode(Ar("ق"))
        result = r(q, first_word=false, silent_last_vowel=false)
        @test result.segment == Bw("q")
        @test length(result.harakaat) == 1
        @test result.harakaat[1].char == Bw("a")  # Vowel for qaf

        # Test 10: Nūn (ن)
        n = encode(Ar("ن"))
        result = r(n, first_word=false, silent_last_vowel=false)
        @test result.segment == Bw("n")
        @test length(result.harakaat) == 1
        @test result.harakaat[1].char == Bw("u")  # Vowel for nun

        # Test 11: 'Ayn Sīn Qāf (عسق)
        esq = encode(Ar("عسق"))
        result = r(esq, first_word=false, silent_last_vowel=false)
        @test result.segment == Bw("E?s?q")
        @test length(result.harakaat) == 4
        @test result.harakaat[1].char == Bw("a")  # Vowel for ayn for a sound
        @test result.harakaat[2].char == Bw("i")  # Vowel for ayn for i sound
        @test result.harakaat[3].char == Bw("i")  # Vowel for sin
        @test result.harakaat[4].char == Bw("a")  # Vowel for qaf

        # Test 12: Complex case with multiple diacritics - Alif Lām Rā (الر)
        alr = encode(Ar("الٓرٓ"))
        result = r(alr, first_word=false, silent_last_vowel=false)
        @test result.segment == Bw("A?l^?r^")
        @test length(result.harakaat) == 4  # 'a' and 'i' for alif, 'a' for lam, 'a' for ra
        @test result.harakaat[1].char == Bw("a")  # First vowel for alif
        @test result.harakaat[2].char == Bw("i")  # Second vowel for alif
        @test result.harakaat[3].char == Bw("a")  # Vowel for lam
        @test result.harakaat[4].char == Bw("a")  # Vowel for ra

        # Test 13: Single letter with shadda - Ṣād with shadda (صّ)
        ss = encode(Ar("صّ"))
        result = r(ss, first_word=false, silent_last_vowel=false)
        @test result.segment == Bw("S~")
        @test length(result.harakaat) == 1
        @test result.harakaat[1].char == Bw("a")  # Vowel for sad

        # Test 14: Letter with both shadda and maddah - this would be unusual but testing for robustness
        # sm = encode(Ar("صّٓ"))  # Note: This might not be a standard Arabic form
        # result = r(sm, first_word=false, silent_last_vowel=false)
        # @test result.segment == "S~^"
        # @test length(result.harakaat) == 1
        # @test result.harakaat[1].char == "a"  # Vowel for sad

        # Test 15: Letter with sukun - Lām with sukun (لْ)
        # ls = encode(Ar("لْ"))
        # result = r(ls, first_word=false, silent_last_vowel=false)
        # @test result.segment == "lo"
        # @test length(result.harakaat) == 1
        # @test result.harakaat[1].char == "a"  # Vowel for lam

        # Test 16: All three main vowel types
        sin = encode(Ar("س"))  # sin - uses 'i' vowel
        ra = encode(Ar("ر"))   # ra - uses 'a' vowel
        nun = encode(Ar("ن"))  # nun - uses 'u' vowel

        result_sin = r(sin, first_word=false, silent_last_vowel=false)
        result_ra = r(ra, first_word=false, silent_last_vowel=false)
        result_nun = r(nun, first_word=false, silent_last_vowel=false)

        @test result_sin.harakaat[1].char == Bw("i")
        @test result_ra.harakaat[1].char == Bw("a")
        @test result_nun.harakaat[1].char == Bw("u")

        # Test 17: Letter combinations not found in Quran but possible in other contexts
        mix = encode(Ar("تنفخ"))  # ta-nun-fa-kha
        result = r(mix, first_word=false, silent_last_vowel=false)
        @test result.segment == Bw("t?n?f?x")
        @test length(result.harakaat) == 4
        @test result.harakaat[1].char == Bw("a")  # Vowel for ta
        @test result.harakaat[2].char == Bw("u")  # Vowel for nun
        @test result.harakaat[3].char == Bw("a")  # Vowel for fa
        @test result.harakaat[4].char == Bw("a")  # Vowel for kha

        # Test 18: Hamza forms
        # hamzas = encode(Ar("ءأؤإئ"))  # Various hamza forms
        # result = r(hamzas, first_word=false, silent_last_vowel=false)
        # @test result.segment == "'?>?&?<?}"
        # @test length(result.harakaat) == 5
        # @test all(x -> x.char == "a", result.harakaat)  # All hamza forms use 'a' vowel

        # Test 19: Mixed with regular text containing explicit vowels
        # This should be handled by the regular syllabification logic, not handle_no_vowels
        mixed = encode(Ar("المَ"))  # The 'a' is an explicit vowel
        result = r(mixed, first_word=false, silent_last_vowel=false)
        # In this case, it should identify the explicit vowel 'a'
        @test any(x -> x.char == Bw("a"), result.harakaat)
    end

    @testset "Rhythmic Vis" begin
        @testset "LastRecitedVariants Enum" begin
            @test A isa LastRecitedVariants
            @test B isa LastRecitedVariants
            @test C isa LastRecitedVariants
            @test Int(A) == 0
            @test Int(B) == 1
            @test Int(C) == 2
        end

        @testset "LastRecited Construction" begin
            # Test construction with each variant
            lr_a = LastRecited(A)
            @test lr_a isa LastRecited
            @test lr_a.variant === A

            lr_b = LastRecited(B)
            @test lr_b isa LastRecited
            @test lr_b.variant === B

            lr_c = LastRecited(C)
            @test lr_c isa LastRecited
            @test lr_c.variant === C

            # Test default constructor
            lr_default = LastRecited()
            @test lr_default isa LastRecited
            @test lr_default.variant === A
        end

        @testset "LastRecitedSyllable Construction" begin
            syl = LastRecitedSyllable(Bw("test"))
            @test syl isa LastRecitedSyllable
            @test syl.syllable === Bw("test")

            # Test with different syllables
            syl1 = LastRecitedSyllable(Bw("iy"))
            syl2 = LastRecitedSyllable(Bw("iym"))
            @test syl1.syllable === Bw("iy")
            @test syl2.syllable === Bw("iym")
        end

        @testset "RhythmicVis Construction" begin
            lr = LastRecited(A)
            vis = RhythmicVis(lr)
            @test vis isa RhythmicVis
            @test vis.args === lr
            @test vis.args.variant === A

            # Test with different variants
            vis_b = RhythmicVis(LastRecited(B))
            @test vis_b.args.variant === B

            vis_c = RhythmicVis(LastRecited(C))
            @test vis_c.args.variant === C
        end

        @testset "last_syllable - Variant A" begin
            lr_a = LastRecited(A)

            # Test with Al-Fatihah first verse
            text1 = Bw("bisomi {ll~ahi {lr~aHoma`ni {lr~aHiymi")
            result = last_syllable(lr_a, text1)
            @test result isa NTuple{1, LastRecitedSyllable}
            @test length(result) == 1
            @test result[1] === LastRecitedSyllable(Bw("iy"))

            # Test with second verse
            text2 = Bw("{loHamodu lil~ahi rab~i {loEa`lamiyna")
            result2 = last_syllable(lr_a, text2)
            @test result2[1] === LastRecitedSyllable(Bw("iy"))

            # Test with different ending
            text3 = Bw("ma`liki yawomi {ld~iyni")
            result3 = last_syllable(lr_a, text3)
            @test result3[1] === LastRecitedSyllable(Bw("iy"))
        end

        @testset "last_syllable - Variant B" begin
            lr_b = LastRecited(B)

            text1 = Bw("bisomi {ll~ahi {lr~aHoma`ni {lr~aHiymi")
            result = last_syllable(lr_b, text1)
            @test result isa NTuple{2, LastRecitedSyllable}
            @test length(result) == 2
            @test result[1] === LastRecitedSyllable(Bw("iy"))
            @test result[2] === LastRecitedSyllable(Bw("iym"))

            text2 = Bw("{loHamodu lil~ahi rab~i {loEa`lamiyna")
            result2 = last_syllable(lr_b, text2)
            @test result2[1] === LastRecitedSyllable(Bw("iy"))
            @test result2[2] === LastRecitedSyllable(Bw("iyn"))
        end

        @testset "last_syllable - Variant C" begin
            lr_c = LastRecited(C)

            text1 = Bw("bisomi {ll~ahi {lr~aHoma`ni {lr~aHiymi")
            result = last_syllable(lr_c, text1)
            @test result isa NTuple{3, LastRecitedSyllable}
            @test length(result) == 3
            @test result === (
                LastRecitedSyllable(Bw("iy")),
                LastRecitedSyllable(Bw("iym")),
                LastRecitedSyllable(Bw("Hiym"))
            )

            text2 = Bw("{loHamodu lil~ahi rab~i {loEa`lamiyna")
            result2 = last_syllable(lr_c, text2)
            @test result2 === (
                LastRecitedSyllable(Bw("iy")),
                LastRecitedSyllable(Bw("iyn")),
                LastRecitedSyllable(Bw("miyn"))
            )
        end

        @testset "to_numbers Function" begin
            # Test with simple sequence
            syllables = [
                LastRecitedSyllable(Bw("iy")),
                LastRecitedSyllable(Bw("iyn")),
                LastRecitedSyllable(Bw("iy")),
                LastRecitedSyllable(Bw("iym"))
            ]

            positions, mapping = to_numbers(syllables)

            # Check positions
            @test positions isa Vector{Int64}
            @test length(positions) == 4
            @test positions == [1, 2, 1, 3]

            # Check mapping
            @test mapping isa Dict{LastRecitedSyllable, Int64}
            @test length(mapping) == 3
            @test mapping[LastRecitedSyllable(Bw("iy"))] == 1
            @test mapping[LastRecitedSyllable(Bw("iyn"))] == 2
            @test mapping[LastRecitedSyllable(Bw("iym"))] == 3

            # Test with all same syllables
            same_syllables = [LastRecitedSyllable(Bw("iy")), LastRecitedSyllable(Bw("iy"))]
            pos2, map2 = to_numbers(same_syllables)
            @test pos2 == [1, 1]
            @test length(map2) == 1

            # Test with single syllable
            single = [LastRecitedSyllable(Bw("test"))]
            pos3, map3 = to_numbers(single)
            @test pos3 == [1]
            @test map3[LastRecitedSyllable(Bw("test"))] == 1
        end

        @testset "to_numbers with Al-Fatihah" begin
            alfatihah_bw = [
                Bw("bisomi {ll~ahi {lr~aHoma`ni {lr~aHiymi"),
                Bw("{loHamodu lil~ahi rab~i {loEa`lamiyna"),
                Bw("{lr~aHoma`ni {lr~aHiymi"),
                Bw("ma`liki yawomi {ld~iyni"),
                Bw("<iy~aAka naEobudu wa<iy~aAka nasotaEiynu"),
                Bw("{hodinaA {lS~ira`Ta {lomusotaqiyma"),
                Bw("Sira`Ta {l~a*iyna >anoEamota Ealayohimo gayori {lomagoDuwbi Ealayohimo walaA {lD~aA^l~iyna")
            ]

            y1_chars = Vector{LastRecitedSyllable}()
            y2_chars = Vector{LastRecitedSyllable}()
            y3_chars = Vector{LastRecitedSyllable}()

            for text in alfatihah_bw
                chars_tuple = last_syllable(LastRecited(C), text)
                push!(y1_chars, chars_tuple[1])
                push!(y2_chars, chars_tuple[2])
                push!(y3_chars, chars_tuple[3])
            end

            y1, y1_dict = to_numbers(y1_chars)
            y2, y2_dict = to_numbers(y2_chars)
            y3, y3_dict = to_numbers(y3_chars)

            @test y1 == [1, 1, 1, 1, 1, 1, 1]
            @test y2 == [1, 2, 1, 2, 2, 1, 2]
            @test y3 == [1, 2, 1, 3, 4, 5, 3]
            @test y1_dict == Dict(LastRecitedSyllable(Bw("iy")) => 1)
            @test y2_dict == Dict(
                LastRecitedSyllable(Bw("iym")) => 1,
                LastRecitedSyllable(Bw("iyn")) => 2
            )
            @test y3_dict == Dict(
                LastRecitedSyllable(Bw("Eiyn")) => 4,
                LastRecitedSyllable(Bw("~iyn")) => 3,
                LastRecitedSyllable(Bw("qiym")) => 5,
                LastRecitedSyllable(Bw("Hiym")) => 1,
                LastRecitedSyllable(Bw("miyn")) => 2
            )
        end

        @testset "RhythmicVis Functor - Variant A" begin
            vis = RhythmicVis(LastRecited(A))
            texts = [
                Bw("bisomi {ll~ahi {lr~aHoma`ni {lr~aHiymi"),
                Bw("{loHamodu lil~ahi rab~i {loEa`lamiyna")
            ]

            result = vis(texts)
            @test result isa Tuple
            @test length(result) == 2

            fig, data = result
            @test fig isa Makie.Figure
            @test data isa NTuple{1, Tuple{Vector{Int64}, Dict{LastRecitedSyllable, Int64}}}

            positions, mapping = data[1]
            @test positions == [1, 1]
            @test length(mapping) == 1
        end

        @testset "RhythmicVis Functor - Variant B" begin
            vis = RhythmicVis(LastRecited(B))
            texts = [
                Bw("bisomi {ll~ahi {lr~aHoma`ni {lr~aHiymi"),
                Bw("{loHamodu lil~ahi rab~i {loEa`lamiyna"),
                Bw("{lr~aHoma`ni {lr~aHiymi")
            ]

            result = vis(texts)
            @test result isa Tuple
            @test length(result) == 2

            fig, data = result
            @test fig isa Makie.Figure
            @test data isa NTuple{2, Tuple{Vector{Int64}, Dict{LastRecitedSyllable, Int64}}}

            # Check first dataset
            positions1, mapping1 = data[1]
            @test length(positions1) == 3
            @test all(p -> p == 1, positions1)  # All should be "iy"

            # Check second dataset
            positions2, mapping2 = data[2]
            @test length(positions2) == 3
            @test length(mapping2) == 2  # "iym" and "iyn"
        end

        @testset "RhythmicVis Functor - Variant C" begin
            vis = RhythmicVis(LastRecited(C))
            texts = [
                Bw("bisomi {ll~ahi {lr~aHoma`ni {lr~aHiymi"),
                Bw("{loHamodu lil~ahi rab~i {loEa`lamiyna"),
            ]

            result = vis(texts)
            @test result isa Tuple
            @test length(result) == 2

            fig, data = result
            @test fig isa Makie.Figure
            @test data isa NTuple{3, Tuple{Vector{Int64}, Dict{LastRecitedSyllable, Int64}}}

            # All three datasets should be present
            @test length(data) == 3
            for (positions, mapping) in data
                @test positions isa Vector{Int64}
                @test mapping isa Dict{LastRecitedSyllable, Int64}
                @test length(positions) == 2
            end
        end

        @testset "RhythmicVis with fig_kwargs" begin
            vis = RhythmicVis(LastRecited(A))
            texts = [
                Bw("bisomi {ll~ahi {lr~aHoma`ni {lr~aHiymi"),
                Bw("{loHamodu lil~ahi rab~i {loEa`lamiyna")
            ]

            # Test that fig_kwargs are accepted (doesn't error)
            result = vis(texts, color=:blue, linewidth=2)
            @test result isa Tuple
            fig, data = result
            @test fig isa Makie.Figure
        end

        @testset "Edge Cases" begin
            # Test with single text
            vis = RhythmicVis(LastRecited(A))
            single_text = [Bw("bisomi {ll~ahi {lr~aHoma`ni {lr~aHiymi")]
            result = vis(single_text)
            @test result isa Tuple

            # Test with many identical endings
            identical_texts = [Bw("bisomi {ll~ahi {lr~aHoma`ni {lr~aHiymi") for _ in 1:10]
            result2 = vis(identical_texts)
            fig, data = result2
            positions, mapping = data[1]
            @test all(p -> p == 1, positions)
            @test length(mapping) == 1
        end

        @testset "Abstract Types" begin
            # Verify inheritance hierarchy
            @test LastRecited <: AbstractRhythmicVisArgs
            @test LastRecitedSyllable <: AbstractSyllable

            # Verify instantiation works through abstract types
            lr = LastRecited(A)
            @test lr isa AbstractRhythmicVisArgs

            syl = LastRecitedSyllable(Bw("test"))
            @test syl isa AbstractSyllable
        end
    end
end