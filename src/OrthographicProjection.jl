__precompile__()

module OrthographicProjection

    using Common
	import Common.AABB,Common.LAR,Common.Points,Common.Point
	import Common.getmodel
	using FileManager
	using Printf
	using Images

	#
	include("struct.jl")
	include("trie_traversal.jl")
	include("saves.jl")
	include("main.jl")
	include("core.jl")
	include("util.jl")

	export Common, FileManager
end # module
