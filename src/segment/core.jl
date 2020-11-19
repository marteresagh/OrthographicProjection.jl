"""
segment(txtpotreedirs::String, output::String, model::Lar.LAR)

Input:
 - A text file containing a list of files to segment
 - output filename
 - model of extraction

 Output:
  - Point cloud LAS
"""
function segment(txtpotreedirs::String, output::String, model::Lar.LAR)
	# initialize parameters
	n = nothing #number of points extracted
	params = init(txtpotreedirs, output, model)

	temp = joinpath(splitdir(params.outputfile)[1],"temp.las")
	open(temp, "w") do s
		write(s, LasIO.magic(LasIO.format"LAS"))
		n = process_trie(params,s)
	end

	# save point cloud extracted
	savepointcloud(params, n, temp)
end

"""
updateif!(params::ParametersExtraction, file::String, s, n::Int64)
"""
function updateif!(params::ParametersExtraction, file::String, s::IOStream, n::Int64)
	h, laspoints =  FileManager.read_LAS_LAZ(file) # read file
    for laspoint in laspoints # read each point
        point = FileManager.xyz(laspoint,h)
        if Common.inmodel(params.model)(point) # if point in model
			n = update_core(params,laspoint,h,s,n)
        end
    end
	return n
end

"""
update!(params::ParametersExtraction, file::String, s, n::Int64)
"""
function update!(params::ParametersExtraction, file::String, s::IOStream, n::Int64)
	h, laspoints = FileManager.read_LAS_LAZ(file) # read file
    for laspoint in laspoints # read each point
		n = update_core(params,laspoint,h,s,n)
    end
	return n
end

"""
update_core(params::ParametersExtraction, laspoint::LasIO.LasPoint, h::LasIO.LasHeader, s, n::Int64)
"""
function update_core(params::ParametersExtraction, laspoint::LasIO.LasPoint, h::LasIO.LasHeader, s::IOStream, n::Int64)
	plas = FileManager.newPointRecord(laspoint,h,LasIO.LasPoint2,params.mainHeader)
	write(s,plas) # write this record on temporary file
	n = n+1 # count the points written
	return n
end
