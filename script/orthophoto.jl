println("loading packages... ")

using ArgParse
using OrthographicProjection

println("packages OK")

function parse_commandline()
    s = ArgParseSettings()

    @add_arg_table! s begin
        "source"
        help = "A text file with Potree directories list or a single Potree directory"
        required = true
        "--output", "-o"
        help = "Output image"
        required = true
        "--bbin"
        help = "Bounding box as 'x_min y_min z_min x_max y_max z_max' or Potree JSON volume model"
        required = true
        "--po"
        help = "Projection plane: XY+, XY-, XZ+, XZ-, YZ+, YZ-"
        arg_type = String
        default = "XY+"
        "--gsd"
        help = "Resolution"
        arg_type = Float64
        default = 0.3
        "--quote"
        help = "Distance of plane from origin"
        arg_type = Float64
        "--thickness"
        help = "Section thickness"
        arg_type = Float64
        "--pc"
        help = "If true a pc of extracted model is saved in a LAS file"
        action = :store_true
        "--ucs"
        help = "Path to UCS JSON file. If not provided is the Identity matrix"
        arg_type = String
        "--bgcolor"
        help = "Background color"
        arg_type = String
        "--bgvoid"
        help = "Color mask for empty pixel"
        arg_type = String
        "--bgfull"
        help = "Color mask for full pixel"
        arg_type = String
        "--epsg"
        help = "EPSG code"
        arg_type = Int
    end

    return parse_args(s)
end

function main()
    args = parse_commandline()

    txtpotreedirs = args["source"]
    outputimage = args["output"]
    bbin = args["bbin"]
    PO = args["po"]
    GSD = args["gsd"]
    bgcolor = args["bgcolor"]
    bgVoid = args["bgvoid"]
    bgFull = args["bgfull"]
    altitude = args["quote"]
    thickness = args["thickness"]
    pc = args["pc"]
    ucs = args["ucs"]
    epsg = args["epsg"]

    println(" ")
    println("== params ==")
    println("Sources  =>  $txtpotreedirs")
    println("Output image  =>  $outputimage")

    b = tryparse.(Float64, split(bbin, " "))
    if length(b) == 6
        bbin = Common.AABB(b[4], b[1], b[5], b[2], b[6], b[3])
    end

    println("Bounding Box  =>")
    println(bbin)
    println("Point of View  =>  $PO")
    println("GSD  =>  $GSD")

    if !isnothing(bgcolor)
        col = tryparse.(Float64, split(bgcolor, " "))
        background = [col[1], col[2], col[3]]
    else
        background = [1.0, 1.0, 1.0]
    end

    if !isnothing(bgVoid)
        col = tryparse.(Float64, split(bgVoid, " "))
        bgVoid = [col[1], col[2], col[3]]
    else
        bgVoid = [0.0, 0.0, 0.0]
    end

    if !isnothing(bgFull)
        col = tryparse.(Float64, split(bgFull, " "))
        bgFull = [col[1], col[2], col[3]]
    else
        bgFull = [1.0, 1.0, 1.0]
    end

    println("Background color  =>  $background")

    if !isnothing(altitude)
        println("Altitude  =>  $altitude")
        println("Thickness  =>  $thickness")
    end

    println("Extract point cloud  =>  $pc")

    if isnothing(ucs)
        ucs = Matrix{Float64}(Common.I, 4, 4)
    else
        println("User coordinates system  =>  $ucs")
    end

    if !isnothing(epsg)
        println("EPSG  =>  $epsg")
    end

    flush(stdout)

    OrthographicProjection.orthophoto(
        txtpotreedirs,
        outputimage,
        bbin,
        GSD,
        PO,
        altitude,
        thickness,
        ucs,
        background,
        pc,
        epsg,
        bgVoid,
        bgFull,
    )
end

@time main()
