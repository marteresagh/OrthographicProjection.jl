"""
Core
"""
function orthophoto_core(params::ParametersOrthophoto,n::Int)

	if params.pc
		temp = joinpath(splitdir(params.outputimage)[1],"temp.las")
		open(temp, "w") do s
			write(s, LasIO.magic(LasIO.format"LAS"))
			n = PointClouds.pointselection(params,s,n)
			return n, temp
		end
	else
		n = PointClouds.pointselection(params,nothing,n)
		return n, nothing
	end

end

"""
imagecreation con i trie
"""
function pointselection(params::ParametersOrthophoto,s,n::Int64)
    for potree in params.potreedirs
        PointClouds.flushprintln( "======== PROJECT $potree ========")
		typeofpoints,scale,npoints,AABB,tightBB,octreeDir,hierarchyStepSize,spacing = PointClouds.readcloudJSON(potree)

		trie = triepotree(potree)

		l=length(keys(trie))
		if modelsdetection(params.model, tightBB) == 2
			flushprintln("FULL model")
			i=1
			for k in keys(trie)
				if i%100==0
					flushprintln(i," files processed of ",l)
				end
				file = trie[k]
				n = updateimage!(params,file,s,n)
				i = i+1
			end
		else
			flushprintln("DFS")
			n,_ = PointClouds.dfsimage(trie,params,s,n,0,l)
		end
	end

	return n
end

"""
update image tensor.
"""
function updateimagewithfilter!(params,file,s,n::Int64)
	h, laspoints =  PointClouds.readpotreefile(file)

    for laspoint in laspoints
        point = PointClouds.xyz(laspoint,h)
        if inmodel(params.model)(point) # se il punto è interno allora
			n = update_core(params,laspoint,h,n,s)
        end
    end

	return n
end

function updateimage!(params,file,s,n::Int64)
	h, laspoints =  PointClouds.readpotreefile(file)

    for laspoint in laspoints
		n = update_core(params,laspoint,h,n,s)
    end

	return n
end

function update_core(params,laspoint,h,n,s)
	point = PointClouds.xyz(laspoint,h)
	rgb = PointClouds.color(laspoint,h)
	p = params.coordsystemmatrix*point
	xcoord = map(Int∘trunc,(p[1]-params.refX) / params.GSD)+1
	ycoord = map(Int∘trunc,(params.refY-p[2]) / params.GSD)+1

	if p[3] >= params.q_l && p[3] <= params.q_u
		if params.pc
			plas = PointClouds.newPointRecord(laspoint,h,LasIO.LasPoint2,params.mainHeader)
			write(s,plas)
			n=n+1
		end
		if params.rasterquote[ycoord,xcoord] < p[3]
			params.rasterquote[ycoord,xcoord] = p[3]
			params.RGBtensor[1, ycoord, xcoord] = rgb[1]
	        params.RGBtensor[2, ycoord, xcoord] = rgb[2]
	        params.RGBtensor[3, ycoord, xcoord] = rgb[3]
		end
	end
	return n
end
