Orthographical Analysis
=============
All Arabic characters and diacritics and other characters used in Arabic texts, such as the Qur'an are all encoded as `struct`s or types. These types have properties that can be used for orthographical analysis. These properties are the vocal and numeral associated with each of the character.

## Numerals
The numerals we refer here is the [Abjad numeral](https://en.wikipedia.org/wiki/Abjad_numerals).
```@repl abc2
using Yunir

ar_basmala = "بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ";
```
If we want to take the numerals, we need to tokenize it first.
```@repl abc2
arb_token = tokenize(ar_basmala)
```
Next we then parse each of these words as   `Orthography`.
```@repl abc2
arb_parsed1 = parse(Orthography, arb_token[1])
arb_parsed2 = parse.(Orthography, arb_token)
```
Finally, we can compute the numerals of the parsed tokens as follows:
```@repl abc2
numerals(arb_parsed2[1])
numerals(arb_parsed2[2])
numerals(arb_parsed2[3])
```
We can also check the type of the characters, whether it is a Lunar or Solar character. To do this, use the `isfeat` (short for 'is feature' in the sense that characters here are also referred as feature).
```@repl abc2
isfeat(arb_parsed2[1], AbstractLunar)
arb_parsed2[1][isfeat(arb_parsed2[1], AbstractLunar)]
isfeat.(arb_parsed2, AbstractLunar)
isfeat.(arb_parsed2, AbstractSolar)
```
## Vocals
Vocals refer to categorization of the characters based on the vocals it mainly uses in pronunciation.
```@repl abc2
vocals(arb_parsed2[1])
vocals(arb_parsed2[2])
vocals(arb_parsed2[3])
```

## Simple Encoding
Simple encoding is a worded or spelled out transliteration of the arabic text.
```@repl abc2
parse(SimpleEncoding, ar_basmala)
```