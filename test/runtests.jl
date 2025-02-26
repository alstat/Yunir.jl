using Test
using Yunir

@testset "Yunir.jl Unit Tests" begin
    @testset "Basic Text Processing" begin
        @info "encoding"
        ar_basmala = "بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ"
        @test encode(ar_basmala) === "bisomi {ll~ahi {lr~aHoma`ni {lr~aHiymi"

        @info "dediac and arabic"
        bw_basmala = "bisomi {ll~ahi {lr~aHoma`ni {lr~aHiymi"
        @test dediac(bw_basmala; isarabic=false) === "bsm {llh {lrHmn {lrHym"
        @test arabic(dediac(bw_basmala; isarabic=false)) === "بسم ٱلله ٱلرحمن ٱلرحيم"
        @test dediac(arabic(bw_basmala)) === arabic(dediac(bw_basmala; isarabic=false))

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
    end
    @testset "tokenization" begin
        sentence10 = "هَلْ,; ذَهَبْتَ إِلَى المَكْتَبَةِ؟"
        @info tokenize(sentence10) === ["هَلْ", "ذَهَبْتَ", "إِلَى", "المَكْتَبَةِ", ",", ";", "؟"]
        @info tokenize(sentence10, false) === ["هَلْ,;", "ذَهَبْتَ", "إِلَى", "المَكْتَبَةِ؟"]
    end
    @testset "transliterator" begin
        ar_basmala = "بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ"
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
        @test encode(ar_basmala) === "A~\$^l~ :mmiun~ :mziux^lu#h~ :mziux~Fl~"
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
        shamela0012129 = "خرج مع ابي بكر الصديق رضي الله عنه في تجارة الي بصري ومعهم نعيمان وكان نعيمان ممن شهد——- بدرا ايضا وك——-ان علي الزاد فقال له سويبط———– اطعمني فقال حتي يجء ابو بكر فقال اما والله لاغيظنك فمروا بقوم فقال لهم سويبط -تشترون مني عبدا قا—لوا نعم فقال انه عبد له كلام وهو قاءل لكم اني حر فان كنتم اذا قال لكم هذه المقالة تركتموه فلا تفسدوا علي عبدي قا-لوا بل نشتريه منك فاشتروه بعشر قلاءص ثم جاءوا فوضعوا في عنقه حبلا ف—————قال نعيمان ان هذا يستهزء بكم واني حر فقالوا قد عرفنا –خبرك وانطلقوا به فلما جاء ابو بكر -اخبروه فاتبعهم ورد عليهم القلاءص واخذه فلما قدموا علي النبي صلي الله عليه وسلم اخبروه فضحك هو واصحابه من ذلك حولا"
        shamela0023790 = "خرج— ابو بكر——————– في تجارة——— ومعه- نعيمان وسويبط بن حرملة وكانا شهدا بدر—–ا وكان نعيمان علي الزاد فقال له سويبط وكان مزاحا اطعمني فقال حتي يجء ابو بكر فقال اما والله لاغيظنك فمروا بقوم فقال لهم سويبط اتشترون مني عبدا لي قالوا نعم ق-ال انه عبد له كلام وهو قاءل لكم اني حر فان كنتم اذا قال لكم هذه المقالة تركتموه فلا تفسدوا علي عبدي فقالوا بل نشتريه منك——– بعشر قلاءص ثم جاءوا فوضعوا في عنقه حبلا وعمامة واشتروه فقال نعيمان ان هذا يستهزء بكم واني حر قا-لوا قد اخبرنا بخبرك وانطلقوا به و—-جاء ابو بكر فاخبروه فاتبعهم فرد عليهم القلاءص واخذه فلما قدموا علي النبي صلي الله عليه وسلم اخبروه فضحك هو واصحابه منهما- حول"
        shamela0012129_cln = clean(shamela0012129)
        shamela0023790_cln = clean(shamela0023790)
        mapping = Dict(
            "الله" => "ﷲ",
            "لا" => "ﻻ",
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
        ar_raheem = encode("ٱلرَّحِيمِ") # output: "{lr~aHiymi"
        r = Syllabification(true, Syllable(0, 0, 1)) # 1 vowel only, and it will start from the last vowel
        @test r(ar_raheem, isarabic=false, first_word=false, silent_last_vowel=false).segment === Segment("i", Harakaat[Harakaat("i", false)]).segment
        @test r(ar_raheem, isarabic=false, first_word=false, silent_last_vowel=false).harakaat == [Harakaat("i", false)]
        @test r(ar_raheem, isarabic=false, first_word=false, silent_last_vowel=false).harakaat[1].char == "i"
        @test r(ar_raheem, isarabic=false, first_word=false, silent_last_vowel=false).harakaat[1].is_tanween == false

        r = Syllabification(true, Syllable(1, 0, 1)) # 1 vowel only, and it will start from the last vowel
        @test r(ar_raheem, isarabic=false, first_word=false, silent_last_vowel=false).segment === Segment("mi", Harakaat[Harakaat("i", false)]).segment
        @test r(ar_raheem, isarabic=false, first_word=false, silent_last_vowel=false).harakaat == [Harakaat("i", false)]
        @test r(ar_raheem, isarabic=false, first_word=false, silent_last_vowel=false).harakaat[1].char == "i"
        @test r(ar_raheem, isarabic=false, first_word=false, silent_last_vowel=false).harakaat[1].is_tanween == false

        r = Syllabification(true, Syllable(1, 1, 1)) # 1 vowel only, and it will start from the last vowel
        @test r(ar_raheem, isarabic=false, first_word=false, silent_last_vowel=false).segment === Segment("mi", Harakaat[Harakaat("i", false)]).segment
        @test r(ar_raheem, isarabic=false, first_word=false, silent_last_vowel=false).harakaat == [Harakaat("i", false)]
        @test r(ar_raheem, isarabic=false, first_word=false, silent_last_vowel=false).harakaat[1].char == "i"
        @test r(ar_raheem, isarabic=false, first_word=false, silent_last_vowel=false).harakaat[1].is_tanween == false

        r = Syllabification(true, Syllable(1, 2, 1)) # 1 vowel only, and it will start from the last vowel
        @test r(ar_raheem, isarabic=false, first_word=false, silent_last_vowel=false).segment === Segment("mi", Harakaat[Harakaat("i", false)]).segment
        @test r(ar_raheem, isarabic=false, first_word=false, silent_last_vowel=false).harakaat == [Harakaat("i", false)]
        @test r(ar_raheem, isarabic=false, first_word=false, silent_last_vowel=false).harakaat[1].char == "i"
        @test r(ar_raheem, isarabic=false, first_word=false, silent_last_vowel=false).harakaat[1].is_tanween == false

        r = Syllabification(true, Syllable(2, 2, 1)) # 1 vowel only, and it will start from the last vowel
        @test r(ar_raheem, isarabic=false, first_word=false, silent_last_vowel=false).segment === Segment("ymi", Harakaat[Harakaat("i", false)]).segment
        @test r(ar_raheem, isarabic=false, first_word=false, silent_last_vowel=false).harakaat == [Harakaat("i", false)]
        @test r(ar_raheem, isarabic=false, first_word=false, silent_last_vowel=false).harakaat[1].char == "i"
        @test r(ar_raheem, isarabic=false, first_word=false, silent_last_vowel=false).harakaat[1].is_tanween == false

        # more than 1 vowel
        r = Syllabification(true, Syllable(0, 0, 2)) # 2 vowels, and it will start from the last vowel

        # capture the long vowel
        @test r(ar_raheem, isarabic=false, first_word=false, silent_last_vowel=false).segment === Segment("iy?i", Harakaat[Harakaat("i", false)]).segment
        @test r(ar_raheem, isarabic=false, first_word=false, silent_last_vowel=false).harakaat == Harakaat[Harakaat("i", false), Harakaat("i", false)]
        @test r(ar_raheem, isarabic=false, first_word=false, silent_last_vowel=false).harakaat[1].char == "i"
        @test r(ar_raheem, isarabic=false, first_word=false, silent_last_vowel=false).harakaat[2].char == "i"
        @test r(ar_raheem, isarabic=false, first_word=false, silent_last_vowel=false).harakaat[1].is_tanween == false
        @test r(ar_raheem, isarabic=false, first_word=false, silent_last_vowel=false).harakaat[2].is_tanween == false

        r = Syllabification(true, Syllable(0, 1, 2)) # 2 vowels, and it will start from the last vowel
        @test r(ar_raheem, isarabic=false, first_word=false, silent_last_vowel=false).segment === Segment("iy?i", Harakaat[Harakaat("i", false)]).segment
        @test r(ar_raheem, isarabic=false, first_word=false, silent_last_vowel=false).harakaat == Harakaat[Harakaat("i", false), Harakaat("i", false)]
        @test r(ar_raheem, isarabic=false, first_word=false, silent_last_vowel=false).harakaat[1].char == "i"
        @test r(ar_raheem, isarabic=false, first_word=false, silent_last_vowel=false).harakaat[2].char == "i"
        @test r(ar_raheem, isarabic=false, first_word=false, silent_last_vowel=false).harakaat[1].is_tanween == false
        @test r(ar_raheem, isarabic=false, first_word=false, silent_last_vowel=false).harakaat[2].is_tanween == false

        r = Syllabification(true, Syllable(1, 1, 2)) # 2 vowels, and it will start from the last vowel
        @test r(ar_raheem, isarabic=false, first_word=false, silent_last_vowel=false).segment === Segment("Hiy?mi", Harakaat[Harakaat("i", false)]).segment
        @test r(ar_raheem, isarabic=false, first_word=false, silent_last_vowel=false).harakaat == Harakaat[Harakaat("i", false), Harakaat("i", false)]
        @test r(ar_raheem, isarabic=false, first_word=false, silent_last_vowel=false).harakaat[1].char == "i"
        @test r(ar_raheem, isarabic=false, first_word=false, silent_last_vowel=false).harakaat[2].char == "i"
        @test r(ar_raheem, isarabic=false, first_word=false, silent_last_vowel=false).harakaat[1].is_tanween == false
        @test r(ar_raheem, isarabic=false, first_word=false, silent_last_vowel=false).harakaat[2].is_tanween == false

        r = Syllabification(true, Syllable(2, 2, 2)) # 2 vowels, and it will start from the last vowel
        @test r(ar_raheem, isarabic=false, first_word=false, silent_last_vowel=false).segment === Segment("aHiym?ymi", Harakaat[Harakaat("i", false)]).segment
        @test r(ar_raheem, isarabic=false, first_word=false, silent_last_vowel=false).harakaat == Harakaat[Harakaat("i", false), Harakaat("i", false)]
        @test r(ar_raheem, isarabic=false, first_word=false, silent_last_vowel=false).harakaat[1].char == "i"
        @test r(ar_raheem, isarabic=false, first_word=false, silent_last_vowel=false).harakaat[2].char == "i"
        @test r(ar_raheem, isarabic=false, first_word=false, silent_last_vowel=false).harakaat[1].is_tanween == false
        @test r(ar_raheem, isarabic=false, first_word=false, silent_last_vowel=false).harakaat[2].is_tanween == false

        # more than 2 vowels
        r = Syllabification(true, Syllable(0, 0, 3)) # 3 vowels, and it will start from the last vowel
        @test r(ar_raheem, isarabic=false, first_word=false, silent_last_vowel=false).segment === Segment("a?iy?i", Harakaat[Harakaat("a", false), Harakaat("i", false), Harakaat("i", false)]).segment
        @test r(ar_raheem, isarabic=false, first_word=false, silent_last_vowel=false).harakaat == Harakaat[Harakaat("a", false), Harakaat("i", false), Harakaat("i", false)]
        @test r(ar_raheem, isarabic=false, first_word=false, silent_last_vowel=false).harakaat[1].char == "a"
        @test r(ar_raheem, isarabic=false, first_word=false, silent_last_vowel=false).harakaat[2].char == "i"
        @test r(ar_raheem, isarabic=false, first_word=false, silent_last_vowel=false).harakaat[3].char == "i"
        @test r(ar_raheem, isarabic=false, first_word=false, silent_last_vowel=false).harakaat[1].is_tanween == false
        @test r(ar_raheem, isarabic=false, first_word=false, silent_last_vowel=false).harakaat[2].is_tanween == false
        @test r(ar_raheem, isarabic=false, first_word=false, silent_last_vowel=false).harakaat[3].is_tanween == false

        # more than 2 vowels
        r = Syllabification(true, Syllable(1, 1, 3)) # 3 vowels, and it will start from the last vowel

        # remember ~ is a sadda, and therefore needs to have consonant preceding it to know what letter to double
        @test r(ar_raheem, isarabic=false, first_word=false, silent_last_vowel=false).segment === Segment("r~aH?Hiy?mi", Harakaat[Harakaat("a", false), Harakaat("i", false), Harakaat("i", false)]).segment
        @test r(ar_raheem, isarabic=false, first_word=false, silent_last_vowel=false).harakaat == Harakaat[Harakaat("a", false), Harakaat("i", false), Harakaat("i", false)]
        @test r(ar_raheem, isarabic=false, first_word=false, silent_last_vowel=false).harakaat[1].char == "a"
        @test r(ar_raheem, isarabic=false, first_word=false, silent_last_vowel=false).harakaat[2].char == "i"
        @test r(ar_raheem, isarabic=false, first_word=false, silent_last_vowel=false).harakaat[3].char == "i"
        @test r(ar_raheem, isarabic=false, first_word=false, silent_last_vowel=false).harakaat[1].is_tanween == false
        @test r(ar_raheem, isarabic=false, first_word=false, silent_last_vowel=false).harakaat[2].is_tanween == false
        @test r(ar_raheem, isarabic=false, first_word=false, silent_last_vowel=false).harakaat[3].is_tanween == false

        r = Syllabification(true, Syllable(2, 2, 3)) # 3 vowels, and it will start from the last vowel
        @test r(ar_raheem, isarabic=false, first_word=false, silent_last_vowel=false).segment === Segment("r~aHiy?aHiym?ymi", Harakaat[Harakaat("a", false), Harakaat("i", false), Harakaat("i", false)]).segment
        @test r(ar_raheem, isarabic=false, first_word=false, silent_last_vowel=false).harakaat == Harakaat[Harakaat("a", false), Harakaat("i", false), Harakaat("i", false)]
        @test r(ar_raheem, isarabic=false, first_word=false, silent_last_vowel=false).harakaat[1].char == "a"
        @test r(ar_raheem, isarabic=false, first_word=false, silent_last_vowel=false).harakaat[2].char == "i"
        @test r(ar_raheem, isarabic=false, first_word=false, silent_last_vowel=false).harakaat[3].char == "i"
        @test r(ar_raheem, isarabic=false, first_word=false, silent_last_vowel=false).harakaat[1].is_tanween == false
        @test r(ar_raheem, isarabic=false, first_word=false, silent_last_vowel=false).harakaat[2].is_tanween == false
        @test r(ar_raheem, isarabic=false, first_word=false, silent_last_vowel=false).harakaat[3].is_tanween == false

        ###
        alhamd = encode("ٱلْحَمْدُ")
        r = Syllabification(true, Syllable(0, 0, 1)) # 1 vowel only, and it will start from the last vowel
        @test r(alhamd, isarabic=false, first_word=true, silent_last_vowel=false).segment === Segment("u", Harakaat[Harakaat("u", false)]).segment
        @test r(alhamd, isarabic=false, first_word=true, silent_last_vowel=false).harakaat == [Harakaat("u", false)]
        @test r(alhamd, isarabic=false, first_word=true, silent_last_vowel=false).harakaat[1].char == "u"
        @test r(alhamd, isarabic=false, first_word=true, silent_last_vowel=false).harakaat[1].is_tanween == false

        alhamd = encode("ٱلْحَمْدُ") # output: "{loHamodu"
        r = Syllabification(true, Syllable(0, 0, 2)) # 1 vowel only, and it will start the finding of vowel from right to left of the letters
        @test r(alhamd, isarabic=false, first_word=true, silent_last_vowel=true).segment === Segment("{?a", Harakaat[Harakaat("a", false), Harakaat("a", false)]).segment
        @test r(alhamd, isarabic=false, first_word=true, silent_last_vowel=true).harakaat == [Harakaat("a", false), Harakaat("a", false)]
        @test r(alhamd, isarabic=false, first_word=true, silent_last_vowel=true).harakaat[1].char == "a"
        @test r(alhamd, isarabic=false, first_word=true, silent_last_vowel=true).harakaat[2].char == "a"

        alhamd = encode("ٱلْحَمْدُ") # output: "{loHamodu"
        r = Syllabification(true, Syllable(0, 1, 2)) # 1 vowel only, and it will start the finding of vowel from right to left of the letters
        @test r(alhamd, isarabic=false, first_word=true, silent_last_vowel=true).segment === Segment("{l?am", Harakaat[Harakaat("a", false), Harakaat("a", false)]).segment
        @test r(alhamd, isarabic=false, first_word=true, silent_last_vowel=true).harakaat == [Harakaat("a", false), Harakaat("a", false)]
        @test r(alhamd, isarabic=false, first_word=true, silent_last_vowel=true).harakaat[1].char == "a"
        @test r(alhamd, isarabic=false, first_word=true, silent_last_vowel=true).harakaat[2].char == "a"

        alhamd = encode("ٱلْحَمْدُ") # output: "{loHamodu"
        r = Syllabification(true, Syllable(1, 1, 2)) # 1 vowel only, and it will start the finding of vowel from right to left of the letters
        @test r(alhamd, isarabic=false, first_word=true, silent_last_vowel=true).segment === Segment("{l?Ham", Harakaat[Harakaat("a", false), Harakaat("a", false)]).segment
        @test r(alhamd, isarabic=false, first_word=true, silent_last_vowel=true).harakaat == [Harakaat("a", false), Harakaat("a", false)]
        @test r(alhamd, isarabic=false, first_word=true, silent_last_vowel=true).harakaat[1].char == "a"
        @test r(alhamd, isarabic=false, first_word=true, silent_last_vowel=true).harakaat[2].char == "a"

        alhamd = encode("ٱلْحَمْدُ") # output: "{loHamodu"
        r = Syllabification(true, Syllable(1, 2, 2)) # 1 vowel only, and it will start the finding of vowel from right to left of the letters
        @test r(alhamd, isarabic=false, first_word=true, silent_last_vowel=true).segment === Segment("{lo?Hamo", Harakaat[Harakaat("a", false), Harakaat("a", false)]).segment
        @test r(alhamd, isarabic=false, first_word=true, silent_last_vowel=true).harakaat == [Harakaat("a", false), Harakaat("a", false)]
        @test r(alhamd, isarabic=false, first_word=true, silent_last_vowel=true).harakaat[1].char == "a"
        @test r(alhamd, isarabic=false, first_word=true, silent_last_vowel=true).harakaat[2].char == "a"

        alhamd = encode("ٱلْحَمْدُ") # output: "{loHamodu"
        r = Syllabification(true, Syllable(2, 2, 2)) # 1 vowel only, and it will start the finding of vowel from right to left of the letters
        @test r(alhamd, isarabic=false, first_word=true, silent_last_vowel=true).segment === Segment("{lo?oHamo", Harakaat[Harakaat("a", false), Harakaat("a", false)]).segment
        @test r(alhamd, isarabic=false, first_word=true, silent_last_vowel=true).harakaat == [Harakaat("a", false), Harakaat("a", false)]
        @test r(alhamd, isarabic=false, first_word=true, silent_last_vowel=true).harakaat[1].char == "a"
        @test r(alhamd, isarabic=false, first_word=true, silent_last_vowel=true).harakaat[2].char == "a"
    end

    @testset "Disconnected Letters (Huroof Muqatta'at)" begin
        # Simple cases - individual letters
        r = Syllabification(true, Syllable(0, 0, 1))

        # Test 1: Basic case - Alif Lām Mīm (الم)
        alm = encode("الم")
        result = r(alm, isarabic=false, first_word=false, silent_last_vowel=false)
        @test result.segment == "A?l?m"
        @test length(result.harakaat) == 4  # 'a' and 'i' for alif, 'a' for lam, 'i' for mim
        @test result.harakaat[1].char == "a"  # First vowel for alif
        @test result.harakaat[2].char == "i"  # Second vowel for alif
        @test result.harakaat[3].char == "a"  # Vowel for lam
        @test result.harakaat[4].char == "i"  # Vowel for mim

        # Test 2: With maddah - Alif Lām Mīm Ṣād (المص)
        alms = encode("الٓمٓصٓ")
        result = r(alms, isarabic=false, first_word=false, silent_last_vowel=false)
        @test result.segment == "A?l^?m^?S^"
        @test length(result.harakaat) == 5  # 'a' and 'i' for alif, 'a' for lam, 'i' for mim, 'a' for sad
        @test result.harakaat[1].char == "a"  # First vowel for alif
        @test result.harakaat[2].char == "i"  # Second vowel for alif
        @test result.harakaat[3].char == "a"  # Vowel for lam
        @test result.harakaat[4].char == "i"  # Vowel for mim
        @test result.harakaat[5].char == "a"  # Vowel for sad

        # Test 3: Kāf Hā Yā 'Ayn Ṣād (كهيعص)
        khyas = encode("كهيعص")
        result = r(khyas, isarabic=false, first_word=false, silent_last_vowel=false)
        @test result.segment == "k?h?y?E?S"
        @test length(result.harakaat) == 6
        @test result.harakaat[1].char == "a"  # Vowel for kaf
        @test result.harakaat[2].char == "a"  # Vowel for ha
        @test result.harakaat[3].char == "a"  # Vowel for ya
        @test result.harakaat[4].char == "a"  # Vowel for ayn since it has sound of a first
        @test result.harakaat[5].char == "i"  # Vowel for ayn since it has sound of i second
        @test result.harakaat[6].char == "a"  # Vowel for sad

        # Test 4: Ṭā Hā (طه)
        th = encode("طه")
        result = r(th, isarabic=false, first_word=false, silent_last_vowel=false)
        @test result.segment == "T?h"
        @test length(result.harakaat) == 2
        @test result.harakaat[1].char == "a"  # Vowel for ta
        @test result.harakaat[2].char == "a"  # Vowel for ha

        # Test 5: Ṭā Sīn Mīm (طسم)
        tsm = encode("طسم")
        result = r(tsm, isarabic=false, first_word=false, silent_last_vowel=false)
        @test result.segment == "T?s?m"
        @test length(result.harakaat) == 3
        @test result.harakaat[1].char == "a"  # Vowel for ta
        @test result.harakaat[2].char == "i"  # Vowel for sin
        @test result.harakaat[3].char == "i"  # Vowel for mim

        # Test 6: Ḥā Mīm (حم)
        hm = encode("حم")
        result = r(hm, isarabic=false, first_word=false, silent_last_vowel=false)
        @test result.segment == "H?m"
        @test length(result.harakaat) == 2
        @test result.harakaat[1].char == "a"  # Vowel for ha
        @test result.harakaat[2].char == "i"  # Vowel for mim

        # Test 7: Yā Sīn (يس)
        ys = encode("يس")
        result = r(ys, isarabic=false, first_word=false, silent_last_vowel=false)
        @test result.segment == "y?s"
        @test length(result.harakaat) == 2
        @test result.harakaat[1].char == "a"  # Vowel for ya
        @test result.harakaat[2].char == "i"  # Vowel for sin

        # Test 8: Ṣād (ص)
        s = encode("صٓ")
        result = r(s, isarabic=false, first_word=false, silent_last_vowel=false)
        @test result.segment == "S^"
        @test length(result.harakaat) == 1
        @test result.harakaat[1].char == "a"  # Vowel for sad

        # Test 9: Qāf (ق)
        q = encode("ق")
        result = r(q, isarabic=false, first_word=false, silent_last_vowel=false)
        @test result.segment == "q"
        @test length(result.harakaat) == 1
        @test result.harakaat[1].char == "a"  # Vowel for qaf

        # Test 10: Nūn (ن)
        n = encode("ن")
        result = r(n, isarabic=false, first_word=false, silent_last_vowel=false)
        @test result.segment == "n"
        @test length(result.harakaat) == 1
        @test result.harakaat[1].char == "u"  # Vowel for nun

        # Test 11: 'Ayn Sīn Qāf (عسق)
        esq = encode("عسق")
        result = r(esq, isarabic=false, first_word=false, silent_last_vowel=false)
        @test result.segment == "E?s?q"
        @test length(result.harakaat) == 4
        @test result.harakaat[1].char == "a"  # Vowel for ayn for a sound
        @test result.harakaat[2].char == "i"  # Vowel for ayn for i sound
        @test result.harakaat[3].char == "i"  # Vowel for sin
        @test result.harakaat[4].char == "a"  # Vowel for qaf

        # Test 12: Complex case with multiple diacritics - Alif Lām Rā (الر)
        alr = encode("الٓرٓ")
        result = r(alr, isarabic=false, first_word=false, silent_last_vowel=false)
        @test result.segment == "A?l^?r^"
        @test length(result.harakaat) == 4  # 'a' and 'i' for alif, 'a' for lam, 'a' for ra
        @test result.harakaat[1].char == "a"  # First vowel for alif
        @test result.harakaat[2].char == "i"  # Second vowel for alif
        @test result.harakaat[3].char == "a"  # Vowel for lam
        @test result.harakaat[4].char == "a"  # Vowel for ra

        # Test 13: Single letter with shadda - Ṣād with shadda (صّ)
        ss = encode("صّ")
        result = r(ss, isarabic=false, first_word=false, silent_last_vowel=false)
        @test result.segment == "S~"
        @test length(result.harakaat) == 1
        @test result.harakaat[1].char == "a"  # Vowel for sad

        # Test 14: Letter with both shadda and maddah - this would be unusual but testing for robustness
        sm = encode("صّٓ")  # Note: This might not be a standard Arabic form
        result = r(sm, isarabic=false, first_word=false, silent_last_vowel=false)
        @test result.segment == "S~^"
        @test length(result.harakaat) == 1
        @test result.harakaat[1].char == "a"  # Vowel for sad

        # Test 15: Letter with sukun - Lām with sukun (لْ)
        ls = encode("لْ")
        result = r(ls, isarabic=false, first_word=false, silent_last_vowel=false)
        @test result.segment == "lo"
        @test length(result.harakaat) == 1
        @test result.harakaat[1].char == "a"  # Vowel for lam

        # Test 16: All three main vowel types
        sin = encode("س")  # sin - uses 'i' vowel
        ra = encode("ر")   # ra - uses 'a' vowel
        nun = encode("ن")  # nun - uses 'u' vowel

        result_sin = r(sin, isarabic=false, first_word=false, silent_last_vowel=false)
        result_ra = r(ra, isarabic=false, first_word=false, silent_last_vowel=false)
        result_nun = r(nun, isarabic=false, first_word=false, silent_last_vowel=false)

        @test result_sin.harakaat[1].char == "i"
        @test result_ra.harakaat[1].char == "a"
        @test result_nun.harakaat[1].char == "u"

        # Test 17: Letter combinations not found in Quran but possible in other contexts
        mix = encode("تنفخ")  # ta-nun-fa-kha
        result = r(mix, isarabic=false, first_word=false, silent_last_vowel=false)
        @test result.segment == "t?n?f?x"
        @test length(result.harakaat) == 4
        @test result.harakaat[1].char == "a"  # Vowel for ta
        @test result.harakaat[2].char == "u"  # Vowel for nun
        @test result.harakaat[3].char == "a"  # Vowel for fa
        @test result.harakaat[4].char == "a"  # Vowel for kha

        # Test 18: Hamza forms
        hamzas = encode("ءأؤإئ")  # Various hamza forms
        result = r(hamzas, isarabic=false, first_word=false, silent_last_vowel=false)
        @test result.segment == "'?>?&?<?}"
        @test length(result.harakaat) == 5
        @test all(x -> x.char == "a", result.harakaat)  # All hamza forms use 'a' vowel

        # Test 19: Mixed with regular text containing explicit vowels
        # This should be handled by the regular syllabification logic, not handle_no_vowels
        mixed = encode("المَ")  # The 'a' is an explicit vowel
        result = r(mixed, isarabic=false, first_word=false, silent_last_vowel=false)
        # In this case, it should identify the explicit vowel 'a'
        @test any(x -> x.char == "a", result.harakaat)
    end
end