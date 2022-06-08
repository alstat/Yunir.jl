module Yunir

using HTTP
using JSON
using ZipFile

import Base: download, delete!

abstract type AbstractModel end

include("database/data.jl")
include("database/utils.jl")
include("orthography/orthography.jl")
# include("pos/morphfeats_types.jl")
include("constants.jl")
include("transliterator/transliterate.jl")
include("utils/decode.jl")
include("utils/normalize.jl")
include("utils/dediac.jl")
include("utils/encode.jl")
include("utils/parse.jl")
include("tokenizers/tokenize.jl")

# data
export CAMeLData, MorphologyDB, locate, load
export BW_ENCODING, AR_DIACS_REGEX, SP_REGEX_CHARS, PUNCTUATIONS_REGEX

export isfeat, vocal, numeral, parse, arabic, dediac, encode, normalize, tokenize, disambig, predict, install_camel
export AbstractCAMeLDB, AbstractEncoder, SimpleEncoding
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
