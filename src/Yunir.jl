module Yunir

import Base: download, delete!

abstract type AbstractModel end

include("orthography/orthography.jl")
# include("pos/morphfeats_types.jl")
include("constants.jl")
include("transliterator/transliterate.jl")
include("utils/decode.jl")
include("utils/normalize.jl")
include("utils/dediac.jl")
include("utils/clean.jl")
include("alignment/align.jl")
include("utils/encode.jl")
include("utils/parse.jl")
include("tokenizers/tokenize.jl")
include("alignment/vis.jl")

# data
export CAMeLData, MorphologyDB, locate, load
export BW_ENCODING, AR_DIACS_REGEX, SP_REGEX_CHARS, PUNCTUATIONS_REGEX, DEFAULT_NORMALIZER

export plot, expand_archars, isfeat, vocals, numerals, parse, arabic, clean, dediac, encode, normalize, tokenize, disambig, predict, install_camel
export align, score, count_matches, count_aligned, count_mismatches, count_insertions, count_deletions, collect
export Alignment, AbstractCAMeLDB, AbstractEncoder, SimpleEncoding
export @transliterator, genproperties

# Orthography
export AbstractCharacter, AbstractCharacter, AbstractConsonant, AbstractSolar, AbstractLunar,
       AbstractVowel, AbstractTanween, AbstractQuranPauseMark

export Tatweel, Orthography, Fatha, Fathatan, Damma, Dammatan, Kasra, Kasratan, Shadda, Sukun, Maddah, HamzaAbove, 
       HamzaBelow, HamzatWasl, AlifKhanjareeya, SmallHighSeen, SmallHighRoundedZero, SmallHighUprightRectangularZero,
       SmallHighMeemIsolatedForm, SmallLowSeen, SmallWaw, SmallYa, SmallHighNoon, EmptyCenterLowStop,
       EmptyCenterHighStop, RoundedHighStopWithFilledCenter, SmallLowMeem

# Consonants
export Alif, AlifMaksurah, Ba, Ta, TaMarbuta, Tha, Jeem, HHa, Kha, Dal, Thal, Ra, Zain, Seen, Sheen, Sad,
       DDad, TTa, DTha, Ain, Ghain, Fa, Qaf, Kaf, Lam, Meem, Noon, Waw, Ha, Hamza, Ya,
       AlifMaddah, AlifHamzaAbove, AlifHamzaBelow, AlifHamzatWasl, WawHamzaAbove, YaHamzaAbove

end # module
