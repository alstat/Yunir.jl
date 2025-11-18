using Yunir
@transliterator :default

ar_basmala = "بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ";
arb_token = tokenize(ar_basmala)
arb_parsed1 = parse(Orthography, arb_token[1])
arb_parsed2 = parse.(Orthography, arb_token)
numerals(arb_parsed2[1])
numerals(arb_parsed2[2])
numerals(arb_parsed2[3])
isfeat(arb_parsed2[1], AbstractLunar)
arb_parsed2[1][isfeat(arb_parsed2[1], AbstractLunar)]
isfeat.(arb_parsed2, AbstractLunar)
isfeat.(arb_parsed2, AbstractSolar)
vocals(arb_parsed2[1])
vocals(arb_parsed2[2])
vocals(arb_parsed2[3])
parse(SimpleEncoding, ar_basmala)
