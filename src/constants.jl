const GOOGLE_DRIVE = "https://docs.google.com/uc?export=download"
const CATALOGUE_URL = "https://raw.githubusercontent.com/CAMeL-Lab/camel-tools-data/main/catalogue-1.4.json"

const CAMEL_DATA = joinpath(@__DIR__, "..", "db")
const CAMEL_CATALOGUE = joinpath(@__DIR__, "../db/catalogue.json")
const CAMEL_MORPHOLOGY = joinpath(@__DIR__, "../db/morphology")
const CAMEL_MORPHOLOGY_EGY = joinpath(@__DIR__, "../db/morphology/egy")
const CAMEL_MORPHOLOGY_MSA = joinpath(@__DIR__, "../db/morphology/msa")
const CAMEL_MORPHOLOGY_GLF = joinpath(@__DIR__, "../db/morphology/glf")
const CAMEL_DISAMBIGUATION = joinpath(@__DIR__, "../db/disambiguation")
const CAMEL_DISAMBIGUATION_MLE = joinpath(@__DIR__, "../db/disambiguation/mle")
const CAMEL_DISAMBIGUATION_MLE_EGY = joinpath(@__DIR__, "../db/disambiguation/mle/egy")
const CAMEL_DISAMBIGUATION_MLE_MSA = joinpath(@__DIR__, "../db/disambiguation/mle/msa")
const CAMEL_DISAMBIGUATION_BERT = joinpath(@__DIR__, "../db/disambiguation/bert")
const CAMEL_DISAMBIGUATION_BERT_EGY = joinpath(@__DIR__, "../db/disambiguation/bert/egy")
const CAMEL_DISAMBIGUATION_BERT_MSA = joinpath(@__DIR__, "../db/disambiguation/bert/msa")
const CAMEL_DISAMBIGUATION_BERT_GLF = joinpath(@__DIR__, "../db/disambiguation/bert/glf")
const CAMEL_DIALECTID = joinpath(@__DIR__, "../db/dialectid")
const CAMEL_NER = joinpath(@__DIR__, "../db/ner")
const CAMEL_SENTIMENT = joinpath(@__DIR__, "../db/sentiment")
const CAMEL_SENTIMENT_MBERT = joinpath(@__DIR__, "../db/sentiment/mbert")
const CAMEL_SENTIMENT_ARABERT = joinpath(@__DIR__, "../db/sentiment/arabert")

const CAMEL_MORPHOLOGY_EGY_R13 = joinpath(CAMEL_MORPHOLOGY_EGY, "morphology-db-egy-r13.zip");
const CAMEL_MORPHOLOGY_MSA_R13 = joinpath(CAMEL_MORPHOLOGY_MSA, "morphology-db-msa-r13.zip");
const CAMEL_MORPHOLOGY_GLF_01 = joinpath(CAMEL_MORPHOLOGY_GLF, "morphology-db-glf-01.zip");
const CAMEL_DISAMBIG_MLE_CALIMA_EGY_R13 = joinpath(CAMEL_DISAMBIGUATION_MLE_EGY, "disambig-mle-calima-egy-r13.zip");
const CAMEL_DISAMBIG_MLE_CALIMA_MSA_R13 = joinpath(CAMEL_DISAMBIGUATION_MLE_MSA, "disambig-mle-calima-msa-r13.zip");
const CAMEL_DISAMBIG_BERT_UNFACTORED_EGY = joinpath(CAMEL_DISAMBIGUATION_BERT_EGY, "disambig-bert-unfactored-egy.zip");
const CAMEL_DISAMBIG_BERT_UNFACTORED_MSA = joinpath(CAMEL_DISAMBIGUATION_BERT_MSA, "disambig-bert-unfactored-msa.zip");
const CAMEL_DISAMBIG_BERT_UNFACTORED_GLF = joinpath(CAMEL_DISAMBIGUATION_BERT_GLF, "disambig-bert-unfactored-glf.zip");
const CAMEL_DIALECTID_DEFAULT = joinpath(CAMEL_DIALECTID, "dialectid-default.zip");
const CAMEL_NER_ARABERT = joinpath(CAMEL_NER, "ner-arabert.zip");
const CAMEL_SENTIMENT_ANALYSIS_MBERT = joinpath(CAMEL_SENTIMENT_MBERT, "sentiment-analysis-mbert.zip");
const CAMEL_SENTIMENT_ANALYSIS_ARABERT = joinpath(CAMEL_SENTIMENT_ARABERT, "sentiment-analysis-arabert.zip");

const BACKOFF_TYPES = Set(["NONE", "NOAN_ALL", "NOAN_PROP", "ADD_ALL", "ADD_PROP"])
const JOIN_FEATS = Set(["gloss", "bw"])

const SIMPLE_ENCODING = Dict(
    Symbol(Char(0x0621)) => Symbol("Hamza"),
    Symbol(Char(0x0622)) => Symbol("Alif+Maddah"),
    Symbol(Char(0x0623)) => Symbol("AlifHamzaAbove"),
    Symbol(Char(0x0624)) => Symbol("WawHamzaAbove"),
    Symbol(Char(0x0625)) => Symbol("AlifHamzaBelow"),
    Symbol(Char(0x0626)) => Symbol("YaHamzaAbove"),
    Symbol(Char(0x0627)) => Symbol("Alif"),
    Symbol(Char(0x0628)) => Symbol("Ba"),
    Symbol(Char(0x0629)) => Symbol("TaMarbuta"),
    Symbol(Char(0x062A)) => Symbol("Ta"),
    Symbol(Char(0x062B)) => Symbol("Tha"),
    Symbol(Char(0x062C)) => Symbol("Jeem"),
    Symbol(Char(0x062D)) => Symbol("HHa"),
    Symbol(Char(0x062E)) => Symbol("Kha"),
    Symbol(Char(0x062F)) => Symbol("Dal"),
    Symbol(Char(0x0630)) => Symbol("Thal"),
    Symbol(Char(0x0631)) => Symbol("Ra"),
    Symbol(Char(0x0632)) => Symbol("Zain"),
    Symbol(Char(0x0633)) => Symbol("Seen"),
    Symbol(Char(0x0634)) => Symbol("Sheen"),
    Symbol(Char(0x0635)) => Symbol("Sad"),
    Symbol(Char(0x0636)) => Symbol("DDad"),
    Symbol(Char(0x0637)) => Symbol("TTa"),
    Symbol(Char(0x0638)) => Symbol("DTha"),
    Symbol(Char(0x0639)) => Symbol("Ain"),
    Symbol(Char(0x063A)) => Symbol("Ghain"),
    Symbol(Char(0x0640)) => Symbol("Tatweel"),
    Symbol(Char(0x0641)) => Symbol("Fa"),
    Symbol(Char(0x0642)) => Symbol("Qaf"),
    Symbol(Char(0x0643)) => Symbol("Kaf"),
    Symbol(Char(0x0644)) => Symbol("Lam"),
    Symbol(Char(0x0645)) => Symbol("Meem"),
    Symbol(Char(0x0646)) => Symbol("Noon"),
    Symbol(Char(0x0647)) => Symbol("Ha"),
    Symbol(Char(0x0648)) => Symbol("Waw"),
    Symbol(Char(0x0649)) => Symbol("AlifMaksura"),
    Symbol(Char(0x064A)) => Symbol("Ya"),
    Symbol(Char(0x064B)) => Symbol("Fathatan"),
    Symbol(Char(0x064C)) => Symbol("Dammatan"),
    Symbol(Char(0x064D)) => Symbol("Kasratan"),
    Symbol(Char(0x064E)) => Symbol("Fatha"),
    Symbol(Char(0x064F)) => Symbol("Damma"),
    Symbol(Char(0x0650)) => Symbol("Kasra"),
    Symbol(Char(0x0651)) => Symbol("Shadda"),
    Symbol(Char(0x0652)) => Symbol("Sukun"),
    Symbol(Char(0x0653)) => Symbol("Maddah"),
    Symbol(Char(0x0654)) => Symbol("HamzaAbove"),
    Symbol(Char(0x0670)) => Symbol("AlifKhanjareeya"),
    Symbol(Char(0x0671)) => Symbol("AlifHamzatWasl"),
    Symbol(Char(0x06DC)) => Symbol("SmallHighSeen"),
    Symbol(Char(0x06DF)) => Symbol("SmallHighRoundedZero"),
    Symbol(Char(0x06E0)) => Symbol("SmallHighUprightRectangularZero"),
    Symbol(Char(0x06E2)) => Symbol("SmallHighMeemIsolatedForm"),
    Symbol(Char(0x06E3)) => Symbol("SmallLowSeen"),
    Symbol(Char(0x06E5)) => Symbol("SmallWaw"),
    Symbol(Char(0x06E6)) => Symbol("SmallYa"),
    Symbol(Char(0x06E8)) => Symbol("SmallHighNoon"),
    Symbol(Char(0x06EA)) => Symbol("EmptyCenterLowStop"),
    Symbol(Char(0x06EB)) => Symbol("EmptyCenterHighStop"),
    Symbol(Char(0x06EC)) => Symbol("RoundedHighStopWithFilledCenter"),
    Symbol(Char(0x06ED)) => Symbol("SmallLowMeem")
);
const ORTHOGRAPHY_TYPES = Dict(
    Symbol(Char(0x0621)) => Hamza,
    Symbol(Char(0x0622)) => AlifMaddah,
    Symbol(Char(0x0623)) => AlifHamzaAbove,
    Symbol(Char(0x0624)) => WawHamzaAbove,
    Symbol(Char(0x0625)) => AlifHamzaBelow,
    Symbol(Char(0x0626)) => YaHamzaAbove,
    Symbol(Char(0x0627)) => Alif,
    Symbol(Char(0x0628)) => Ba,
    Symbol(Char(0x0629)) => Ta,
    Symbol(Char(0x062A)) => Ta,
    Symbol(Char(0x062B)) => Tha,
    Symbol(Char(0x062C)) => Jeem,
    Symbol(Char(0x062D)) => HHa,
    Symbol(Char(0x062E)) => Kha,
    Symbol(Char(0x062F)) => Dal,
    Symbol(Char(0x0630)) => Thal,
    Symbol(Char(0x0631)) => Ra,
    Symbol(Char(0x0632)) => Zain,
    Symbol(Char(0x0633)) => Seen,
    Symbol(Char(0x0634)) => Sheen,
    Symbol(Char(0x0635)) => Sad,
    Symbol(Char(0x0636)) => DDad,
    Symbol(Char(0x0637)) => TTa,
    Symbol(Char(0x0638)) => DTha,
    Symbol(Char(0x0639)) => Ain,
    Symbol(Char(0x063A)) => Ghain,
    Symbol(Char(0x0640)) => Tatweel,
    Symbol(Char(0x0641)) => Fa,
    Symbol(Char(0x0642)) => Qaf,
    Symbol(Char(0x0643)) => Kaf,
    Symbol(Char(0x0644)) => Lam,
    Symbol(Char(0x0645)) => Meem,
    Symbol(Char(0x0646)) => Noon,
    Symbol(Char(0x0647)) => Ha,
    Symbol(Char(0x0648)) => Waw,
    Symbol(Char(0x0649)) => AlifMaksurah,
    Symbol(Char(0x064A)) => Ya,
    Symbol(Char(0x064B)) => Fathatan,
    Symbol(Char(0x064C)) => Dammatan,
    Symbol(Char(0x064D)) => Kasratan,
    Symbol(Char(0x064E)) => Fatha,
    Symbol(Char(0x064F)) => Damma,
    Symbol(Char(0x0650)) => Kasra,
    Symbol(Char(0x0651)) => Shadda,
    Symbol(Char(0x0652)) => Sukun,
    Symbol(Char(0x0653)) => Maddah,
    Symbol(Char(0x0654)) => HamzaAbove,
    Symbol(Char(0x0670)) => AlifKhanjareeya,
    Symbol(Char(0x0671)) => AlifHamzatWasl,
    Symbol(Char(0x06DC)) => SmallHighSeen,
    Symbol(Char(0x06DF)) => SmallHighRoundedZero,
    Symbol(Char(0x06E0)) => SmallHighUprightRectangularZero,
    Symbol(Char(0x06E2)) => SmallHighMeemIsolatedForm,
    Symbol(Char(0x06E3)) => SmallLowSeen,
    Symbol(Char(0x06E5)) => SmallWaw,
    Symbol(Char(0x06E6)) => SmallYa,
    Symbol(Char(0x06E8)) => SmallHighNoon,
    Symbol(Char(0x06EA)) => EmptyCenterLowStop,
    Symbol(Char(0x06EB)) => EmptyCenterHighStop,
    Symbol(Char(0x06EC)) => RoundedHighStopWithFilledCenter,
    Symbol(Char(0x06ED)) => SmallLowMeem
);
const BW_ENCODING = Dict(
    Symbol(Char(0x0621)) => Symbol('\''),
    Symbol(Char(0x0622)) => Symbol('('),
    Symbol(Char(0x0623)) => Symbol('>'),
    Symbol(Char(0x0624)) => Symbol('&'),
    Symbol(Char(0x0625)) => Symbol('<'),
    Symbol(Char(0x0626)) => Symbol('}'),
    Symbol(Char(0x0627)) => Symbol('A'),
    Symbol(Char(0x0628)) => Symbol('b'),
    Symbol(Char(0x0629)) => Symbol('p'),
    Symbol(Char(0x062A)) => Symbol('t'),
    Symbol(Char(0x062B)) => Symbol('v'),
    Symbol(Char(0x062C)) => Symbol('j'),
    Symbol(Char(0x062D)) => Symbol('H'),
    Symbol(Char(0x062E)) => Symbol('x'),
    Symbol(Char(0x062F)) => Symbol('d'),
    Symbol(Char(0x0630)) => Symbol('*'),
    Symbol(Char(0x0631)) => Symbol('r'),
    Symbol(Char(0x0632)) => Symbol('z'),
    Symbol(Char(0x0633)) => Symbol('s'),
    Symbol(Char(0x0634)) => Symbol('$'),
    Symbol(Char(0x0635)) => Symbol('S'),
    Symbol(Char(0x0636)) => Symbol('D'),
    Symbol(Char(0x0637)) => Symbol('T'),
    Symbol(Char(0x0638)) => Symbol('Z'),
    Symbol(Char(0x0639)) => Symbol('E'),
    Symbol(Char(0x063A)) => Symbol('g'),
    Symbol(Char(0x0640)) => Symbol('_'),
    Symbol(Char(0x0641)) => Symbol('f'),
    Symbol(Char(0x0642)) => Symbol('q'),
    Symbol(Char(0x0643)) => Symbol('k'),
    Symbol(Char(0x0644)) => Symbol('l'),
    Symbol(Char(0x0645)) => Symbol('m'),
    Symbol(Char(0x0646)) => Symbol('n'),
    Symbol(Char(0x0647)) => Symbol('h'),
    Symbol(Char(0x0648)) => Symbol('w'),
    Symbol(Char(0x0649)) => Symbol('Y'),
    Symbol(Char(0x064A)) => Symbol('y'),
    Symbol(Char(0x064B)) => Symbol('F'),
    Symbol(Char(0x064C)) => Symbol('N'),
    Symbol(Char(0x064D)) => Symbol('K'),
    Symbol(Char(0x064E)) => Symbol('a'),
    Symbol(Char(0x064F)) => Symbol('u'),
    Symbol(Char(0x0650)) => Symbol('i'),
    Symbol(Char(0x0651)) => Symbol('~'),
    Symbol(Char(0x0652)) => Symbol('o'),
    Symbol(Char(0x0653)) => Symbol('^'),
    Symbol(Char(0x0654)) => Symbol('#'),
    Symbol(Char(0x0670)) => Symbol('`'),
    Symbol(Char(0x0671)) => Symbol('{'),
    Symbol(Char(0x06DC)) => Symbol(':'),
    Symbol(Char(0x06DF)) => Symbol('@'),
    Symbol(Char(0x06E0)) => Symbol('\"'),
    Symbol(Char(0x06E2)) => Symbol('['),
    Symbol(Char(0x06E3)) => Symbol(';'),
    Symbol(Char(0x06E5)) => Symbol(','),
    Symbol(Char(0x06E6)) => Symbol('.'),
    Symbol(Char(0x06E8)) => Symbol('!'),
    Symbol(Char(0x06EA)) => Symbol('-'),
    Symbol(Char(0x06EB)) => Symbol('+'),
    Symbol(Char(0x06EC)) => Symbol('%'),
    Symbol(Char(0x06ED)) => Symbol(']')
);

const AR_DIACS_REGEX = Regex(
    string(
        Char(0x064B)[1], "|", 
        Char(0x064C)[1], "|", 
        Char(0x064D)[1], "|", 
        Char(0x064E)[1], "|", 
        Char(0x064F)[1], "|", 
        Char(0x0640)[1], "|", # move this to special diac
        Char(0x0650)[1], "|", 
        Char(0x0651)[1], "|", 
        Char(0x0652)[1], "|", 
        Char(0x0653)[1], "|",
        Char(0x0670)[1], "|",
        Char(0x0654)[1]
    )
);
const PUNCTUATIONS_REGEX = r"[\.,-\/#!$%\^&\*;:{}=\-_`~()@\+\?><\[\]\+\؟\،\؛]"
const AR_DIACS = Symbol.(split(AR_DIACS_REGEX.pattern, "|"));
const SP_DEDIAC_MAPPING = Dict(
    Symbol(Char(0x0622)) => Symbol(Char(0x0627)),
    Symbol(Char(0x0623)) => Symbol(Char(0x0627)),
    Symbol(Char(0x0670)) => Symbol(Char(0x0627)),
    Symbol(Char(0x0671)) => Symbol(Char(0x0627)),
    Symbol(Char(0x0625)) => Symbol(Char(0x0627)),
    Symbol(Char(0x0624)) => Symbol(Char(0x0648)),
    Symbol(Char(0x0626)) => Symbol(Char(0x064A)),
    Symbol(Char(0x0649)) => Symbol(Char(0x064A)),
    Symbol(Char(0x0629)) => Symbol(Char(0x0647)),
    Symbol(Char(0xFDFA)) => Symbol("صلى الله عليه وسلم"),
    Symbol(Char(0xFDFB)) => Symbol("جل جلاله"),
    Symbol(Char(0xFDFD)) => Symbol("بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ")
);
const SP_DEDIAC_KEYS = collect(keys(SP_DEDIAC_MAPPING));
const SP_REGEX_CHARS = ['\\', '^', '$', '.', '|', '?', '*', '+', ')', '(', ']', '[', '}', '{'];