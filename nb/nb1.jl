using Yunir

shamela0012129 = "خرج مع ابي بكر الصديق رضي الله عنه في تجارة الي بصري ومعهم نعيمان وكان نعيمان ممن شهد——- بدرا ايضا وك——-ان علي الزاد فقال له سويبط———– اطعمني فقال حتي يجء ابو بكر فقال اما والله لاغيظنك فمروا بقوم فقال لهم سويبط -تشترون مني عبدا قا—لوا نعم فقال انه عبد له كلام وهو قاءل لكم اني حر فان كنتم اذا قال لكم هذه المقالة تركتموه فلا تفسدوا علي عبدي قا-لوا بل نشتريه منك فاشتروه بعشر قلاءص ثم جاءوا فوضعوا في عنقه حبلا ف—————قال نعيمان ان هذا يستهزء بكم واني حر فقالوا قد عرفنا –خبرك وانطلقوا به فلما جاء ابو بكر -اخبروه فاتبعهم ورد عليهم القلاءص واخذه فلما قدموا علي النبي صلي الله عليه وسلم اخبروه فضحك هو واصحابه من ذلك حولا"
shamela0023790 = "خرج— ابو بكر——————– في تجارة——— ومعه- نعيمان وسويبط بن حرملة وكانا شهدا بدر—–ا وكان نعيمان علي الزاد فقال له سويبط وكان مزاحا اطعمني فقال حتي يجء ابو بكر فقال اما والله لاغيظنك فمروا بقوم فقال لهم سويبط اتشترون مني عبدا لي قالوا نعم ق-ال انه عبد له كلام وهو قاءل لكم اني حر فان كنتم اذا قال لكم هذه المقالة تركتموه فلا تفسدوا علي عبدي فقالوا بل نشتريه منك——– بعشر قلاءص ثم جاءوا فوضعوا في عنقه حبلا وعمامة واشتروه فقال نعيمان ان هذا يستهزء بكم واني حر قا-لوا قد اخبرنا بخبرك وانطلقوا به و—-جاء ابو بكر فاخبروه فاتبعهم فرد عليهم القلاءص واخذه فلما قدموا علي النبي صلي الله عليه وسلم اخبروه فضحك هو واصحابه منهما- حول"

mapping = Dict(
    "الله" => "ﷲ",
    "لا" => "ﻻ"
)

shamela0012129_cln = clean(shamela0012129)
shamela0023790_cln = clean(shamela0023790)
shamela0012129_exp = normalize(shamela0012129_cln, mapping)
shamela0023790_exp = normalize(shamela0023790_cln, mapping)

shamela0012129_enc = encode(shamela0012129_exp)
shamela0023790_enc = encode(shamela0023790_exp)
etgt = shamela0023790_enc
eref = shamela0012129_enc
using BioAlignments
costmodel = CostModel(match=0, mismatch=1, insertion=1, deletion=1);
res = align(eref, etgt; costmodel=costmodel);
res.score
using CairoMakie
f, a, xys = plot(res, :insertions)
f
# reference        
function generate_xys(res::Yunir.Alignment, text::Symbol=:reference, type::Symbol=:matches, nchars::Int64=60)
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

xr, yr, nc = generate_xys(res, :reference, :mismatches)
xt, yt, nc = generate_xys(res, :target, :mismatches)
sigmoid(x) = 1/(1+exp(-x))
p = lines(LinRange(xr[1], xt[1], 15), tan.(LinRange(pi/2.3, -pi/2.3, 50)), color=:red)
for i in 2:length(xr)
    lines!(LinRange(xr[i], xt[i], 15), tan.(LinRange(pi/2.3, -pi/2.3, 50)), color=:red)
end
p
lines(tan.(LinRange(pi/2.3, -pi/2.3, 50)))
maximum(sigmoid.(LinRange(-3, 3, 15)))
using Colors
function Makie.plot(res::Alignment, 
    type::Symbol=:matches,
    targetstyles::NamedTuple=(
        color=colorant"#3AB0FF",
    ),
    referencestyles::NamedTuple=(
        color=colorant"#3AB0FF",
    ),
    midstyles::NamedTuple=(
        color=(colorant"#F87474", 0.6),
    )
    )
    if type === :matches
        xr, yr, nc = generate_xys(res)
        xt, yt, nc = generate_xys(res, :target)
    elseif type === :insertions
        xr, yr, nc = generate_xys(res, :reference, :insertions)
        xt, yt, nc = generate_xys(res, :target, :insertions)
    elseif type === :deletions
        xr, yr, nc = generate_xys(res, :reference, :deletions)
        xt, yt, nc = generate_xys(res, :target, :deletions)
    elseif type === :mismatches
        xr, yr, nc = generate_xys(res, :reference, :mismatches)
        xt, yt, nc = generate_xys(res, :target, :mismatches)
    else
        throw("type takes :matches, :insertions, :deletions and :mismatches only.")
    end
    f = Figure()
    a = f[1,1] = GridLayout()
    axt = Axis(a[1:2,1], xaxisposition=:top)
    mid = Axis(a[3,1], leftspinevisible=false, rightspinevisible=false, topspinevisible=false, bottomspinevisible=false)
    axr = Axis(a[4:5,1])
    axt.yticks = (0:20:nc, string.(collect(nc:-20:0)))
    axr.yticks = (0:20:nc, string.(collect(nc:-20:0)))
    axt.ylabel = "Target"
    axr.ylabel = "Reference"
    ylims!(axt, low=-2, high=nc+2)
    ylims!(mid, low=0, high=1)
    ylims!(axr, low=-2, high=nc+2)
    linkxaxes!(axt, mid, axr)
    linkyaxes!(axt, axr)
    plot!(axr, xr, yr; referencestyles...)
    plot!(axt, xt, yt; targetstyles...)
    lines!(mid, LinRange(xr[1], xt[1], 15), sigmoid.(LinRange(-4, 4, 15)); midstyles...)
    tlen = length(xr) > length(xt) ? length(xt) : length(xr)
    for i in 2:tlen
        lines!(mid, LinRange(xr[i], xt[i], 15), sigmoid.(LinRange(-4, 4, 15)); midstyles...)
    end
    hidedecorations!(mid)
    rowgap!(a, 10)
    return f, (axt, mid, axr), ((xt, yt), (xr, yr))
end
etgt = shamela0023790_enc
eref = shamela0012129_enc

f, a, xys = plot(res, :insertions)
a[1].xlabel = "Shamela0023790"
a[1].xlabelsize = 20
a[1].xticks = 0:2:unique(xys[1][1])[end]
a[3].xlabel = "Shamela0012129"
a[3].xlabelsize = 20
a[3].xticks = 0:2:unique(xys[2][1])[end]
f

f, a, xys = plot(res, :matches)
a[1].xlabel = "Shamela0023790"
a[1].xlabelsize = 20
a[1].xticks = 0:2:unique(xys[1][1])[end]
a[3].xlabel = "Shamela0012129"
a[3].xlabelsize = 20
a[3].xticks = 0:2:unique(xys[2][1])[end]
f

f, a, xys = plot(res, :mismatches)
a[1].xlabel = "Shamela0023790"
a[1].xlabelsize = 20
a[1].xticks = 0:2:unique(xys[1][1])[end]
a[3].xlabel = "Shamela0012129"
a[3].xlabelsize = 20
a[3].xticks = 0:2:unique(xys[2][1])[end]
f

f, a, xys = plot(res, :deletions)
f
a[1].xlabel = "Shamela0023790"
a[1].xlabelsize = 20
a[1].xticks = 0:2:unique(xys[1][1])[end]
a[3].xlabel = "Shamela0012129"
a[3].xlabelsize = 20
a[3].xticks = 0:2:unique(xys[2][1])[end]
f

f = Figure()
a = f[1,1] = GridLayout()
axt = Axis(a[1,1], xaxisposition=:top)
axr = Axis(a[2,1])
axt.yticks = 60:-20:0
axr.yticks = 60:-20:0
axt.ylabel = "Target"
axr.ylabel = "Reference"

# linkxaxes!(axt, axr)
plot!(axr, xr, yr)
plot!(axt, xt, yt)
f

using Makie          
# target        
xs, ys, zs = Int[], [1], Float32[]
j = 1; k = 1; l = 1; m = 1
for i in out
    if j % 60 == 0
        m += 1
        ys = [1]
    else
        if i[2] == i[1]
            push!(xs, m)
            push!(ys, ys[end] - 1)
            push!(zs, ys[end] - 1)
        elseif i[2] != "_"
            push!(ys, ys[end] - 1)
        end
    end
    j += 1
end
zs
plot(xs, zs .+ 60)


BioAlignments.alignment(res.alignment)
using BioAlignments
res.alignment

bw_basmala = encode(expand_archars(dediac(normalize(arabic("bisomi {ll~ahi {lr~aHoma`ni {lr~aHiymi")))))
res = align(bw_basmala, bw_basmala)
collect(res.alignment)
count_matches(res)
count_mismatches(res)
count_insertions(res)
count_deletions(res)
count_aligned(res)
score(res)

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
etgt
eref = encode.(normalize.(dediac.(reference)));
eref = string.(strip.(replace.(eref, r"\s+" => " ")));

using CairoMakie
@time res, scr = align(eref[1:20], etgt[1:30]); # 1.23 hours
ff, aa, xyss = plot(res[1,1], :insertions)
ff


idx = findmin(scr, dims=2)[2][findmin(scr, dims=2)[1] .< 1000]
f, ax, xys = plot(res, idx)
res
scr
fig, ax, hm = heatmap(1:size(scr, 1), 1:size(scr, 2), scr);
Colorbar(fig[:, end+1], hm)
fig

fig, ax, hm = heatmap(1:size(scr, 1), 1:size(scr, 2), map(x -> x .< 1060 ? x : missing, scr))
Colorbar(fig[:, end+1], hm)
ax.xlabel("Reference")
ax
ax.ylabel("Target")
fig.ylabel("Target")
ax
scr
findall(eachrow(scr))

xmins = mapslices(x -> minimum(x), scr, dims=2)
xmins
findmin(scr, dims=2)[2]
scr[findmin(scr, dims=2)[2]]

out = []
for i in 1:size(scr, 1)
    push!(out, scr[i,:] == xmins[i])
end
sum(out[1])

findall(map(x -> x .< 1060 ? true : false, scr))
plot(res[12,32], :matches)[1]
plot(res[12,32], :mismatches)[1]
plot(res[12,32], :insertions)[1]


function generate_xys(ares::Matrix{Yunir.Alignment}, scr_indcs::Vector{CartesianIndex{2}},
    type::Symbol=:matches)
    refs_xrs = []
    refs_yrs = []
    refs_ncs = 0

    tgts_xrs = []
    tgts_yrs = []
    tgts_ncs = 0
    for idx in scr_indcs
        if type === :matches
            xr, yr, nr = generate_xys(ares[idx])
            xt, yt, nt = generate_xys(ares[idx], :target)
        elseif type === :insertions
            xr, yr, nr = generate_xys(ares[idx], :reference, :insertions)
            xt, yt, nt = generate_xys(ares[idx], :target, :insertions)
        elseif type === :deletions
            xr, yr, nr = generate_xys(ares[idx], :reference, :deletions)
            xt, yt, nt = generate_xys(ares[idx], :target, :deletions)
        elseif type === :mismatches
            xr, yr, nr = generate_xys(ares[idx], :reference, :mismatches)
            xt, yt, nt = generate_xys(ares[idx], :target, :mismatches)
        else
            throw("type takes :matches, :insertions, :deletions and :mismatches only.")
        end
        try
            push!(refs_xrs, xr .+ (idx[1] * nr))
        catch
            push!(refs_xrs, xr)
        end
        push!(refs_yrs, yr)
        refs_ncs = nr[1]

        try
            push!(tgts_xrs, xt .+ (idx[2] * nr))
        catch
            push!(tgts_xrs, xt)
        end
        push!(tgts_yrs, yt)
        tgts_ncs = nr[1]
    end
    return (refs_xrs, refs_yrs, refs_ncs), (tgts_xrs, tgts_yrs, tgts_ncs)
end

function generate_xys(res::Yunir.Alignment, text::Symbol=:reference, type::Symbol=:matches, nchars::Int64=60)
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
scr
# plotting aggregated vis
idx = findmin(scr, dims=2)[2][findmin(scr, dims=2)[1] .< 1150]
findmin(scr[1:end-1,1:end-1], dims=2)[1][findmin(scr[1:end-1,1:end-1], dims=2)[1] .< 1000]
# o = Yunir.generate_xys(res, idx, :insertions)
ff, a, xx = plot(res, idx; midstyles=(color=(:red, 0.7), linewidth=0.1))
ff
nc = 60
ref_idx = [1,Int64(ceil(sum([length(i) for i in eref])/nchar))]
tgt_idx = [1,Int64(ceil(sum([length(i) for i in etgt])/nchar))]
f = Figure()
a = f[1,1] = GridLayout()
xr = vcat(o[1][1]...)
xt = vcat(o[2][1]...)
axt = Axis(a[1:2,1], xaxisposition=:top)
mid = Axis(a[3,1], leftspinevisible=false, rightspinevisible=false, topspinevisible=false, bottomspinevisible=false)
axr = Axis(a[4:5,1])
axt.yticks = (0:20:nc, string.(collect(nc:-20:0)))
axr.yticks = (0:20:nc, string.(collect(nc:-20:0)))
axt.ylabel = "Target"
axr.ylabel = "Reference"
if maximum(xt) > maximum(xr)
    vlines!(axr, maximum(xr)+maximum(xr)*0.01; color=:orange)
else
    vlines!(axt, maximum(xt)+maximum(xt)*0.01; color=:orange)
end
axt.xgridvisible = false
axr.xgridvisible = false
axt.ygridvisible = false
axr.ygridvisible = false
plot!(axr, ref_idx, [1,1], color=(:white, 0))
plot!(axt, tgt_idx, [1,1], color=(:white, 0))
plot!(axr, xr, vcat(o[1][2]...), color=:blue, markersize=2)
lines!(mid, xr[1], xt[1], 50), tan.(LinRange(-pi/2.3, pi/2.3, 50))
# tlen = length(xr) > length(xt) ? length(xt) : length(xr)
j = 0; 
con_idx = length(xr) > length(xt) ? unique([(i, j) for (i,j) in zip(xr[3:end], xt)]) : unique([(i, j) for (i,j) in zip(xr, xt)])
N = length(con_idx)
for i in con_idx
    if j % 10 == 0
        @info "Processing $(round((j/N)*100, digits=2))%"
    end
    lines!(mid, LinRange(i[1], i[2], 50), tan.(LinRange(-pi/2.3, pi/2.3, 50)), color=(:red, 0.1), linewidth=0.1)
    j += 1
end
plot!(axt, xt, vcat(o[2][2]...), color=:blue, markersize=1)
ylims!(axt, low=-2, high=nc+2)
ylims!(mid, low=-4.5, high=4.5)
ylims!(axr, low=-2, high=nc+2)
linkxaxes!(axt, mid, axr)
linkyaxes!(axt, axr)
xlen = maximum(xt) > maximum(xr) ? maximum(xt) : maximum(xr)
xlims!(axr, low=ceil(-maximum(xr)*0.01), high=ceil(maximum(xr)+maximum(xr)*0.01))
xlims!(axt, low=ceil(-maximum(xt)*0.01), high=ceil(maximum(xt)+maximum(xt)*0.01))
hidedecorations!(mid)
rowgap!(a, 10)
f


idx = findmin(scr[1:end-1,1:end-1], dims=2)[2][findmin(scr[1:end-1,1:end-1], dims=2)[1] .< 1000]
findmin(scr[1:end-1,1:end-1], dims=2)[1][findmin(scr[1:end-1,1:end-1], dims=2)[1] .< 1000]
nc = 60
type=:matches
ares = res
idcs = idx
f, ax, xys = plot(res, idx)
f
function Makie.plot(ares::Matrix{Yunir.Alignment}, idcs::Vector{CartesianIndex{2}},
    type::Symbol = :matches, nc::Int64 = 60)
    xys = generate_xys(ares, idcs, type) 
    f = Figure()
    a = f[1,1] = GridLayout()
    xr = vcat(xys[1][1]...)
    xt = vcat(xys[2][1]...)
    axt = Axis(a[1:2,1], xaxisposition=:top)
    mid = Axis(a[3,1], leftspinevisible=false, rightspinevisible=false, topspinevisible=false, bottomspinevisible=false)
    axr = Axis(a[4:5,1])
    axt.yticks = (0:20:nc, string.(collect(nc:-20:0)))
    axr.yticks = (0:20:nc, string.(collect(nc:-20:0)))
    axt.ylabel = "Target"
    axr.ylabel = "Reference"
    if maximum(xt) > maximum(xr)
        vlines!(axr, maximum(xr)+maximum(xr)*0.01; color=:orange)
    else
        vlines!(axt, maximum(xt)+maximum(xt)*0.01; color=:orange)
    end
    plot!(axr, xr, vcat(xys[1][2]...), color=:blue, markersize=2)
    lines!(mid, xr[1], xt[1], 50), tan.(LinRange(-pi/2.3, pi/2.3, 50))
    con_idx = length(xr) > length(xt) ? unique([(i, j) for (i,j) in zip(xr[3:end], xt)]) : unique([(i, j) for (i,j) in zip(xr, xt)])
    j = 0; N = length(con_idx)
    for i in con_idx
        if j % 10 == 0
            @info "Processing $(round((j/N)*100, digits=2))%"
        end
        lines!(mid, LinRange(i[1], i[2], 50), tan.(LinRange(-pi/2.3, pi/2.3, 50)), color=(:red, 0.1), linewidth=0.1)
        j += 1
    end
    plot!(axt, xt, vcat(xys[2][2]...), color=:blue, markersize=1)
    ylims!(axt, low=-2, high=nc+2)
    ylims!(mid, low=-4.5, high=4.5)
    ylims!(axr, low=-2, high=nc+2)
    linkxaxes!(axt, mid, axr)
    linkyaxes!(axt, axr)
    xlen = maximum(xt) > maximum(xr) ? maximum(xt) : maximum(xr)
    xlims!(axr, low=ceil(-xlen*0.01), high=ceil(xlen+xlen*0.01))
    xlims!(axt, low=ceil(-xlen*0.01), high=ceil(xlen+xlen*0.01))
    hidedecorations!(mid)
    rowgap!(a, 10)
    return f, (axt, mid, axr), ((xt, yt), (xr, yr))
end
function Makie.plot(res::Alignment, 
    type::Symbol=:matches,
    targetstyles::NamedTuple=(
        color=colorant"#3AB0FF",
    ),
    referencestyles::NamedTuple=(
        color=colorant"#3AB0FF",
    ),
    midstyles::NamedTuple=(
        color=(colorant"#F87474", 0.6),
    )
    )
    if type === :matches
        xr, yr, nc = generate_xys(res)
        xt, yt, nc = generate_xys(res, :target)
    elseif type === :insertions
        xr, yr, nc = generate_xys(res, :reference, :insertions)
        xt, yt, nc = generate_xys(res, :target, :insertions)
    elseif type === :deletions
        xr, yr, nc = generate_xys(res, :reference, :deletions)
        xt, yt, nc = generate_xys(res, :target, :deletions)
    elseif type === :mismatches
        xr, yr, nc = generate_xys(res, :reference, :mismatches)
        xt, yt, nc = generate_xys(res, :target, :mismatches)
    else
        throw("type takes :matches, :insertions, :deletions and :mismatches only.")
    end
    f = Figure()
    a = f[1,1] = GridLayout()
    axt = Axis(a[1:2,1], xaxisposition=:top)
    mid = Axis(a[3,1], leftspinevisible=false, rightspinevisible=false, topspinevisible=false, bottomspinevisible=false)
    axr = Axis(a[4:5,1])
    axt.yticks = (0:20:nc, string.(collect(nc:-20:0)))
    axr.yticks = (0:20:nc, string.(collect(nc:-20:0)))
    axt.ylabel = "Target"
    axr.ylabel = "Reference"
    ylims!(axt, low=-2, high=nc+2)
    ylims!(mid, low=-4.5, high=4.5)
    ylims!(axr, low=-2, high=nc+2)
    linkxaxes!(axt, mid, axr)
    linkyaxes!(axt, axr)
    plot!(axr, xr, yr; referencestyles...)
    plot!(axt, xt, yt; targetstyles...)
    lines!(mid, LinRange(xr[1], xt[1], 50), tan.(LinRange(-pi/2.3, pi/2.3, 50)); midstyles...)
    tlen = length(xr) > length(xt) ? length(xt) : length(xr)
    for i in 2:tlen
        lines!(mid, LinRange(xr[i], xt[i], 50), tan.(LinRange(-pi/2.3, pi/2.3, 50)); midstyles...)
    end
    hidedecorations!(mid)
    rowgap!(a, 10)
    return f, (axt, mid, axr), ((xt, yt), (xr, yr))
end

collect(res)
using CairoMakie
f, a, xys = plot(res[1,end-1], :matches)
f


costmodel = CostModel(match=0, mismatch=3, insertion=1, deletion=1);

out = pairalign(EditDistance(), "abcd hgf", "adcde jhb", costmodel)
out
count_mismatches(alignment(out))


#\
using Yunir
using BioAlignments
etgt = "رضي الله عنه"
eref = "صلي الله عليه وسلم"
mapping = Dict("الله" => "ﷲ",)
etgt_nrm = normalize(etgt, mapping)
eref_nrm = normalize(eref, mapping)
costmodel = CostModel(match=0, mismatch=1, insertion=1, deletion=1)
res = align(encode(eref_nrm), encode(etgt_nrm), costmodel=costmodel)
res