"""
ParametersOrthophoto

# Constructors
```jldoctest
ParametersOrthophoto(
	txtpotreedirs::String,
	outputimage::String,
	bbin::Union{String,AABB},
	GSD::Float64,
	PO::String,
	altitude::Union{Float64,Nothing},
	thickness::Union{Float64,Nothing},
	ucs::Union{String,Matrix{Float64}},
	BGcolor::Array{Float64,1},
	pc::Bool
	)
```
Input description:
 - txtpotreedirs: path to Potree project or a text file containing a list of Potree projects
 - outputimage: Output filename for image
 - bbin: Path to json file or AABB
 - GSD: Ground sampling distance
 - PO: Projection plane and sight direction. Option: "XY+","XY-","XZ+","XZ-","YZ+","YZ-"
 - quote: Distance of plane from the origin
 - thickness: Thickness of plane
 - ucs: User coordinates system
 - BGcolor: Background color image
 - pc: If true return LAS file of point cloud

# Fields
```jldoctest
PO::String
outputimage::String
outputfile::String
potreedirs::Array{String,1}
model::LAR
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
```

Fields description:
 - PO: Projection plane and sight direction. Option: "XY+","XY-","XZ+","XZ-","YZ+","YZ-"
 - outputimage: Output filename for image
 - outputfile: Output filename for point cloud
 - potreedirs: Potree projects
 - model: Cuboidal LAR model
 - coordsystemmatrix: Rotation matrix related to PO
 - RGBtensor: Image tensor
 - rasterquote: Matrix of heigth (z-buffer)
 - GSD: Ground sampling distance
 - refX: x coordinate of landmark
 - refY: y coordinate of landmark
 - pc: if true extract point cloud
 - ucs: user coordinate system
 - tightBB: segmented point cloud AABB
 - mainHeader: header of point cloud file las

"""
mutable struct ParametersOrthophoto
    PO::String
    outputimage::String
    outputfile::String
    potreedirs::Array{String,1}
    model::LAR
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

	function ParametersOrthophoto(
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
		epsg::Union{Nothing,Integer}
		)

		# check validity
		@assert length(PO)==3 "orthoprojectionimage: $PO not valid view"

		numPointsProcessed = 0
		numNodes = 0
		numFilesProcessed = 0
		stream_tmp = nothing

		outputfile = splitext(outputimage)[1]*".las"

		potreedirs = get_potree_dirs(txtpotreedirs)

		if typeof(ucs) == Matrix{Float64}
			coordsystemmatrix = PO2matrix(PO,ucs)
		else
			ucs = FileManager.ucs2matrix(ucs)
			coordsystemmatrix = PO2matrix(PO,ucs)
		end

		model = getmodel(bbin)
		aabb = AABB(model[1])

		if !isnothing(altitude) && !isnothing(thickness)
			directionview = PO[3]
		    if directionview == '-'
				altitude = -altitude
			end
			origin = Common.inv(ucs)[1:3,4]
			model = getmodel(Common.inv(coordsystemmatrix), altitude, thickness, aabb; new_origin = origin)
			aabb = AABB(model[1])
		end

		RGBtensor, rasterquote, refX, refY = init_raster_array(coordsystemmatrix, GSD, model, BGcolor)

		#per l'header devo creare il nuovo AABB dato dal nuovo orientamento.
		new_verts_BB = Common.apply_matrix(ucs,model[1])
		aabb = AABB(new_verts_BB)
		mainHeader = FileManager.newHeader(aabb,"ORTHOPHOTO",FileManager.SIZE_DATARECORD)

		if !isnothing(epsg)
			FileManager.LasIO.epsg_code!(mainHeader, epsg)
		end

		return new(PO,
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
				 AABB(-Inf, Inf,-Inf, Inf,-Inf, Inf),
				 mainHeader,
				 numPointsProcessed,
				 numNodes,
		 		 numFilesProcessed,
				 stream_tmp)
	end

end

# """
# ParametersExtraction
#
# # Constructors
# ```jldoctest
# ParametersExtraction(txtpotreedirs::String,
# 	outputfile::String,
# 	model::LAR;
# 	epsg = nothing::Union{Nothing,Integer}
# 	)
# ```
# Input description:
# - txtpotreedirs: path to Potree project or a text file containing a list of Potree projects
# - outputfile: output LAS filename
# - model: cuboidal LAR model
# - epsg: projection code
#
#
# # Fields
# ```jldoctest
# outputfile::String
# potreedirs::Array{String,1}
# model::LAR
# mainHeader::LasIO.LasHeader
# ```
#
# Fields description:
#  - outputfile: Output filename for point cloud
#  - potreedirs: Potree projects
#  - model: Cuboidal LAR model
#  - mainHeader: header of point cloud LAS file
#
# """
# mutable struct ParametersExtraction
# 	outputfile::String
# 	potreedirs::Array{String,1}
# 	model::LAR
# 	tightBB::AABB
# 	mainHeader::LasIO.LasHeader
#
# 	function ParametersExtraction(txtpotreedirs::String,
# 		outputfile::String,
# 		model::LAR;
# 		epsg = nothing::Union{Nothing,Integer}
# 		)
#
# 		potreedirs = get_potree_dirs(txtpotreedirs)
#
# 		aabb = AABB(model[1])
#
# 		mainHeader = FileManager.newHeader(aabb,"EXTRACTION",FileManager.SIZE_DATARECORD)
# 		if !isnothing(epsg)
# 			FileManager.LasIO.epsg_code!(mainHeader, epsg)
# 		end
#
# 		return new(outputfile,
# 		potreedirs,
# 		model,
# 		AABB(-Inf, Inf,-Inf, Inf,-Inf, Inf),
# 		mainHeader)
# 	end
#
# end
