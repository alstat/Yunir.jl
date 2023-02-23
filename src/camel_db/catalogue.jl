struct CAMeLData end

@enum PackageType _META=0 _HTTP=1
"""
Data class containing information about a given file.

`path` is the relative path of file in the package directory. `sha256` is the SHA256 hash of this file.
"""
struct FileEntry 
    path::String
    sha256::String
end

struct PackageEntry
    name::String
    description::String
    version::Union{Nothing,String}
    license::Union{Nothing,String}
    package_type::PackageType
    url::Union{Nothing,String}
    destination::Union{Nothing,String}
    dependencies::Union{Nothing,Set{String}}
    files::Union{Nothing,Vector{FileEntry}}
    private::Bool
    sha256::Union{Nothing,String}
    size::Union{Nothing,Int64}
    post_install::Union{Nothing,Dict}
end

"""
Data class containing information about an individual dataset.

`name` is the name of this dataset. `component` is the name of the component of this dataset belongs to. `path` is the relative path of this dataset in the data directory.
"""
struct DatasetEntry
    name::String
    component::String
    path::String
end

"""
Data class that contains dataset information for a given component.

`name` is the name of the component. `default` is the default dataset name for this component. `dataset` is the mapping of dataset names to their respective entries.
"""
struct ComponentEntry
    name::String
    default::String
    datasets::Dict{String,DatasetEntry}
end

function download_catalogue()
    try    
        mkdir(DATABASE_DIR)
    catch end

    if in.(split(CATALOGUE_URL, "/")[end], Ref(Set(readdir(DATABASE_DIR))))
        @info "Skipping download since the file is already available"
    else
        HTTP.download(CATALOGUE_URL, joinpath(DATABASE_DIR, split(CATALOGUE_URL, "/")[end]))
    end
end

function Base.get(::Type{CAMeLData}, type::Symbol)
    if type == :catalogue
        download_catalogue()
    end
end

function Base.delete!(::Type{CAMeLData}, type::Symbol)
    try
        if type == :catalogue
            rm(joinpath(DATABASE_DIR, split(CATALOGUE_URL, "/")[end]), recursive=true)
            @info "CAMeL Catalogue Data successfully deleted."
        elseif type == :all
            rm(joinpath(DATABASE_DIR), recursive=true)
            @info "CAMeL database successfully deleted."
        end
    catch
        @info "Skipping deletion of CAMeL Catalogue Data since it is not available in the first place."
    end
end

mutable struct Catalogue 
    version::String
    packages::Dict{String,PackageEntry}
    components::Dict{String,ComponentEntry}
end

struct CatalogueError <: Exception
    message::String
end

function load_catalogue(path::Union{Nothing,String}=nothing)::Catalogue
    if path isa Nothing
        path = joinpath(DATABASE_DIR, split(CATALOGUE_URL, "/")[end])
    end

    # check if catalogue is there
    if !in.(split(CATALOGUE_URL, "/")[end], Ref(Set(readdir(DATABASE_DIR))))
        get(CAMeLData, :catalogue)
    end
    
    catalogue_json = JSON.parsefile(joinpath(DATABASE_DIR, split(CATALOGUE_URL, "/")[end]))
    version = catalogue_json["version"]
    packages = Dict()
    components = Dict()

    for (pkg_name, pkg_json) in catalogue_json["packages"]
        if get(pkg_json, "files", nothing) isa Nothing
            files = nothing
        else
            files = []
            for file_json in pkg_json["files"]
                push!(files, FileEntry(file_json["path"], file_json["sha256"]))
            end
        end

        destination = get(pkg_json, "destination", nothing)
        if !isa(destination, Nothing)
            destination = joinpath(DATABASE_DIR, destination)
        end 

        pkg_entry = PackageEntry(
            pkg_name,
            get(pkg_json, "description", ""),
            get(pkg_json, "version", nothing),
            get(pkg_json, "license", nothing),            
            PackageType[eval(Symbol("_" * uppercase(pkg_json["package_type"])))][1],
            get(pkg_json, "url", nothing),
            destination,
            Set(get(pkg_json, "dependencies", [])),
            files,
            pkg_json["private"],
            get(pkg_json, "sha256", nothing),
            get(pkg_json, "size", nothing),
            get(pkg_json, "post_install", nothing)
        )
        packages[pkg_name] = pkg_entry
    end

    for (cmp_name, cmp) in catalogue_json["components"]
        default = cmp["default"]
        datasets = Dict()

        for (ds_name, ds) in cmp["datasets"]
            ds_path = joinpath(DATABASE_DIR, ds["path"])
            try
                mkdir(ds_path)
            catch end
            datasets[ds_name] = DatasetEntry(ds_name, cmp_name, ds_path)
        end

        components[cmp_name] = ComponentEntry(cmp_name, default, datasets)
    end

    return Catalogue(version, packages, components)
end

function load(::Type{Catalogue}, path=nothing)
    load_catalogue(path)
end

function get_package(catalogue::Catalogue, package::String)::PackageEntry
    """Get a package entry for a given package name.
    Arguments:
        package (:obj:`str`): Name of package to query.
    Returns:
        :obj:`~camel_tools.data.ComponentEntry`: Entry associated with
        given package name.
    Raises:
        :obj:`~camel_tools.data.CatalogueError`: When `package` is not
            a valid package name.
    """
    if in.(package, Ref(Set(keys(catalogue.packages))))
        return catalogue.packages[package]
    else
        throw(CatalogueError("Invalid package name $(repr(package))."))
    end
end

function get_component(catalogue::Catalogue, component::String)::ComponentEntry
    """Get component entry for a given component name.
    Arguments:
        component (:obj:`str`): Name of component to query.
    Returns:
        :obj:`~camel_tools.data.PackageEntry`: Entry associated with given
        component name.
    Raises:
        :obj:`~camel_tools.data.CatalogueError`: When `component` is not
            a valid component name.
    """
    if in.(component, Ref(Set(keys(catalogue.components))))
        return catalogue.components[component]
    else
        throw(CatalogueError("Invalid component name $(repr(component))."))
    end
end

function get_datasets(catalogue::Catalogue, dataset::String)::DatasetEntry
    """Get dataset entry for a given component name and dataset name.
    Arguments:
        component (:obj:`str`): Name of component.
        dataset (:obj:`str`, Optional): Name of dataset for given component
            to query. If set to `None` then the entry for the default
            dataset will be returned. Defaults to `None`.
    Returns:
        :obj:`~camel_tools.data.DatasetEntry`: The dataset entry for the
        given component and dataset names.
    """
    if in.(component, Ref(Set(keys(catalogue.components))))
        cmp = catalogue.components[component]

        if dataset isa Nothing
            dataset = cmp.default
        end
        if in.(dataset, Ref(Set(cmp.datasets)))
            return cmp.datasets[dataset]
        else
            throw(CatalogueError("Invalid dataset name $(repr(dataset))"))
        end
    else
        throw(CatalogueError("Invalid component name $(repr(dataset))."))
    end
end

function _get_dependencies(catalogue::Catalogue, package::String)
    dep_set = Set()
    dep_stack = [package]
    while length(dep_stack) > 0
        pkg_name = pop!(dep_stack)
        pkg = get(catalogue.packages, pkg_name, nothing)
        if pkg isa Nothing
            throw(CatalogueError("Invalid package name $(repr(pkg_name))."))
        end

        if pkg.package_type != PackageType[_META][1]
            push!(dep_set, pkg_name)
        end

        if pkg.dependencies isa Nothing || length(pkg.dependencies) == 0
            continue
        end

        for pkg_dep in pkg.dependencies
            if !in.(pkg_dep, Ref(pkg.dependencies))
                push!(dep_stack, pkg_dep)
            end
        end
    end
    return dep_set
end

function get_public_packages(catalogue::Catalogue)::Vector{PackageEntry}
    pkgs = [p for p in values(catalogue.packages) if p.private == false]
    sort!(pkgs, by = x -> x.name)

    return pkgs
end

function download_package(catalogue::Catalogue, package::String; recursive::Bool=true, force::Bool=false, print_status::Bool=false)
    if !in.(package, Ref(Set(keys(catalogue.packages))))
        throw(CatalogueError("Invalid package name $(repr(package))."))
    end

    if recursive
        deps = _get_dependencies(catalogue, package)
    else
        deps = [package]
    end

    if in.("versions.json", Ref(Set(readdir(DATABASE_DIR))))
        ct_versions = json.parsefile(joinpath(DATABASE_DIR, "versions.json"))
    else
        ct_versions = Dict()
    end

    if !force
        new_deps = []
        for dep in deps
            dep_ver = catalogue.packages[dep].version
            if !in.(dep, Ref(Set(keys(ct_versions)))) || dep_ver != ct_versions[dep]
                push!(new_deps, dep)
            end
        end
        deps = new_deps
    end

    if length(deps) == 0
        if print_status
            println("No new packages will be installed")
        end
        return
    end

    if print_status
        pkg_repr = join([repr(d) for d in deps], ", ")
        println("The following packages will be installed: $pkg_repr")
    end

    for dep in deps
        dep_pkg = catalogue.packages[dep]

        if dep_pkg.package_type == PackageType[_META][1]
            continue
        end
        
        dep_pkg_path = dep_pkg.destination
        newpath = DATABASE_DIR
        for i in split(dep_pkg_path, "/")[end-1:end]
            try
                newpath = joinpath(newpath, i)
                mkdir(newpath)
            catch end
        end
        if split(dep_pkg.url, ".")[end] == "zip"
            HTTP.download(dep_pkg.url, joinpath(dep_pkg_path, split(dep_pkg.url, "/")[end]))
            unzip(joinpath(dep_pkg_path, split(dep_pkg.url, "/")[end]))
        end
    end
end

function list_builtin_dbs(catalogue::Catalogue)
    return get_component(catalogue, "MorphologyDB").datasets
end

function builtin_db(catalogue::Catalogue; db_name=nothing, flags::Vector{Symbol}=[:a])
    if db_name isa Nothing
        db_name = catalogue.components["MorphologyDB"].default
    end

    db_info = catalogue.components["MorphologyDB"].datasets[db_name]
    return MorphologyDB(joinpath(db_info.path, "morphology.db"), flags)
end
