"""

    CAMeLData(data::Symbol)

Instantiate CAMeLData by specifying the type of `data`, choices are `:morphology`, `:morphology_egy`,
`morphology_msa`, `morphology_glf`, `disambiguation`, `disambiguation_mle_egy`, `disambiguation_mle_msa`,
`disambiguation_bert_egy`, `disambiguation_bert_glf`, `disambiguation_bert_msa`, `sentiment`, `sentiment_mbert`,
`sentiment_arabert`, `ner`, and `diaclectid`
"""
struct CAMeLData
    data::Symbol
end

function Base.download(camel::CAMeLData)
    check_db()
    if camel.data == :morphology
        camel_morphology()
    elseif camel.data == :morphology_egy
        camel_morphology(:egy)
    elseif camel.data == :morphology_msa
        camel_morphology(:msa)
    elseif camel.data == :morphology_glf
        camel_morphology(:glf)
    elseif camel.data == :disambiguation
        camel_disambiguation()
    elseif camel.data == :disambiguation_mle_egy
        camel_disambiguation(:mle_egy)
    elseif camel.data == :disambiguation_mle_msa
        camel_disambiguation(:mle_msa)
    elseif camel.data == :disambiguation_bert_egy
        camel_disambiguation(:bert_egy)
    elseif camel.data == :disambiguation_bert_msa
        camel_disambiguation(:bert_msa)
    elseif camel.data == :disambiguation_bert_glf
        camel_disambiguation(:bert_glf)
    elseif camel.data == :sentiment
        camel_sentiment()
    elseif camel.data == :sentiment_mbert
        camel_sentiment(:mbert)
    elseif camel.data == :sentiment_arabert
        camel_sentiment(:arabert)
    elseif camel.data == :ner
        camel_ner()
    elseif camel.data == :dialectid
        camel_dialectidentification()
    elseif camel.data == :all
        @info "Downloading all data."
        camel_morphology()
        camel_disambiguation()
        camel_sentiment()
        camel_ner()
        camel_dialectid()
    else
        throw("data=:" * string(camel.data) * " is not supported. See docs for available choices for data.")
    end
end

function check_files(folder::String, message::String)
    files = readdir(folder)
    if length(files) > 0
        @info message
    else 
        @info message
    end
end

function camel_morphology(type::Symbol=:all)
    catalogue = JSON.parsefile(Yunir.CAMEL_CATALOGUE);
    if type == :all
        files = readdir(Yunir.CAMEL_MORPHOLOGY_EGY)
        if length(files) > 0
            @info "morphology/egy DB is already available, no need to download. Run delete!(CAMeLData(:morphology_egy)) to delete current db."
        else
            HTTP.download(catalogue["packages"]["morphology-db-egy-r13"]["url"], Yunir.CAMEL_MORPHOLOGY_EGY_R13)
            unzip(Yunir.CAMEL_MORPHOLOGY_EGY_R13)
        end

        files = readdir(Yunir.CAMEL_MORPHOLOGY_MSA)
        if length(files) > 0
            @info "morphology/msa DB is already available, no need to download. Run delete!(CAMeLData(:morphology_msa)) to delete current db."
        else
            HTTP.download(catalogue["packages"]["morphology-db-msa-r13"]["url"], Yunir.CAMEL_MORPHOLOGY_MSA_R13)
            unzip(Yunir.CAMEL_MORPHOLOGY_MSA_R13)
        end
        
        files = readdir(Yunir.CAMEL_MORPHOLOGY_GLF)
        if length(files) > 0
            @info "morphology/glf DB is already available, no need to download. Run delete!(CAMeLData(:morphology_glf)) to delete current db."
        else
            HTTP.download(catalogue["packages"]["morphology-db-glf-01"]["url"], Yunir.CAMEL_MORPHOLOGY_GLF_01)
            unzip(Yunir.CAMEL_MORPHOLOGY_GLF_01)
        end
    elseif type == :egy
        files = readdir(Yunir.CAMEL_MORPHOLOGY_EGY)
        if length(files) > 0
            @info "morphology/egy DB is already available, no need to download. Run delete!(CAMeLData(:morphology_egy)) to delete current db."
        else
            HTTP.download(catalogue["packages"]["morphology-db-egy-r13"]["url"], Yunir.CAMEL_MORPHOLOGY_EGY_R13)
            unzip(Yunir.CAMEL_MORPHOLOGY_EGY_R13)
        end
    elseif type == :msa
        files = readdir(Yunir.CAMEL_MORPHOLOGY_MSA)
        if length(files) > 0
            @info "morphology/msa DB is already available, no need to download. Run delete!(CAMeLData(:morphology_msa)) to delete current db."
        else
            HTTP.download(catalogue["packages"]["morphology-db-msa-r13"]["url"], Yunir.CAMEL_MORPHOLOGY_MSA_R13)
            unzip(Yunir.CAMEL_MORPHOLOGY_MSA_R13)
        end
    elseif type == :glf
        files = readdir(Yunir.CAMEL_MORPHOLOGY_GLF)
        if length(files) > 0
            @info "morphology/glf DB is already available, no need to download. Run delete!(CAMeLData(:morphology_glf)) to delete current db."
        else
            HTTP.download(catalogue["packages"]["morphology-db-glf-01"]["url"], Yunir.CAMEL_MORPHOLOGY_GLF_01)
            unzip(Yunir.CAMEL_MORPHOLOGY_GLF_01)
        end
    else
        throw("type=:" * string(type) * ", unknown type. Choices are :egy, :msa, :glf and :all.")
    end
end

function camel_disambiguation(type::Symbol=:all)
    catalogue = JSON.parsefile(Yunir.CAMEL_CATALOGUE);
    if type == :all
        files = readdir(Yunir.CAMEL_DISAMBIGUATION_MLE_EGY)
        if length(files) > 0
            @info "disambiguation/mle/egy DB is already available, no need to download. Run delete!(CAMeLData(:disambiguation_mle_egy)) to delete current db."
        else
            HTTP.download(catalogue["packages"]["disambig-mle-calima-egy-r13"]["url"], Yunir.CAMEL_DISAMBIG_MLE_CALIMA_EGY_R13)
            unzip(Yunir.CAMEL_DISAMBIG_MLE_CALIMA_EGY_R13)
        end

        files = readdir(Yunir.CAMEL_DISAMBIGUATION_MLE_MSA)
        if length(files) > 0
            @info "disambiguation/mle/msa DB is already available, no need to download. Run delete!(CAMeLData(:disambiguation_mle_msa)) to delete current db."
        else
            HTTP.download(catalogue["packages"]["disambig-mle-calima-msa-r13"]["url"], Yunir.CAMEL_DISAMBIG_MLE_CALIMA_MSA_R13)
            unzip(Yunir.CAMEL_DISAMBIG_MLE_CALIMA_MSA_R13)
        end

        files = readdir(Yunir.CAMEL_DISAMBIGUATION_BERT_EGY)
        if length(files) > 0
            @info "disambiguation/bert/egy DB is already available, no need to download. Run delete!(CAMeLData(:disambiguation_bert_egy)) to delete current db."
        else
            HTTP.download(catalogue["packages"]["disambig-bert-unfactored-egy"]["url"], Yunir.CAMEL_DISAMBIG_BERT_UNFACTORED_EGY)
            unzip(Yunir.CAMEL_DISAMBIG_BERT_UNFACTORED_EGY)
        end

        files = readdir(Yunir.CAMEL_DISAMBIGUATION_BERT_MSA)
        if length(files) > 0
            @info "disambiguation/bert/msa DB is already available, no need to download. Run delete!(CAMeLData(:disambiguation_bert_msa)) to delete current db."
        else
            HTTP.download(catalogue["packages"]["disambig-bert-unfactored-msa"]["url"], Yunir.CAMEL_DISAMBIG_BERT_UNFACTORED_MSA)
            unzip(Yunir.CAMEL_DISAMBIG_BERT_UNFACTORED_MSA)
        end

        files = readdir(Yunir.CAMEL_DISAMBIGUATION_BERT_GLF)
        if length(files) > 0
            @info "disambiguation/bert/glf DB is already available, no need to download. Run delete!(CAMeLData(:disambiguation_bert_glf)) to delete current db."
        else
            HTTP.download(catalogue["packages"]["disambig-bert-unfactored-glf"]["url"], Yunir.CAMEL_DISAMBIG_BERT_UNFACTORED_GLF)
            unzip(Yunir.CAMEL_DISAMBIG_BERT_UNFACTORED_GLF)
        end
    elseif type == :mle_egy
        files = readdir(Yunir.CAMEL_DISAMBIGUATION_MLE_EGY)
        if length(files) > 0
            @info "disambiguation/mle/egy DB is already available, no need to download. Run delete!(CAMeLData(:disambiguation_mle_egy)) to delete current db."
        else
            HTTP.download(catalogue["packages"]["disambig-mle-calima-egy-r13"]["url"], Yunir.CAMEL_DISAMBIG_MLE_CALIMA_EGY_R13)
            unzip(Yunir.CAMEL_DISAMBIG_MLE_CALIMA_EGY_R13)
        end
    elseif type == :mle_msa
        files = readdir(Yunir.CAMEL_DISAMBIGUATION_MLE_MSA)
        if length(files) > 0
            @info "disambiguation/mle/msa DB is already available, no need to download. Run delete!(CAMeLData(:disambiguation_mle_msa)) to delete current db."
        else
            HTTP.download(catalogue["packages"]["disambig-mle-calima-msa-r13"]["url"], Yunir.CAMEL_DISAMBIG_MLE_CALIMA_MSA_R13)
            unzip(Yunir.CAMEL_DISAMBIG_MLE_CALIMA_MSA_R13)
        end
    elseif type == :bert_egy
        files = readdir(Yunir.CAMEL_DISAMBIGUATION_BERT_EGY)
        if length(files) > 0
            @info "disambiguation/bert/egy DB is already available, no need to download. Run delete!(CAMeLData(:disambiguation_bert_egy)) to delete current db."
        else
            HTTP.download(catalogue["packages"]["disambig-bert-unfactored-egy"]["url"], Yunir.CAMEL_DISAMBIG_BERT_UNFACTORED_EGY)
            unzip(Yunir.CAMEL_DISAMBIG_BERT_UNFACTORED_EGY)
        end
    elseif type == :bert_msa
        files = readdir(Yunir.CAMEL_DISAMBIGUATION_BERT_MSA)
        if length(files) > 0
            @info "disambiguation/bert/msa DB is already available, no need to download. Run delete!(CAMeLData(:disambiguation_bert_msa)) to delete current db."
        else
            HTTP.download(catalogue["packages"]["disambig-bert-unfactored-msa"]["url"], Yunir.CAMEL_DISAMBIG_BERT_UNFACTORED_MSA)
            unzip(Yunir.CAMEL_DISAMBIG_BERT_UNFACTORED_MSA)
        end
    elseif type == :bert_glf
        files = readdir(Yunir.CAMEL_DISAMBIGUATION_BERT_GLF)
        if length(files) > 0
            @info "disambiguation/bert/glf DB is already available, no need to download. Run delete!(CAMeLData(:disambiguation_bert_glf)) to delete current db."
        else
            HTTP.download(catalogue["packages"]["disambig-bert-unfactored-glf"]["url"], Yunir.CAMEL_DISAMBIG_BERT_UNFACTORED_GLF)
            unzip(Yunir.CAMEL_DISAMBIG_BERT_UNFACTORED_GLF)
        end
    else
        throw("type=:" * string(type) * ", unknown type. Choices are :mle_egy, :mle_msa, :bert_egy, :bert_msa, :bert_glf and :all.")
    end
end

function camel_ner()
    files = readdir(Yunir.CAMEL_NER)
    if length(files) > 0
        @info "ner DB is already available, no need to download. Run delete!(CAMeLData(:ner)) to delete current NER DB."
    else
        catalogue = JSON.parsefile(Yunir.CAMEL_CATALOGUE);
        HTTP.download(catalogue["packages"]["ner-arabert"]["url"], Yunir.CAMEL_NER_ARABERT)
        unzip(Yunir.CAMEL_NER_ARABERT)
    end
end

function camel_dialectidentification()
    files = readdir(Yunir.CAMEL_DIALECTID)
    if length(files) > 0
        @info "dialectid DB is already available, no need to download. Run delete!(CAMeLData(:dialectid)) to delete current Dialect Identification DB."
    else
        catalogue = JSON.parsefile(Yunir.CAMEL_CATALOGUE);
        HTTP.download(catalogue["packages"]["dialectid-default"]["url"], Yunir.CAMEL_DIALECTID_DEFAULT)
        unzip(Yunir.CAMEL_DIALECTID_DEFAULT)
    end
end

function camel_sentiment(type::Symbol=:all)
    catalogue = JSON.parsefile(Yunir.CAMEL_CATALOGUE);
    if type == :all
        files = readdir(Yunir.CAMEL_SENTIMENT_MBERT)
        if length(files) > 0
            @info "sentiment/mbert DB is already available, no need to download. Run delete!(CAMeLData(:sentiment_mbert)) to delete current db."
        else
            HTTP.download(catalogue["packages"]["sentiment-analysis-mbert"]["url"], Yunir.CAMEL_SENTIMENT_ANALYSIS_MBERT)
            unzip(Yunir.CAMEL_SENTIMENT_ANALYSIS_MBERT)
        end

        files = readdir(Yunir.CAMEL_SENTIMENT_ARABERT)
        if length(files) > 0
            @info "sentiment/arabert is already available, no need to download. Run delete!(CAMeLData(:sentiment_arabert)) to delete current db."
        else
            HTTP.download(catalogue["packages"]["sentiment-analysis-arabert"]["url"], Yunir.CAMEL_SENTIMENT_ANALYSIS_ARABERT)    
            unzip(Yunir.CAMEL_SENTIMENT_ANALYSIS_ARABERT)
        end
    elseif type == :mbert
        files = readdir(Yunir.CAMEL_SENTIMENT_MBERT)
        if length(files) > 0
            @info "sentiment/mbert is already available, no need to download. Run delete!(CAMeLData(:sentiment_mbert)) to delete current db."
        else
            HTTP.download(catalogue["packages"]["sentiment-analysis-mbert"]["url"], Yunir.CAMEL_SENTIMENT_ANALYSIS_MBERT)
            unzip(Yunir.CAMEL_SENTIMENT_ANALYSIS_MBERT)
        end
    elseif type == :arabert
        files = readdir(Yunir.CAMEL_SENTIMENT_ARABERT)
        if length(files) > 0
            @info "sentiment/arabert is already available, no need to download. Run delete!(CAMeLData(:sentiment_arabert)) to delete current db."
        else
            HTTP.download(catalogue["packages"]["sentiment-analysis-arabert"]["url"], Yunir.CAMEL_SENTIMENT_ANALYSIS_ARABERT)    
            unzip(Yunir.CAMEL_SENTIMENT_ANALYSIS_ARABERT)
        end
    else
        throw("type=:" * string(type) * ", unknown type. Choices are :mbert, :arabert and :all.")
    end
end

function create_db()
    @info "Creating db folder"
    mkdir(Yunir.CAMEL_DATA)
    mkdir(Yunir.CAMEL_MORPHOLOGY)
    mkdir(Yunir.CAMEL_MORPHOLOGY_EGY)
    mkdir(Yunir.CAMEL_MORPHOLOGY_MSA)
    mkdir(Yunir.CAMEL_MORPHOLOGY_GLF)
    mkdir(Yunir.CAMEL_DISAMBIGUATION)
    mkdir(Yunir.CAMEL_DISAMBIGUATION_MLE)
    mkdir(Yunir.CAMEL_DISAMBIGUATION_MLE_EGY)
    mkdir(Yunir.CAMEL_DISAMBIGUATION_MLE_MSA)
    mkdir(Yunir.CAMEL_DISAMBIGUATION_BERT)
    mkdir(Yunir.CAMEL_DISAMBIGUATION_BERT_EGY)
    mkdir(Yunir.CAMEL_DISAMBIGUATION_BERT_MSA)
    mkdir(Yunir.CAMEL_DISAMBIGUATION_BERT_GLF)
    mkdir(Yunir.CAMEL_DIALECTID)
    mkdir(Yunir.CAMEL_NER)
    mkdir(Yunir.CAMEL_SENTIMENT)
    mkdir(Yunir.CAMEL_SENTIMENT_MBERT)
    mkdir(Yunir.CAMEL_SENTIMENT_ARABERT)
end

function check_db()
    try
        readdir(joinpath(@__DIR__, "../../db"))
    catch
        create_db()
    end
    HTTP.download(Yunir.CATALOGUE_URL, Yunir.CAMEL_CATALOGUE, update_period=5)
end

function Base.delete!(camel::CAMeLData)
    try
        if camel.data == :all
            rm(Yunir.CAMEL_DATA, recursive=true)
            @info "Successfully deleted db folder"
        elseif camel.data == :morphology
            delete_all_files!(Yunir.CAMEL_MORPHOLOGY_EGY)
            delete_all_files!(Yunir.CAMEL_MORPHOLOGY_MSA)
            delete_all_files!(Yunir.CAMEL_MORPHOLOGY_GLF)
            @info "Successfully deleted files under the egy, msa and glf of morphology folder."
        elseif camel.data == :morphology_egy
            delete_all_files!(Yunir.CAMEL_MORPHOLOGY_EGY)
            @info "Successfully deleted files under the morphology/egy folder."
        elseif camel.data == :morphology_msa
            delete_all_files!(Yunir.CAMEL_MORPHOLOGY_MSA)
            @info "Successfully deleted files under the morphology/msa folder."
        elseif camel.data == :morphology_glf
            delete_all_files!(Yunir.CAMEL_MORPHOLOGY_GLF)
            @info "Successfully deleted files under the morphology/glf folder."
        elseif camel.data == :disambiguation
            delete_all_files!(Yunir.CAMEL_DISAMBIGUATION_MLE_EGY)
            delete_all_files!(Yunir.CAMEL_DISAMBIGUATION_MLE_MSA)
            delete_all_files!(Yunir.CAMEL_DISAMBIGUATION_BERT_EGY)
            delete_all_files!(Yunir.CAMEL_DISAMBIGUATION_BERT_MSA)
            delete_all_files!(Yunir.CAMEL_DISAMBIGUATION_BERT_GLF)
            @info "Successfully deleted files under the mle/egy, mle/msa, bert/egy, bert/msa, and bert/glf of disambiguation folder."
        elseif camel.data == :disambiguation_mle_egy
            delete_all_files!(Yunir.CAMEL_DISAMBIGUATION_MLE_EGY)
            @info "Successfully deleted files under the disambiguation/mle/egy folder."
        elseif camel.data == :disambiguation_mle_msa
            delete_all_files!(Yunir.CAMEL_DISAMBIGUATION_MLE_MSA)
            @info "Successfully deleted files under the disambiguation/mle/msa folder."
        elseif camel.data == :disambiguation_bert_egy
            delete_all_files!(Yunir.CAMEL_DISAMBIGUATION_BERT_EGY)
            @info "Successfully deleted files under the disambiguation/bert/egy folder."
        elseif camel.data == :disambiguation_bert_msa
            delete_all_files!(Yunir.CAMEL_DISAMBIGUATION_BERT_MSA)
            @info "Successfully deleted files under the disambiguation/bert/msa folder."
        elseif camel.data == :disambiguation_bert_glf
            delete_all_files!(Yunir.CAMEL_DISAMBIGUATION_BERT_GLF)
            @info "Successfully deleted files under the disambiguation/bert/glf folder."
        elseif camel.data == :ner
            delete_all_files!(Yunir.CAMEL_NER)
            @info "Successfully deleted files under the ner folder."
        elseif camel.data == :sentiment
            delete_all_files!(Yunir.CAMEL_SENTIMENT_MBERT)
            delete_all_files!(Yunir.CAMEL_SENTIMENT_ARABERT)
            @info "Successfully deleted files under the sentiment/mbert and sentiment/arabert folder."
        elseif camel.data == :sentiment_mbert
            delete_all_files!(Yunir.CAMEL_SENTIMENT_MBERT)
            @info "Successfully deleted files under the sentiment/mbert folder."
        elseif camel.data == :sentiment_arabert
            delete_all_files!(Yunir.CAMEL_SENTIMENT_ARABERT)
            @info "Successfully deleted files under the sentiment/arabert folder."
        elseif camel.data == :dialectid
            delete_all_files!(Yunir.CAMEL_DIALECTID)
            @info "Successfully deleted files under the dialectid folder."
        else
            throw("Unknown value CAMeLData(:" * string(camel.data) * "), choices for x in CAMeLData(x) are :all, :morphology, :disambiguation, :ner, :sentiment, :diaclectid.")
        end
    catch
        throw("No db folder yet, run download(CAMeLData(:" * string(camel.data) * ")) to create the folder.")
    end
end

function delete_all_files!(path::String)
    all_files = readdir(path)
    for i in all_files
        rm(joinpath(path, i), recursive=true)
    end
end

#######
# function find_gcode(ckj)
#     for cookie ∈ ckj
#         if match(r"_warning_", cookie.name) !== nothing
#             return cookie.value
#         end
#     end
#     nothing
# end

# function check_data(camel::CAMeLData)
#     try
#         data_list = readdir(CAMEL_DATA)
#         if camel.type === :light
#             if length(data_list) > 2
#                 @info "Full CAMeLData already downloaded. To override, run delete!(CAMeLData) and then download again."
#                 return true
#             else
#                 @info "Light CAMeLData already downloaded. To override, run delete!(CAMeLData) and then download again."
#                 return true
#             end
#         elseif camel.type === :full
#             if length(data_list) < 3
#                 @info "Overriding light CAMeLData already downloaded, to download the full CAMeLData."
#                 return false
#             else 
#                 return true
#             end
#         else
#             error(string("Expecting :light or :full for CAMeLData, got ", camel.type, " instead."))
#         end
#     catch
#         return false
#     end
# end

# function Base.download(camel::CAMeLData, update_period::Int64=5)
#     isdata = check_data(camel)

#     if isdata
#         return nothing
#     else
#         @info "downloading catalogue from camel_tools"
#         HTTP.download(CATALOGUE, CAMEL_CATALOGUE, update_period=5);
#         catalogue = JSON.parsefile(CAMEL_CATALOGUE);
#         if camel.type === :light
#             data = catalogue["downloads"]["light"]
#         else
#             data = catalogue["downloads"]["full"]
#         end

#         url = string(GOOGLE_DRIVE, "&id=", data["file_id"])
#         filepath = joinpath(@__DIR__, "../..", "data.zip")
        
#         @info "downloading camel data"
#         downloaded_bytes = 0
#         default_ckjar = HTTP.CookieRequest.default_cookiejar
#         ckjar = copy(default_ckjar isa Array ? default_ckjar[Base.Threads.threadid()] : default_ckjar)
#         HTTP.open("GET", url; cookies=true, cookiejar=ckjar) do stream
#             ckj = ckjar["docs.google.com"]
#             code = find_gcode(ckj)
#             if code !== nothing
#                 url = string(GOOGLE_DRIVE, "&confirm=", code, "&id=", data["file_id"])
#                 HTTP.request("GET", url, response_stream=stream, update_period=5)
#                 Base.open(filepath, "w") do file
#                     while(!eof(steam))
#                         write(file, readavailable(stream))
#                     end
#                 end
#             else
#                 HTTP.download(url, filepath, response_stream=stream, update_period=5)
#             end
#         end

#         @info "unzipping downloaded data"
#         unzip(filepath, joinpath(@__DIR__, "../.."))
#     end
# end

# function Base.download(camel::CAMeLData, path::Union{String,Nothing}=nothing)
#     @info "downloading catalogue from camel_tools"
#     ENV["CAMEL_CATALOGUE"] = joinpath(@__DIR__, "../catalogue.json")
#     HTTP.download(CATALOGUE, ENV["CAMEL_CATALOGUE"], update_period=5);
#     catalogue = JSON.parsefile(ENV["CAMEL_CATALOGUE"]);
#     if camel.type === :light
#         data = catalogue["downloads"]["light"]
#         url = string(GOOGLE_DRIVE, "&id=", data["file_id"])
#     else
#         data = catalogue["downloads"]["full"]
#         url = string(GOOGLE_DRIVE, "&id=", data["file_id"])
#     end

#     if path isa Nothing
#         ENV["CAMEL_DATA"] = joinpath(@__DIR__, "../..", "data")
#         filepath = joinpath(@__DIR__, "../..", "data.zip")
#     else
#         ENV["CAMEL_DATA"] = joinpath(path, "data")
#         filepath = joinpath(path, "data.zip")
#     end
#     @info "downloading camel data"
#     HTTP.download(url, filepath, update_period=5)
    
#     @info "unzipping downloaded data"
#     if path isa Nothing
#         unzip(filepath, joinpath(@__DIR__, "../.."))
#     else
#         unzip(filepath, path)
#     end
# end

# function Base.delete!(::Type{CAMeLData})
#     try
#         rm(CAMEL_DATA, recursive=true)
#         @info string("successfully deleted data at ", CAMEL_DATA)
#     catch
#         @info "no camel data yet"
#     end

#     try 
#         rm(CAMEL_CATALOGUE)
#         @info string("successfully deleted catalogue at ", CAMEL_CATALOGUE)
#     catch
#         @info "no camel catalogue yet"
#     end
# end

# function locate(::Type{CAMeLData})
#     return CAMEL_DATA
# end

# function install_camel(full_data::Bool=false)
#     if full_data
#         @info "installing camel-tools"
#         run(`pip3 install camel-tools`)
#         @info "downloading camel_data"
#         run(`camel_data full`)
#     else
#         @info "installing camel-tools"
#         run(`pip3 install camel-tools`)
#         @info "downloading camel_data"
#         run(`camel_data light`)
#     end
# end

# function install_camel(full_data::Bool=false, data_directory::Union{Nothing,String}=nothing)
#     if full_data
#         @info "installing camel-tools"
#         run(`pip3 install camel-tools`)
#         if data_directory isa Nothing
#             @info "downloading camel_data"
#             run(`camel_data full`)
#         else
#             @info "downloading camel_data to " * data_directory
#             ENV["CAMELTOOLS_DATA"] = data_directory
#             run(`sh -c export '|' camel_data full`)
#             # run(`camel_data full`)
#         end
#     else
#         @info "installing camel-tools"
#         run(`pip3 install camel-tools`)
#         if data_directory isa Nothing
#             @info "downloading camel_data"
#             run(`camel_data light`)
#         else
#             @info "downloading camel_data to " * data_directory
#             ENV["CAMELTOOLS_DATA"] = data_directory
#             run(`sh -c export '|' camel_data light`)
#             # run(`camel_data light`)
#         end
#     end
# end