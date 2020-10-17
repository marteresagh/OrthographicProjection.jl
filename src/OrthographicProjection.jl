module OrthographicProjection

    using Common
	using FileManager
	using Images

	# first include struct
	include("struct.jl")
	include("saves.jl")

	#include all file .jl in other folders
	include("orthophoto/dfs.jl")
	include("orthophoto/init.jl")
	include("orthophoto/main.jl")
	include("orthophoto/orthophoto.jl")

	include("segmentation/dfs.jl")
	include("segmentation/extraction.jl")
	include("segmentation/init.jl")
	include("segmentation/main.jl")


end # module
