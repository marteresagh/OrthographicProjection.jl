"""
	update_core(params::ParametersOrthophoto, laspoint::LasIO.LasPoint, h::LasIO.LasHeader, s::Union{Nothing,IOStream}, n::Int64)
"""
function processPoint(params::ParametersOrthophoto, point::Point)
    position = point.position
    rgb = point.color
    pt = params.coordsystemmatrix * position
    xcoord = map(Int ∘ trunc, (pt[1] - params.refX) / params.GSD) + 1
    ycoord = map(Int ∘ trunc, (params.refY - pt[2]) / params.GSD) + 1

    #blending image
    array = copy(params.raster_points[ycoord, xcoord])
    push!(array, ([rgb[1], rgb[2], rgb[3]], pt[3]))
    params.raster_points[ycoord, xcoord] = array
    if pt[3] < params.min_h
        params.min_h = pt[3]
    end
    if pt[3] > params.max_h
        params.max_h = pt[3]
    end


    # color for image
    if params.rasterquote[ycoord, xcoord] < pt[3]
        params.rasterquote[ycoord, xcoord] = pt[3]
        params.RGBtensor[1, ycoord, xcoord] = rgb[1]
        params.RGBtensor[2, ycoord, xcoord] = rgb[2]
        params.RGBtensor[3, ycoord, xcoord] = rgb[3]
    end

    # point for point cloud
    if params.pc
        Common.update_boundingbox!(
            params.tightBB,
            vcat(Common.apply_matrix(params.ucs, position)...),
        )
        plas = newPointRecord(
            point,
            LasIO.LasPoint2,
            params.mainHeader;
            affineMatrix = params.ucs,
        )
        # plas = FileManager.newPointRecord(laspoint,header,LasIO.LasPoint2,params.mainHeader; affineMatrix = params.ucs)
        write(params.stream_tmp, plas) # write this record on temporary file
    end

    params.numPointsProcessed += 1

end


function processPoint(params::ParametersPlanOrthophoto, point::Point)
    position = point.position
    rgb = point.color
    pt = params.coordsystemmatrix[1:3, 1:3] * position
    xcoord = map(Int ∘ trunc, (pt[1] - params.refX) / params.GSD) + 1
    ycoord = map(Int ∘ trunc, (params.refY - pt[2]) / params.GSD) + 1

    #blending image
    array = copy(params.raster_points[ycoord, xcoord])
    push!(array, ([rgb[1], rgb[2], rgb[3]], pt[3]))
    params.raster_points[ycoord, xcoord] = array
    if pt[3] < params.min_h
        params.min_h = pt[3]
    end
    if pt[3] > params.max_h
        params.max_h = pt[3]
    end

    # color for image
    if params.rasterquote[ycoord, xcoord] < pt[3]
        params.rasterquote[ycoord, xcoord] = pt[3]
        params.RGBtensor[1, ycoord, xcoord] = rgb[1]
        params.RGBtensor[2, ycoord, xcoord] = rgb[2]
        params.RGBtensor[3, ycoord, xcoord] = rgb[3]
    end



    params.numPointsProcessed += 1

end


"""
	updateWithControl!(params::Union{ParametersOrthophoto,ParametersExtraction}, file::String, s::Union{Nothing,IOStream}, n::Int64)

Process all points, in file, falling in region of interest.
"""
function updateWithControl!(
    params::Union{ParametersOrthophoto,ParametersPlanOrthophoto},
    file::String,
)
    header, laspoints = FileManager.read_LAS_LAZ(file) # read file
    for laspoint in laspoints # read each point
        # point = FileManager.xyz(laspoint,header)
        point = Point(laspoint, header)
        if Common.inmodel(params.model)(point.position) # if point in model
            # processPoint(params,laspoint,header)
            processPoint(params, point)
        end
    end
end

"""
	updateWithoutControl!(params::Union{ParametersOrthophoto,ParametersExtraction}, file::String, s::Union{Nothing,IOStream}, n::Int64)

Process points in file without further checks.
"""
function updateWithoutControl!(
    params::Union{ParametersOrthophoto,ParametersPlanOrthophoto},
    file::String,
)
    header, laspoints = FileManager.read_LAS_LAZ(file) # read file
    for laspoint in laspoints # read each point
        point = Point(laspoint, header)
        processPoint(params, point)
        # processPoint(params,laspoint,header)
    end
end
