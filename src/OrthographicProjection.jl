__precompile__()

module OrthographicProjection

    using Common
	import Common.AABB,Common.LAR,Common.Points,Common.Point
	import Common.getmodel
	using FileManager
	using Printf
	using Images


	# first include struct
	include("struct.jl")
	include("trie_traversal.jl")
	include("common.jl")
	include("saves.jl")
	#
	# #include all file .jl in other folders
	include("orthophoto/main.jl")
	include("orthophoto/core.jl")
	include("orthophoto/util.jl")
	#
	include("segment/core.jl")
	#
	# include("slices/main.jl")

	export Common, FileManager
end # module
