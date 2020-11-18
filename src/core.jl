"""
process file in trie.
"""
function process_trie(params::Union{ParametersExtraction,ParametersOrthophoto},s,n::Int64)

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
				n = update!(params,file,s,n)
				i = i+1
			end
		else
			flushprintln("DFS")
			n,nfiles = dfs(trie,params,s,n,0,l)
		end
	end

	if !isnothing(nfiles)
		flushprintln("$(l-nfiles) file of $l not processed - out of region of interest")
	end
	return n
end

"""
Trie DFS.
"""
function dfs(t::DataStructures.Trie{String},
	params::Union{ParametersOrthophoto,ParametersExtraction},
	s,n::Int64,nfiles::Int64,l::Int64)

	file = t.value
	nodebb = FileManager.las2aabb(file)
	inter = Common.modelsdetection(params.model, nodebb)

	if inter == 1 # intersecato ma non contenuto
		nfiles = nfiles+1

		if nfiles%100==0
			flushprintln(nfiles," files processed of ",l)
		end

		n = updateif!(params,file,s,n)

		for key in collect(keys(t.children))
			n,nfiles = dfs(t.children[key],params,s,n,nfiles,l)
		end
	elseif inter == 2 # contenuto
		for k in keys(t)
			nfiles = nfiles+1

			if nfiles%100==0
				flushprintln(nfiles," files processed of ",l)
			end

			file = t[k]
			n = update!(params,file,s,n)
		end
	end

	return n,nfiles
end


"""
Update parameters.
"""
# Override
function updateif!(params::ParametersOrthophoto,file::String,s,n::Int64)
	return updateimageif!(params,file,s,n)
end

function updateif!(params::ParametersExtraction,file::String,s,n::Int64)
	return updatepointsif!(params,file,s,n)
end

function update!(params::ParametersOrthophoto,file::String,s,n::Int64)
	return updateimage!(params,file,s,n)
end

function update!(params::ParametersExtraction,file::String,s,n::Int64)
	return updatepoints!(params,file,s,n)
end
