using BioAlignments
mutable struct Alignment
	alignment::BioAlignments.PairwiseAlignment
	score::Int64
end

function align(src::String, tgt::String; costmodel::CostModel=CostModel(match=0, mismatch=1, insertion=1, deletion=0))
	res = pairalign(EditDistance(), tgt, src, costmodel)
	return Alignment(BioAlignments.alignment(res), BioAlignments.score(res))
end

function Base.show(io::IO, t::Alignment)
	println(io, "PairwiseAlignment")
	println(io, "١-reference")
	println(io, "٢-target\n")
    print(io, print_align(t.alignment))
end

function print_align(out)
	text_a = "٢    "
	text_b = "١    "
	text_m = ["     "]
	output = ""
	j = 1
	for i in out
		if i[1] == '-'
			a = "_"
		else
			a = i[1]
		end
	
		if i[2] == '-'
			b = "_"
		else
			b = i[2]
		end
	
		if i[1] == i[2]
			m = "ا"
		else
			m = "ـ"
		end
	
		if j % 60 == 0
			text_a = arabic(text_a) * 
				"\n" * join(text_m) * 
				"\n" * arabic(text_b) * "\n\n"
			output = output * text_a
			text_a = "٢    "
			text_b = "١    "
			text_m = ["     "]
		else
			text_a *= a
			text_b *= b
			push!(text_m, m)
		end
		j += 1
	end
	return output
end

function BioAlignments.count_matches(res::Yunir.Alignment)
    BioAlignments.count_matches(res.alignment)
end

function BioAlignments.count_aligned(res::Yunir.Alignment)
    BioAlignments.count_aligned(res.alignment)
end

function BioAlignments.count_deletions(res::Yunir.Alignment)
    BioAlignments.count_deletions(res.alignment)
end

function BioAlignments.count_insertions(res::Yunir.Alignment)
    BioAlignments.count_insertions(res.alignment)
end

function BioAlignments.count_mismatches(res::Yunir.Alignment)
    BioAlignments.count_mismatches(res.alignment)
end

function BioAlignments.collect(res::Yunir.Alignment)
	BioAlignments.collect(res.alignment)
end

function BioAlignments.score(res::Yunir.Alignment)
	res.score
end