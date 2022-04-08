mutable struct OrthophotoArguments
    destinationDir::String
    potrees::Vector{String}
    model::LAR
    PO::String
    coordsystemmatrix::Array{Float64,2}
    RGBtensor::Array{Float64,3}
    rasterquote::Array{Float64,2}
    GSD::Float64
    refX::Float64
    refY::Float64
    clip::Bool
    ucs::Matrix
    tightBB::AABB
    mainHeader::LasIO.LasHeader
    numPointsProcessed::Int64
    numNodes::Int64
    numFilesProcessed::Int64
    stream_tmp::Union{Nothing,IOStream}
    raster_points::Array{Vector{Any},2}
    max_h::Float64
    min_h::Float64
    BGcolor::Vector{Float64}
    ColorMask::Vector{Vector{Float64}}

    function OrthophotoArguments(
        destinationDir::String,
        potrees::Vector{String},
        model::Common.LAR,
        GSD::Float64,
        PO::String,
        ucs::Matrix{Float64},
        BGcolor::Vector{Float64},
        bgVoid::Vector{Float64},
        bgFull::Vector{Float64},
        pc::Bool,
        epsg::Union{Nothing,Integer},
    )

        # check validity
        @assert length(PO) == 3 "orthoprojectionimage: $PO not valid view"

        numPointsProcessed = 0
        numNodes = 0
        numFilesProcessed = 0
        stream_tmp = nothing

        coordsystemmatrix = PO2matrix(PO, ucs)

        aabb = AABB(model[1])

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
            destinationDir,
            potrees,
            model,
            PO,
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
            -Inf,
            BGcolor,
            [bgVoid,bgFull],
        )
    end

end


mutable struct PlanArguments
    destinationDir::String
    potreedirs::Vector{String}
    model::LAR
    coordsystemmatrix::Array{Float64,2}
    RGBtensor::Array{Float64,3}
    rasterquote::Array{Float64,2}
    GSD::Float64
    refX::Float64
    refY::Float64
    numPointsProcessed::Int64
    numNodes::Int64
    numFilesProcessed::Int64
    raster_points::Array{Vector{Any},2}
    min_h::Float64
    max_h::Float64
    pixel::Vector{Int64}

    function PlanArguments(
        potreedirs::Vector{String},
        out_folder::String,
        model::LAR,
        GSD::Float64,
        coordsystemmatrix::Array{Float64,2},
        BGcolor::Array{Float64,1}
    )

        numPointsProcessed = 0
        numNodes = 0
        numFilesProcessed = 0

        matrix = coordsystemmatrix[1:3,1:3]

        RGBtensor, rasterquote, refX, refY =
            init_raster_array(matrix, GSD, model, BGcolor)

        r,c = size(rasterquote)
        raster_points = fill([],r,c)

        return new(
        out_folder,
        potreedirs,
        model,
        coordsystemmatrix,
        RGBtensor,
        rasterquote,
        GSD,
        refX,
        refY,
        numPointsProcessed,
        numNodes,
        numFilesProcessed,
        raster_points,
        Inf,
        -Inf,
        [c,r]
        )
    end

end
