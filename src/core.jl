"""
	update_core(params::ParametersOrthophoto, laspoint::LasIO.LasPoint, h::LasIO.LasHeader, s::Union{Nothing,IOStream}, n::Int64)
"""
function update_core(params::ParametersOrthophoto, laspoint::LasIO.LasPoint, h::LasIO.LasHeader)
	point = FileManager.xyz(laspoint,h)
	rgb = FileManager.color(laspoint,h)
	p = params.coordsystemmatrix*point
	xcoord = map(Int∘trunc,(p[1]-params.refX) / params.GSD)+1
	ycoord = map(Int∘trunc,(params.refY-p[2]) / params.GSD)+1

	# color for image
	if params.rasterquote[ycoord,xcoord] < p[3]
		params.rasterquote[ycoord,xcoord] = p[3]
		params.RGBtensor[1, ycoord, xcoord] = rgb[1]
		params.RGBtensor[2, ycoord, xcoord] = rgb[2]
		params.RGBtensor[3, ycoord, xcoord] = rgb[3]
	end

	# point for point cloud
	if params.pc
		Common.update_boundingbox!(params.tightBB,vcat(Common.apply_matrix(params.ucs,point)...))
		plas = FileManager.newPointRecord(laspoint,h,LasIO.LasPoint2,params.mainHeader; affineMatrix = params.ucs)
		write(params.stream_tmp,plas) # write this record on temporary file
	end

	params.numPointsProcessed +=1

end

# """
# Core
# """
# function orthophoto_core(params::ParametersOrthophoto)
#
# 	if params.pc
# 		temp = joinpath(splitdir(params.outputimage)[1],"temp.las")
# 		open(temp, "w") do s
# 			write(s, LasIO.magic(LasIO.format"LAS"))
# 			traversal(params)
# 			return temp
# 		end
# 	else
# 		trie_traversal(params,nothing)
# 		return nothing
# 	end
#
# end
