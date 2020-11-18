__precompile__()

module OrthographicProjection

    using Common
	using FileManager
	using Images

	# first include struct
	include("struct.jl")
	include("process_trie.jl")
	include("saves.jl")

	#include all file .jl in other folders
	#include("orthophoto/dfs.jl")
	include("orthophoto/init.jl")
	include("orthophoto/main.jl")
	include("orthophoto/core.jl")

	#include("segmentation/dfs.jl")
	include("segmentation/core.jl")
	include("segmentation/init.jl")
	include("segmentation/main.jl")

	include("Sections/main.jl")
	include("Sections/init.jl")

	export Common, FileManager
end # module
