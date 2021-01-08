__precompile__()

module OrthographicProjection

    using Common
	using FileManager
	using Images


	# first include struct
	include("struct.jl")
	include("trie_traversal.jl")
	include("common.jl")
	include("saves.jl")

	#include all file .jl in other folders

	include("orthophoto/init.jl")
	include("orthophoto/main.jl")
	include("orthophoto/core.jl")
	include("orthophoto/util.jl")

	include("segment/core.jl")
	include("segment/init.jl")

	include("slices/main.jl")

	export Common, FileManager
end # module
