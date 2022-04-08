function orthophoto_new(
    destinationDir::String,
    potrees::Vector{String},
    model::Common.LAR,
    GSD::Float64,
    PO::String,
    ucs::Matrix{Float64},
    BGcolor::Array{Float64,1},
    clip::Bool,
    epsg::Union{Nothing,Integer},
    bgVoid::Array{Float64,1},
    bgFull::Array{Float64,1},
)

    # initialization
    params = OrthophotoArguments(
        destinationDir,
        potrees,
        model,
        GSD,
        PO,
        ucs,
        BGcolor,
        bgVoid,
        bgFull,
        clip,
        epsg,
    )

    temp = joinpath(params.destinationDir, "tmp.las")
    if params.clip
        params.stream_tmp = open(temp, "w")
    end

    println(" ")
    println("========= PROCESSING =========")

    for potree in params.potrees
        traversal(potree, params)
    end

    if params.clip
        close(params.stream_tmp)
    end

    saveAsset(params, temp)
    return params
end


function planOrthophoto(
    potrees,
    outputfolder,
    model,
    GSD,
    coordsystemmatrix,
    background,
)
    # initialization
    params = PlanArguments(
        potrees,
        outputfolder,
        model,
        GSD,
        coordsystemmatrix,
        background
    )

    println(" ")
    println("========= PROCESSING =========")

    for potree in params.potreedirs
        traversal(potree, params)
    end

    saveAsset(params)
    return params
end
