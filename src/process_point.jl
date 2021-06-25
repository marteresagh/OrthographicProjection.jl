"""
	update_core(params::ParametersOrthophoto, laspoint::LasIO.LasPoint, h::LasIO.LasHeader, s::Union{Nothing,IOStream}, n::Int64)
"""
function processPoint(params::ParametersOrthophoto, point::Point)
    position = point.position
    rgb = point.color
    pt = params.coordsystemmatrix * position
    xcoord = map(Int ∘ trunc, (pt[1] - params.refX) / params.GSD) + 1
    ycoord = map(Int ∘ trunc, (params.refY - pt[2]) / params.GSD) + 1

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


"""
	updateWithControl!(params::Union{ParametersOrthophoto,ParametersExtraction}, file::String, s::Union{Nothing,IOStream}, n::Int64)

Process all points, in file, falling in region of interest.
"""
function updateWithControl!(params::ParametersOrthophoto, file::String)
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
function updateWithoutControl!(params::ParametersOrthophoto, file::String)
    header, laspoints = FileManager.read_LAS_LAZ(file) # read file
    for laspoint in laspoints # read each point
        point = Point(laspoint, header)
        processPoint(params, point)
        # processPoint(params,laspoint,header)
    end
end
