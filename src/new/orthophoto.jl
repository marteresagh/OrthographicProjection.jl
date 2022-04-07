function orthophoto_new(
    txtpotreedirs::String,
    outputimage::String,
    bbin::Union{String,AABB},
    GSD::Float64,
    PO::String,
    altitude::Union{Float64,Nothing},
    thickness::Union{Float64,Nothing},
    ucs::Union{String,Matrix{Float64}},
    BGcolor::Array{Float64,1},
    pc::Bool,
    epsg::Union{Nothing,Integer},
    bgVoid::Array{Float64,1},
    bgFull::Array{Float64,1},
)

    # initialization
    params = OrthophotoArguments(
        txtpotreedirs,
        outputimage,
        bbin,
        GSD,
        PO,
        altitude,
        thickness,
        ucs,
        BGcolor,
        pc,
        epsg,
    )

    proj_folder = splitdir(params.outputfile)[1]
    nameIMage = split(splitdir(params.outputfile)[2], ".")[1]

    if params.pc
        temp = joinpath(proj_folder, "tmp.las")
        params.stream_tmp = open(temp, "w")
    end

    println(" ")
    println("========= PROCESSING =========")

    for potree in params.potreedirs
        traversal(potree, params)
    end

    if params.pc
        close(params.stream_tmp)
    end

    saveAsset(params)
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
