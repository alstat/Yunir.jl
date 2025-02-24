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
