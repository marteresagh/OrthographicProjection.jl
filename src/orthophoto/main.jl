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
	quota::Union{Float64,Nothing},
	thickness::Union{Float64,Nothing},
	ucs::Union{String,Matrix{Float64}},
	BGcolor::Array{Float64,1},
	pc::Bool
	)

	# initialization
	params = init( txtpotreedirs, outputimage, bbin, GSD, PO, quota, thickness,	ucs, BGcolor, pc);

	# image creation
	flushprintln("========= PROCESSING =========")

	n, temp = orthophoto_core(params)

	flushprintln("========= SAVES =========")

	# saves image
	saveimage(params)

	# saves point cloud extracted
	if pc
		savepointcloud(params, n, temp)
	end
end
