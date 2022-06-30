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
function generate_xys(res::Alignment, text::Symbol=:reference, nchars::Int64=60)
    xs, ys, zs = Int[], [1], Float32[]
    j = 1; k = 1;
    if text === :reference
        out = filter(x -> x[2] != '-', collect(res))
    elseif text === :target
        out = filter(x -> x[1] != '-', collect(res))
    else
        throw("text only takes :reference or :target as input.")
    end
    for i in out
        if j % nchars == 0
            k += 1
            ys = [1]
        else
            if i[2] == i[1]
                push!(xs, k)
                push!(ys, ys[end] - 1)
                push!(zs, ys[end] - 1)
            else
                push!(ys, ys[end] - 1)
            end
        end
        j += 1
    end
    return xs, zs .+ nchars
end

xr, yr = generate_xys(res)
xt, yt = generate_xys(res, :target)

pr = plot(xr, yr)
pt = plot(xt, yt)

plot(pr, pt)

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