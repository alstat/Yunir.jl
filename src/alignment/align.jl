using BioAlignments
mutable struct Alignment
	alignment::BioAlignments.PairwiseAlignment
	score::Int64
end

"""
	align(src::String, tgt::String; costmodel::BioAlignments.CostModel=BioAlignments.CostModel(match=0, mismatch=1, insertion=1, deletion=1))	

Align `tgt` string to `src` string using a particular `costmodel` from BioAlignments.jl.
"""
function align(src::String, tgt::String; costmodel::BioAlignments.CostModel=BioAlignments.CostModel(match=0, mismatch=1, insertion=1, deletion=1))
	res = BioAlignments.pairalign(BioAlignments.EditDistance(), tgt, src, costmodel)
	return Alignment(BioAlignments.alignment(res), BioAlignments.score(res))
end

"""
	align(src::Array{String}, tgt::Array{String}; 
		costmodel::CostModel=CostModel(match=0, mismatch=1, insertion=1, deletion=0),
		store_results::Bool=true
	)

ALign `tgt` array of texts to `src` array of texts using a particular `costmodel` from BioAlignments.jl. `store_results` if results of alignment are stored or returned, 
otherwise, only the scores are returned.
"""
function align(src::Array{String}, tgt::Array{String}; 
	costmodel::CostModel=CostModel(match=0, mismatch=1, insertion=1, deletion=0),
	store_results::Bool=true)
	nref = length(src)
	ntgt = length(tgt)
	scores = Matrix{Int64}(undef, nref, ntgt)
	if store_results
		results = Matrix{Yunir.Alignment}(undef, nref, ntgt)
	end
	for i in 1:nref
		for j in 1:ntgt
			alignres = align(src[i], tgt[j], costmodel=costmodel)
			if store_results
				results[i, j] = alignres
			end
			scores[i, j] = score(alignres)
		end
		if string(i)[end] == '1'
			if i != 11
				@info "$(round(i/nref, digits=4)*100)%, aligning $(i)st reference milestone to all target milestone."
			else
				@info "$(round(i/nref, digits=4)*100)%, aligning $(i)th reference milestone to all target milestone."
			end
		elseif string(i)[end] == '2'
			if i != 12
				@info "$(round(i/nref, digits=4)*100)%, aligning $(i)nd reference milestone to all target milestone."
			else
				@info "$(round(i/nref, digits=4)*100)%, aligning $(i)th reference milestone to all target milestone."
			end
		elseif string(i)[end] == '3'
			if i != 13
				@info "$(round(i/nref, digits=4)*100)%, aligning $(i)rd reference milestone to all target milestone."
			else
				@info "$(round(i/nref, digits=4)*100)%, aligning $(i)th reference milestone to all target milestone."
			end
		else
			@info "$(round(i/nref, digits=4)*100)%, aligning $(i)th reference milestone to all target milestone."
		end
	end
	if store_results
		return results, scores
	else
		return scores
	end
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
	
	out = collect(out)
	nout = length(out)
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
			m = " "
		end
		
		if nout < 60
			if j != nout
				text_a *= a
				text_b *= b
				push!(text_m, m)
			else
				text_a = arabic(text_a) * 
					"\n" * join(text_m) * 
					"\n" * arabic(text_b) * "\n\n"
				output = output * text_a
			end
		else
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