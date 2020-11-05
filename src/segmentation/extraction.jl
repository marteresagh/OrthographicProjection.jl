"""
process file in trie.
"""
function extraction_core(params::ParametersExtraction,s,n::Int64)

	nfiles = nothing
	l = nothing

    for potree in params.potreedirs
        flushprintln( "======== PROJECT $potree ========")
		metadata = CloudMetadata(potree)

		trie = potree2trie(potree)
		l=length(keys(trie))
		if Common.modelsdetection(params.model, metadata.tightBoundingBox) == 2
			flushprintln("FULL model")
			i=1
			for k in keys(trie)
				if i%100==0
					flushprintln(i," files processed of ",l)
				end
				file = trie[k]
				n = updatepoints!(params,file,s,n)
				i=i+1
			end
		else
			flushprintln("DFS")
			n,nfiles = dfsextraction(trie,params,s,n,0,l)
		end
	end

	if !isnothing(nfiles)
		flushprintln("$(l-nfiles) file of $l not processed - out of region of interest")
	end
	return n
end

"""
save points in a temporary file
"""
function updatepointswithfilter!(params::ParametersExtraction,file,s,n::Int64)
	h, laspoints =  FileManager.read_LAS_LAZ(file)
    for laspoint in laspoints
        point = FileManager.xyz(laspoint,h)
        if Common.inmodel(params.model)(point) # se il punto è interno allora
			n = updatepoints_core(params,laspoint,h,n,s)
			# if p[3] >= params.q_l && p[3] <= params.q_u
			# 	plas = FileManager.newPointRecord(laspoint,h,LasIO.LasPoint2,params.mainHeader)
			# 	write(s,plas)
			# 	n=n+1
			# end
        end
    end
	return n
end

function updatepoints!(params::ParametersExtraction,file,s,n::Int64)
	h, laspoints = FileManager.read_LAS_LAZ(file)
    for laspoint in laspoints
		n = updatepoints_core(params,laspoint,h,n,s)
		# point = FileManager.xyz(laspoint,h)
		# p = params.coordsystemmatrix*point
		# if p[3] >= params.q_l && p[3] <= params.q_u
		# 	plas = FileManager.newPointRecord(laspoint,h,LasIO.LasPoint2,params.mainHeader)
		# 	write(s,plas)
		# 	n=n+1
		# end
    end
	return n
end


function updatepoints_core(params,laspoint,h,n,s)
	point = FileManager.xyz(laspoint,h)
	p = params.coordsystemmatrix*point
	if p[3] >= params.q_l && p[3] <= params.q_u
		plas = FileManager.newPointRecord(laspoint,h,LasIO.LasPoint2,params.mainHeader)
		write(s,plas)
		n=n+1
	end
	return n
end
