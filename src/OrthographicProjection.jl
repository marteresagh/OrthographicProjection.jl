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


	include("new/struct.jl")
	include("new/orthophoto.jl")
	include("new/process_point.jl")
	include("new/save.jl")
	include("new/traversal.jl")
	export Common, FileManager
end # module
