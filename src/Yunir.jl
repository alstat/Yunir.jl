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
include("utils/texts_wrapper.jl")
include("alignment/align.jl")
include("utils/encode.jl")
include("utils/parse.jl")
include("tokenizers/tokenize.jl")
include("alignment/vis.jl")
include("analysis/rhythmic/utils.jl")
include("analysis/rhythmic/vis_last_recited.jl")
include("analysis/symmetric/utils.jl")

# data
export CAMeLData, MorphologyDB, locate, load
export AR_DIACS_REGEX, AR_VOWELS, BW_VOWELS, BW_ENCODING, DEFAULT_NORMALIZER, PUNCTUATIONS_REGEX, SP_REGEX_CHARS

export expand_archars, isfeat, vocals, numerals, parse, arabic, clean, dediac, encode, normalize, tokenize, disambig, predict, install_camel
export align, score, count_matches, count_aligned, count_mismatches, count_insertions, count_deletions, collect
export Alignment, AbstractCAMeLDB, AbstractEncoder, SimpleEncoding
export @transliterator, genproperties

# text wrapper
export Ar, Bw

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

# Rhyme
export AbstractRhythmicVisArgs, AbstractSyllable, Harakaat, Syllabification, Syllable, Segment, Sequence, RState, sequence, vowel_indices, syllabic_consistency
export LastRecited, RhythmicVis, LastRecitedSyllable, last_syllable, to_numbers, vis
export LastRecitedVariants, A, B, C

# Symmetric Analysis
export Slicer, AyahEmbeddings, AyahMidpoints, gen_midpoints, gen_slices, fitness, selection, slicer, five_summary, refine!, mutate!, crossover!

end # module
