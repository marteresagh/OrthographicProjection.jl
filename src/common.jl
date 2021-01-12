"""
	get_potree_dirs(txtpotreedirs::String)

Return collection of potree directories.
"""
function get_potree_dirs(txtpotreedirs::String)
    if isfile(txtpotreedirs)
    	return FileManager.get_directories(txtpotreedirs)
    elseif isdir(txtpotreedirs)
    	return [txtpotreedirs]
    end
end

"""
	updateif!(params::Union{ParametersOrthophoto,ParametersExtraction}, file::String, s, n::Int64)

Process all points, in file, falling in region of interest.
"""
function updateif!(params::Union{ParametersOrthophoto,ParametersExtraction}, file::String, s::Union{Nothing,IOStream}, n::Int64)
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
	update!(params::Union{ParametersOrthophoto,ParametersExtraction}, file::String, s::Union{Nothing,IOStream}, n::Int64)

Process points in file without further checks.
"""
function update!(params::Union{ParametersOrthophoto,ParametersExtraction}, file::String, s::Union{Nothing,IOStream}, n::Int64)
	h, laspoints = FileManager.read_LAS_LAZ(file) # read file
	for laspoint in laspoints # read each point
		n = update_core(params,laspoint,h,s,n)
	end
	return n
end

"""
	add_point!(params::Union{ParametersExtraction,ParametersOrthophoto}, laspoint::LasIO.LasPoint, h::LasIO.LasHeader, s::IOStream, n::Int64)

Add new point to segmented point cloud.
"""
function add_point(params::Union{ParametersExtraction,ParametersOrthophoto}, laspoint::LasIO.LasPoint, h::LasIO.LasHeader, s::IOStream, n::Int64)
	point = FileManager.xyz(laspoint,h)
	Common.update_boundingbox!(params.header_bb,point)
	plas = FileManager.newPointRecord(laspoint,h,LasIO.LasPoint2,params.mainHeader)
	write(s,plas) # write this record on temporary file
	n = n+1 # count the points written
	return n
end
