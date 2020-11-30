__precompile__()

module OrthographicProjection

    using Common
	using FileManager
	using Images


	# first include struct
	include("struct.jl")
	include("process_trie.jl")
	include("common.jl")

	#include all file .jl in other folders

	include("orthophoto/init.jl")
	include("orthophoto/main.jl")
	include("orthophoto/core.jl")

	include("segment/core.jl")
	include("segment/init.jl")

	include("slices/main.jl")

	export Common, FileManager
end # module
