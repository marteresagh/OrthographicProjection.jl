"""
Save extracted pc in a file.
"""
function pointExtraction(
     txtpotreedirs::String,
	 outputfile::String,
	 coordsystemmatrix::Array{Float64,2},
	 bbin::Union{String,Tuple{Array{Float64,2},Array{Float64,2}}},
	 quota::Union{Float64,Nothing},
	 thickness::Union{Float64,Nothing},
	  )


    params = initParamsExtraction(   txtpotreedirs::String,
									 outputfile::String,
									 coordsystemmatrix::Array{Float64,2},
									 bbin::Union{String,Tuple{Array{Float64,2},Array{Float64,2}}},
									 quota::Union{Float64,Nothing},
									 thickness::Union{Float64,Nothing}
									 )

	n = 0
	temp = joinpath(splitdir(params.outputfile)[1],"temp.las")
	open(temp, "w") do s
		write(s, LasIO.magic(LasIO.format"LAS"))
    	n = processfiles(params,s,n)
	end

	savepointcloud( params, n, temp)

end
