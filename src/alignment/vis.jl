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

sigmoid(x) = 1/(1+exp(-x))
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
    ylims!(mid, low=0.05, high=0.95)
    ylims!(axr, low=-2, high=nc+2)
    linkxaxes!(axt, mid, axr)
    linkyaxes!(axt, axr)
    plot!(axr, xr, yr; referencestyles...)
    plot!(axt, xt, yt; targetstyles...)
    lines!(mid, LinRange(xr[1], xt[1], 15), sigmoid.(LinRange(-3, 3, 15)); midstyles...)
    tlen = length(xr) > length(xt) ? length(xt) : length(xr)
    for i in 2:tlen
        lines!(mid, LinRange(xr[i], xt[i], 15), sigmoid.(LinRange(-3, 3, 15)); midstyles...)
    end
    hidedecorations!(mid)
    rowgap!(a, 10)
    return f, (axt, mid, axr), ((xt, yt), (xr, yr))
end