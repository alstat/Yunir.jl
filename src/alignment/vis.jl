using Colors
using Makie
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

function Makie.plot(res::Alignment,
    type::Symbol=:matches;
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

function Makie.plot(ares::Matrix{Yunir.Alignment}, idcs::Vector{CartesianIndex{2}},
    type::Symbol=:matches, nc::Int64=60; 
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
        vlines!(axr, maximum(xr)+maximum(xr)*0.01; endlinestyle...)
    else
        vlines!(axt, maximum(xt)+maximum(xt)*0.01; endlinestyle...)
    end
    yr = vcat(xys[1][2]...)
    plot!(axr, xr, yr; referencestyles...)
    # lines!(mid, xr[1], xt[1], 50), tan.(LinRange(-pi/2.3, pi/2.3, 50))
    con_idx = length(xr) > length(xt) ? unique([(i, j) for (i,j) in zip(xr[3:end], xt)]) : unique([(i, j) for (i,j) in zip(xr, xt)])
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