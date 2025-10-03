using DataFrames
using QuranTree
using Makie
using Colors
using CairoMakie
using MakieThemes
using Yunir

CairoMakie.activate!(type = "svg")
active_theme = :dust

if active_theme == :earth
    Makie.set_theme!(ggthemr(:earth))
    current_theme = Dict(
        :background => "#36312C",
        :text       => ["#555555", "#F8F8F0"],
        :line       => ["#ffffff", "#827D77"],
        :gridline   => "#504940",
        :swatch     => ["#F8F8F0", "#DB784D", "#95CC5E", "#E84646", "#F8BB39", "#7A7267", "#E1AA93", "#168E7F", "#2B338E"],
        :gradient   => ["#7A7267", "#DB784D"]
    )
elseif active_theme == :dust
    Makie.set_theme!(ggthemr(:dust))
    current_theme = Dict(
        :background => "#FAF7F2",
        :text       => ["#5b4f41", "#5b4f41"],
        :line       => ["#8d7a64", "#8d7a64"],
        :gridline   => "#E3DDCC",
        :swatch     => ["#555555", "#db735c", "#EFA86E", "#9A8A76", "#F3C57B", "#7A6752", "#2A91A2", "#87F28A", "#6EDCEF"],
        :gradient   => ["#F3C57B", "#7A6752"]
    )
else
    error("No active_theme=" * string(active_theme))
end;
colors = [parse(Color, i) for i in current_theme[:swatch]]
crps, tnzl = load(QuranData());
crps_tbl = table(crps)
tnzl_tbl = table(tnzl)

function last_syllable(bw_texts)
    bw1_texts = Array{String,1}()
    bw2_texts = Array{String,1}()
    bw3_texts = Array{String,1}()
    for bw_text in bw_texts
        @info bw_text
        push!(bw1_texts, replace(bw_text[end-3:end-2], "o" => ""))
        push!(bw2_texts, replace(bw_text[end-3:end-1], "o" => ""))
        push!(bw3_texts, replace(bw_text[end-4:end-1], "o" => ""))
    end
    return bw1_texts, bw2_texts, bw3_texts
end

function encode_to_number(ychars::Array{String})
    y = unique(ychars)
    y_dict = Dict()
    for i in eachindex(y)
        if i == 1
            y_dict[y[i]] = i
        end
        
        if y[i] .∈ Ref(Set(keys(y_dict)))
            continue
        else
            y_dict[y[i]] = i
        end
    end
    y_vec = Array{Int64,1}()
    for i in ychars
        push!(y_vec, y_dict[i])
    end
    return y_vec, y_dict # scaling to 100 since algo will fail saying range step cannot 0
end

bw_texts = verses(crps_tbl[1])
y1_chars, y2_chars, y3_chars = last_syllable(bw_texts)
y1, y1_dict = encode_to_number(y1_chars)
y2, y2_dict = encode_to_number(y2_chars)
y3, y3_dict = encode_to_number(y3_chars)

f = Figure(resolution=(800, 800));
a1 = Axis(f[1, 1], 
    ylabel="Last Pronounced Syllable\n\n\n",
    title="Surah Al-Fatihah\n\n",
    yticks=(unique(y1), unique(string.(y1_chars))),
    xticks = collect(eachindex(y1_chars))
)
# ylims!(a1, 100, maximum(y1) .+1)

a2 = Axis(f[2, 1], 
    ylabel="3 Characters\n\n\n",
    yticks=(unique(y2), unique(string.(y2_chars))),
    xticks = collect(eachindex(y2_chars))
)

a3 = Axis(f[3, 1], 
    ylabel="3-4 Characters\n\n",
    yticks=(unique(y3), unique(string.(y3_chars))),
    xticks = collect(eachindex(y3_chars))
)

lines!(a1, collect(eachindex(y1_chars)), y1)
hidexdecorations!(a1)
lines!(a2, collect(eachindex(y2_chars)), y2)
hidexdecorations!(a2)
lines!(a3, collect(eachindex(y3_chars)), y3)

f

bw_texts = verses(crps_tbl[55])
y1_chars, y2_chars, y3_chars = last_syllable(bw_texts)
y1, y1_dict = encode_to_number(y1_chars)
y2, y2_dict = encode_to_number(y2_chars)
y3, y3_dict = encode_to_number(y3_chars)

# f = Figure(resolution=(500, 500));
a1 = Axis(f[1, 2], 
    # ylabel="Last Syllable",
    title="Surah Ar-Rahman\n\n",
    yticks=(unique(y1), unique(string.(y1_chars))),
    # xticks = collect(eachindex(y1_chars))
)

a2 = Axis(f[2, 2], 
    # ylabel="2-3 Characters",
    yticks=(unique(y2), unique(string.(y2_chars))),
    # xticks = collect(eachindex(y2_chars))
)

a3 = Axis(f[3, 2], 
    # ylabel="3-4 Characters",
    # yticks=(collect(eachindex(y3_chars)), string.(y3_chars)),
    # xticks = collect(eachindex(y3_chars))
)

lines!(a1, collect(eachindex(y1_chars)), y1)
hidexdecorations!(a1)
lines!(a2, collect(eachindex(y2_chars)), y2)
hidexdecorations!(a2)
lines!(a3, collect(eachindex(y3_chars)), y3)
f

# save("plots/plot_rhythmic1.svg", f)
