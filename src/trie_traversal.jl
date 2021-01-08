"""
	trie_traversal(params::Union{ParametersExtraction,ParametersOrthophoto},s::Union{Nothing,IOStream})

Trie traversal.
"""
function trie_traversal(params::Union{ParametersExtraction,ParametersOrthophoto}, s::Union{Nothing,IOStream})

	n = 0 # total points processed
	nfiles = nothing # total files processed
	l = nothing # total files to process

    for potree in params.potreedirs
        flushprintln("======== PROJECT $potree ========")
		metadata = CloudMetadata(potree) # metadata of current potree project

		trie = potree2trie(potree)
		l = length(keys(trie))

		# if model contains the whole point cloud ( == 2)
		#	process all files
		# else
		# 	navigate potree
		intersection = Common.modelsdetection(params.model, metadata.tightBoundingBox)
		if intersection == 2
			flushprintln("FULL model")
			i = 1
			for k in keys(trie)
				if i%100==0
					flushprintln(i," files processed of ",l)
				end
				file = trie[k]
				n = update!(params,file,s,n)
				i = i+1
			end
		elseif intersection == 1
			flushprintln("DFS")
			n,nfiles = dfs(trie,params,s,n,0,l)
		elseif intersection == 0
			flushprintln("OUT OF REGION OF INTEREST")
		end
	end

	if !isnothing(nfiles)
		flushprintln("$(l-nfiles) file of $l not processed - out of region of interest")
	end

	return n
end

"""
	dfs(t::DataStructures.Trie{String},
   		params::Union{ParametersOrthophoto,ParametersExtraction},
   		s::Union{Nothing,IOStream},n::Int64,nfiles::Int64,l::Int64)

Depth search first.
"""
function dfs(t::DataStructures.Trie{String},
	params::Union{ParametersOrthophoto,ParametersExtraction},
	s::Union{Nothing,IOStream},n::Int64,nfiles::Int64,l::Int64)

	file = t.value # path to node file
	nodebb = FileManager.las2aabb(file) # aabb of current octree
	inter = Common.modelsdetection(params.model, nodebb)

	if inter == 1
		# intersecato ma non contenuto
		# alcuni punti ricadono nel modello altri no
		nfiles = nfiles + 1
		if nfiles%100==0
			flushprintln(nfiles," files processed of ",l)
		end

		n = updateif!(params,file,s,n) # update with check

		for key in collect(keys(t.children)) # for all children
			n,nfiles = dfs(t.children[key],params,s,n,nfiles,l)
		end

	elseif inter == 2
		# contenuto: tutti i punti del albero sono nel modello
		for k in keys(t)
			nfiles = nfiles+1

			if nfiles%100==0
				flushprintln(nfiles," files processed of ",l)
			end

			file = t[k]
			n = update!(params,file,s,n) # update without check
		end
	end

	return n,nfiles
end
