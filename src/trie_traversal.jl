"""
	traversal(potree::String, params::ParametersOrthophoto)

Trie traversal.
If entire point cloud falls in volume process all files of Potree project
else travers trie, depth search first, and process nodes falling in region of interest.

Input:
 - params: initial parameters
 - potree: potree hierarchy
"""
function traversal(potree::String, params::ParametersOrthophoto)
    println("= ")
    println("= PROJECT: $potree")
    println("= ")

    metadata = CloudMetadata(potree) # metadata of current potree project
    trie = potree2trie(potree)
    params.numNodes = length(keys(trie))

    # if model contains the whole point cloud ( == 2)
    #	process all files
    # else
    # 	navigate potree

    intersection =
        Common.modelsdetection(params.model, metadata.tightBoundingBox)

    if intersection == 2
        println("FULL model")
        for k in keys(trie)
            params.numFilesProcessed = params.numFilesProcessed + 1
            if params.numFilesProcessed % 100 == 0
                println(
                    params.numFilesProcessed,
                    " files processed of ",
                    params.numNodes,
                )
            end

            file = trie[k]
            updateWithoutControl!(params, file)

        end
    elseif intersection == 1
        println("DFS")
        dfs(trie, params)

        if params.numNodes - params.numFilesProcessed > 0
            println("$(params.numNodes-params.numFilesProcessed) file of $(params.numNodes) not processed - out of region of interest")
        end
    elseif intersection == 0
        println("OUT OF REGION OF INTEREST")
    end

end


"""
	dfs(t::DataStructures.Trie{String},
	params::Union{ParametersOrthophoto,ParametersExtraction},
	s::Union{Nothing,IOStream},n::Int64,nfiles::Int64,l::Int64)

Depth search first.
"""
function dfs(trie::DataStructures.Trie{String}, params::ParametersOrthophoto)# due callback: 1 con controllo e 1 senza controllo

    file = trie.value # path to node file
    nodebb = FileManager.las2aabb(file) # aabb of current octree
    inter = Common.modelsdetection(params.model, nodebb)

    if inter == 1
        # intersecato ma non contenuto
        # alcuni punti ricadono nel modello altri no
        params.numFilesProcessed = params.numFilesProcessed + 1
        if params.numFilesProcessed % 100 == 0
            println(
                params.numFilesProcessed,
                " files processed of ",
                params.numNodes,
            )
        end

        updateWithControl!(params, file) # update with check
        for key in collect(keys(trie.children)) # for all children
            dfs(trie.children[key], params)
        end
    elseif inter == 2
        # contenuto: tutti i punti del albero sono nel modello
        for k in keys(trie)
            params.numFilesProcessed = params.numFilesProcessed + 1
            if params.numFilesProcessed % 100 == 0
                println(
                    params.numFilesProcessed,
                    " files processed of ",
                    params.numNodes,
                )
            end
            file = trie[k]
            updateWithoutControl!(params, file) # update without check
        end
    end

end
