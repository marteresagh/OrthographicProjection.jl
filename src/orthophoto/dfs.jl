"""
Trie DFS.
"""
function dfsimage(t,params::ParametersOrthophoto,s,n::Int64,nfiles,l)
	file = t.value
	nodebb = FileManager.las2aabb(file)
	@time  inter = Common.modelsdetection(params.model, nodebb)
	if inter == 1
		nfiles = nfiles+1
		if nfiles%100==0
			flushprintln(nfiles," files processed of ",l)
		end
		n = updateimagewithfilter!(params,file,s,n)
		for key in collect(keys(t.children))
			n,nfiles = dfsimage(t.children[key],params,s,n,nfiles,l)
		end
	elseif inter == 2
		for k in keys(t)
			nfiles = nfiles+1
			if nfiles%100==0
				flushprintln(nfiles," files processed of ",l)
			end
			file = t[k]
			n = updateimage!(params,file,s,n)
		end
	end
	return n,nfiles
end
