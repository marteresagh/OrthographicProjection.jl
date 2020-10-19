"""
process file in trie.
"""
function processfiles(params::ParametersExtraction,s,n::Int64)

    for potree in params.potreedirs
        PointClouds.flushprintln( "======== PROJECT $potree ========")
		typeofpoints,scale,npoints,AABB,tightBB,octreeDir,hierarchyStepSize,spacing = PointClouds.readcloudJSON(potree)

		trie = potree2trie(potree)
		l=length(keys(trie))
		if PointClouds.modelsdetection(params.model, tightBB) == 2
			PointClouds.flushprintln("FULL model")
			i=1
			for k in keys(trie)
				if i%100==0
					PointClouds.flushprintln(i," files processed of ",l)
				end
				file = trie[k]
				n = PointClouds.updatepoints!(params,file,s,n)
				i=i+1
			end
		else
			PointClouds.flushprintln("DFS")
			n,_ = PointClouds.dfsextraction(trie,params,s,n,0,l)
		end
	end
	return n
end

"""
save points in a temporary file
"""
function updatepointswithfilter!(params::ParametersExtraction,file,s,n::Int64)
	h, laspoints =  PointClouds.readpotreefile(file)
    for laspoint in laspoints
        point = PointClouds.xyz(laspoint,h)
		p = params.coordsystemmatrix*point
        if PointClouds.inmodel(params.model)(point) # se il punto è interno allora
			if p[3] >= params.q_l && p[3] <= params.q_u
				plas = PointClouds.newPointRecord(laspoint,h,LasIO.LasPoint2,params.mainHeader)
				write(s,plas)
				n=n+1
			end
        end
    end
	return n
end

function updatepoints!(params::ParametersExtraction,file,s,n::Int64)
	h, laspoints =  PointClouds.readpotreefile(file)
    for laspoint in laspoints
		point = PointClouds.xyz(laspoint,h)
		p = params.coordsystemmatrix*point
		if p[3] >= params.q_l && p[3] <= params.q_u
			plas = PointClouds.newPointRecord(laspoint,h,LasIO.LasPoint2,params.mainHeader)
			write(s,plas)
			n=n+1
		end
    end
	return n
end
