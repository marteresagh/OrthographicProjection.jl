"""
Core
"""
function orthophoto_core(params::ParametersOrthophoto)

	if params.pc
		temp = joinpath(splitdir(params.outputimage)[1],"temp.las")
		open(temp, "w") do s
			write(s, LasIO.magic(LasIO.format"LAS"))
			n = process_trie(params,s)
			return n, temp
		end
	else
		n = process_trie(params,nothing)
		return n, nothing
	end

end

"""
update image tensor.
"""
function updateif!(params::ParametersOrthophoto,file,s,n::Int64)
	h, laspoints =  FileManager.read_LAS_LAZ(file)

	for laspoint in laspoints
		point = FileManager.xyz(laspoint,h)
		if Common.inmodel(params.model)(point) # se il punto è interno allora
			n = update_core(params,laspoint,h,n,s)
		end
	end

	return n
end

function update!(params::ParametersOrthophoto,file,s,n::Int64)
	h, laspoints = FileManager.read_LAS_LAZ(file)

	for laspoint in laspoints
		n = update_core(params,laspoint,h,n,s)
	end

	return n
end

function update_core(params::ParametersOrthophoto,laspoint,h,n,s)
	point = FileManager.xyz(laspoint,h)
	rgb = FileManager.color(laspoint,h)
	p = params.coordsystemmatrix*point
	xcoord = map(Int∘trunc,(p[1]-params.refX) / params.GSD)+1
	ycoord = map(Int∘trunc,(params.refY-p[2]) / params.GSD)+1

	if params.pc
		plas = FileManager.newPointRecord(laspoint,h,LasIO.LasPoint2,params.mainHeader)
		write(s,plas)
		n = n+1
	end
	if params.rasterquote[ycoord,xcoord] < p[3]
		params.rasterquote[ycoord,xcoord] = p[3]
		params.RGBtensor[1, ycoord, xcoord] = rgb[1]
		params.RGBtensor[2, ycoord, xcoord] = rgb[2]
		params.RGBtensor[3, ycoord, xcoord] = rgb[3]
	end

	return n
end
