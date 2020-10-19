"""
Initialize usefull parameters.
"""
function initparams(
	txtpotreedirs::String,
	outputimage::String,
	bbin::Union{String,AABB},
	GSD::Float64,
	PO::String,
	quota::Union{Float64,Nothing},
	thickness::Union{Float64,Nothing},
	ucs::Union{String,Matrix{Float64}},
	pc::Bool
	)

	# check validity
	@assert isfile(txtpotreedirs) "orthoprojectionimage: $txtpotreedirs not an existing file"
	@assert length(PO)==3 "orthoprojectionimage: $PO not valid view"


	outputfile = splitext(outputimage)[1]*".las"

	potreedirs = FileManager.get_directories(txtpotreedirs)


	if typeof(ucs) == Matrix{Float64}
		coordsystemmatrix = PO2matrix(PO)
	else
		ucs = FileManager.ucs2matrix(ucs)
		coordsystemmatrix = PO2matrix(PO,ucs)
	end

	model = getmodel(bbin)
	aabb = Common.boundingbox(model[1])

	if !isnothing(quota) && !isnothing(thickness)
		model = plane2model(coordsystemmatrix, quota, thickness, aabb)
	end

	q_l = -Inf
 	q_u = Inf

	# if !isnothing(quota)
	# 	if PO == "XY+" || PO == "XY-"
	# 		puntoquota = [0,0,quota]
	# 	elseif PO == "XZ+" || PO == "XZ-"
	# 		puntoquota = [0, quota, 0]
	# 	elseif PO == "YZ+" || PO == "YZ-"
	# 		puntoquota = [quota, 0, 0]
	# 	end
	#
	# 	@assert !isnothing(thickness) "OrthographicProjection: thickness missing"
	# 	q_l = (coordsystemmatrix*puntoquota)[3] - thickness/2
	# 	q_u = (coordsystemmatrix*puntoquota)[3] + thickness/2
	# else
	# 	q_l = -Inf
	# 	q_u = Inf
	# end

	RGBtensor, rasterquote, refX, refY = init_raster_array(coordsystemmatrix,GSD,model)


	mainHeader = FileManager.newHeader(aabb,"ORTHOPHOTO",SIZE_DATARECORD)

	return  ParametersOrthophoto(PO,
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
					 q_l,
					 q_u,
					 pc,
					 ucs,
					 mainHeader)
end


"""
Basis.
"""
function PO2matrix(PO::String, UCS=Matrix{Float64}(Lar.I,4,4)::Matrix)
    planecode = PO[1:2]
    @assert planecode == "XY" || planecode == "XZ" || planecode == "YZ" "orthoprojectionimage: $PO not valid view "

    directionview = PO[3]
    @assert directionview == '+' || directionview == '-' "orthoprojectionimage: $PO not valid view "

    coordsystemmatrix = Matrix{Float64}(Lar.I,3,3)

    # if planecode == XY # top, - bottom
    #     continue
    if planecode == "XZ" # back, - front
        coordsystemmatrix[1,1] = -1.
        coordsystemmatrix[2,2] = 0.
        coordsystemmatrix[3,3] = 0.
        coordsystemmatrix[2,3] = 1.
        coordsystemmatrix[3,2] = 1.
    elseif planecode == "YZ" # right, - left
        coordsystemmatrix[1,1] = 0.
        coordsystemmatrix[2,2] = 0.
        coordsystemmatrix[3,3] = 0.
        coordsystemmatrix[1,2] = 1.
        coordsystemmatrix[2,3] = 1.
        coordsystemmatrix[3,1] = 1.
    end

    # if directionview == "+"
    #     continue
    if directionview == '-'
        R = [-1. 0 0; 0 1. 0; 0 0 -1]
        coordsystemmatrix = R*coordsystemmatrix
    end

    return coordsystemmatrix*UCS[1:3,1:3]
end


"""
initialize raster image.
"""
function init_raster_array(coordsystemmatrix::Array{Float64,2}, GSD::Float64, model::Lar.LAR)

	verts,edges,faces = model
	bbglobalextention = zeros(2)
	ref = zeros(2)

	newcoord = coordsystemmatrix*verts

	for i in 1:2
		extr = extrema(newcoord[i,:])
		bbglobalextention[i] = extr[2]-extr[1]
		ref[i] = extr[i]
	end

	# IMAGE RESOLUTION
	resX = map(Int∘trunc,bbglobalextention[1] / GSD) + 1
	resY = map(Int∘trunc,bbglobalextention[2] / GSD) + 1

	# Z-BUFFER MATRIX
	rasterquote = fill(-Inf,(resY,resX))

	# RASTER IMAGE MATRIX
	rasterChannels = 3

	RGBtensor = fill(1.,(rasterChannels,resY, resX))

	# refX=ref[1]
	# refY=ref[2]
	return RGBtensor, rasterquote, ref[1], ref[2]
end

#TODO fare altri test ma sembra funzionare
function plane2model(rot_mat::Matrix, constant::Float64, thickness::Float64, aabb::AABB)
	verts,_ = getmodel(aabb)
	rotation = Common.matrix2euler(rot_mat)
	center_model = [(aabb.x_max-aabb.x_min)/2,(aabb.y_max-aabb.y_min)/2,(aabb.z_max-aabb.z_min)/2]
	quota = rot_mat[:,3]*constant
	position = quota+center_model
	newverts = rot_mat*verts
	x_range = extrema(newverts[1,:])
	y_range = extrema(newverts[2,:])
	#extrema of newverts x e y
	scale = [x_range[2]-x_range[1],y_range[2]-y_range[1],thickness]
	volume = Volume(scale,position,rotation)
	model = Common.volume2LARmodel(volume)
	return model
end
