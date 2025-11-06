using DataFrames
using QuranTree
using Yunir

crps, tnzl = load(QuranData());
crps_tbl, tnzl_tbl = table(crps), table(tnzl);
crps_tbl
tnzl_tbl

