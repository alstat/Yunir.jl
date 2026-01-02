# test
using Yunir
using CairoMakie

###
tajweed_timings = Dict{Bw,RState}(
    Bw("i") => RState(1, "short"),
    Bw("a") => RState(1, "short"),
    Bw("u") => RState(1, "short"),
    Bw("F") => RState(1, "short"),
    Bw("N") => RState(1, "short"),
    Bw("K") => RState(1, "short"),
    Bw("iy") => RState(2, "long"),
    Bw("aA") => RState(2, "long"),
    Bw("uw") => RState(2, "long"),
    Bw("a`") => RState(2, "long"),
    Bw("^") => RState(4, "maddah")
)

schillinger = Schillinger(tajweed_timings)

bw_texts = [
    Bw("bisomi {ll~ahi {lr~aHoma`ni {lr~aHiymi"),
    Bw("{loHamodu lil~ahi rab~i {loEa`lamiyna"),
    Bw("{lr~aHoma`ni {lr~aHiymi"),
    Bw("ma`liki yawomi {ld~iyni"),
    Bw("<iy~aAka naEobudu wa<iy~aAka nasotaEiynu"),
    Bw("{hodinaA {lS~ira`Ta {lomusotaqiyma"),
    Bw("Sira`Ta {l~a*iyna >anoEamota Ealayohimo gayori {lomagoDuwbi Ealayohimo walaA {lD~aA^l~iyna")
]

states = rhythmic_states(schillinger, bw_texts[4:4])
@test length(states) == 7

# Verify all verses produced rhythmic states
@test all(s -> length(s) > 0, states)

# Create visualization
fig = vis(states, Figure(size=(900, 900)), "Al-Fatihah Rhythmic Analysis", "Time", "Verse")
@test fig isa Makie.Figure