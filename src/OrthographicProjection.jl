__precompile__()

module OrthographicProjection

	using Common
	import Common.AABB, Common.LAR, Common.Points
	import Common.getmodel
	using FileManager
	using Printf
	using Images

	#
	include("struct.jl")
	include("trie_traversal.jl")
	include("saves.jl")
	include("main.jl")
	include("process_point.jl")
	include("util.jl")

	export Common, FileManager
end # module
