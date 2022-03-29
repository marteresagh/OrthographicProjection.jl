
"""
	init_raster_array(matrix::Array{Float64,2}, GSD::Float64, model::LAR, BGcolor::Array{Float64,1})

Orthoprojection of `model` on plane defined by `matrix`, create a raster image with background color `BGcolor`.
"""
function init_raster_array(
    matrix::Array{Float64,2},
    GSD::Float64,
    model::LAR,
    BGcolor::Array{Float64,1},
)

    verts, edges, faces = model
    bbglobalextention = zeros(2)
    ref = zeros(2)

    newcoord = matrix * verts

    for i = 1:2
        extr = extrema(newcoord[i, :])
        bbglobalextention[i] = extr[2] - extr[1]
        ref[i] = extr[i]
    end

    # IMAGE RESOLUTION
    resX = map(Int ∘ trunc, bbglobalextention[1] / GSD) + 1
    resY = map(Int ∘ trunc, bbglobalextention[2] / GSD) + 1

    # Z-BUFFER MATRIX
    rasterquote = fill(-Inf, (resY, resX))

    # RASTER IMAGE MATRIX
    rasterChannels = 3

    RGBtensor = ones(rasterChannels, resY, resX)
    RGBtensor[1, :, :] .= BGcolor[1]
    RGBtensor[2, :, :] .= BGcolor[2]
    RGBtensor[3, :, :] .= BGcolor[3]
    # refX=ref[1]
    # refY=ref[2]
    return RGBtensor, rasterquote, ref[1], ref[2]
end


"""
	get_potree_dirs(txtpotreedirs::String)

Return collection of potree directories.
"""
function get_potree_dirs(txtpotreedirs::String)
    if isfile(txtpotreedirs)
        return FileManager.readlines(txtpotreedirs)
    elseif isdir(txtpotreedirs)
        return [txtpotreedirs]
    end
end


"""
	PO2matrix(PO::String, UCS=Matrix{Float64}(Common.I,4,4)::Matrix)

Observation point.
Valid input:
 - "XY+": Top view
 - "XY-": Bottom view
 - "XZ+": Back view
 - "XZ-": Front view
 - "YZ+": Left view
 - "YZ-": Right view
"""
function PO2matrix(PO::String, UCS = Matrix{Float64}(Common.I, 4, 4)::Matrix)
    planecode = PO[1:2]
    @assert planecode == "XY" || planecode == "XZ" || planecode == "YZ" "orthoprojectionimage: $PO not valid view "

    directionview = PO[3]
    @assert directionview == '+' || directionview == '-' "orthoprojectionimage: $PO not valid view "

    coordsystemmatrix = Matrix{Float64}(Common.I, 3, 3)

    # if planecode == XY # top, - bottom
    #     continue
    if planecode == "XZ" # back, - front
        coordsystemmatrix[1, 1] = -1.0
        coordsystemmatrix[2, 2] = 0.0
        coordsystemmatrix[3, 3] = 0.0
        coordsystemmatrix[2, 3] = 1.0
        coordsystemmatrix[3, 2] = 1.0
    elseif planecode == "YZ" # right, - left
        coordsystemmatrix[1, 1] = 0.0
        coordsystemmatrix[2, 2] = 0.0
        coordsystemmatrix[3, 3] = 0.0
        coordsystemmatrix[1, 2] = 1.0
        coordsystemmatrix[2, 3] = 1.0
        coordsystemmatrix[3, 1] = 1.0
    end

    # if directionview == "+"
    #     continue
    if directionview == '-'
        R = [-1.0 0 0; 0 1.0 0; 0 0 -1]
        coordsystemmatrix = R * coordsystemmatrix
    end

    return coordsystemmatrix * UCS[1:3, 1:3]
end




function blendColors(colors...)
    base = [0, 0, 0, 0]
    mix = nothing
    for added in colors
        @assert length(added) == 4 "not alpha channel: $added"
        # check if both alpha channels exist.
        if base[4] != 0 && added[4] != 0
            mix = [0, 0, 0, 0.0]
            mix[4] = 1 - (1 - added[4]) * (1 - base[4])
            mix[1] =
                (added[1] * added[4] / mix[4]) +
                (base[1] * base[4] * (1 - added[4]) / mix[4])
            mix[2] =
                (added[2] * added[4] / mix[4]) +
                (base[2] * base[4] * (1 - added[4]) / mix[4])
            mix[3] =
                (added[3] * added[4] / mix[4]) +
                (base[3] * base[4] * (1 - added[4]) / mix[4])
        else
            mix = added
        end
        base = mix
    end

    return mix
end

"""
    mapping(input_extrema, output_extrema)(x)

 - input_extrema: (min,max) of input interval
 - output_extrema: (min,max) of output interval
"""
function mapping(input_extrema, output_extrema)
    function mapping0(x)
        return  (x - input_extrema[1]) / (input_extrema[2] - input_extrema[1]) * (output_extrema[2] - output_extrema[1]) + output_extrema[1]
    end
    return mapping0
end
