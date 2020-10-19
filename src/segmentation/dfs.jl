
"""
Trie DFS.
"""
function dfsextraction(t,params::ParametersExtraction,s,n,nfiles,l)
	file = t.value
	nodebb = FileManager.las2aabb(file)
	inter = Common.modelsdetection(params.model, nodebb)
	if inter == 1
		nfiles = nfiles+1
		if nfiles%100==0
			flushprintln(nfiles," files processed of ",l)
		end
		n = updatepointswithfilter!(params,file,s,n)
		for key in collect(keys(t.children))
			n,nfiles = dfsextraction(t.children[key],params,s,n,nfiles,l)
		end
	elseif inter == 2
		for k in keys(t)
			nfiles = nfiles+1
			if nfiles%100==0
				flushprintln(nfiles," files processed of ",l)
			end
			file = t[k]
			n = updatepoints!(params,file,s,n)
		end
	end
	return n, nfiles
end
