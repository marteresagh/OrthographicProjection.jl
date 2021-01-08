"""

"""
function update_core(params::ParametersOrthophoto, laspoint::LasIO.LasPoint, h::LasIO.LasHeader, s::Union{Nothing,IOStream}, n::Int64)
	point = FileManager.xyz(laspoint,h)
	rgb = FileManager.color(laspoint,h)
	p = params.coordsystemmatrix*point
	xcoord = map(Int∘trunc,(p[1]-params.refX) / params.GSD)+1
	ycoord = map(Int∘trunc,(params.refY-p[2]) / params.GSD)+1

	if params.pc
		n = add_point(params, laspoint, h, s, n)
		# Common.update_boundingbox!(params.header_bb,point)
		# plas = FileManager.newPointRecord(laspoint,h,LasIO.LasPoint2,params.mainHeader)
		# write(s,plas)
		# n = n+1
	end
	if params.rasterquote[ycoord,xcoord] < p[3]
		params.rasterquote[ycoord,xcoord] = p[3]
		params.RGBtensor[1, ycoord, xcoord] = rgb[1]
		params.RGBtensor[2, ycoord, xcoord] = rgb[2]
		params.RGBtensor[3, ycoord, xcoord] = rgb[3]
	end

	return n
end

"""
Core
"""
function orthophoto_core(params::ParametersOrthophoto)

	if params.pc
		temp = joinpath(splitdir(params.outputimage)[1],"temp.las")
		open(temp, "w") do s
			write(s, LasIO.magic(LasIO.format"LAS"))
			n = trie_traversal(params,s)
			return n, temp
		end
	else
		n = trie_traversal(params,nothing)
		return n, nothing
	end

end
