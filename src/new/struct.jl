mutable struct OrthophotoArguments
    destinationDir::String
    projName::String
    potrees::Vector{String}
    model::LAR
    PO::String
    coordsystemmatrix::Array{Float64,2}
    RGBtensor::Array{Float64,3}
    rasterquote::Array{Float64,2}
    GSD::Float64
    refX::Float64
    refY::Float64
    pc::Bool
    ucs::Matrix
    tightBB::AABB
    mainHeader::LasIO.LasHeader
    numPointsProcessed::Int64
    numNodes::Int64
    numFilesProcessed::Int64
    stream_tmp::Union{Nothing,IOStream}

    function OrthophotoArguments(
        potrees::Vector{String},
        outputimage::String,
        bbin::Union{String,AABB},
        GSD::Float64,
        PO::String,
        ucs::Union{String,Matrix{Float64}},
        BGcolor::Vector{Float64},
        pc::Bool,
        epsg::Union{Nothing,Integer},
    )

        # check validity
        @assert length(PO) == 3 "orthoprojectionimage: $PO not valid view"

        numPointsProcessed = 0
        numNodes = 0
        numFilesProcessed = 0
        stream_tmp = nothing

        outputfile = splitext(outputimage)[1] * ".las"

        potreedirs = get_potree_dirs(txtpotreedirs)

        if typeof(ucs) == Matrix{Float64}
            coordsystemmatrix = PO2matrix(PO, ucs)
        else
            ucs = FileManager.ucs2matrix(ucs)
            coordsystemmatrix = PO2matrix(PO, ucs)
        end

        model = getmodel(bbin)
        aabb = AABB(model[1])

        if !isnothing(altitude) && !isnothing(thickness)
            directionview = PO[3]
            if directionview == '-'
                altitude = -altitude
            end
            origin = Common.inv(ucs)[1:3, 4]
            model = getmodel(
                Common.inv(coordsystemmatrix),
                altitude,
                thickness,
                aabb;
                new_origin = origin,
            )
            aabb = AABB(model[1])
        end

        RGBtensor, rasterquote, refX, refY =
            init_raster_array(coordsystemmatrix, GSD, model, BGcolor)

        raster_points = fill([], size(rasterquote))

        #per l'header devo creare il nuovo AABB dato dal nuovo orientamento.
        new_verts_BB = Common.apply_matrix(ucs, model[1])
        aabb = AABB(new_verts_BB)
        mainHeader = FileManager.newHeader(
            aabb,
            "ORTHOPHOTO",
            FileManager.SIZE_DATARECORD,
        )

        if !isnothing(epsg)
            FileManager.LasIO.epsg_code!(mainHeader, epsg)
        end

        return new(
            PO,
            outputimage,
            outputfile,
            potreedirs,
            model,
            coordsystemmatrix,
            RGBtensor,
            rasterquote,
            GSD,
            refX,
            refY,
            pc,
            ucs,
            AABB(-Inf, Inf, -Inf, Inf, -Inf, Inf),
            mainHeader,
            numPointsProcessed,
            numNodes,
            numFilesProcessed,
            stream_tmp,
            raster_points,
            Inf,
            -Inf
        )
    end

end
