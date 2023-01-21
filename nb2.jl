using Kitab
using Yunir
macarif_url = "https://raw.githubusercontent.com/OpenITI/RELEASE/f70348b43c92e97582e63b6c4b4a8596e6d4ac84/data/0276IbnQutaybaDinawari/0276IbnQutaybaDinawari.Macarif/0276IbnQutaybaDinawari.Macarif.Shamela0012129-ara1.mARkdown";
cuyunakhbar_url = "https://raw.githubusercontent.com/OpenITI/RELEASE/f70348b43c92e97582e63b6c4b4a8596e6d4ac84/data/0276IbnQutaybaDinawari/0276IbnQutaybaDinawari.CuyunAkhbar/0276IbnQutaybaDinawari.CuyunAkhbar.Shamela0023790-ara1.completed";
Kitab.get(OpenITIDB, [macarif_url, cuyunakhbar_url])
list(OpenITIDB)
cuyunakhbar = load(OpenITIDB, 1)
macarif = load(OpenITIDB, 2)

target = clean.(split(join(cuyunakhbar, " "), "ms"))
reference = clean.(split(join(macarif, " "), "ms"))

target = map(x -> x != "" ? x : "   ", target)
reference = map(x -> x != "" ? x : "   ", reference)

mapping = Dict(
    "الله" => "ﷲ",
    "لا" => "ﻻ"
)

target = normalize(target, mapping)
reference = normalize(reference, mapping)

etgt = encode.(normalize.(dediac.(target)));
etgt = string.(strip.(replace.(etgt, r"\s+" => " ")));
etgt = string.(strip.(replace.(etgt, "\ufeff" => "")));
etgt
eref = encode.(normalize.(dediac.(reference)));
eref = string.(strip.(replace.(eref, r"\s+" => " ")));
eref = string.(strip.(replace.(eref, "\ufeff" => "")));

using CairoMakie
@time res, scr = align(eref[1:20], etgt[1:40]); # 1.23 hours
ff, aa, xyss = plot(res[1,1], :matches, 300)
ff
scr
score_indcs = findmin(scr, dims=2)[2][findmin(scr, dims=2)[1] .< 1100]
f, ax, xys = plot(res, idx, :matches, 300)
f

function generate_xys(res::Alignment, text::Symbol=:reference, type::Symbol=:matches, nchars::Int64=60)
    xs, ys, zs = Int[], [1], Float32[]
    j = 1; k = 1;
    if text === :reference
        if type === :matches
            out = filter(x -> x[2] != '-', collect(res))
        elseif type === :insertions
            out = collect(res)
        elseif type === :deletions
            out = filter(x -> x[2] != '-', collect(res))
        elseif type === :mismatches
            out = filter(x -> x[2] != '-', collect(res))
        else
            throw("type takes :matches, :insertions, :deletions and :mismatches only.")
        end
    elseif text === :target
        if type === :matches
            out = filter(x -> x[1] != '-', collect(res))
        elseif type === :insertions
            out = filter(x -> x[1] != '-', collect(res))
        elseif type === :deletions
            out = collect(res)
        elseif type === :mismatches
            out = filter(x -> x[1] != '-', collect(res))
        else
            throw("type takes :matches, :insertions, :deletions and :mismatches only.")
        end
    else
        throw("text only takes :reference or :target as input.")
    end
    for i in out
        if j % nchars == 0
            k += 1
            ys = [1]
        else
            if i[2] == i[1]
                push!(ys, ys[end] - 1)
                if type === :matches
                    push!(xs, k)
                    push!(zs, ys[end] - 1)
                end
            else
                if type === :matches
                    push!(ys, ys[end] - 1)
                elseif type === :insertions
                    if i[2] === '-'
                        push!(xs, k)
                        push!(ys, ys[end] - 1)
                        push!(zs, ys[end] - 1)
                    else
                        push!(ys, ys[end] - 1)
                    end
                elseif type === :deletions
                    if i[1] === '-'
                        push!(xs, k)
                        push!(ys, ys[end] - 1)
                        push!(zs, ys[end] - 1)
                    else
                        push!(ys, ys[end] - 1)
                    end
                else
                    if i[1] != '-' && i[2] != '-' && i[1] != i[2]
                        push!(xs, k)
                        push!(ys, ys[end] - 1)
                        push!(zs, ys[end] - 1)
                    else
                        push!(ys, ys[end] - 1)
                    end 
                end
            end
        end
        j += 1
    end
    return xs, zs .+ nchars, nchars
end


###
ares = res
refs_ncs = 0
tgts_ncs = 0

rmid_xrs = []
tmid_xrs = []
# idx = src_indcs[2]
type=:matches
nchars=300
score_indcs = findmin(scr, dims=2)[2][findmin(scr, dims=2)[1] .< 1100]
k = 1
i = 3; j = 1
all_refs_xrs = []
all_tgts_xrs = []
all_tgts_xts = []
all_refs_yrs = []
all_tgts_yrs = []
all_tmid_xrs = []
all_rmid_xrs = []
for i in 1:2#size(ares, 1)
    old_i = i; l = 1    
    
    tgts_xrs = []
    tgts_xts = []
    tgts_yrs = []
    refs_xrs = []
    refs_yrs = []

    tmid_xrs = []
    rmid_xrs = []
    for j in 1:size(ares, 2)
        @info i,j,k
        if type === :matches
            xr, yr, nr = generate_xys(ares[i,j], :reference, :matches, nchars)
            xt, yt, nt = generate_xys(ares[i,j], :target, :matches, nchars)
        elseif type === :insertions
            xr, yr, nr = generate_xys(ares[i,j], :reference, :insertions, nchars)
            xt, yt, nt = generate_xys(ares[i,j], :target, :insertions, nchars)
        elseif type === :deletions
            xr, yr, nr = generate_xys(ares[i,j], :reference, :deletions, nchars)
            xt, yt, nt = generate_xys(ares[i,j], :target, :deletions, nchars)
        elseif type === :mismatches
            xr, yr, nr = generate_xys(ares[i,j], :reference, :mismatches, nchars)
            xt, yt, nt = generate_xys(ares[i,j], :target, :mismatches, nchars)
        else
            throw("type takes :matches, :insertions, :deletions and :mismatches only.")
        end
                
        if j == 1
            push!(tgts_xrs, xt)
            if i == 1
                if l == 1
                    push!(refs_xrs, xr)
                end
            else
                push!(refs_xrs, xr .+ maximum(all_refs_xrs[end][end]))
            end
        else
            push!(tgts_xrs, xt .+ maximum(tgts_xrs[end]))
        end
        
        if CartesianIndex(i,j) ∈ score_indcs
            if length(all_tgts_yrs) > 0
                if sum(all_tgts_yrs[end][j]) isa Missing
                    all_tgts_yrs[end][j] = yt
                    all_tgts_xts[end][j] = xt
                end
                push!(tgts_yrs, all_tgts_yrs[end][j])
                push!(tgts_xts, all_tgts_xts[end][j])
            else
                push!(tgts_yrs, yt)
                push!(tgts_xts, xt)
            end
            
            push!(refs_yrs, yr)
            if i == 1
                push!(refs_xrs, xr)
                push!(rmid_xrs, xr)
                push!(tmid_xrs, tgts_xrs[end])
            else
                push!(refs_xrs, xr .+ maximum(refs_xrs[end]))
                push!(rmid_xrs, xr .+ maximum(refs_xrs[end]))
                push!(tmid_xrs, tgts_xrs[end])
            end
        else
            if length(all_tgts_yrs) > 0
                push!(tgts_yrs, all_tgts_yrs[end][j])
                push!(tgts_xts, all_tgts_xts[end][j])
            else
                push!(tgts_yrs, repeat([missing], outer=length(yt)))
                push!(tgts_xts, xt)
            end

            if l == 1
                push!(refs_yrs, repeat([missing], outer=length(yr)))
            end
        end
        l += 1
    end
    push!(all_refs_xrs, refs_xrs)
    push!(all_tgts_xrs, tgts_xrs)
    push!(all_tgts_xts, tgts_xts)
    push!(all_refs_yrs, refs_yrs)
    push!(all_tgts_yrs, tgts_yrs)
    push!(all_rmid_xrs, rmid_xrs)
    push!(all_tmid_xrs, tmid_xrs)
end 
vcat(tgts_xts...)
vcat(vcat(all_tgts_xrs...)...)
vcat(vcat(all_tgts_xts...)...)
vcat(vcat(all_tgts_yrs...)...)
all_refs_xrs[end]
all_refs_yrs[end]
all_rmid_xrs[end]
all_tmid_xrs[end]

all_tgts_xrs[end]
all_tgts_yrs[end]

all_refs_xrs[2]
all_refs_yrs[2]
all_tgts_xrs[2]
all_tgts_yrs[2]

xr
yr
nr
xt
yt
nt

xr
xr
refs_xrs
push!(refs_xrs, xr .+ (idx[1] .* maximum(xr[end])))
push!(refs_xrs, xr .+ (idx[1] .* maximum(refs_xrs[end])))


push!(refs_xrs, xr .+ xr_newidx)

function generate_xys1(ares::Matrix{Yunir.Alignment}, score_indcs::Vector{CartesianIndex{2}},
    type::Symbol=:matches, nchars::Int64=60)
    all_refs_xrs = []
    all_tgts_xrs = []
    all_tgts_xts = []
    all_refs_yrs = []
    all_tgts_yrs = []
    all_tmid_xrs = []
    all_rmid_xrs = []
    for i in 1:5#size(ares, 1)
        old_i = i; l = 1    
        
        tgts_xrs = []
        tgts_xts = []
        tgts_yrs = []
        refs_xrs = []
        refs_yrs = []

        tmid_xrs = []
        rmid_xrs = []
        for j in 1:size(ares, 2)
            @info i,j,l
            if type === :matches
                xr, yr, nr = generate_xys(ares[i,j], :reference, :matches, nchars)
                xt, yt, nt = generate_xys(ares[i,j], :target, :matches, nchars)
            elseif type === :insertions
                xr, yr, nr = generate_xys(ares[i,j], :reference, :insertions, nchars)
                xt, yt, nt = generate_xys(ares[i,j], :target, :insertions, nchars)
            elseif type === :deletions
                xr, yr, nr = generate_xys(ares[i,j], :reference, :deletions, nchars)
                xt, yt, nt = generate_xys(ares[i,j], :target, :deletions, nchars)
            elseif type === :mismatches
                xr, yr, nr = generate_xys(ares[i,j], :reference, :mismatches, nchars)
                xt, yt, nt = generate_xys(ares[i,j], :target, :mismatches, nchars)
            else
                throw("type takes :matches, :insertions, :deletions and :mismatches only.")
            end
                    
            if j == 1
                push!(tgts_xrs, xt)
                if i == 1
                    if l == 1
                        push!(refs_xrs, xr)
                    end
                else
                    push!(refs_xrs, xr .+ maximum(all_refs_xrs[end][end]))
                end
            else
                push!(tgts_xrs, xt .+ maximum(tgts_xrs[end]))
            end
            
            if CartesianIndex(i,j) ∈ score_indcs
                @info "inside the score"
                if length(all_tgts_yrs) > 0
                    if sum(all_tgts_yrs[end][j]) isa Missing
                        all_tgts_yrs[end][j] = yt
                        all_tgts_xts[end][j] = xt
                    end
                    push!(tgts_yrs, all_tgts_yrs[end][j])
                    push!(tgts_xts, all_tgts_xts[end][j])
                else
                    push!(tgts_yrs, yt)
                    push!(tgts_xts, xt)
                end
                
                push!(refs_yrs, yr)
                if i == 1
                    push!(refs_xrs, xr)
                    push!(rmid_xrs, xr)
                    push!(tmid_xrs, tgts_xrs[end])
                else
                    push!(refs_xrs, xr .+ maximum(refs_xrs[end]))
                    push!(rmid_xrs, xr .+ maximum(refs_xrs[end]))
                    push!(tmid_xrs, tgts_xrs[end])
                end
            else
                @info "outside the score"
                if length(all_tgts_yrs) > 0
                    push!(tgts_yrs, all_tgts_yrs[end][j])
                    push!(tgts_xts, all_tgts_xrs[end][j])
                else
                    push!(tgts_yrs, repeat([missing], outer=length(yt)))
                    push!(tgts_xts, xt)
                end

                if l == 1
                    push!(refs_yrs, repeat([missing], outer=length(yr)))
                end
            end
            l += 1
            @info "length of xt=$(length(xt)), and yt=$(length(yt))"
            @info "length of tgts_xts=$(length(vcat(tgts_xts...))); tgts_yrs=$(length(vcat(tgts_yrs...)))"
        end
        push!(all_refs_xrs, refs_xrs)
        push!(all_tgts_xrs, tgts_xrs)
        push!(all_tgts_xts, tgts_xts)
        push!(all_refs_yrs, refs_yrs)
        push!(all_tgts_yrs, tgts_yrs)
        push!(all_rmid_xrs, rmid_xrs)
        push!(all_tmid_xrs, tmid_xrs)
    end 
    return (all_refs_xrs, all_refs_yrs, all_rmid_xrs), (all_tgts_xts, all_tgts_yrs, all_tmid_xrs)
end
score_indcs = findmin(scr, dims=2)[2][findmin(scr, dims=2)[1] .< 1040]
using CairoMakie
xys = generate_xys1(res, score_indcs);
referencestyles=(
        color=:blue, markersize=2
    )
    midstyles=(
        color=:red, linewidth=0.5
    )
    targetstyles=(
        color=:blue, markersize=1
    )
f = Figure()
a = f[1,1] = GridLayout()
xr = vcat(vcat(xys[1][1]...)...)
xt = vcat(xys[2][1][end]...)
mr = vcat(vcat(xys[1][3]...)...)
mt = vcat(vcat(xys[2][3]...)...)
axt = Axis(a[1:2,1], xaxisposition=:top)
mid = Axis(a[3,1], leftspinevisible=false, rightspinevisible=false, topspinevisible=false, bottomspinevisible=false)
axr = Axis(a[4:5,1])
if nchars == 300
    axt.yticks = (0:50:nchars, string.(collect(nchars:-50:0)))
    axr.yticks = (0:50:nchars, string.(collect(nchars:-50:0)))
else
    axt.yticks = (0:20:nchars, string.(collect(nchars:-20:0)))
    axr.yticks = (0:20:nchars, string.(collect(nchars:-20:0)))
end
axt.ylabel = "Target"
axr.ylabel = "Reference"
# if maximum(xt) > maximum(xr)
#     vlines!(axr, maximum(xr)+maximum(xr)*0.01; endlinestyle...)
# else
#     vlines!(axt, maximum(xt)+maximum(xt)*0.01; endlinestyle...)
# end
xr
yr = vcat(vcat(xys[1][2]...)...)
Makie.plot!(axr, xr, yr; referencestyles...)
# lines!(mid, xr[1], xt[1], 50), tan.(LinRange(-pi/2.3, pi/2.3, 50))
f
score_indcs
con_idx = length(xr) > length(xt) ? unique([(i, j) for (i,j) in zip(mr[3:end], mt)]) : unique([(i, j) for (i,j) in zip(mr, mt)])
j = 0; N = length(con_idx)
for i in con_idx
    if j % 10 == 0
        @info "Processing $(round((j/N)*100, digits=2))%"
    end
    lines!(mid, LinRange(i[1], i[2], 50), tan.(LinRange(-pi/2.3, pi/2.3, 50)); midstyles...)
    j += 1
end
f
vcat(xys[2][2][end]...)
vcat(xys[2][2][end])
vcat(xys[2][1][end]...)
vcat(xys[2][2][end]...)
xt
yt = vcat(xys[2][2][end]...)
plot!(axt, xt, yt; targetstyles...)
f
if (nchars == 300)
    ylims!(axt, low=-10, high=nchars+10)
    ylims!(axr, low=-10, high=nchars+10)
else
    ylims!(axt, low=-2, high=nchars+2)
    ylims!(axr, low=-2, high=nchars+2)
end
ylims!(mid, low=-4.5, high=4.5)
linkxaxes!(axt, mid, axr)
linkyaxes!(axt, axr)
f
xlen = maximum(xt) > maximum(xr) ? maximum(xt) : maximum(xr)
xlims!(axr, low=ceil(-xlen*0.01), high=ceil(xlen+xlen*0.01))
xlims!(axt, low=ceil(-xlen*0.01), high=ceil(xlen+xlen*0.01))
hidedecorations!(mid)
rowgap!(a, 10)
return f, (axt, mid, axr), ((xt, yt), (xr, yr))
function plot1(ares::Matrix{Yunir.Alignment}, idcs::Vector{CartesianIndex{2}},
    type::Symbol=:matches, nchars::Int64=60; 
    targetstyles::NamedTuple=(
        color=:blue, markersize=1
    ),
    referencestyles::NamedTuple=(
        color=:blue, markersize=2
    ),
    midstyles::NamedTuple=(
        color=:red, linewidth=0.5
    ),
    endlinestyle::NamedTuple=(color=:orange, linewidth=2))
    xys = generate_xys(ares, idcs, type, nchars) 
    f = Figure()
    a = f[1,1] = GridLayout()
    xr = vcat(xys[1][1]...)
    xt = vcat(xys[2][1]...)
    mr = vcat(xys[1][4]...)
    mt = vcat(xys[2][4]...)
    axt = Axis(a[1:2,1], xaxisposition=:top)
    mid = Axis(a[3,1], leftspinevisible=false, rightspinevisible=false, topspinevisible=false, bottomspinevisible=false)
    axr = Axis(a[4:5,1])
    if nchars == 300
        axt.yticks = (0:50:nchars, string.(collect(nchars:-50:0)))
        axr.yticks = (0:50:nchars, string.(collect(nchars:-50:0)))
    else
        axt.yticks = (0:20:nchars, string.(collect(nchars:-20:0)))
        axr.yticks = (0:20:nchars, string.(collect(nchars:-20:0)))
    end
    axt.ylabel = "Target"
    axr.ylabel = "Reference"
    # if maximum(xt) > maximum(xr)
    #     vlines!(axr, maximum(xr)+maximum(xr)*0.01; endlinestyle...)
    # else
    #     vlines!(axt, maximum(xt)+maximum(xt)*0.01; endlinestyle...)
    # end
    yr = vcat(xys[1][2]...)
    plot!(axr, xr, yr; referencestyles...)
    # lines!(mid, xr[1], xt[1], 50), tan.(LinRange(-pi/2.3, pi/2.3, 50))
    con_idx = length(xr) > length(xt) ? unique([(i, j) for (i,j) in zip(mr[3:end], mt)]) : unique([(i, j) for (i,j) in zip(mr, mt)])
    j = 0; N = length(con_idx)
    for i in con_idx
        if j % 10 == 0
            @info "Processing $(round((j/N)*100, digits=2))%"
        end
        lines!(mid, LinRange(i[1], i[2], 50), tan.(LinRange(-pi/2.3, pi/2.3, 50)); midstyles...)
        j += 1
    end
    yt = vcat(xys[2][2]...)
    plot!(axt, xt, yt; targetstyles...)
    if (nchars == 300)
        ylims!(axt, low=-10, high=nchars+10)
        ylims!(axr, low=-10, high=nchars+10)
    else
        ylims!(axt, low=-2, high=nchars+2)
        ylims!(axr, low=-2, high=nchars+2)
    end
    ylims!(mid, low=-4.5, high=4.5)
    linkxaxes!(axt, mid, axr)
    linkyaxes!(axt, axr)
    xlen = maximum(xt) > maximum(xr) ? maximum(xt) : maximum(xr)
    xlims!(axr, low=ceil(-xlen*0.01), high=ceil(xlen+xlen*0.01))
    xlims!(axt, low=ceil(-xlen*0.01), high=ceil(xlen+xlen*0.01))
    hidedecorations!(mid)
    rowgap!(a, 10)
    return f, (axt, mid, axr), ((xt, yt), (xr, yr))
end