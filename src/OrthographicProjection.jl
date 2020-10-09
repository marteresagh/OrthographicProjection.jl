module OrthographicProjection

    using LinearAlgebraicRepresentation
    using LasIO

	Lar = LinearAlgebraicRepresentation

	# println with flush
    flushprintln(s...) = begin
		println(stdout,s...)
		flush(stdout)
	end

	# first include struct
	include("struct.jl")

	#include all file .jl in other folders

	dirs = readdir("src")
	for dir in dirs
		name = joinpath("src",dir)
    	if isdir(name)
			for (root,folders,files) in walkdir(name)
				for file in files
					head = splitdir(root)[2]
				 	include(joinpath(head,file))
				end
			end
		end
	end

end # module
