"""
    orthophoto(
    	txtpotreedirs::String,
    	outputimage::String,
    	bbin::Union{String,AABB},
    	GSD::Float64,
    	PO::String,
    	quota::Union{Float64,Nothing},
    	thickness::Union{Float64,Nothing},
    	ucs::Union{String,Matrix{Float64}},
    	BGcolor::Array{Float64,1},
    	pc::Bool
    	)

Orthographic projection of point cloud.

Description:
 - txtpotreedirs: path to Potree project or a text file containing a list of Potree projects
 - outputimage: output filename for image
 - bbin: region of interest, aabb ("xmin ymin zmin xmax ymax zmax") or volume (path to json file of described volume)
 - GSD: ground sampling distance
 - PO: projection plane and sight direction. Option: "XY+","XY-","XZ+","XZ-","YZ+","YZ-"
 - ucs: user coordinate system
 - BGcolor: background color of image
 - pc: if true saves the segmented point cloud in region of interest

It is possible to limit the region of interest for a section of point cloud. The slice is described with:
 - quota: distance of plane to origin
 - thickness: thickness of plane

Put both of them to nothing if you are not interested in a slice.
"""
function orthophoto(
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
    bgFull::Array{Float64,1}
)

    # initialization
    params = ParametersOrthophoto(
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


    println(" ")
    println("========= SAVES =========")

    # saves image
    print("Image: saving ...")
    # save tfw
    save_tfw(params.outputimage, params.GSD, params.refX, params.refY)

    # save image
    save(params.outputimage, Images.colorview(RGB, params.RGBtensor))
    println("Done.")

    # save mask
    print("Mask: saving ...")
    channels, rows, columns =  size(params.RGBtensor)
    BWImage = ones(channels, rows, columns)
    for i in 1:rows
        for j in 1:columns
            colorRGB = params.RGBtensor[:, i, j]
            if colorRGB == BGcolor
                BWImage[:, i, j] = bgVoid
            else
                BWImage[:, i, j] = bgFull
            end
        end
    end
    save(joinpath(proj_folder,"$(nameIMage)_mask.jpg"), Images.colorview(RGB, BWImage))
    println("Done.")



    ##### blend image
    print("Blending: saving ...")
    rows, columns =  size(params.raster_points)
    Image_Blending = fill(RGBA(0.,0.,0.,0.), rows, columns)
    for i in 1:rows
        @show "$i of $rows"
        for j in 1:columns
            # rgbas = []
            # for (rgb, h) in params.raster_points[i,j]
            #     push!(rgbas, [rgb[1],rgb[2],rgb[3],mapping((params.min_h,params.max_h),(0.3,1.0))(h)] )
            # end
            if length(params.raster_points[i,j]) > 0
                rgbas = [[rgb[1],rgb[2],rgb[3],mapping((params.min_h,params.max_h),(0.3,1.0))(h)] for (rgb, h) in params.raster_points[i,j]]

                color = blendColors(rgbas...)
                Image_Blending[i,j] = RGBA(color...)
            end
        end
    end
    save(joinpath(proj_folder,"$(nameIMage)_alpha.png"), Image_Blending)
    println("Done.")


    ######################

    M = params.coordsystemmatrix
    origin = params.ucs[1:3, 4]
    text = "$(M[1,1]) $(M[1,2]) $(M[1,3]) $(origin[1])\n$(M[2,1]) $(M[2,2]) $(M[2,3]) $(origin[2])\n$(M[3,1]) $(M[3,2]) $(M[3,3]) $(origin[3])\n0 0 0 1"
    FileManager.successful(
        params.numPointsProcessed != 0,
        proj_folder;
        message = text,
    )


    println("Processed $(params.numPointsProcessed) points")

    # saves point cloud extracted
    if pc
        savepointcloud(params, temp)
    end

end
