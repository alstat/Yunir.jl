using Yunir

shamela0012129 = "خرج مع ابي بكر الصديق رضي الله عنه في تجارة الي بصري ومعهم نعيمان وكان نعيمان ممن شهد——- بدرا ايضا وك——-ان علي الزاد فقال له سويبط———– اطعمني فقال حتي يجء ابو بكر فقال اما والله لاغيظنك فمروا بقوم فقال لهم سويبط -تشترون مني عبدا قا—لوا نعم فقال انه عبد له كلام وهو قاءل لكم اني حر فان كنتم اذا قال لكم هذه المقالة تركتموه فلا تفسدوا علي عبدي قا-لوا بل نشتريه منك فاشتروه بعشر قلاءص ثم جاءوا فوضعوا في عنقه حبلا ف—————قال نعيمان ان هذا يستهزء بكم واني حر فقالوا قد عرفنا –خبرك وانطلقوا به فلما جاء ابو بكر -اخبروه فاتبعهم ورد عليهم القلاءص واخذه فلما قدموا علي النبي صلي الله عليه وسلم اخبروه فضحك هو واصحابه من ذلك حولا"
shamela0023790 = "خرج— ابو بكر——————– في تجارة——— ومعه- نعيمان وسويبط بن حرملة وكانا شهدا بدر—–ا وكان نعيمان علي الزاد فقال له سويبط وكان مزاحا اطعمني فقال حتي يجء ابو بكر فقال اما والله لاغيظنك فمروا بقوم فقال لهم سويبط اتشترون مني عبدا لي قالوا نعم ق-ال انه عبد له كلام وهو قاءل لكم اني حر فان كنتم اذا قال لكم هذه المقالة تركتموه فلا تفسدوا علي عبدي فقالوا بل نشتريه منك——– بعشر قلاءص ثم جاءوا فوضعوا في عنقه حبلا وعمامة واشتروه فقال نعيمان ان هذا يستهزء بكم واني حر قا-لوا قد اخبرنا بخبرك وانطلقوا به و—-جاء ابو بكر فاخبروه فاتبعهم فرد عليهم القلاءص واخذه فلما قدموا علي النبي صلي الله عليه وسلم اخبروه فضحك هو واصحابه منهما- حول"
# normalize("ٱللَّهِ")
# normalize(dediac("ٱللَّهِ")) == "الله"
# لا

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
res = align(eref, etgt);
typeof(res)

out = collect(res.alignment)
out

using CairoMakie
# reference        
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
    return xs, zs .+ nchars
end

xr, yr = generate_xys(res, :reference, :matches)
xt, yt = generate_xys(res, :target, :matches)
yr
yt

p = lines([xr[1], xt[1]], [0, 1], color=:red)
for i in 2:length(xr)
    lines!([xr[i], xt[i]], [0, 1], color=:red)
end
p

function Makie.plot(res::Alignment, type::Symbol=:matches)
    if type === :matches
        xr, yr = generate_xys(res)
        xt, yt = generate_xys(res, :target)
    elseif type === :insertions
        xr, yr = generate_xys(res, :reference, :insertions)
        xt, yt = generate_xys(res, :target, :insertions)
    elseif type === :deletions
        xr, yr = generate_xys(res, :reference, :deletions)
        xt, yt = generate_xys(res, :target, :deletions)
    elseif type === :mismatches
        xr, yr = generate_xys(res, :reference, :mismatches)
        xt, yt = generate_xys(res, :target, :mismatches)
    else
        throw("type takes :matches, :insertions, :deletions and :mismatches only.")
    end
    f = Figure()
    a = f[1,1] = GridLayout()
    axt = Axis(a[1,1], xaxisposition=:top)
    axr = Axis(a[2,1])
    axt.yticks = 60:-20:0
    axr.yticks = 60:-20:0
    axt.ylabel = "Target"
    axr.ylabel = "Reference"
    ylims!(axt, low=-2, high=62)
    ylims!(axr, low=-2, high=62)
    linkxaxes!(axt, axr)
    linkyaxes!(axt, axr)
    plot!(axr, xr, yr)
    plot!(axt, xt, yt)
    return f, (axt, axr) 
end
etgt = shamela0023790_enc
eref = shamela0012129_enc

f, a = plot(res, :insertions)
a[1].xlabel = "Shamela0023790"
a[1].xlabelsize = 20
a[2].xlabel = "Shamela0012129"
a[2].xlabelsize = 20
f
a
a[]
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

etgt = encode.(expand_archars.(normalize.(dediac.(target))));
etgt = string.(strip.(replace.(etgt, r"\s+" => " ")));
etgt
eref = encode.(expand_archars.(normalize.(dediac.(reference))));
eref = string.(strip.(replace.(eref, r"\s+" => " ")));

@time res, scr = align(eref, etgt);