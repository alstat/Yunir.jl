# function clean(s::Union{Char,String}, encoder::AbstractEncoder, replace_non_ar::String)
#     words = ""
#     for c in s
#         if c === ' '
#             words *= " "
#         else
#             if c === '\U0622'
#                 words *= string(encoder.encode[Symbol('\U0627')], encoder.encode[Symbol('\U0653')])
#             else
#                 try
#                     string(encoder.encode[Symbol(c)])
#                     words *= c
#                 catch
#                     words *= replace_non_ar
#                 end
#             end
#         end
#     end
#     return words
# end

"""
    clean(s::String, replace_non_ar::String, target_regex::Regex)

Clean the input text by replacing all non-Arabic texts with a string input.
"""
function clean(s::Union{String,SubString{String}}, replace_non_ar::String="", target_regex::Regex = r"[A-Za-z0-9\(:×\|\–\[\«\»\]~\)_@./#&+\—-]*")
    return replace(s, target_regex => replace_non_ar)
end

function expand_archars(s::String)
    s = replace(s, "الله" => "ا ل ل ه")
    s = replace(s, "لا" => "ل ا")
    return s
	# out = []
	# for x in split(s, " ")
	# 	if occursin("الله", x) || occursin("لا", x)
	# 		try
	# 			push!(out, join(split(x, ""), " "))
	# 		catch
	# 			push!(out, x)
	# 		end
	# 	else
	# 		push!(out, x)
	# 	end
	# end
	# return join(out, " ")
end