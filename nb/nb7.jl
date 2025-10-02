using Yunir
using Test

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
@test r(ar_raheem, isarabic=false, first_word=false, silent_last_vowel=false).segment === Segment("i?i", Harakaat[Harakaat("i", false)]).segment
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
@test r(ar_raheem, isarabic=false, first_word=false, silent_last_vowel=false).segment === Segment("a?i?i", Harakaat[Harakaat("a", false), Harakaat("i", false), Harakaat("i", false)]).segment
@test r(ar_raheem, isarabic=false, first_word=false, silent_last_vowel=false).harakaat == Harakaat[Harakaat("a", false), Harakaat("i", false), Harakaat("i", false)]
@test r(ar_raheem, isarabic=false, first_word=false, silent_last_vowel=false).harakaat[1].char == "a"
@test r(ar_raheem, isarabic=false, first_word=false, silent_last_vowel=false).harakaat[2].char == "i"
@test r(ar_raheem, isarabic=false, first_word=false, silent_last_vowel=false).harakaat[3].char == "i"
@test r(ar_raheem, isarabic=false, first_word=false, silent_last_vowel=false).harakaat[1].is_tanween == false
@test r(ar_raheem, isarabic=false, first_word=false, silent_last_vowel=false).harakaat[2].is_tanween == false
@test r(ar_raheem, isarabic=false, first_word=false, silent_last_vowel=false).harakaat[3].is_tanween == false

# more than 2 vowels
r = Syllabification(true, Syllable(1, 1, 3)) # 3 vowels, and it will start from the last vowel
@test r(ar_raheem, isarabic=false, first_word=false, silent_last_vowel=false).segment === Segment("~aH?Hiy?mi", Harakaat[Harakaat("a", false), Harakaat("i", false), Harakaat("i", false)]).segment
@test r(ar_raheem, isarabic=false, first_word=false, silent_last_vowel=false).harakaat == Harakaat[Harakaat("a", false), Harakaat("i", false), Harakaat("i", false)]
@test r(ar_raheem, isarabic=false, first_word=false, silent_last_vowel=false).harakaat[1].char == "a"
@test r(ar_raheem, isarabic=false, first_word=false, silent_last_vowel=false).harakaat[2].char == "i"
@test r(ar_raheem, isarabic=false, first_word=false, silent_last_vowel=false).harakaat[3].char == "i"
@test r(ar_raheem, isarabic=false, first_word=false, silent_last_vowel=false).harakaat[1].is_tanween == false
@test r(ar_raheem, isarabic=false, first_word=false, silent_last_vowel=false).harakaat[2].is_tanween == false
@test r(ar_raheem, isarabic=false, first_word=false, silent_last_vowel=false).harakaat[3].is_tanween == false

r = Syllabification(true, Syllable(2, 2, 3)) # 3 vowels, and it will start from the last vowel
@test r(ar_raheem, isarabic=false, first_word=false, silent_last_vowel=false).segment === Segment("r~aHi?aHiym?ymi", Harakaat[Harakaat("a", false), Harakaat("i", false), Harakaat("i", false)]).segment
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

alm

alms = encode("الٓمٓصٓ")
r = Syllabification(true, Syllable(0, 0, 1)) # 1 vowel only, and it will start from the last vowel
r(alms, isarabic=false, first_word=false, silent_last_vowel=false)

@test r(alms, isarabic=false, first_word=false, silent_last_vowel=false).segment === Segment("A?l^?m^?S^", Harakaat[]).segment
@test r(ar_raheem, isarabic=false, first_word=false, silent_last_vowel=false).harakaat == [Harakaat("i", false)]
@test r(ar_raheem, isarabic=false, first_word=false, silent_last_vowel=false).harakaat[1].char == "i"
@test r(ar_raheem, isarabic=false, first_word=false, silent_last_vowel=false).harakaat[1].is_tanween == false


# Test suite for handle_no_vowels function covering all disconnected letter cases
using Yunir
using Test

# Test suite for handle_no_vowels function covering all disconnected letter cases
@testset "Disconnected Letters (Huroof Muqatta'at)" begin
    # Simple cases - individual letters
    r = Syllabification(true, Syllable(1, 1, 1))
    
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
    @test length(result.harakaat) == 5
    @test result.harakaat[1].char == "a"  # Vowel for kaf
    @test result.harakaat[2].char == "a"  # Vowel for ha
    @test result.harakaat[3].char == "a"  # Vowel for ya
    @test result.harakaat[4].char == "a"  # Vowel for ayn
    @test result.harakaat[5].char == "a"  # Vowel for sad

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
    @test length(result.harakaat) == 3
    @test result.harakaat[1].char == "a"  # Vowel for ayn
    @test result.harakaat[2].char == "i"  # Vowel for sin
    @test result.harakaat[3].char == "a"  # Vowel for qaf

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

# Run the tests
# To run, use the following command:
# include("test_disconnected_letters.jl")