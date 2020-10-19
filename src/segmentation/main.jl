"""
Save extracted pc in a file.
"""
function pointExtraction(
     txtpotreedirs::String,
	 outputfile::String,
	 coordsystemmatrix::Array{Float64,2},
	 bbin::Union{String,AABB},
	 quota::Union{Float64,Nothing},
	 thickness::Union{Float64,Nothing},
	  )


    params = initParamsExtraction(   txtpotreedirs,
									 outputfile,
									 coordsystemmatrix,
									 bbin,
									 quota,
									 thickness
									 )

	n = 0
	temp = joinpath(splitdir(params.outputfile)[1],"temp.las")
	open(temp, "w") do s
		write(s, LasIO.magic(LasIO.format"LAS"))
    	n = extraction_core(params,s,n)
	end

	savepointcloud( params, n, temp)

end
