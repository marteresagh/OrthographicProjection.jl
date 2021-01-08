"""
segment(txtpotreedirs::String, output::String, model::Lar.LAR)

Input:
 - A text file containing a list of files to segment
 - output filename
 - model of extraction

 Output:
  - Point cloud LAS
"""
function segment(txtpotreedirs::String, output::String, model::Lar.LAR; temp_name = "temp.las"::String, epsg = nothing::Union{Nothing,Integer})
	# initialize parameters
	n = nothing #number of points extracted
	params = init(txtpotreedirs, output, model; epsg = epsg)

	temp = joinpath(splitdir(params.outputfile)[1],temp_name)
	open(temp, "w") do s
		write(s, LasIO.magic(LasIO.format"LAS"))
		n = trie_traversal(params,s)
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

"""
get_sections(
	txtpotreedirs::String,
	project_name::String,
	proj_folder::String,
	bbin::Union{AABB,String},
	models::Array{Lar.LAR,1})

For each model in models extracts and saves the clipped point cloud.
"""
function extract_models(
	txtpotreedirs::String,
	project_name::String,
	proj_folder::String,
	bbin::Union{AABB,String},
	models::Array{Lar.LAR,1})

	n_models = length(models)
	Threads.@threads for i in 1:n_models
		flushprintln(" ")
		flushprintln(" ---- Section $i of $n_models ----")
		output = joinpath(proj_folder,project_name)*"_section_$(i-1).las"
		segment(txtpotreedirs, output, models[i]; temp_name = "temp_$i.las") # slicing point cloud
	end
end
