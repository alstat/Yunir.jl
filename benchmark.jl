using BenchmarkTools
using Yunir
quran = readlines("quran.txt");

@benchmark normalize.(quran)
@time dediac.(verses(tnzldat))
@time evrs = encode.(verses(tnzldat))
@time arabic.(evrs)
